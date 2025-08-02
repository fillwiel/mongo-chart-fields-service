// To connect with your mongoDB database
const mongoose = require('mongoose');
const mongoURI = process.env.MONGODB_URI;

mongoose.connect(mongoURI).then(() => console.log("Connected to MongoDB")).catch(e => console.log(e));
// Create a Flight model
const Flight = mongoose.connection.model('Flight', {} , 'flight');

// For backend and express
const express = require('express');
const app = express();
const cors = require("cors");
console.log("App listen at port 5000");
app.use(express.json());
app.use(cors());
app.get("/", (req, resp) => {
    console.log("request to the main address");
    resp.send("App is Working");
});
app.get("/fetchArrivalCities", async (req, resp) => {
    console.log("received request to /fetchArrivalCities");
    Flight.distinct("arrivalCity").then(r => resp.send(r));
});
app.get("/fetchDepartureCities", async (req, resp) => {
    console.log("received request to /fetchDepartureCities");
    Flight.distinct("departureCity").then(r => resp.send(r));
});
app.get("/fetchCountries", async (req, resp) => {
    console.log("received request to /fetchCountries");
    Flight.distinct("country").then(r => resp.send(r));
});
app.listen(5000);