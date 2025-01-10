abbr mv 'mv -v'
abbr cp 'cp -v'

abbr vim 'nvim'
abbr vi  'nvim'

if type -q nvm
  function __nvm_auto --on-variable PWD
    nvm use --silent 2>/dev/null
  end
  __nvm_auto
end

if type -q pyenv
  status --is-interactive; and source (pyenv init -|pbsub)
end

if type -q exa
  abbr --add -g ls 'exa --long --classify --all --header --git --no-user --tree --level 1'
end

if type -q bat
  abbr --add -g cat 'bat'
end

if type -q trash
  abbr --add -g rm 'trash'
end
