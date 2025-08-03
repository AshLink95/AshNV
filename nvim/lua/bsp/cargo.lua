cargo = {}

function cargo.cargocheck(fp)
	local dir = vim.fn.fnamemodify(fp, ':p')
	local last = ""
	while dir and dir ~= "/" and dir ~= last do
		local cargop = dir.."/Cargo.toml"
		local cargof = io.open(cargop, "r")
		if cargof then
			cargof:close()
			return dir
		end
		last = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

function cargo.cargobuild(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && cargo build')
end

function cargo.cargorun(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && cargo run')
end

function cargo.cargotest(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && cargo test')
end

function cargo.cargoclean(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && cargo clean')
end

function cargo.cargotbuild(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cargo build'
end

function cargo.cargotrun(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cargo run'
end

function cargo.cargottest(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cargo test'
end

function cargo.cargotclean(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cargo clean'
end

function cargo.cargoconfig(dir)
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

	vim.api.nvim_set_hl(0, "CargoBorder", { fg = "#FF8800" })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:CargoBorder", { win = win })

	vim.cmd("edit "..dir.."/Cargo.toml")

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

return cargo
