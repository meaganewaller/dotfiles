local function setup(ts)
  ts.setup({
    remove_template_string = true,
  })

  if vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) then
    vim.cmd("doautocmd FileType " .. vim.bo.filetype)
  end
end

local loaded, template_string = pcall(require, "template-string")
if not loaded then
  return
end

setup(temeplate_string)
