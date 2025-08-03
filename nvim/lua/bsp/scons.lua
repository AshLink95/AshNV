scons = {}

function scons.sconscheck(fp)
	local dir = vim.fn.fnamemodify(fp, ':p')
	local last = ""
	while dir and dir ~= "/" and dir ~= last do
		local sconsp = dir.."/SConstruct"
		local sconsf = io.open(sconsp, "r")
		if sconsf then
			sconsf:close()
			return dir
		end
		last = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

function scons.sconsbuild(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && scons')
end

-- TODO: look for a single "add_executable" and run it in scons.sconsrun(dir)

function scons.sconstbuild(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && scons'
end

-- TODO: scons.sconstrun(dir) is the same as scons.sconsrun(dir)

function scons.sconsconfig(dir)
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

	vim.api.nvim_set_hl(0, "SConsBorder", { fg = "#CC3733" })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:SConsBorder", { win = win })

	vim.cmd("edit "..dir.."/SConstruct")

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

return scons
