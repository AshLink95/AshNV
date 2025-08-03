rust = {}

function rust.rscheck(fp)
	local fe = vim.fn.fnamemodify(fp, ':e')
	if (fe=='rs') then
		return true
	end
end

function rust.rscomp(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! rustc -o '..fr..' %')
end

function rust.rsrun(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! ./'..fr)
end

function rust.rstcomp(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return 'rustc -o "'..fr..'" "'..fp..'"'
	else
		return 'rustc -o '..fr..' '..fp
	end
end

function rust.rstrun(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return '"'..fr..'"'
	else
		return fr
	end
end

-- function rust.rsconfigs(fp)
-- 	if rust.rscheck(fp) then
--		--settings
--
--		--special functions
--
--		--commands
--
--		--keymaps
-- 	end
-- end

function rust.rust_analyzer() --LSP
	require'lspconfig'.rust_analyzer.setup{
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {desc = "displays information of selected in a small hovering window"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>r', '<Cmd>lua vim.lsp.buf.references()<CR>', {desc = "displays a list in a winodw with all references of selected"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-d>', '<Cmd>lua vim.lsp.buf.definition()<CR>', {desc = "goes back to when selected is first decalared"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-c>', '<Cmd>lua vim.lsp.buf.rename()<CR>', {desc = "rename all instances of selected"})

			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', {desc = "show error in selected line in a small hovering window"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>l', '<Cmd>lua vim.diagnostic.setloclist()<CR>', {desc = "show a list of all errors in file in a window"})
		end,
		settings = { ["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
			standalone = true
		}}
	}
end

function rust.rssnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	if rust.rscheck(fp) then
 		ls.add_snippets("rust", {
			s("main()", {
				t("fn main(){"),
				t({ "", "\t" }), i(0),
				t({"", "}"})
			}),
		})
	end
end

return rust
