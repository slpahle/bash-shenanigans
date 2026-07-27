# bash-sheanigans

## dcps

`docker ps` with better formatting for compose projects.

Inspired by [this feature request](https://forums.docker.com/t/feature-request-group-docker-ps-items-by-compose-profile/112923). I don't like the default `docker ps` formatting, and tend to use something like `docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"` when I just want to see basic status. I use `docker compose` for most things, and it would be convenient to see things grouped by project as well. This script was mostly created to practice with Bash and to make something that I might find semi-useful.

## sprites

Just messing around with ANSI escape sequences for foreground/background color and pixel art. There's a separate Groovy script to convert an image file to one of these scripts, but it's horrible and I'm not sharing it. There are three version:

1. `nu.sh` - Simple. Directly use pixel colors in the `printf` commands.
2. `colors_nu.sh` - Slightly more efficient. Has a cache of colors to use.
3. `pixels_nu.sh` - More efficient. Has a cache of pixels to use, including the foreground/background escape sequence as well as colors.
