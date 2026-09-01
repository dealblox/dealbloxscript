--==================================================
-- DEAL BLOX
-- MAIN
--==================================================

repeat
	task.wait()
until game:IsLoaded()

local Players =
	game:GetService("Players")

local Player =
	Players.LocalPlayer

while not Player do

	task.wait()

	Player =
		Players.LocalPlayer
end

local BASE_URL =
	"https://raw.githubusercontent.com/dealblox/dealbloxscript/refs/heads/main/"

local Environment =
	getgenv and getgenv() or _G

Environment.DealBloxLoading =
	true

--==================================================
-- LOG
--==================================================

local function Log(
	text
)

	print(
		"[DEAL BLOX / MAIN] "
		..
		tostring(text)
	)
end

local function Warn(
	text
)

	warn(
		"[DEAL BLOX / MAIN] "
		..
		tostring(text)
	)
end

--==================================================
-- LOAD
--==================================================

local LoadedModules = {}

local function LoadModule(
	path
)

	Log(
		"Carregando "
		..
		path
	)

	local downloadSuccess, source =
		pcall(function()

			return game:HttpGet(
				BASE_URL
				..
				path
			)

		end)

	if not downloadSuccess then

		error(
			"Falha ao baixar "
			..
			path
			..
			"\n"
			..
			tostring(source)
		)
	end

	if
		not source
		or
		source == ""
	then

		error(
			"Arquivo vazio: "
			..
			path
		)
	end

	local compiled, compileError =
		loadstring(
			source
		)

	if not compiled then

		error(
			"Erro de compilação em "
			..
			path
			..
			"\n"
			..
			tostring(
				compileError
			)
		)
	end

	local success, result =
		xpcall(
			compiled,
			debug.traceback
		)

	if not success then

		error(
			"Erro executando "
			..
			path
			..
			"\n"
			..
			tostring(
				result
			)
		)
	end

	LoadedModules[path] =
		result

	Log(
		"✅ "
		..
		path
	)

	return result
end

--==================================================
-- START
--==================================================

local success, errorMessage =
	xpcall(

		function()

			Log(
				"============================="
			)

			Log(
				"Iniciando DEAL BLOX"
			)

			-- CORE

			local Config =
				LoadModule(
					"core/config.lua"
				)

			local Debug =
				LoadModule(
					"core/debug.lua"
				)

			local State =
				LoadModule(
					"core/state.lua"
				)

			-- DATA

			local Quests =
				LoadModule(
					"data/quests.lua"
				)

			-- UI COMPONENTS

			local Components =
				LoadModule(
					"ui/components.lua"
				)

			-- INTERFACE

			local Interface =
				LoadModule(
					"ui/interface.lua"
				)

			local App =
				Interface.Create(
					Config,
					Components,
					Debug
				)

			if not App then

				error(
					"Interface.Create não retornou App."
				)
			end

			-- PRINCIPAL

			local Principal =
				LoadModule(
					"ui/principal.lua"
				)

			Principal.Create(
				App,
				Config,
				Components,
				Debug
			)

			-- FARM ENGINE

			local FarmModule =
				LoadModule(
					"modules/farm.lua"
				)

			local FarmEngine =
				FarmModule.Create(
					State,
					Quests,
					Debug
				)

			if not FarmEngine then

				error(
					"FarmModule.Create não retornou FarmEngine."
				)
			end

			-- CONFIG FARM

			local FarmConfig =
				LoadModule(
					"ui/farmconfig.lua"
				)

			FarmConfig.Create(
				App,
				Config,
				Components,
				Debug,
				State
			)

			-- FARM UI

			local FarmUI =
				LoadModule(
					"ui/farm.lua"
				)

			FarmUI.Create(
				App,
				Config,
				Components,
				Debug,
				State,
				FarmEngine
			)

			-- GLOBAL

			Environment.DealBlox = {

				Config =
					Config,

				Debug =
					Debug,

				State =
					State,

				Quests =
					Quests,

				App =
					App,

				Farm =
					FarmEngine,

				Modules =
					LoadedModules
			}

			Environment.DealBloxLoading =
				false

			Environment.DealBloxLoaded =
				true

			Debug.Log(
				"============================="
			)

			Debug.Log(
				"✅ DEAL BLOX CARREGADO"
			)

			Debug.Log(
				"Farm e Configurações disponíveis."
			)

			Debug.Log(
				"============================="
			)
		end,

		debug.traceback
	)

--==================================================
-- ERRO
--==================================================

if not success then

	Environment.DealBloxLoading =
		false

	Environment.DealBloxLoaded =
		false

	Warn(
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	)

	Warn(
		"❌ ERRO AO INICIAR DEAL BLOX"
	)

	Warn(
		errorMessage
	)

	Warn(
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	)
end
