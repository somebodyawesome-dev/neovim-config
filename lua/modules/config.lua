
-- Setup neovim lua configuration
require('neodev').setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})


require("modules.configs.nvim")
require("modules.configs.ui")
require("modules.configs.netrw")
require("modules.configs.telescope")
require("modules.configs.treesitter")
require("modules.configs.lsp")
require("modules.configs.dap")
require("modules.configs.cmp")




