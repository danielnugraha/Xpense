# Xpense

## Server
The server code is located in the `Xpense Server` directory.
Before starting it you might want to change the variables in the `"Xpense Server"/.env` file.

### Start the server locally
To start the server locally, run following command:

1. `cd Xpense Server` to go to the server code directory
2. `vapor run migrate` to migrate the database (only needs to be done once)
3. `vapor run serve` to start the server

### Start the server with Docker (compose)
To start the server with Docker you can run the following commands:
1. `cd Xpense Server` to go to the server code directory
2. `docker compose build app` to build the vapor application
3. `docker compose up -d` to start the database and vapor application
4. `docker compose run migrate` to migrate the database (you have to wait until the database is availabe)
5. `docker compose logs -f` to see the output of all services
6. `docker compose logs -f app` to see only the output of the vapor application
7. `docker compose down` to stop all services