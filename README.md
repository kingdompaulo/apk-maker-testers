# APK Maker testers

A tester exchange for apps made with the [Agentic APK Maker](https://github.com/SimonSchubert/omarchy-widgets) widget.

Google Play makes new personal developer accounts run a **closed test with at least 12 testers, opted in
for 14 days in a row**, before an app can go to production. Here, APK Maker users test each other's apps.

## How it works

1. **Join the testers group** with the Google account on your phone (the link is in the widget, and
   in [`community.json`](community.json)). You join once; it covers every app listed here.
2. **Test other apps.** Open the list in the widget (play tab › community testers), or read
   [`apps.json`](apps.json). For each app: tap *opt in*, install it from Google Play, and **keep it
   installed for 14 days**.
3. **List your own app** once it's on the closed testing track: the widget's *ask the community*
   button adds the group as a tester of your closed track and opens a filled-in issue here. A bot lists
   the app for 21 days and closes the issue.

## Please really test

Google asks, when you apply for production, how testers used your app and what they said. Apps whose
testers never opened them get turned down. So:

- Open each app you test a few times over the 14 days, and try what its description asks.
- Leave feedback in Google Play (the app's page › *Send private feedback to the developer*, shown to testers).
- Don't leave a test early: a tester who opts out loses their days, for that app's developer too.
- Test about as many apps as you need testers for: that's what makes 12 testers each possible.

## Rules

- Up to 3 apps listed per GitHub account at a time; a listing lasts 21 days.
- Only apps you made and own, that work, and that follow Google Play's policies. Listings breaking
  this are removed.
- The list is public: it shows the app's name, package, description and your GitHub name.
