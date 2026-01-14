# Multi-Location Weather Forecasting App

A Ruby on Rails application that allows users to create multiple locations, automatically geocode them, and view a 7-day weather forecast with visual charting.

---

## Prerequisites

- Ruby 3.3.4 (Selected for compatibility with the installed gems and local environment)
- Rails 8.1.1
- SQLite (development)


---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/JobyMartin/weather-forecast-app.git
cd weather-forecast-app
```


2. Install Ruby dependencies:

`bundle install`


3. Set up the database:

`rails db:setup`


4. Start the server:

`rails server`


5. Visit the app at: http://localhost:3000


---

## Usage

- Navigate to the new location page
- Enter a city or town name (no state required)
- If the location is recognized by the geocoding API, it will be automatically geocoded
- View the 7-day forecast for your entered location
- Explore the temperature chart for visual insight
- Create, view, update, and delete locations as desired


---

## Frontend Enhancements

- **Stimulus.js**: Handles dynamic showing/hiding of latitude and longitude inputs when geocoding fails
- Form input validation prevents invalid lat/lon values from being submitted


## Deployment

The app is deployed on Fly.io at: https://weather-forecast-app.fly.dev

**Notes about deployment:**

- The app listens on port 8080 as required by Fly.io
- Machines may auto-stop when idle (free tier), causing a brief "cold start" delay on first access
- PostgreSQL is used in production via Fly.io Managed Postgres
- SSL and environment variables are properly configured for production use


## Technologies Used

- Ruby on Rails 8.1.1
- Stimulus.js (handles dynamic form interactions)
- RSpec and Capybara (system and service tests)
- Open-Meteo API (weather and geocoding) 
- Image-Charts (forecast visualization)
- RoleModel Optics (UI base styles)

This project uses the RoleModel Optics design system for base styles and layout. Optics is included via CDN for simplicity and to avoid additional build tooling.