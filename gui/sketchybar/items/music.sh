MUSIC_EVENT="com.apple.Music.playerInfo"

music=(
  script="$PLUGIN_DIR/music.sh"
  click_script="$PLUGIN_DIR/music_click"
  label.padding_right=10
  associated_space=1
)

sketchybar \
  --add event music_changed $MUSIC_EVENT \
  --add item music center \
  --set music "${music[@]}" \
  --subscribe music music_changed
