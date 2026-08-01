-- ==========================================
-- TEMPLATE: LAZYVIM PALETTE (MATUGEN)
-- ==========================================

return {
	-- Sfondi e superfici
	base00 = "{{colors.surface.default.hex}}", -- Sfondo principale
	base01 = "{{colors.surface_container.default.hex}}", -- Sfondo secondario (Status bar, numeri di riga)
	base02 = "{{colors.surface_variant.default.hex}}", -- Sfondo di selezione
	base03 = "{{colors.outline.default.hex}}", -- Commenti e caratteri invisibili

	-- Testi e contrasti
	base04 = "{{colors.on_surface_variant.default.hex}}", -- Testo scuro/dim
	base05 = "{{colors.on_surface.default.hex}}", -- Testo predefinito
	base06 = "{{colors.on_surface.default.hex}}", -- Testo chiaro
	base07 = "{{colors.primary_container.default.hex}}", -- Testo chiarissimo

	-- Colori di sintassi (Variabili, stringhe, funzioni)
	base08 = "{{colors.error.default.hex}}", -- Variabili / Tag XML
	base09 = "{{colors.tertiary.default.hex}}", -- Costanti / Numeri / Booleani
	base0A = "{{colors.secondary.default.hex}}", -- Classi / Elementi di ricerca
	base0B = "{{colors.primary_fixed.default.hex}}", -- Stringhe
	base0C = "{{colors.tertiary_container.default.hex}}", -- Regex / Supporto
	base0D = "{{colors.primary.default.hex}}", -- Funzioni / Metodi
	base0E = "{{colors.secondary_container.default.hex}}", -- Parole chiave / Statement
	base0F = "{{colors.error_container.default.hex}}", -- Deprecati / Errori
}
