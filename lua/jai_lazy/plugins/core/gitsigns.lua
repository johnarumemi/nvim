
-- This depends on which-key due to various keymaps
-- that I have setup.

return {
			"lewis6991/gitsigns.nvim",
			tag = "v0.6",
  dependencies = { "folke/which-key.nvim" },
			config = function()
				local gitsigns_config = require("jai_lazy.plugins.configs.gitsigns_config")
				require("gitsigns").setup(gitsigns_config.config)
            end

}
