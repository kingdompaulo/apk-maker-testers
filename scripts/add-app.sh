#!/usr/bin/env bash
# Adds the app from an "add-app" issue to apps.json. The issue body comes in $BODY, untrusted:
# it is only ever parsed as text and handed to jq as data. Prints the reply for the issue and
# exits 1 when the request is refused.
set -euo pipefail

# The value under an issue form's "### <label>" heading.
field() {
  awk -v h="### $1" '$0 == h {on=1; next} /^### / {on=0} on' <<< "$BODY" \
    | sed '/^_No response_$/d' | sed -e 's/\r//g' | awk 'NF {print}' | head -c 400
}

pkg=$(field "Package name" | head -1 | tr -d '[:space:]')
name=$(field "App name" | head -1 | cut -c1-50)
desc=$(field "What it does" | tr '\n' ' ' | sed 's/  */ /g; s/ $//' | cut -c1-300)

if ! [[ $pkg =~ ^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$ ]] || [ ${#pkg} -gt 150 ]; then
  echo "\"$pkg\" isn't a package name (like com.apkmaker.my_app). Edit the issue to fix it."; exit 1
fi
[ -n "$name" ] || { echo "The app needs a name. Edit the issue to add it."; exit 1; }

days=$(jq -r '.days // 21' community.json)
max=$(jq -r '.maxPerDeveloper // 3' community.json)
today=$(date -u +%F)
until=$(date -u -d "+$days days" +%F)

owner=$(jq -r --arg p "$pkg" '.[] | select(.pkg == $p) | .by' apps.json)
if [ -n "$owner" ] && [ "$owner" != "$AUTHOR" ]; then
  echo "$pkg is already listed by someone else."; exit 1
fi
if [ -z "$owner" ] && [ "$(jq --arg a "$AUTHOR" '[.[] | select(.by == $a)] | length' apps.json)" -ge "$max" ]; then
  echo "You already have $max apps listed: wait until one is done."; exit 1
fi

tmp=$(mktemp)
jq --arg p "$pkg" --arg n "$name" --arg d "$desc" --arg a "$AUTHOR" --arg t "$today" --arg u "$until" --argjson i "$ISSUE" \
  '[.[] | select(.pkg != $p)] + [{pkg:$p, name:$n, description:$d, by:$a, added:$t, until:$u, issue:$i,
     optIn:("https://play.google.com/apps/testing/" + $p), play:("https://play.google.com/store/apps/details?id=" + $p)}]' \
  apps.json > "$tmp"
mv "$tmp" apps.json
echo "Listed **$name** (\`$pkg\`) until $until. Testers opt in at https://play.google.com/apps/testing/$pkg"
echo
echo "Make sure the community group is a tester of your closed track (APK Maker does this for you), and test a few other apps in the list too."
