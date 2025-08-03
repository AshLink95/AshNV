make = {}

function make.makecheck(fp)
	local dir = vim.fn.fnamemodify(fp, ':p')
	local last = ""
	while dir and dir ~= "/" and dir ~= last do
		local makep = dir.."/makefile"
		local makef = io.open(makep, "r")
		if makef then
			makef:close()
			return dir
		end
		last = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

function make.makebuild(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && make build')
end

function make.makerun(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && make run')
end

function make.maketest(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && make test')
end

function make.makeclean(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && make clean')
end

function make.maketbuild(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && make build'
end

function make.maketrun(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && make run'
end

function make.makettest(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && make test'
end

function make.maketclean(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && make clean'
end

function make.makeconfig(dir)
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

	vim.api.nvim_set_hl(0, "MakeBorder", { fg = "#C4C4C4" })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:MakeBorder", { win = win })

	vim.cmd("edit "..dir.."/makefile")

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

return make
