# Futurama

This is a piece of software meant to create the roads between all the services.
It was created with a `bash` script and `docker compose`.

Works with:
 - 🐧 **Linux**
 - 🍎 **MacOS**
 - 🪟 **Windows (WSL)**

## Instructions
1. Go to the root folder of this program
2. Run the command `./start.sh` in your terminal
3. Follow the instructions

You don't have to worry about anything, just follow the instructions and **Futurama will take care of everything**.

## Registered Services
| Microservice      | Port |
|-------------------|------|
| skipper-api       | 3000 |
| skipper-front WIP | 3001 |

## Run commands inside the docker container
All the commands, like installing a new library in a software, must run inside the docker container.
For example:

```sh
{sudo} docker exec -t {containerName} ash -c "npm install {library}"
```

- `{sudo}` You add sudo if you need it
- `{container}` replace with the name of the container
- `{library}` name of the library
- `ash` is the bash for Alpine OS

## Known problems
### Operation Not Permitted (MacOS / Win)
When `operation not permitted` appears in MacOS or Win, is because you have to add the permissions for creating folders.
Follow this steps:
1. In Docker Desktop go to **Preferences** -> **Resources** -> **File Sharing**
2. Add the directory `.../local-architecture` to the list
3. Restart Docker Desktop
