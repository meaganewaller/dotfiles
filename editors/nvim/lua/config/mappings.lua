local keymaps = require('nvim.keymaps')

local mappings = {}

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
  keymaps.register("n", {
    ["H"] = [[^]] -- H to move to the first non-blank character of the line
  })
  keymaps.register("x", { -- Move selected line / block of text in visual mode
    ["K"] = [[:move '<-2<CR>gv-gv]],
    ["J"] = [[:move '>+1<CR>gv-gv]]
  })
end

local function buffer()
end

local function editor_motion()
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
