# bash-sheanigans

## dcps

`docker ps` with better formatting for compose projects.

Inspired by [this feature request](https://forums.docker.com/t/feature-request-group-docker-ps-items-by-compose-profile/112923). I don't like the default `docker ps` formatting, and tend to use something like `docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"` when I just want to see basic status. I use `docker compose` for most things, and it would be convenient to see things grouped by project as well. This script was mostly created to practice with Bash and to make something that I might find semi-useful.
