# CurtainWith

## deploying to Heroku

1. Create a Heroku application.

2. Add buildpacks:

```bash
$ heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir
$ heroku buildpacks:add https://github.com/gjaldon/phoenix-static-buildpack
```

3. If you need Postgres, add it to Heroku:

```bash
$ heroku addons:create heroku-postgresql
```

4. Set required environment variables on Heroku:

```bash
$ heroku config:set API_KEY=`<api_key>`
```

5. Create/Migrate databases:

```bash
$ heroku run mix ecto.create
$ heroku run mix ecto.migrate
```

6. Run it:

```bash
$ heroku open
```
