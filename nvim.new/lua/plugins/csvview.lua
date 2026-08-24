--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/csvview.lua
-- Description: Aligns CSV columns into a readable table (:CsvViewToggle)
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"hat0uma/csvview.nvim",
	opts = {
		parser = {
			-- lines processed per cycle by the async parser; lower this if the
			-- UI freezes on large files
			async_chunksize = 50
		},
		view = {
			min_column_width = 5,
			spacing = 2,
			-- "highlight" colors the delimiter, "border" draws a `│` in its place
			display_mode = "border"
		}
	}
}}
