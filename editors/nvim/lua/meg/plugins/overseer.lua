local loaded, overseer = pcall(require, "overseer")
if not loaded then
  mw.loading_error_msg("overseer")
  return
end

overseer.setup({
  component_aliases = {
    default_neotest = {
      "on_output_summarize",
      "on_exit_set_status",
      "on_complete_dispose",
    },
  },
  templates = { "java_build" },
})
