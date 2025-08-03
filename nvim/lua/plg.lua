local plg={}

-- Dependencies --

--nvim-web-devicons
function plg.nvimwebdevicons()
    require'nvim-web-devicons'.setup {
        override_by_extension = {
            ["tpp"] = { icon = "" },
            ["inl"] = { icon = "" }
        },
    }

	require'nvim-web-devicons'.get_icons()
end

--plenary.nvim
function plg.plenarynvim()
	require 'plenary.async'
end

-- Rq: all language specific plugins are configured in their respective language settings function

-- smoother directory navigation --

--nvim-tree
function plg.nvimtree()
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true
    require("nvim-tree").setup({
        sort = {
            sorter = "case_sensitive",
        },
        view = {
            width = 25,
        },
        filters = {
            dotfiles = true,
        },
        git = {
            enable = true,
            show_on_dirs = true,
        },
        renderer = {
            group_empty = true,
            highlight_git = true,
            icons = {
                show = {
                    git = true,
                },
            },
        },
    })
    vim.keymap.set('n', '<C-t>', '<Cmd>NvimTreeToggle<CR>', {})
end

--nvim-telescope
function plg.nvimtelescope()
	require('telescope').setup({
		defaults = {
			layout_config = {
				vertical = { width = 0.5 }
			},
		},
	})
	local tsbuiltin = require('telescope.builtin')
	vim.keymap.set('n', '<C-f>t', '<Cmd>Telescope<CR>', {})
	vim.keymap.set('n', '<C-f>f', tsbuiltin.find_files, {})
	vim.keymap.set('n', '<C-f>g', tsbuiltin.live_grep, {})
	vim.keymap.set('n', '<C-f>b', tsbuiltin.buffers, {})
	vim.keymap.set('n', '<C-f>h', tsbuiltin.help_tags, {})
	vim.keymap.set('n', '<C-f><C-s>', tsbuiltin.diagnostics, {})
end

-- Git integration --

--vim-fugitive
function plg.fugitive()
	vim.cmd([[packadd! vim-fugitive]])

	--keymaps
	vim.api.nvim_set_keymap('n', '<c-g>a', ':G add %<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>A', ':G add .<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>c', ':G commit<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>h', ':G push<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>l', ':G pull<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>s', ':G status<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>d', ':Gvdiff<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>b', ':G blame<CR>', {})
	vim.api.nvim_set_keymap('n', '<c-g>g', ':G log<CR>', {})
end

--gitsigns
function plg.gitsigns()
	require('gitsigns').setup {
		signs = {
			add          = { text = '┃' },
			change       = { text = '┃' },
			delete       = { text = '_' },
			topdelete    = { text = '‾' },
			changedelete = { text = '~' },
			untracked    = { text = '┆' },
		},
		signs_staged = {
			add          = { text = '┃' },
			change       = { text = '┃' },
			delete       = { text = '_' },
			topdelete    = { text = '‾' },
			changedelete = { text = '~' },
			untracked    = { text = '┆' },
		},
		signs_staged_enable = true,
		signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
		numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000, -- Disable if file is longer than this (in lines)
		preview_config = {
			border = 'single',
			style = 'minimal',
			relative = 'cursor',
			row = 0,
			col = 1
		},
	}

	--keymaps
end

-- IDE-like features --

--Colorscheme (OneDark)
function plg.OneDark()
	require('onedark').setup {
	    style = 'darker',
	    colors = { green = "#00FF00" }
	}
	require('onedark').load()
end

--Statusline (lualine)
function plg.lualine()
	require('lualine').setup {
		options = {
			icons_enabled = true,
			theme = 'auto',
			component_separators = { left = '', right = ''},
			section_separators = { left = '', right = ''},
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = false,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			}
		},
		sections = {
			lualine_a = {},
			lualine_b = {'filename'},
			lualine_c = {'branch', 'diff', 'diagnostics'},
			lualine_x = {},
			lualine_y = {'progress'},
			lualine_z = {'location'}
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {'filename'},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {'location'}
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {}
	}
end

-- nvim-treesitter
function plg.treesitter()
    require'nvim-treesitter.configs'.setup({
        ensure_installed = require('ext').parsers,

        sync_install = false,
        auto_install = false,
        ignore_install = {},
        modules = {},
        highlight = {
            enable = true,
            -- disable = {}, --languages with no highlighting
            additional_vim_regex_highlighting = false,
        },
    })
end

--all snippets
function plg.snips(fp)
	require('ext').snips(fp) -- all snippets here
end

-- LSPs and autocomplete --

--all LSPs
function plg.lsp()
	require('ext').lsp() -- all LSP configs here
end

--nvim-cmp
function plg.autocmp(check)
	local cmp = require'cmp'
	if check then
		cmp.setup({
			mapping = {
				['<Tab>'] = cmp.mapping.confirm({ select = true }), -- select option
				['<C-j>'] = cmp.mapping.select_next_item(), -- move down 1 option
				['<C-k>'] = cmp.mapping.select_prev_item(), -- move up 1 option
			},
			sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'luasnip'}}),
			window = {completion = {winhighlight = 'Normal:CmpPmenu'}},
		})
		cmp.complete()
	else
		cmp.abort()
		cmp.setup({
			mapping = {},
			sources = {},
			window = {}
		})
	end
end

return plg
