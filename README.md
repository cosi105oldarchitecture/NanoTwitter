# NanoTwitter

Production deployment: https://nano-twitter.herokuapp.com/

[![Codeship Status for cosi105/NanoTwitter](https://app.codeship.com/projects/ec59bc70-1c93-0137-a172-0eda4e30ac77/status?branch=master)](https://app.codeship.com/projects/328870)
[![Maintainability](https://api.codeclimate.com/v1/badges/5156885903d76b6a4e64/maintainability)](https://codeclimate.com/github/cosi105/NanoTwitter/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5156885903d76b6a4e64/test_coverage)](https://codeclimate.com/github/cosi105/NanoTwitter/test_coverage)

Authors

- Yang Shang
- Ari Carr
- Brad Nesbitt

NanoTwitter is a light version of Twitter, implemented in Ruby with Sinatra.

## How to make sense of this mess

As of now (v0.5, 3/21/19), our NanoTwitter is comprised of two Sinatra apps plus a custom-made Ruby gem. Here are the pieces you'll need to understand in order to run our app:

### nt_models

[nt_models](https://github.com/cosi105/nt_models) is a gem we created, hosted on [RubyGems](https://rubygems.org/gems/nt_models), to hold the source code for our database migrations and their associated ActiveRecord models. We set this up so that we could create multiple Sinatra apps that, along with sharing the same database, also DRYly have the exact same model files. Both NanoTwitter and YourBiggestFanout utilize nt_models to manage their schema.

### NanoTwitter

This is the main app, providing a UI and an API for Twitter-like functionality including posts, follows, and timelines.

### YourBiggestFanout

[YourBiggestFanout](https://github.com/cosi105/YourBiggestFanout) is a microservice we created to asynchronously handle the write-intensive task of distributing tweets to followers' timelines, both in the case where a user newly follows another user (and thus needs to receive all of that user's tweets) and the case where a user with followers posts a tweet.

## How to use this mess

### Testing

Each of these repos has its own test suite that doesn't depend on any configuration of the other files. You can navigate to the root directory of any of these repos and run `rake test` to launch our test suites.

### Running the apps

Having a fully-functioning NanoTwitter including tweet fanout functionality requires you to have both NanoTwitter and YourBiggestFanout. To do this, you'll need to do the following:

- Download both NanoTwitter and YourBiggestFanout.
- Run `bundle install` on both apps.
- Run `rake db:drop db:create` on either one of the apps.
- Run `rake db:migrate` on both apps.
- Run `ruby app.rb` on both apps. YourBiggestFanout should launch on port 9494, and NanoTwitter should launch on port 4567.

### Seeding the database

There are two ways to seed our app, based on how much data you want and how quickly you want the seeding to run. Both methods require you to download seed data from our GitHub gists, whose URLs are saved as environment variables (included in LATTE submissions).

#### SQL Dump (recommended)

By running `rake db:dump:seed`, you can quickly import the entire seed database by downloading and processing a series of SQL commands that will construct the data in the database directly, without the overhead of ActiveRecord.

#### Test API (for granular control)

By sending a POST request to `/test/reset`, with at least one of the parameters `users`, `tweets`, or `follows`, our app will download the seed data as CSVs and lazily import as many rows as required to meet the given constraints. Note that due to the overhead of parsing CSV files and initializing ActiveRecord models, this method is actually _slower_ than the SQL dump even when less data is being seeded.

## Changes

### 0.7 (4/4/19)

- Build [NanoTwitter client gem](https://github.com/cosi105/nano_twitter) (Ari and Brad)
- Improved front-end with pagination (Yang)

### 0.6 (3/28/19)

- Implement groundwork for timeline pagination (Yang)
- Implement indexing (Ari)
- Implement Redis (Brad)

### 0.5 (3/21/19)

- Investigate GraphQL (Yang)
- Move models and migrations to gem, to be shared in multiple repos (Ari)
- Offload "tweet fanout" functionality to microservice (Ari)
- Run tests with Loader.io and New Relic, and start lab notebook in doc folder (Brad)
- Revise schema for denormalization (Brad)

### 0.4 (3/14/19)

- DB optimizations: seed time & switch to database on Amazon RDS (Ari)
- Implement dynamic version numbers in route URLs (Ari)
- Implement test interface & seed_helper (Yang)
- Implement version 1 of UI (Brad)
- Set up Heroku add-on compatibility (Ari)
- Add Code Climate and test coverage (Ari)

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
