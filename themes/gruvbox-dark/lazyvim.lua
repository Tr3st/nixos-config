return {
	-- 1. Installa e configura il plugin Gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			transparent_mode = true, -- Il segreto per l'effetto vetro smerigliato
			contrast = "hard", -- Colori più vividi e netti
			dim_inactive = false,
		},
	},
	-- 2. Dichiara a LazyVim di usare questo tema
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},
}
