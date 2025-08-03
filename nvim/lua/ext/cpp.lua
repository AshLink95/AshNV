cpp = {}

function cpp.cppcheck(fp)
	local fe = vim.fn.fnamemodify(fp, ':e')
	if (fe=='cpp' or fe=='hpp' or fe=='tpp' or fe=='inl') then
		return true
	end
end

function cpp.cppcomp(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! g++ -std=c++20 -o '..fr..' %')
end

function cpp.cpprun(fp)
	local ft = vim.fn.fnamemodify(fp, ':t')
	local fr = vim.fn.fnamemodify(ft, ':r')
	vim.cmd(':! ./'..fr)
end

function cpp.cpptcomp(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return 'g++ -std=c++20 -o "'..fr..'" "'..fp..'"'
	else
		return 'g++ -std=c++20 -o '..fr..' '..fp
	end
end

function cpp.cpptrun(fp)
	local fr = vim.fn.fnamemodify(fp, ':r')
	if fp:match(" ") or (fp:match([[\!]]) or fp:match([[/!]])) then
		return '"'..fr..'"'
	else
		return fr
	end
end

function cpp.cppconfigs(fp)
	if cpp.cppcheck(fp) then
		--settings
        vim.opt.syntax = "cpp"

		--special functions

		--commands

		--keymaps
	end
end

function cpp.clangd() --LSP
	require'lspconfig'.clangd.setup{
		filetypes = {"c", "h", "cpp", "hpp", "tpp", "inl", "objc", "objcpp", "cuda"},
		cmd = {"clangd", "--compile-commands-dir=build"},
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {desc = "displays information of selected in a small hovering window"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>r', '<Cmd>lua vim.lsp.buf.references()<CR>', {desc = "displays a list in a winodw with all references of selected"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-d>', '<Cmd>lua vim.lsp.buf.definition()<CR>', {desc = "goes back to when selected is first decalared"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-c>', '<Cmd>lua vim.lsp.buf.rename()<CR>', {desc = "rename all instances of selected"})

			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', {desc = "show error in selected line in a small hovering window"})
			vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>l', '<Cmd>lua vim.diagnostic.setloclist()<CR>', {desc = "show a list of all errors in file in a window"})
		end,
	}
	-- allowing for C++20 syntax highlighting
	local name = vim.api.nvim_buf_get_name(0)
	local filetype = vim.fn.fnamemodify(name, ":e")
	if filetype=="cpp" or filetype=="hpp" or filetype=="tpp" then
	local config = io.open(".clangd", "w")
		local found = false
		while true do
			local line = config:read("*l")
			if line==nil then break end
			if line=="  Add: [-std=c++20]" then
				found = true
				break
			end
		end
		if not found then
			config:write("CompileFlags:\n  Add: [-std=c++20]")
		end
		config:close()
	end
end

function cpp.cppsnips(fp, ls, s, sn, t, i, f, ch, d, rst, rep, fmt)
	if cpp.cppcheck(fp) then
 		ls.add_snippets("cpp", {
			s("main()", {
				t("int main(){"),
				t({ "", "\t" }), i(0),
				t({ "", "", "\t"}), t("return 0;"),
				t({"", "}"})
			}),
		})
	end
end

return cpp
