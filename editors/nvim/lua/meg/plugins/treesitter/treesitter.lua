return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    { "RRethy/nvim-treesitter-endwise" },
  },
  build = ":TSUpdate",
  config = function()
    -- if vim.uv.os_uname().sysname == "Windows_NT" then
    --   require("nvim-treesitter.install").prefer_git = false
    -- end
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "graphql",
        "hcl",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "regex",
        "ruby",
        "rust",
        "scss",
        "sql",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      match = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "zi",
          node_incremental = "zI",
          scope_incremental = "zo",
          node_decremental = "zd",
        },
      },
      indent = {
        enable = true,
      },
      swap = {
        enable = true,
        swap_next = {
          ["<Leader>rp"] = "@parameter.inner",
        },
        swap_previous = {
          ["<Leader>rP"] = "@parameter.inner",
        },
      },
      textsubjects = {
        enable = true,
        keymaps = {
          ["."] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
          ["i;"] = "textsubjects-container-inner",
        },
      },
    })

    local map_virt =  require("meg.utils").map_virtual
    local noremap = require("meg.utils").noremap

    noremap("n", "<Leader>dp", function()
      vim.treesitter.inspect_tree({ command = "botright 60vnew" })
    end, "treesitter playground")

    noremap("n", "<C-\\>", ":TSHighlightCapturesUnderCursor<CR>", "treesitter highlight")
    map_virt("zi", "init selection")
    map_virt("zI", "node incremental")
    map_virt("zo", "scope incremental")
    map_virt("zd", "node decremental")
    map_virt("<Leader>rp", "swap parameter to next")
    map_virt("<Leader>rP", "swap parameter to previous")
  end,
  build = function()
    vim.cmd [[TSUpdate]]
  end,
}
