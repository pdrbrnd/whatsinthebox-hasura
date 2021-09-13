# whatsinthebox.tv graphql engine

[Hasura](https://hasura.io) graphql engine for [whatsinthebox.tv](https://whatsinthebox.tv)

## Admin API Routes

The [front-end project](https://github.com/pdrbrnd/whatsinthebox) contains a few routes that are specially built to be used with this hasura.

### Main routes

- `/api/admin/channels/update` - create / update in the DB the list of available channels
- `/api/admin/queue/create` - for each channel, create an entry in the queue to process a given day. It accepts an `offset` payload to specify the day we want to schedule (e.g.: `{ payload: { offset: 1 } }` fetches the programming for following day)
- `/api/admin/queue/next` - find the next incomplete channel in the queue and processes it (find the IMDB id for each movie and fetches movie details from OMDB)
- `/api/admin/schedule/<schedule_id>` - processes again a given schedule. Helpful when we make changes and need to update an old entry.

### Cron jobs

This project has two cron jobs:

- Every midnight, each channel gets queued to get the day's programming. (api/admin/queue/create)
- Every 2 minutes, we check for incomplete items in queue and process them. (api/admin/queue/next)

### Manual triggering

You can also trigger manually these endpoints using Postman (or any other similar tool) and sending an `authorization` header with the code defined in the `.env` files of both projects (`API_CODE` and `API_ADMIN_CODE`). All admin endpoints are `POST` and, if a payload is required, use the following format:

```
{
  "payload": {
    YOUR_PAYLOAD
  }
}
```

---

## Local development

### Requirements

- Make sure you have docker and docker-compose.
- Clone the [front-end project](https://github.com/pdrbrnd/whatsinthebox), fill its environment variables, install dependencies (`npm i`) and run the project (`npm run dev`)

### Environment variables

Copy the example .env file and fill with whatever necessary: `cp .env.example .env`.  
Make sure your `APP_ADMIN_CODE` matches `API_CODE` in the front-end repo

### Spin it up!

```
docker-compose up
```

Hasura is now running at http://localhost:8080/

Refer to [Docker's documentation](https://docs.docker.com/compose/) for more.

### Initial data

To start fetching some movies you need to trigger `/api/admin/channels/update`. Refer to the API routes above.

---

## Deploy changes

Refer to [hasura's CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) docs for detailed instructions.

**Update the `.env` file to point to whichever instance you want to update.**

### Metadata

[Metadata CLI reference](https://hasura.io/docs/latest/graphql/core/hasura-cli/hasura_metadata.html)

Run `hasura metadata apply` to apply local metadata changes to the deployed instance.

### Migrations

[Migrate CLI reference](https://hasura.io/docs/latest/graphql/core/hasura-cli/hasura_migrate.html)

```
hasura migrate squash --name "<feature-name>" --from <start-migration-version> --database-name <database-name>

# note down the version

# mark the squashed migration as applied on this server
hasura migrate apply --version "<squash-migration-version>" --skip-execution --database-name <database-name>
```

from [this guide](https://hasura.io/docs/latest/graphql/core/migrations/migrations-setup.html#migrations-setup)
