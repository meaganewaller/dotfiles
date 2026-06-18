-- Treesitter post-install/update hook, must come before vim.pack.add()
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not event.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

local gh = function(repo)
  return "https://github.com/" .. repo
end

local specs = {
  -- Treesitter
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

  -- Completion
  { src = gh("Saghen/blink.cmp"), version = vim.version.range("1.0") },

  -- Utils
  gh("nvim-lua/plenary.nvim"),
  gh("folke/which-key.nvim"),
  gh("windwp/nvim-autopairs"),
  gh("echasnovski/mini.surround"),
  gh("echasnovski/mini.indentscope"),
  gh("b0o/schemastore.nvim"),

  -- Formatting
  gh("stevearc/conform.nvim"),

  -- Rails development
  gh("tpope/vim-rails"),

  -- Picker & search
  gh("ibhagwan/fzf-lua"),

  -- Harpoon
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },

  -- Git
  gh("lewis6991/gitsigns.nvim"),
  gh("tpope/vim-fugitive"),
  gh("tpope/vim-rhubarb"),

  -- Statusline
  gh("nvim-tree/nvim-web-devicons"), -- Dependency of lualine
  gh("nvim-lualine/lualine.nvim"),

  -- File tree
  gh("stevearc/oil.nvim"),

  -- TODO Comments
  gh("folke/todo-comments.nvim"),

  -- Agentic Stuff (and their dependencies)
  gh("yetone/avante.nvim"),
  { src = gh("github/copilot.vim"), name = "copilot" },
  { src = gh("CopilotC-Nvim/CopilotChat.nvim"), name = "CopilotChat" },
  { src = gh("stevearc/dressing.nvim"), name = "dressing" },
  { src = gh("MunifTanjim/nui.nvim"), name = "nui" },
  { src = gh("HakonHarnes/img-clip.nvim"), name = "img-clip" },
  { src = gh("MeanderingProgrammer/render-markdown.nvim"), name = "render-markdown" },
  { src = gh("zbirenbaum/copilot.lua"), name = "copilot-lua" },
  { src = gh("coder/claudecode.nvim"), name = "claudecode" },
  { src = gh("nickjvandyke/opencode.nvim"), name = "opencode" },
  { src = gh("folke/snacks.nvim"), name = "snacks" },

  -- Colorschemes
  gh("catppuccin/nvim"),
  gh("folke/tokyonight.nvim"),
  gh("ellisonleao/gruvbox.nvim"),
  gh("rose-pine/neovim"),
  gh("xero/evangelion.nvim"),
  gh("rebelot/kanagawa.nvim"),
  gh("EdenEast/nightfox.nvim"),
  gh("navarasu/onedark.nvim"),
  gh("vague-theme/vague.nvim"),
  gh("danilo-augusto/vim-afterglow"),
  { src = gh("everviolet/nvim"), name = "evergarden" },
  gh("xero/miasma.nvim"),
  gh("trapd00r/neverland-vim-theme"),
  gh("bettervim/yugen.nvim"),
  gh("savq/melange-nvim"),
  gh("zootedb0t/citruszest.nvim"),
  gh("rockerBOO/boo-colorscheme-nvim"),
}

local function spec_name(spec)
  if type(spec) == "string" then
    return spec:match("/([^/]+)%.git$") or spec:match("/([^/]+)$")
  end

  return spec.name or (spec.src:match("/([^/]+)%.git$") or spec.src:match("/([^/]+)$"))
end

local wanted = {}
for _, spec in ipairs(specs) do
  wanted[spec_name(spec)] = true
end

local stale = {}
for _, plugin in ipairs(vim.pack.get()) do
  if not wanted[plugin.spec.name] then
    table.insert(stale, plugin.spec.name)
  end
end

local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind

  if name == "avante" and (kind == "install" or kind == "update") then
    vim.system({ "make" }, { cwd = ev.data.path })
  end
end

if #stale > 0 then
  vim.pack.del(stale)
end

vim.pack.add(specs)

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
