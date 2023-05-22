vim.g.user_emmet_mode = 'i'
vim.g.user_emmet_install_global = 0
vim.g.user_emmet_install_command = 0
vim.g.user_emmet_complete_tag = 0

nx.au({
  { "<FileType>", pattern = { "html", "css", "vue", "javascript", "javascriptreact", "svelte", "typescript", "typescriptreact" }}, command = function() vim.cmd [[ EmmetInstall imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr) ]]
})
