local flt = {}

function flt.notes()
	local buf = vim.api.nvim_create_buf(false, true)
	local win_width = math.floor(vim.o.columns * 0.6)
	local win_height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - win_height) / 2)
	local col = math.floor((vim.o.columns - win_width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "rounded"
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	vim.api.nvim_set_hl(0, "NotesBorder", { fg = "#FFFFFF" })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:NotesBorder", { win = win })

	vim.cmd("edit notes.md")

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

function flt.test(arg)
	local buf = vim.api.nvim_create_buf(false, true)
	local win_width = math.floor(vim.o.columns * 0.6)
	local win_height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - win_height) / 2)
	local col = math.floor((vim.o.columns - win_width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "rounded"
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	local fgc = "#A1A1A1"
	if arg == "cpp" or arg == "c++" then
		arg = "cpp"
		fgc = "#4B0082"
	elseif arg == "rs" or arg == "rust" then
		arg = "rs"
		fgc = "#dea584"
	elseif arg == "go" then
		arg = "go"
		fgc = "#29BEB0"
    elseif arg == "py" or arg == "python" then
		arg = "py"
		fgc = "#00FF00"
	elseif arg == "f90" or arg == "fortran" then
		arg = "f90"
		fgc = "#4d41b1"
    end

	vim.api.nvim_set_hl(0, "TryWinBorder", { fg = fgc })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:TryWinBorder", { win = win })

	vim.cmd("edit try."..arg)

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

return flt
