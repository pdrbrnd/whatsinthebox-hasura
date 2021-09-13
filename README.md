# whatsinthebox.tv graphql engine

[Hasura](https://hasura.io) graphql engine for [whatsinthebox.tv](https://whatsinthebox.tv)

## Local development

### Requirements

- Make sure you have docker and docker-compose.
- Clone the [front-end repo](https://github.com/pdrbrnd/whatsinthebox), fill its environment variables, install dependencies (`npm i`) and run the project (`npm run dev`)

### Environment variables

Copy the example .env file and fill with whatever necessary: `cp .env.example .env`.  
Make sure your `APP_ADMIN_CODE` matches `API_CODE` in the front-end repo

### Spin it up!

```
docker-compose up
```

Refer to [Docker's documentation](https://docs.docker.com/compose/) for more.

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
