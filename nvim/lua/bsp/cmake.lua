cmake = {}

function cmake.cmakecheck(fp)
	local dir = vim.fn.fnamemodify(fp, ':p')
	local last = ""
	while dir and dir ~= "/" and dir ~= last do
		local cmakep = dir.."/CMakeLists.txt"
		local cmakef = io.open(cmakep, "r")
		if cmakef then
			cmakef:close()
			return dir
		end
		last = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

function cmake.cmakebuild(dir)
	vim.cmd(':! cd '..vim.fn.shellescape(dir)..' && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja -S . -B build && cmake --build build -j')
end

function cmake.cmakerun(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && cmake --build build --target run')
end

function cmake.cmaketest(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && cd build/ && ctest && cd ..')
end

function cmake.cmakeclean(dir)
	vim.cmd('! cd '..vim.fn.shellescape(dir)..' && cmake --build build --target purge')
end

function cmake.cmaketbuild(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja -S . -B build && cmake --build build -j'
end

function cmake.cmaketrun(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cmake --build build --target run'
end

function cmake.cmakettest(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cd build/ && ctest && cd ..'
end

function cmake.cmaketclean(dir)
	return 'cd '..vim.fn.shellescape(dir)..' && cmake --build build --target purge'
end

function cmake.cmakeconfig(dir)
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

	vim.api.nvim_set_hl(0, "CmakeBorder", { fg = "#4285F4" })
	vim.api.nvim_set_option_value("winhighlight", "FloatBorder:CmakeBorder", { win = win })

	vim.cmd("edit "..dir.."/CMakeLists.txt")

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})
end

return cmake
