--- ### Heirline config modules
--
--  DESCRIPTION:
--  We use this file to configure the plugin "Heirline".
--  By having this file, we don't have to require every file separately.

return {
  component = require "utils.status.component",
  condition = require "utils.status.condition",
  env = require "utils.status.env",
  heirline = require "utils.status.heirline",
  hl = require "utils.status.hl",
  init = require "utils.status.init",
  provider = require "utils.status.provider",
  utils = require "utils.status.utils",
}
