local loaded, nvim_surround = pcall(require, "nvim-surround")
if not loaded then
  mw.loading_error_msg("nvim-surround")
  return
end

nvim_surround.setup()
