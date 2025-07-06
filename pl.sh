#!/bin/bash
touch "$HOME/musicae/playlists/$2.json"
yt-dlp \
  -f bestaudio \
  --flat-playlist \
  --dump-json \
  "https://music.youtube.com/@$1/videos" \
  | jq -s 'map({(.title): .id}) | add' \
> "$HOME/musicae/playlists/$2.json"
