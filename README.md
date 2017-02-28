# CurtainWith

## deploying to Heroku

1. Create a Heroku application.

2. Add buildpacks:

    $ heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir
    $ heroku buildpacks:add https://github.com/gjaldon/phoenix-static-buildpack

3. If you need Postgres, add it to Heroku:

    $ heroku addons:create heroku-postgresql

4. Set required environment variables on Heroku:

    $ heroku config:set SECRET_KEY_BASE=<key>

5. Create/Migrate databases:

    $ heroku run mix ecto.create
    $ heroku run mix ecto.migrate

6. Run it:

    $ heroku open
