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
-- BOOT LOG
--==================================================

local function Log(text)

	print(
		"[DEAL BLOX / MAIN] "
		..
		tostring(text)
	)
end

local function Warn(text)

	warn(
		"[DEAL BLOX / MAIN] "
		..
		tostring(text)
	)
end

--==================================================
-- LOAD MODULE
--==================================================

local LoadedModules = {}

local function LoadModule(
	path,
	required
)

	Log(
		"Carregando "
		..
		path
	)

	-- DOWNLOAD

	local downloadSuccess, source =
		pcall(function()

			return game:HttpGet(
				BASE_URL
				..
				path
			)

		end)

	if not downloadSuccess then

		Warn(
			"Falha download: "
			..
			path
		)

		Warn(source)

		if required then
			error(
				"Falha obrigatória: "
				..
				path
			)
		end

		return nil
	end

	-- COMPILAR

	local compiled, compileError =
		loadstring(source)

	if not compiled then

		Warn(
			"Erro compilação: "
			..
			path
		)

		Warn(
			compileError
		)

		if required then
			error(
				compileError
			)
		end

		return nil
	end

	-- EXECUTAR

	local success, result =
		xpcall(
			compiled,
			debug.traceback
		)

	if not success then

		Warn(
			"Erro módulo: "
			..
			path
		)

		Warn(result)

		if required then
			error(result)
		end

		return nil
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

local success, startupError =
	xpcall(

		function()

			Log(
				"=========================="
			)

			Log(
				"Iniciando DEAL BLOX"
			)

			--==========================================
			-- CORE
			--==========================================

			local Config =
				LoadModule(
					"core/config.lua",
					true
				)

			local Debug =
				LoadModule(
					"core/debug.lua",
					true
				)

			local State =
				LoadModule(
					"core/state.lua",
					true
				)

			--==========================================
			-- DATA
			--==========================================

			local Quests =
				LoadModule(
					"data/quests.lua",
					true
				)

			--==========================================
			-- COMPONENTS
			--==========================================

			local Components =
				LoadModule(
					"ui/components.lua",
					true
				)

			--==========================================
			-- INTERFACE
			--==========================================

			local Interface =
				LoadModule(
					"ui/interface.lua",
					true
				)

			local App =
				Interface.Create(
					Config,
					Components,
					Debug
				)

			--==========================================
			-- PRINCIPAL
			--==========================================

			local Principal =
				LoadModule(
					"ui/principal.lua",
					true
				)

			Principal.Create(
				App,
				Config,
				Components,
				Debug
			)

			--==========================================
			-- MOTOR FARM
			--==========================================

			local FarmModule =
				LoadModule(
					"modules/farm.lua",
					true
				)

			local FarmEngine =
				FarmModule.Create(
					State,
					Quests,
					Debug
				)

			--==========================================
			-- FARM CONFIG UI
			--==========================================

			local FarmConfig =
				LoadModule(
					"ui/farmconfig.lua",
					true
				)

			FarmConfig.Create(
				App,
				Config,
				Components,
				Debug,
				State
			)

			--==========================================
			-- FARM UI
			--==========================================

			local FarmUI =
				LoadModule(
					"ui/farm.lua",
					true
				)

			FarmUI.Create(
				App,
				Config,
				Components,
				Debug,
				State,
				FarmEngine
			)

			--==========================================
			-- EXPOR DEAL BLOX
			--==========================================

			Environment.DealBlox = {

				Config =
					Config,

				Debug =
					Debug,

				State =
					State,

				Quests =
					Quests,

				Components =
					Components,

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
				"=========================="
			)

			Debug.Log(
				"✅ DEAL BLOX CARREGADO"
			)

			Debug.Log(
				"Auto Farm disponível."
			)

			Debug.Log(
				"=========================="
			)

		end,

		debug.traceback
	)

--==================================================
-- ERROR
--==================================================

if not success then

	Environment.DealBloxLoading =
		false

	Environment.DealBloxLoaded =
		false

	Warn(
		"━━━━━━━━━━━━━━━━━━━━━━━━"
	)

	Warn(
		"❌ DEAL BLOX NÃO INICIOU"
	)

	Warn(
		startupError
	)

	Warn(
		"━━━━━━━━━━━━━━━━━━━━━━━━"
	)
end
