#!/bin/bash

trap "echo 'Suspended!!'; exit 0" SIGINT

JSON_FILE="$1.json"

if [ ! -f "$JSON_FILE" ]; then
  echo "JSON file '$JSON_FILE' not found."
  exit 1
fi

while true; do
  jq -r 'to_entries | map("\(.key)|\(.value)")[]' "$JSON_FILE" | \
  shuf | \
  while IFS='|' read -r title id; do
    echo "Now playing: $title"
    mpv --ytdl-format=bestaudio --no-video "https://www.youtube.com/watch?v=$id"
  done
done
