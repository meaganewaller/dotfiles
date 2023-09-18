-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '250' })
  end
})

-- Remove whitespace on save
autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    print("Saving file " .. args.file)
    if string.match(args.file, "config/locales/[%a%d%p/]+.yml") then
      return
    else
      vim.cmd(":%s/\\s\\+$//e")
    end
  end
})

-- Don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '*',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Settings for filetypes:
-- Disable line length marker
augroup('setLineLength', { clear = true })
autocmd('Filetype', {
  group = 'setLineLength',
  pattern = { 'text', 'markdown', 'html', 'xhtml', 'javascript', 'typescript' },
  command = 'setlocal cc=0'
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
  'yaml', 'lua'
},
command = 'setlocal shiftwidth=2 tabstop=2'
})

-- Make eruby.yaml files be treated like yaml files
autocmd('FileType', {
  pattern = 'eruby.yaml',
  command = 'set filetype=yaml'
})

augroup('fugitiveLineNumber', { clear = true })
autocmd('FileType', {
  group = 'fugitiveLineNumber',
  pattern = { 'fugitive' },
  command = 'setlocal nonumber'
})
-- Terminal settings:
-- Open a Terminal on the right tab
autocmd('CmdlineEnter', {
  command = 'command! Term :botright vsplit term://$SHELL'
})

-- No line numbers, no whitespace characters in terminal buffers
autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

-- Close terminal buffer on process exit
autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert'
})
