#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <channel_name> <playlist_name>"
  exit 1
fi

touch "$HOME/musicae/playlists/$2.json"
yt-dlp \
  -f bestaudio \
  --flat-playlist \
  --dump-json \
  "https://youtube.com/@$1/videos" \
  | jq -s 'map({(.title): .id}) | add' \
> "$HOME/musicae/playlists/$2.json"
