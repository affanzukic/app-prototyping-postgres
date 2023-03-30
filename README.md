# Fast Application Prototyping System (PostgreSQL)

## Prerequisites

In order to run the application, you will need following things installed on your machine:
- `bash`
- `make`
- `docker`
- `docker-compose`

## Running the application

Run the following commands inside your shell.

```bash
cp .env.example .env
make up-d
```

Now, let the database deploy.

After the database is deployed, you can access it using `make psql` or `make shell` to access the Docker container shell.

## Shutting down the application

To shut the application down, just run `make down`.

## Cleaning the PostgreSQL database

To completely clean the database and containers, please run the following commands:

```bash
make clean
make up-d
```

## Running a SQL file

To run commands from a SQL file, just type `make file FILE=<path to your file>`. For example, if we want to run the `example.sql` file located inside of `src/queries/example.sql`, we would type `make file FILE=src/queries/example.sql`

## External access to the database 

To access the database externally (e.g using DBeaver), please note the following credentials.

```
  Hostname: localhost
  Port: 5432
  Database: burch
  Username: postgres
  Password: <run 'cat .db_postgres_password' if using UNIX>
```
Please note that your PostgreSQL password is contained inside of the `.db_postgres_password`. If you do not see the file, make sure that the application is running using `make up-d`
