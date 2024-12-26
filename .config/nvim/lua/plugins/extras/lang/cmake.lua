return {
  {
    "Civitasv/cmake-tools.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    keys = {
      { "<Leader>Ck", "<cmd>CMakeSelectKit<CR>", desc = "Select kit" },
      { "<leader>Cv", "<cmd>CMakeSelectBuildType<cr>", desc = "Select build type" },
      -- NOTE: default is native build system generate
      -- NOTE: to specify generate by `CMakeGenerate -G MinGW\\ Makefiles`
      { "<leader>Cg", "<cmd>CMakeGenerate<cr>", desc = "Generate" },
      { "<leader>CB", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select Build Target" },
      { "<leader>Cb", "<cmd>CMakeBuild<cr>", desc = "Build Target" },
      { "<leader>Ci", "<cmd>CMakeInstall<cr>", desc = "Install" },
      { "<leader>Cd", "<cmd>CMakeDebug<cr>", desc = "Debug Target" },
      { "<leader>CR", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select launch target" },
      { "<leader>Cr", "<cmd>CMakeRun<cr>", desc = "Run Target" },
      { "<leader>Cc", "<cmd>CMakeClean<cr>", desc = "Clean" },
      { "<leader>Cs", "<cmd>CMakeStop<cr>", desc = "Stop" },
      { "<leader>Co", "<cmd>CMakeOpen<cr>", desc = "Open" },
      { "<leader>CC", "<cmd>CMakeClose<cr>", desc = "Close" },
    },
    opts = {
      -- this is used to specify cmake command path
      cmake_command = "cmake",
      -- auto generate when save CMakeLists.txt
      cmake_regenerate_on_save = false,
      -- auto generate when save CMakeLists.txt
      cmake_build_directory = "build/${variant:buildType}",
      -- cmake_build_directory = 'build\\${variant:buildType}',
      -- this will be passed when invoke `CMakeGenerate`
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      -- this will be passed when invoke `CMakeBuild`
      cmake_build_options = {},
      -- this will automatically make a soft link from compile commands file to project root dir
      cmake_soft_link_compile_commands = false,
      -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
      cmake_compile_commands_from_lsp = true,
      -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
      cmake_kits_path = nil,
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>C", group = "cmake" },
      },
    },
  },

  -- syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "cmake" })
      end
    end,
  },

  -- mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "cmake-language-server", -- lsp
        "cmakelint", -- linter
        "cmakelang", -- linter, formatter
      })
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        cmake = {},
        -- neocmake = {},
      },
    },
  },
}
