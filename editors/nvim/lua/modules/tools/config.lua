local config = {}

function config.template_nvim()
  require('template').setup({
    temp_dir = '~/.config/nvim/template',
    author = 'meaganewaller',
    email = 'meagan@meaganwaller.com',
  })
  require('fzf-lua').load_extension('find_template')
end

function config.guard()
  local ft = require('guard.filetype')
  ft('c,cpp'):fmt({
    cmd = 'clang-format',
    stdin = true,
    ignore_patterns = { 'neovim', 'vim' },
  })

  ft('lua'):fmt({
    cmd = 'stylua',
    args = { '-' },
    stdin = true,
    ignore_patterns = 'editors/nvim/*%.lua',
  })
  ft('go'):fmt('lsp'):append('golines')
  ft('rust'):fmt('rustfmt')
  ft('typescript', 'javascript', 'typescriptreact', 'javascriptreact'):fmt('prettier')
  -- hack when save diagnostic is missing
  vim.api.nvim_create_autocmd('User', {
    pattern = 'GuardFmt',
    callback = function(args)
      if args.data.status == 'done' then
        vim.diagnostic.show()
      end
    end,
  })
end

return config