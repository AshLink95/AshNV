go = {}

function go.gocheck(fp)
	local fe = vim.fn.fnamemodify(fp, ':e')
	if fe=='go' then
		return true
	end
end

function go.gocomp(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! go build -o '..fr..' %')
end

function go.gorun(fp)
	vim.cmd(':! go run %')
end

function go.gotcomp(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return 'go build -o "'..fr..'" "'..fp..'"'
	else
		return 'go build -o '..fr..' '..fp
	end
end

function go.gotrun(fp)
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return 'go run "'..fp..'"'
	else
		return 'go run '..fp
	end
end

-- function go.goconfigs(fp)
-- 	if go.gocheck(fp) then
--		--settings
--
--		--special functions
--
--		--commands
--
--		--keymaps
-- 	end
-- end


function go.gopls() --LSP
	require'lspconfig'.gopls.setup{
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
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

-- function go.gosnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
--	if go.gocheck(fp) then
--  		ls.add_snippets("go", {
-- 			s("trigger", {
-- 				t("keyword"),
-- 			}),
-- 		})
-- 	end
-- end

return go
