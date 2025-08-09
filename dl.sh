#!/bin/bash

if [ $# -ne 1 ]; then
  echo "使い方: ./dl.sh プレイリスト名 (例: ./dl.sh miko)"
  exit 1
fi

PLAYLIST_NAME="$1"
JSON_PATH="./playlists/${PLAYLIST_NAME}.json"
OUTPUT_DIR="./audio/${PLAYLIST_NAME}/"

if ! command -v jq &> /dev/null; then
  echo "エラー: jq が見つかりません。インストールしてください。"
  exit 1
fi

if ! command -v yt-dlp &> /dev/null; then
  echo "エラー: yt-dlp が見つかりません。インストールしてください。"
  exit 1
fi

if [ ! -f "$JSON_PATH" ]; then
  echo "エラー: ${JSON_PATH} が見つかりません。"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

jq -r 'to_entries[] | "\(.key)\t\(.value)"' "$JSON_PATH" | while IFS=$'\t' read -r title video_id; do
  url="https://www.youtube.com/watch?v=${video_id}"
  safe_title=$(echo "$title" | sed 's/[\/:*?"<>|]/_/g')

  echo "▶️ Downloading: $safe_title"
  yt-dlp -f bestaudio -x --audio-format mp3 -o "${OUTPUT_DIR}${safe_title}.%(ext)s" "$url"
done
