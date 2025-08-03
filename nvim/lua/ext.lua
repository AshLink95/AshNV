local ext = {}
--C++ (.cpp)
local cpp = require([[ext.cpp]])
local function cpplangd() -- LSP for C and C++
	cpp.clangd();
end

--Rust (.rs)
local rs = require([[ext.rust]])
local function rust_analyzer()
	rs.rust_analyzer()
end

--Go (.go)
local go = require([[ext.go]])
local function gopls() -- LSP for go
	go.gopls();
end

--Python (.py)
local py = require([[ext.python]])
local function pyright() -- LSP for python
	py.pyright();
end

--Fortran (.f90)
local f90 = require([[ext.fortran]])
local function fortls() -- LSP for Fortran
	f90.fortls()
end


--The stuff

function ext.configs(fp)
	cpp.cppconfigs(fp)
	-- rs.rsconfigs(fp)
	-- go.goconfigs(fp)
	-- py.pyconfigs(fp)
	-- f90.f90configs(fp)
end

function ext.lsp() --LSPs
	rust_analyzer()
	cpplangd()
    gopls()
	pyright()
	fortls()
end

-- ext.parsers = {"cpp", "rust", "go", "python", "fortran"} --parsers for nvim.treesitter

function ext.snips(fp) --snippets
	local ls = require("luasnip")
	local s = ls.snippet
	local sn = ls.snippet_node
	local t = ls.text_node
	local i = ls.insert_node
	local f = ls.function_node
	local ch = ls.choice_node
	local d = ls.dynamic_node
	local rst = ls.restore_node
	local rep = require("luasnip.extras").rep
	local fmt = require("luasnip.extras.fmt").fmt

	ls.config.set_config({enable_autosnippets = true,})

	cpp.cppsnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	rs.rssnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	-- go.gosnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	-- py.pysnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	f90.f90snips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
end

function ext.wc(fp)
	vim.cmd(':w')
	if cpp.cppcheck(fp) then
		cpp.cppcomp(fp)
	elseif rs.rscheck(fp) then
		rs.rscomp(fp)
	elseif go.gocheck(fp) then
		go.gocomp(fp)
	elseif f90.f90check(fp) then
		f90.f90comp(fp)
	else
		print(vim.fn.fnamemodify(fp, ':e').." extension is not compilable")
	end
end

function ext.wcr(fp)
	vim.cmd(':w')
	if cpp.cppcheck(fp) then
		cpp.cppcomp(fp)
		cpp.cpprun(fp)
	elseif rs.rscheck(fp) then
		rs.rscomp(fp)
		rs.rsrun(fp)
	elseif go.gocheck(fp) then
		go.gorun(fp)
	elseif py.pycheck(fp) then
		py.pyrun(fp)
	elseif f90.f90check(fp) then
		f90.f90comp(fp)
		f90.f90run(fp)
	else
		print(vim.fn.fnamemodify(fp, ':e').." extension is not supported")
	end
end

local function wtc(fp)
	local w1
	if cpp.cppcheck(fp) then
		w1=cpp.cpptcomp(fp)
	elseif rs.rscheck(fp) then
		w1=rs.rstcomp(fp)
	elseif go.gocheck(fp) then
		w1=go.gotcomp(fp)
	elseif f90.f90check(fp) then
		w1=f90.f90tcomp(fp)
	else
		w1='echo '..vim.fn.fnamemodify(fp, ':e').." extension is not supported"
	end
	return w1
end

local function wtcr(fp)
	local w1,w2
	if cpp.cppcheck(fp) then
		w1=cpp.cpptcomp(fp)
		w2=cpp.cpptrun(fp)
	elseif rs.rscheck(fp) then
		w1=rs.rstcomp(fp)
		w2=rs.rstrun(fp)
	elseif go.gocheck(fp) then
		w1=go.gotrun(fp)
	elseif py.pycheck(fp) then
		w1=py.pytrun(fp)
	elseif f90.f90check(fp) then
		w1=f90.f90tcomp(fp)
		w2=f90.f90trun(fp)
	else
		w1='echo '..vim.fn.fnamemodify(fp, ':e').." extension is not supported"
	end
	return w1,w2
end

local function execinterm(cmd)
	if cmd ~= nil then
		vim.cmd([[:call feedkeys(']]..cmd..[['."\<Enter>")]])
	end
end

function ext.wtc(fp)

	if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') ~= 'terminal' then
		vim.cmd(':w')
		local cw = vim.api.nvim_get_current_win()
		local tw = nil
		for _,w in pairs(vim.api.nvim_list_wins()) do
			vim.api.nvim_set_current_win(w)
			if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
				tw = w
				break
			end
		end

		local w1 = wtc(fp)
		if tw==nil then
			vim.api.nvim_set_current_win(cw)
			vim.cmd(':below split | term')
			vim.cmd([[:call feedkeys("A\<CR>")]])
			execinterm(w1)
		else
			vim.api.nvim_set_current_win(tw)
			vim.cmd([[:call feedkeys("A\<CR>")]])
			execinterm(w1)
		end

	else
		print('execute :Wx from the file buffer')

	end

end

function ext.wtcr(fp)

	if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') ~= 'terminal' then
		vim.cmd(':w')
		local cw = vim.api.nvim_get_current_win()
		local tw = nil
		for _,w in pairs(vim.api.nvim_list_wins()) do
			vim.api.nvim_set_current_win(w)
			if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
				tw = w
				break
			end
		end

		local w1, w2 = wtcr(fp)
		if tw==nil then
			vim.api.nvim_set_current_win(cw)
			vim.cmd(':below split | term')
			vim.cmd([[:call feedkeys("A\<CR>")]])
			execinterm(w1)
			execinterm(w2)
		else
			vim.api.nvim_set_current_win(tw)
			vim.cmd([[:call feedkeys("A\<CR>")]])
			execinterm(w1)
			execinterm(w2)
		end

	else
		print('execute :Wx from the file buffer')

	end

end

return ext
