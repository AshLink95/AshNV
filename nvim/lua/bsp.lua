local bsp = {}

--make (everything)
local make = require([[bsp.make]])

--cargo (Rust project manager)
local cargo = require([[bsp.cargo]])

--cmake (C, C++ and Fortran build system and project manager)
local cmake = require([[bsp.cmake]])

--ninja (everything)
local ninja = require([[bsp.ninja]])

--scons (everything)
local scons = require([[bsp.scons]])

-- TODO: add go and bazel

--The stuff

function bsp.look(fp)
	local root
	local type
	if make.makecheck(fp) then
		root = make.makecheck(fp)
		type = "make"
	elseif cargo.cargocheck(fp) then
		root = cargo.cargocheck(fp)
		type = "cargo"
	elseif cmake.cmakecheck(fp) then
		root = cmake.cmakecheck(fp)
		type = "cmake"
    elseif ninja.ninjacheck(fp) then
		root = ninja.ninjacheck(fp)
		type = "ninja"
    elseif scons.sconscheck(fp) then
		root = scons.sconscheck(fp)
		type = "scons"
	end

	if root then
		print("We're using "..type..". Root at "..root)
		return root, type
	end
	print("No build system or project manager found!")
end

function bsp.config(fp)
	local root, type = bsp.look(fp)
	if type == "make" then
		make.makeconfig(root)
	elseif type == "cargo" then
		cargo.cargoconfig(root)
	elseif type == "cmake" then
		cmake.cmakeconfig(root)
    elseif type == "ninja" then
		ninja.ninjaconfig(root)
    elseif type == "scons" then
		scons.sconsconfig(root)
	end
end

function bsp.wb(fp)
	vim.cmd(':wa')
	local root, type = bsp.look(fp)
	if type == "make" then
		make.makebuild(root)
	elseif type == "cargo" then
		cargo.cargobuild(root)
	elseif type == "cmake" then
		cmake.cmakebuild(root)
    elseif type == "ninja" then
		ninja.ninjabuild(root)
    elseif type == "scons" then
		scons.sconsbuild(root)
	end
end

function bsp.wbr(fp)
	vim.cmd(':wa')
	local root, type = bsp.look(fp)
	if type == "make" then
		make.makebuild(root)
		make.makerun(root)
	elseif type == "cargo" then
		cargo.cargorun(root)
	elseif type == "cmake" then
		cmake.cmakebuild(root)
        cmake.cmakerun(root)
    elseif type == "ninja" then
		ninja.ninjabuild(root)
		ninja.ninjarun(root)
    elseif type == "scons" then
		print("scons.sconsrun(root) ain't ready")
	end
end

function bsp.wbt(fp)
	vim.cmd(':wa')
	local root, type = bsp.look(fp)
	if type == "make" then
		make.makebuild(root)
		make.maketest(root)
	elseif type == "cargo" then
		cargo.cargotest(root)
	elseif type == "cmake" then
        cmake.cmakebuild(root)
		cmake.cmaketest(root)
	elseif type == "ninja" then
		ninja.ninjabuild(root)
		ninja.ninjatest(root)
	-- elseif type == "scons" then
	-- 	print("scons.sconsrun(root) ain't ready")
	end
end

function bsp.wc(fp)
	vim.cmd(':wa')
	local root, type = bsp.look(fp)
	if type == "make" then
		make.makeclean(root)
	elseif type == "cargo" then
		cargo.cargoclean(root)
	elseif type == "cmake" then
		cmake.cmakebuild(root)
		cmake.cmakeclean(root)
	elseif type == "ninja" then
        ninja.ninjaclean(root)
	-- elseif type == "scons" then
	-- 	print("scons.sconsclean(root) ain't ready")
	end
end

