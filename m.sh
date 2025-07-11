#!/bin/bash

JSON_FILE="$HOME/musicae/playlists/$1.json"

if [ ! -f "$JSON_FILE" ]; then
  echo "JSON file '$JSON_FILE' not found."
  exit 1
fi

jq -r 'to_entries | map("https://youtube.com/watch?v=\(.value)")[]' "$JSON_FILE" | shuf > .tmp_playlist.txt

mpv \
  --no-video \
  --terminal \
  --msg-level=ffmpeg=fatal \
  --term-playing-msg="🎵 Playing: \${media-title}" \
  --playlist=.tmp_playlist.txt
