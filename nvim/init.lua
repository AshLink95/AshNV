--simple configs
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hlsearch = false

--essential keymaps
vim.keymap.set('n','<Tab>','>>', {desc = "make <Tab> shift text to the right in normal mode"})
vim.keymap.set('v','<Tab>','>', {desc = "make <Tab> shift text to the right in visual mode"})
vim.keymap.set('v', '<Enter>', '<esc>`<i<Enter><esc>`>', {desc = "return selected to next line"})
vim.keymap.set('t','<esc><esc>','<C-\\><C-n>', {desc = "exit terminal mode with double <esc>"})

vim.keymap.set('n', '<C-h>', '<C-w>h', {desc = "navigate to left window"})
vim.keymap.set('n', '<C-l>', '<C-w>l', {desc = "navigate to right window"})
vim.keymap.set('n', '<C-j>', '<C-w>j', {desc = "navigate to lower window"})
vim.keymap.set('n', '<C-k>', '<C-w>k', {desc = "navigate to upper window"})

vim.keymap.set('v', '()', '<esc>`>a)<esc>`<i(<esc>', {desc = "put selected between parentheses"})
vim.keymap.set('v', '{}', '<esc>`>a}<esc>`<i{<esc>', {desc = "put selected between braces"})
vim.keymap.set('v', '[]', '<esc>`>a]<esc>`<i[<esc>', {desc = "put selected between brackets"})
vim.keymap.set('v', '<>', '<esc>`>a><esc>`<i<<esc>', {desc = "put selected between angle brackets"})
vim.keymap.set('v', '""', '<esc>`>a"<esc>`<i"<esc>', {desc = "put selected between quotes"})
vim.keymap.set('v', '\'\'', '<esc>`>a\'<esc>`<i\'<esc>', {desc = "put selected between apostrophes"})
vim.keymap.set('v', '``', '<esc>`>a`<esc>`<i`<esc>', {desc = "put selected between backticks"})
vim.keymap.set('v', '||', '<esc>`>a|<esc>`<i|<esc>', {desc = "put selected between pipes"})

vim.keymap.set('v', '(<Enter>', '<esc>`>a<Enter>)<esc>`<i(<Enter><esc>', {desc = "put selected in a separate line and between parentheses"})
vim.keymap.set('v', '{<Enter>', '<esc>`>a<Enter>}<esc>`<i{<Enter><esc>', {desc = "put selected in a separate line and between braces"})
vim.keymap.set('v', '[<Enter>', '<esc>`>a<Enter>]<esc>`<i[<Enter><esc>', {desc = "put selected in a separate line and between brackets"})
vim.keymap.set('v', '<<Enter>', '<esc>`>a<Enter>><esc>`<i<<Enter><esc>', {desc = "put selected in a separate line and between angle brackets"})
vim.keymap.set('v', '"<Enter>', '<esc>`>a<Enter>"<esc>`<i"<Enter><esc>', {desc = "put selected in a separate line and between double quotes"})
vim.keymap.set('v', '\'<Enter>', '<esc>`>a<Enter>\'<esc>`<i\'<Enter><esc>', {desc = "put selected in a separate line and between single quotes"})
vim.keymap.set('v', '`<Enter>', '<esc>`>a<Enter>`<esc>`<i`<Enter><esc>', {desc = "put selected in a separate line and between backticks"})
vim.keymap.set('v', '|<Enter>', '<esc>`>a<Enter>|<esc>`<i|<Enter><esc>', {desc = "put selected in a separate line and between pipes"})

vim.opt.clipboard = 'unnamedplus'

--plugins and extension-specific configs
local fp = vim.api.nvim_buf_get_name(0)
vim.api.nvim_create_autocmd("BufEnter", {pattern = "*", callback = function()
	fp = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
end,})

local ext = require('ext') --language support
local bsp = require('bsp') --build system and project management support

local plg = require('plg') --plugins
plg.lsp() -- LSPs
plg.treesitter() -- Treesitter

plg.nvimwebdevicons() --nvim-web-devicons plugin
plg.plenarynvim() --plenary.nvim plugin

plg.OneDark() --colorscheme
plg.lualine() --statusline

vim.defer_fn(function() plg.nvimtree() plg.nvimtelescope() end, 15) --smoother directory navigation

vim.defer_fn(function() plg.fugitive() plg.gitsigns() end, 20) --Git integration

local check1 = false
local function toggle_autocmp()
	check1 = not check1
	plg.autocmp(check1)
end

check2 = false
function toggle_ts()
	check2 = not check2
    if (check2) then
        print("TS inbound")
        vim.cmd("TSBufEnable highlight")
        vim.cmd("TSBufEnable indent")
    else
        print("TS out")
        vim.cmd("TSBufDisable highlight")
        vim.cmd("TSBufDisable indent")
    end
end

