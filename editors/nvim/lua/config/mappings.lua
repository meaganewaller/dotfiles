local keymaps = require('nvim.keymaps')

local mappings = {}

local keymap = vim.keymap.set
local silent = { silent = true }

table.unpack = table.unpack or unpack

keymap("n", "H", "^", silent)

local function tabs()
end

local function windows()
  keymaps.register("n", {
    ["<C-h>"] = [[<C-w>h]],
    ["<C-j>"] = [[<C-w>j]],
    ["<C-k>"] = [[<C-w>k]],
    ["<C-l>"] = [[<C-w>l]]
  })
end

local function navigations()
  keymaps.register("x", { -- Move selected line / block of text in visual mode
    ["K"] = [[:move '<-2<CR>gv-gv]],
    ["J"] = [[:move '>+1<CR>gv-gv]]
  })
end

local function buffer()
  keymaps.register("n", {
    ["<C-s>"] = [[:w<CR>]], -- save with Ctrl+S
    ["<CR>"] = [[:noh<CR>]], -- clear highlights
    ["<Leader>pf"] = "<CMD>lua require('plugins.telescope').project_files({ default_text = vim.fn.expand('<cword>'), initial_mode = 'normal' })<CR>",
    ["<Leader>pw"] = "<CMD>lua require('telescope.builtin).grep_string({ initial_mode = 'normal' })<CR>",
    ["<Tab>"] = [[:BufferLineCycleNext<CR>]],
    ["gn"] = [[:bn<CR>]],
    ["<S-Tab>"] = [[:BufferLineCyclePrev<CR>]],
    ["gp"] = [[:bp<CR>]],
    ["<S-q>"] = [[:lua require('mini.bufremove').delete(0, false)<CR>]],
    ["<Space>,"] = [[:cp<CR>]],
    ["<Space>."] = [[:cn<CR>]],
    ["<Leader>q"] = [[:lua require('utils').toggle_quicklist()<CR>]],
    ["<C-a>"] = [[:if  !switch#Switch() <bar> call speeddating#increment(v:count1) <bar> endif<CR>]],
    ["<C-x>"] = [[:if !switch#Switch({'reverse': 1}) <bar> call speeddating#increment(-v:count1) <bar> endif<CR>]],
  })
end

local function editor_motion()
end

local function lsp_maps()
  keymaps.register("n", {
    ["<C-Space>"]  = [[:lua vim.lsp.buf.code_action()<CR>]],
    ["<Leader>ca"] = [[:lua vim.lsp.buf.code_action()<CR>]],
    ["<Leader>cr"] = [[:lua vim.lsp.buf.rename()<CR>]],
    ["<Leader>cf"] = [[:lua vim.lsp.buf.format({ async = true })<CR>]],
    ["<Leader>cl"] = [[:lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>]],
    ["gl"]         = [[:lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>]],
    ["L"]          = [[:lua vim.lsp.buf.signature_help()<CR>]],
    ["]g"]        = [[:lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>]],
    ["[g"]        = [[:lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>]],
  })
end

local function editor_visual()
  keymaps.register("v", {
    ["<"] = [[<gv]],
    [">"] = [[>gv]],
    ["`"] = [[u]],
    ["<A-`>"] = [[U]],
  })
end

local function editor_dap()
end

function mappings.setup()
  tabs()
  windows()
  navigations()
  buffer()
  editor_motion()
  editor_visual()
  editor_dap()
  lsp_maps()
  vim.cmd([[
    nnoremap <Plug>SpeedDatingFallbackUp <c-a>
    nnoremap <Plug>SpeedDatingFallbackDown <c-x>
  ]])
end

return mappings
