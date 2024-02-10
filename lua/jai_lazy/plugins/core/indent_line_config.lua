-- [[ indentLine pluging configuration ]]
-- rep: https://github.com/Yggdroot/indentLine

return {
			"Yggdroot/indentLine",
			enabled = false,
			config = function()

            -- Change Conceal Behaviour
            --
            -- Determine how text with the "conceal" syntax attribute |:syn-conceal|
            -- is shown:
            -- Value		Effect
            -- 0		Text is shown normally
            -- 1		Each block of concealed text is replaced with one
            -- 		character.  If the syntax item does not have a custom
            -- 		replacement character defined (see |:syn-cchar|) the
            -- 		character defined in 'listchars' is used (default is a
            -- 		space).
            -- 		It is highlighted with the "Conceal" highlight group.
            -- 2		Concealed text is completely hidden unless it has a
            -- 		custom replacement character defined (see
            -- 		|:syn-cchar|).
            -- 3		Concealed text is completely hidden.
            --
            --

            -- keep our conceal setting
            vim.g.indentLine_setConceal = 0

            -- Defaults from plugin
            vim.g.indentLine_concealcursor = "inc"
            vim.g.indentLine_conceallevel = 2

            -- highlight conceal color with your colors scheme
            vim.g.indentLine_setColors = 0

            vim.g.indentLine_fileTypeExclude = { "markdown", "norg" }

            local wk = require("which-key")

            wk.register({
                --
                -- <leader>t
                t = {
                    name = "Toggle",
                    i = { [[:IndentLinesToggle<CR>]], "Indent Lines Toggle" },
                },
            }, { prefix = "<leader>" })
			end,
}
