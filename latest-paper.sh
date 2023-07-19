#!/bin/sh -e

LATEST_BUILD=$(curl "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds" | jq ".builds[-1].build")
curl "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/${LATEST_BUILD}/downloads/paper-1.20.1-${LATEST_BUILD}.jar" \
  -Lo ./papermc_latest.jar
