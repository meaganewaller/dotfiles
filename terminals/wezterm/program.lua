---@param cfg table
return function(config)
  config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
  config.launch_menu = {
	  { label = "fish", args= { "/opt/homebrew/bin/fish", "-l" } },
  }
end
