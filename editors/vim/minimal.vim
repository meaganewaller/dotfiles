call plug#begin("/Users/meaganwaller/.local/share/nvim/plugged")
Plug 'olimorris/onedarkpro.nvim'
call plug#end()

lua << EOF
require("onedarkpro").load()
EOF
