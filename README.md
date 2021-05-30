# Flyway
A flight-related app featuring an airport map and a few features centering on Schipol Airport.

## Task
The task was to make an app that gives information about different airports that can be reached on a given day from Schiphol Airport.
Schiphol has provided us with the following two data files:
* Airports: https://flightassets.datasavannah.com/test/airports.json
* Flights: https://flightassets.datasavannah.com/test/flights.json

The stakeholders want a multi-tab iOS application. 
On the first tab they would like to see a map that shows all the airports. When a user then taps on one of the airports the app will navigate to the airport details screen.

The airport details screen should display the following:
* The specifications of this airport. (id, latitude, longitude, name, city and countryId).
* The nearest airport and its distance (in kilometers).

On the second tab they would like to see a list of airports that could be reached directly from Schiphol Airport that day, sorted by the distance (in kilometers) from Schiphol Airport, ascending.

## Rules & recommendations
* We’re using this test to assess your programming skills, so please give it your best shot! If you’re in doubt between finishing more features or doing something according to your standards, we recommend doing it according to your standards (and finishing less features).
* Please work on the assignment for no more than **12 hours**. If you’re not done, don’t worry about it. Just stop and hand it in. If you run into planning issues, please reach out to us! We’d rather wait a week than have an assignment that’s not a good indication of your skill level.
* Log the time working you spent working on this test. 
* The app needs to run on iOS 14 and above.
* The UI has to be built programmatically. Storyboards and SwiftUI are not permitted.
* Searching on the internet is allowed and found code snippets can be used. Please
add comments to sources used.
* The usage of third-party libraries is permitted.

## Bonus points
* Add unit tests ❌
* Highlight the two airports on the map that are the furthest away from each other ✅
* A third tab with settings where you can change the distance unit from kilometers to
miles. ❌
* Support localization and add a second language to the app. ❌
* Use asynchronous web requests to retrieve the two JSON files. ✅
