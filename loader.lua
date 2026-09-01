--==================================================
-- DEAL BLOX V2
-- LOADER
--==================================================

repeat
	task.wait()
until game:IsLoaded()

local URL =
	"https://raw.githubusercontent.com/dealblox/dealbloxscript/refs/heads/main/main.lua"
	..
	"?dealblox="
	..
	tostring(
		math.floor(
			tick() * 1000
		)
	)

local success, source =
	pcall(function()
		return game:HttpGet(
			URL
		)
	end)

if not success then
	error(
		"[DEAL BLOX / LOADER] Falha ao baixar main.lua:\n"
		..
		tostring(source)
	)
end

local compiled, compileError =
	loadstring(
		source
	)

if not compiled then
	error(
		"[DEAL BLOX / LOADER] Erro de compilação no main.lua:\n"
		..
		tostring(compileError)
	)
end

local runSuccess, runError =
	xpcall(
		compiled,
		debug.traceback
	)

if not runSuccess then
	error(
		"[DEAL BLOX / LOADER] Erro executando main.lua:\n"
		..
		tostring(runError)
	)
end
