python = {}

function python.pycheck(fp)
	local fe = vim.fn.fnamemodify(fp, ':e')
	if fe=='py' then
		return true
	end
end

function python.pyrun(fp)
	vim.cmd(':! python %')
end

function python.pytrun(fp)
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return 'python "'..fp..'"'
	else
		return 'python '..fp
	end
end

-- function python.pyconfigs(fp)
-- 	if python.pycheck(fp) then
--		--settings
--
--		--special functions
--
--		--commands
--
--		--keymaps
-- 	end
-- end


function python.pyright() --LSP
	require'lspconfig'.pyright.setup{
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {desc = "displays information of selected in a small hovering window"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>r', '<Cmd>lua vim.lsp.buf.references()<CR>', {desc = "displays a list in a winodw with all references of selected"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-d>', '<Cmd>lua vim.lsp.buf.definition()<CR>', {desc = "goes back to when selected is first decalared"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-c>', '<Cmd>lua vim.lsp.buf.rename()<CR>', {desc = "rename all instances of selected"})

			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', {desc = "show error in selected line in a small hovering window"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>l', '<Cmd>lua vim.diagnostic.setloclist()<CR>', {desc = "show a list of all errors in file in a window"})
		end,
	}
end

-- function python.pysnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
--	if python.pycheck(fp) then
--  		ls.add_snippets("python", {
-- 			s("trigger", {
-- 				t("keyword"),
-- 			}),
-- 		})
-- 	end
-- end

return python
