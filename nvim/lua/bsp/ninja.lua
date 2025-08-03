ninja = {}

function ninja.ninjacheck(fp)
	local dir = vim.fn.fnamemodify(fp, ':p')
	local last = ""
	while dir and dir ~= "/" and dir ~= last do
		local ninjap = dir.."/build.ninja"
		local ninjaf = io.open(ninjap, "r")
		if ninjaf then
			ninjaf:close()
			return dir
		end
		last = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

function ninja.ninjabuild(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && ninja build')
end

function ninja.ninjarun(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && ninja run')
end

function ninja.ninjatest(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && ninja test')
end

function ninja.ninjaclean(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && ninja clean')
end

function ninja.ninjatbuild(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && ninja build'
end

function ninja.ninjatrun(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && ninja run'
end

function ninja.ninjattest(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && ninja test'
end

function ninja.ninjatclean(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && ninja clean'
end

function ninja.ninjaconfig(dir)
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

	vim.api.nvim_set_hl(0, "NinjaBorder", { fg = "#000000" })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:NinjaBorder", { win = win })

	vim.cmd("edit "..dir.."/build.ninja")

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

return ninja
