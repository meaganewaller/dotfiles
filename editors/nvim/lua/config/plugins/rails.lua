return {
  {
    'tpope/vim-rails',
    event = { "BufEnter *.rb" },
    ft = { 'ruby', 'slim', 'erb' },
    dependencies = {
      'tpope/vim-projectionist'
    },
  },
  {
    'slim-template/vim-slim',
    ft = 'slim',
  },
  {
    'vim-ruby/vim-ruby',
    event = { "BufEnter *.rb" },
    ft = 'ruby',
  },
  {
    'tpope/vim-rake',
    event = { "BufEnter *.rb", "BufEnter Rakefile" },
    ft = 'ruby',
  },
  {
    'tpope/vim-bundler',
    event = { "BufEnter *.rb" },
    ft = 'ruby',
  },
  {
    'tpope/vim-cucumber',
    ft = { 'cucumber' },
  },
  {
    'greggroth/vim-cucumber-folding',
    ft = { 'cucumber' },
  },
}
