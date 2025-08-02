# Chart Filter Fields Provider
Webservice that provides filter fields for chart viewer app.

## Prerequisites
Specify MongoDB URI in environment variable `MONGODB_URI`.

## API
### GET /fetchArrivalCities
returns JSON with arrival cities found in mongoDB collection.

### GET /fetchDepartureCities
returns JSON with departure cities found in mongoDB collection.

### GET /fetchCountries
returns JSON with countries found in mongoDB collection.