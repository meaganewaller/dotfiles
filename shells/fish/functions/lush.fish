function lush -a cmd --description "Create a lush colorscheme"
  argparse -s h/help -- $argv

  if set --query _flag_help
    echo "Usage: lush cmd [options] <name>"
    echo
    echo "Options:"
    echo "  -h, --help  Show this message"
    return
  end

  set -e argv[1]

  switch (string lower -- $cmd)
    case new
      __lush_new $argv
    end
end

function __lush_new -a name
  set LUSH_NAME $name
  set GIT_NAME $(git config user.name)
  set YEAR $(date +%Y)
  git clone git@github.com:rktjmp/lush-template.git $LUSH_NAME
  cd $LUSH_NAME
  mv colors/lush_template.lua colors/$LUSH_NAME.lua
  mv lua/lush_theme/lush_template.lua lua/lush_theme/$LUSH_NAME.lua
  if command -v sed &> /dev/null; then
    sed -i "s/lush_template/$LUSH_NAME/g" colors/$LUSH_NAME.lua
    sed -i "s/COPYRIGHT_NAME/$GIT_NAME/g" LICENSE
    sed -i "s/COPYRIGHT_YEAR/$YEAR/g" LICENSE
    git add .
  else
    echo "Could not find sed, please manually replace 'lush_template' with '$LUSH_NAME' in colors/$LUSH_NAME.lua, and
    update the LICENSE file."
  end
end
