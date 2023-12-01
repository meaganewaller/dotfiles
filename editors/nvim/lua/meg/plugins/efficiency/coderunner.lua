local M = {
  "CRAG666/code_runner.nvim",
  event = "VeryLazy",
  dependencies = "nvim-lua/plenary.nvim",
}

function M.config()
  require("code_runner").setup({
    -- put here the commands by filetype
    mode = "float",
    filetype = {
      awk = "awk -f $file",
      c = "cd $dir && cc -Wall -fsanitize=address -Wno-nullability-completeness -Wextra -pedantic -g -std=c99 $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
      cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
      cs = "cd $dir && dotnet run",
      go = "cd $dir && go run $fileName",
      haskell = "cabal run",
      java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
      javascript = "node %",
      jl = "cd $dir && julia %",
      kotlin = "cd $dir && kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar $fileNameWithoutExt.jar",
      lisp = "clisp $file",
      lua = "luajit $file",
      perl = "cd $dir && perl $file",
      python = "cd $dir && python3 $file",
      r = "cd $dir && Rscript $file",
      rust = "cd $dir && cargo run",
      sh = "cd $dir && bash $file",
      typescript = "deno run %",
    },
    float = {
      border = require("meg.custom").border,
    },
  })

  local map = require("meg.utils").map
  map("n", "<Leader>rr", ":RunCode<CR>", "Run Code", { noremap = true, silent = false })
  map("n", "<Leader>rf", ":RunFile<CR>", "Run File", { noremap = true, silent = false })
  map("n", "<Leader>rft", ":RunFile tab<cr>", "Run File in Tab", { noremap = true, silent = false })
  map("n", "<Leader>rp", ":RunProject<CR>", "Run Project", { noremap = true, silent = false })
  map("n", "<Leader>rc", ":RunClose<CR>", "Run and Close", { noremap = true, silent = false })
  map("n", "<Leader>crf", ":CRFiletype<CR>", "Run Filetype", { noremap = true, silent = false })
  map("n", "<Leader>crp", ":CRProjects<CR>", "Run Project", { noremap = true, silent = false })
end

return M
