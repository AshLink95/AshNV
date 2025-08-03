fortran ={}

function fortran.f90check(fp)
	local fe = vim.fn.fnamemodify(fp, ':e')
	if fe=='f90' then
		return true
	end
end

function fortran.f90comp(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! gfortran -o '..fr..' %')
end

function fortran.f90run(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! ./'..fr)
end

function fortran.f90tcomp(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return 'gfortran -o "'..fr..'" "'..fp..'"'
	else
		return 'gfortran -o '..fr..' '..fp
	end
end

function fortran.f90trun(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return '"'..fr..'"'
	else
		return fr
	end
end

-- function fortran.f90configs(fp)
-- 	if fortran.f90check(fp) then
--		--settings
--
--		--special functions
--
--		--commands
--
--		--keymaps
-- 	end
-- end

function fortran.fortls() --LSP
	require'lspconfig'.fortls.setup{
		root_dir = function(fname)
			return vim.fn.getcwd()
		end,
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

function fortran.f90snips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	if fortran.f90check(fp) then
		ls.add_snippets("fortran",{
			s("PROGRAM", {
				t("PROGRAM "), i(1),
				t({ "", "\t" }), t("IMPLICIT NONE"),
				t({ "", "\t" }), i(0),
				t({ "", "END PROGRAM" })
			}),

			s("MODULE", {
				t("mODULE"), i(1),
				t({ "", "\t" }), t("IMPLICIT NONE"),
				t({ "", "\t" }), i(0),
				t({ "", "END MODULE" })
			}),

			s("SUBROUTINE", {
				t("SUBROUTINE"), i(1),
				t({ "", "\t" }), t("IMPLICIT NONE"),
				t({ "", "\t" }), i(0),
				t({ "", "END SUBROUTINE" })
			}),

			s("FUNCTION", {
				t("FUNCTION"), i(1),
				t({ "", "\t" }), t("IMPLICIT NONE"),
				t({ "", "\t" }), i(0),
				t({ "", "END FUNCTION" })
			}),
		})
	end
end

return fortran
