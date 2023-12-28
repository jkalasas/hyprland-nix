local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- formatters
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.stylua,

		-- linters
		null_ls.builtins.diagnostics.eslint,
	},
})