local function wtb(fp)
	local w1
	local root, type = bsp.look(fp)
	if type == "make" then
		w1=make.maketbuild(root)
	elseif type == "cargo" then
		w1=cargo.cargotbuild(root)
	elseif type == "cmake" then
		w1=cmake.cmaketbuild(root)
    elseif type == "ninja" then
		w1=ninja.ninjatbuild(root)
    elseif type == "scons" then
		w1=scons.sconstbuild(root)
	else
		w1="echo No build system or project manager ready!"
	end
	return w1
end

local function wtbr(fp)
	local w1,w2
	local root, type = bsp.look(fp)
	if type == "make" then
        w1=make.maketbuild(root)
        w2=make.maketrun(root)
	elseif type == "cargo" then
		w2=cargo.cargotrun(root)
	elseif type == "cmake" then
        w1=cmake.cmaketbuild(root)
        w2=cmake.cmaketrun(root)
    elseif type == "ninja" then
        w1=ninja.ninjatbuild(root)
        w2=ninja.ninjatrun(root)
    elseif type == "scons" then
		w1=print("scons.sconstrun(root) ain't ready")
	else
		w1="echo No build system or project manager ready!"
	end
	return w1,w2
end

local function wtbt(fp)
	local w1,w2
	local root, type = bsp.look(fp)
	if type == "make" then
        w1=make.maketbuild(root)
        w2=make.makettest(root)
	elseif type == "cargo" then
		w2=cargo.cargottest(root)
	elseif type == "cmake" then
        w1=cmake.cmaketbuild(root)
        w2=cmake.cmakettest(root)
    elseif type == "ninja" then
        w1=ninja.ninjatbuild(root)
        w2=ninja.ninjattest(root)
	--    elseif type == "scons" then
	-- 	print("scons.sconsttest(root) ain't ready")
	else
		w1="echo No build system or project manager ready!"
	end
	return w1,w2
end

local function wtd(fp)
    local w1
	local root, type = bsp.look(fp)
	if type == "make" then
		w1=make.maketclean(root)
	elseif type == "cargo" then
		w1=cargo.cargotclean(root)
	elseif type == "cmake" then
        w1=cmake.cmaketclean(root)
	elseif type == "ninja" then
		w1=ninja.ninjatclean(root)
	-- elseif type == "scons" then
	-- 	print("scons.sconstclean(root) ain't ready")
	else
		w1="echo No build system or project manager ready!"
	end
    return w1
end

local function execinterm(cmd)
	if cmd ~= nil then
		vim.fn.feedkeys(cmd .. "\n")
	end
end

function bsp.wtb(fp)
		vim.cmd(':wa')
		local cw = vim.api.nvim_get_current_win()
		local tw = nil
		for _,w in pairs(vim.api.nvim_list_wins()) do
			vim.api.nvim_set_current_win(w)
			if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
				tw = w
				break
			end
		end

		local w1 = wtb(fp)
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
end

function bsp.wtbr(fp)
	vim.cmd(':wa')
	local cw = vim.api.nvim_get_current_win()
	local tw = nil
	for _,w in pairs(vim.api.nvim_list_wins()) do
		vim.api.nvim_set_current_win(w)
		if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
			tw = w
			break
		end
	end

	local w1, w2 = wtbr(fp)
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
end

function bsp.wtbt(fp)
	vim.cmd(':wa')
	local cw = vim.api.nvim_get_current_win()
	local tw = nil
	for _,w in pairs(vim.api.nvim_list_wins()) do
		vim.api.nvim_set_current_win(w)
		if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
			tw = w
			break
		end
	end

	local w1, w2 = wtbt(fp)
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
end

function bsp.wtd(fp)
		vim.cmd(':wa')
		local cw = vim.api.nvim_get_current_win()
		local tw = nil
		for _,w in pairs(vim.api.nvim_list_wins()) do
			vim.api.nvim_set_current_win(w)
			if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype') == 'terminal' then
				tw = w
				break
			end
		end

		local w1 = wtd(fp)
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
end

return bsp
