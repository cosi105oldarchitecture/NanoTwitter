# NanoTwitter

[![Codeship Status for cosi105/NanoTwitter](https://app.codeship.com/projects/ec59bc70-1c93-0137-a172-0eda4e30ac77/status?branch=master)](https://app.codeship.com/projects/328870)

Authors

- Yang Shang
- Ari Carr
- Brad Nesbitt

NanoTwitter is a light version of Twitter, implemented in Ruby with Sinatra.

## Changes

### 0.4 (3/13/19)

- DB optimizations: seed time & switch to database on Amazon RDS (Ari)
- Implement dynamic version numbers in route URLs (Ari)
- Implement test interface & seed_helper (Yang)
- Implement version 1 of UI (Brad)
- Set up Heroku add-on compatibility (Ari)

### 0.3 (3/7/19)

- Set up seeding for "official" seed data (Brad & Ari)
- Implemented user routes + initial view (Yang)
- Implemented tweet routes + initial view (Brad)
- Implemented model testing (Ari)
- Updated schema (Ari & Brad)

### 0.2 (2/28/19)

- Set up skeleton Sinatra app with migrations for schema (Brad)
- Write model files corresponding to schema with ActiveRecord relations (Brad/Ari)
- Implement user authentication (Yang)
- Set up automatic deployment to Heroku and testing via Codeship (Ari)
- Set up a "testing skeleton" for ease of writing tests in the future (Ari)

### 0.1 (2/14/19)

- Design the schema
- Design the UI prototypes
- Design the routes
- Create standard repo files
