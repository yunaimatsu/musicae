#!/bin/bash
JSON_FILE="$HOME/musicae/playlists/$1.json"
PLAYLIST_DIR="$HOME/musicae/playlists"

case "$1" in
  ls)
    echo ""
    echo -e "\033[1;32mAVAILABLE PLAYLISTS:\033[0m"
    find "$PLAYLIST_DIR" -type f -name "*.json" -exec basename {} .json \;
    ;;

  edit)
    if [ -z "$2" ]; then
      echo "❌ Please specify a playlist name to edit."
      exit 1
    fi
    EDIT_FILE="$PLAYLIST_DIR/$2.json"
    if [ ! -f "$EDIT_FILE" ]; then
      echo "❌ JSON file '$EDIT_FILE' not found."
      exit 1
    fi
    vim "$EDIT_FILE"
    ;;

  *)
    JSON_FILE="$PLAYLIST_DIR/$1.json"

    if [ ! -f "$JSON_FILE" ]; then
      echo "❌ JSON file '$JSON_FILE' not found."
      exit 1
    fi

    jq -r 'to_entries | map("https://youtube.com/watch?v=\(.value)")[]' "$JSON_FILE" | shuf > .tmp_playlist.txt

    mpv \
      --no-video \
      --terminal \
      --msg-level=ffmpeg=fatal \
      --term-playing-msg="Playing: \${media-title}" \
      --playlist=.tmp_playlist.txt
    ;;
esac
