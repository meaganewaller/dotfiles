sketchybar -m --add event music_changed com.apple.Music.playerInfo
sketchybar -m --add event song_update com.apple.iTunes.playerInfo

sketchybar \
  --add item music center \
  --set music \
  script="$PLUGIN_DIR/music.sh" \
  click_script="$PLUGIN_DIR/music_click" \
  label.padding_right=10 \
  --subscribe music music_changed \
  --subsscribe music song_update