vim.api.nvim_create_autocmd("BufEnter", {pattern = "*", callback = function() --on open
	vim.defer_fn(function() ext.configs(fp) end, 10) -- extension specific adjustments

	vim.defer_fn(function() bsp.look(fp) end, 11) -- check for build systems

	vim.defer_fn(function() vim.cmd("LspStart") end, 12) -- Initiate LSP connection

	vim.defer_fn(function() --autocomplete and snippets
		vim.keymap.set('i','<C-a>',toggle_autocmp,{desc = "Toggle auto-complete menu"})
		plg.snips(fp)
	end, 13)

	vim.defer_fn(function() --TS highlight and indent
		vim.keymap.set('n','<C-j>',toggle_ts,{desc = "Toggle treesitter hl & indent"})
	end, 14)
end,})


--special general commands
vim.api.nvim_create_user_command(
	'T',
	function(opts)
		local cw = vim.api.nvim_get_current_win()
		local tw = nil
		for _,w in pairs(vim.api.nvim_list_wins()) do
			vim.api.nvim_set_current_win(w)
			if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
				tw = w
				break
			end
		end
		if tw==nil then
			vim.api.nvim_set_current_win(cw)
			vim.cmd(':below split | term')
			vim.cmd(':resize '..opts.args)
		else
			vim.api.nvim_set_current_win(tw)
			vim.cmd(':resize '..opts.args)
		end
	end,
	{nargs = 1, desc = "opens terminal with specific number of lines (resize if already exists)"}
)

vim.api.nvim_create_user_command(
	'W',
	function()
		ext.wcr(fp)
	end,
	{nargs = 0, desc = "executes current file"}
)

vim.api.nvim_create_user_command(
	'Wc',
	function()
		ext.wc(fp)
	end,
	{nargs = 0, desc = "compiles current file"}
)

vim.api.nvim_create_user_command(
	'Wx',
	function()
		ext.wtcr(fp)
	end,
	{nargs = 0, desc = "executes current file in terminal"}
)

vim.api.nvim_create_user_command(
	'Wxc',
	function()
		ext.wtc(fp)
	end,
	{nargs = 0, desc = "compiles current file in terminal"}
)


vim.api.nvim_create_user_command(
	'Ws',
	function()
		bsp.wb(fp)
	end,
	{nargs = 0, desc = "Build current project"}
)

vim.api.nvim_create_user_command(
	'Wz',
	function()
		bsp.wbr(fp)
	end,
	{nargs = 0, desc = "Build and run current project"}
)

vim.api.nvim_create_user_command(
	'Wa',
	function()
		bsp.wbt(fp)
	end,
	{nargs = 0, desc = "Build and test current project"}
)

vim.api.nvim_create_user_command(
	'Wd',
	function()
		bsp.wc(fp)
	end,
	{nargs = 0, desc = "Clean current project directory"}
)

vim.api.nvim_create_user_command(
	'Wxs',
	function()
		bsp.wtb(fp)
	end,
	{nargs = 0, desc = "Build current project in terminal"}
)

vim.api.nvim_create_user_command(
	'Wxz',
	function()
		bsp.wtbr(fp)
	end,
	{nargs = 0, desc = "Build and run current project in terminal"}
)

vim.api.nvim_create_user_command(
	'Wxa',
	function()
		bsp.wtbt(fp)
	end,
	{nargs = 0, desc = "Build and test current project in terminal"}
)

vim.api.nvim_create_user_command(
	'Wxd',
	function()
		bsp.wtd(fp)
	end,
	{nargs = 0, desc = "Clean current project directory in terminal"}
)


vim.api.nvim_create_user_command(
	'Config',
	function()
		bsp.config(fp)
	end,
	{nargs = 0, desc = "Open build system configuration file in a floating window"}
)


local flt = require('flt') --floating windows
vim.api.nvim_create_user_command(
	'Note',
	function()
		flt.notes()
	end,
	{nargs = 0, desc = "opens notes.md in a floating window"}
)

vim.api.nvim_create_user_command(
	'Try',
	function(opts)
		flt.test(opts.args)
	end,
	{nargs = 1, desc = "opens test.arg in a floating window"}
)

--highlights
vim.cmd([[highlight GrnBlHL ctermbg=green ctermfg=white guibg=green guifg=white]])
vim.cmd([[highlight YlwBlHL ctermbg=yellow ctermfg=black guibg=yellow guifg=black]])
vim.cmd([[highlight RedWhHL ctermbg=red ctermfg=white guibg=red guifg=white]])

vim.cmd("call matchadd('GrnBlHL', 'DONE')")
vim.cmd("call matchadd('YlwBlHL', 'TODO')")
vim.cmd("call matchadd('YlwBlHL', 'MISSING')")
vim.cmd("call matchadd('RedWhHL', 'ERROR')")
