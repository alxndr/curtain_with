# CurtainWith


## dev setup

1. Set up local Postgres (>= v9.4 because we need jsonb columns) with an `ecto` user and a `local_curtain_with` database:

```bash
$ brew install postgres
$ initdb /usr/local/var/db/postgres                     # or whatever
$ pg_ctl -D /usr/local/var/db/postgres -l logfile start
$ createuser --superuser postgres                       # the `mix ecto.setup` task uses this role
$ createuser --pwprompt ecto                            # and then type a password
$ createdb -Oecto -Eutf8 local_curtain_with
```


## deploying to Heroku

1. Create a Heroku application.

2. Add buildpacks:

```bash
$ heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir
$ heroku buildpacks:add https://github.com/gjaldon/phoenix-static-buildpack
```

3. Add Postgres to Heroku (>= v9.4 because we need jsonb columns):

```bash
$ heroku addons:create heroku-postgresql
```

4. Set required environment variables on Heroku:

```bash
$ heroku config:set API_KEY=<api_key> DATABASE_URL=<database_url>
```

5. Create/Migrate databases:

```bash
$ heroku config:set POOL_SIZE=18 # to leave 2 open on free plan for migrations
# don't need to create; the DB already exists on Heroku
$ heroku run "POOL_SIZE=2 MIX_ENV=prod mix ecto.migrate"
```

6. Run it:

```bash
$ heroku open
```
