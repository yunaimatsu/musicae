touch "$HOME/musicae/playlists/$2.txt"
yt-dlp \
  -f bestaudio
  --flat-playlist \
  --dump-json \
  "https://music.youtube.com/@$1/videos" \
  | jq -r '.id' \
  > "$HOME/musicae/playlists/$2.txt"
