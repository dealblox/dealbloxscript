--==================================================
-- DEAL BLOX
-- MAIN
--==================================================

repeat
	task.wait()
until game:IsLoaded()

local Players =
	game:GetService("Players")

local ReplicatedStorage =
	game:GetService("ReplicatedStorage")

local Player =
	Players.LocalPlayer

while not Player do
	task.wait()

	Player =
		Players.LocalPlayer
end

--==================================================
-- CONFIG
--==================================================

local BASE_URL =
	"https://raw.githubusercontent.com/dealblox/dealbloxscript/refs/heads/main/"

local Environment =
	getgenv and getgenv() or _G

Environment.DealBloxLoading =
	true

Environment.DealBloxLoaded =
	false

--==================================================
-- LOG
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

local function LoadModule(path)

	Log(
		"Carregando "
		..
		path
	)

	-- Evita carregar versão antiga em cache
	local cacheBuster =
		"?dealblox="
		..
		tostring(
			math.floor(
				tick() * 1000
			)
		)

	local downloadSuccess, source =
		pcall(function()

			return game:HttpGet(
				BASE_URL
				..
				path
				..
				cacheBuster
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
		loadstring(source)

	if not compiled then

		error(
			"Erro de compilação em "
			..
			path
			..
			"\n"
			..
			tostring(compileError)
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
			tostring(result)
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
-- DETECTOR DE SEA
--==================================================

local function ConfigureSeaDetector(
	Quests,
	Debug
)

	local KnownPlaceIds = {

		-- SEA 1
		[2753915549] = 1,

		-- SEA 2
		[4442272183] = 2,

		-- SEA 3
		[7449423635] = 3
	}

	--==================================================
	-- NOMES ÚNICOS DOS MAPAS
	--==================================================

	local SeaLocations = {

		[1] = {

			"Middle Town",
			"Jungle",
			"Pirate Village",
			"Desert",
			"Frozen Village",
			"Marine Fortress",
			"Skylands",
			"Prison",
			"Magma Village",
			"Underwater City",
			"Fountain City"
		},

		[2] = {

			"Kingdom of Rose",
			"Green Zone",
			"Graveyard",
			"Snow Mountain",
			"Hot and Cold",
			"Cursed Ship",
			"Ice Castle",
			"Forgotten Island"
		},

		[3] = {

			"Port Town",
			"Hydra Island",
			"Great Tree",
			"Floating Turtle",
			"Castle on the Sea",
			"Haunted Castle",
			"Sea of Treats",
			"Tiki Outpost"
		}
	}

	local CachedSea =
		nil

	--==================================================
	-- NORMALIZAR
	--==================================================

	local function Normalize(text)

		text =
			string.lower(
				tostring(text or "")
			)

		text =
			string.gsub(
				text,
				"[%s%p_]+",
				""
			)

		return text
	end

	--==================================================
	-- BUSCAR LOCAL
	--==================================================

	local function HasLocation(
		container,
		locationName
	)

		if not container then
			return false
		end

		local target =
			Normalize(
				locationName
			)

		for _, object in ipairs(
			container:GetChildren()
		) do

			if
				Normalize(object.Name)
				==
				target
			then

				return true
			end
		end

		return false
	end

	--==================================================
	-- DETECTAR PELO MAPA
	--==================================================

	local function DetectFromWorld()

		local WorldOrigin =
			workspace:FindFirstChild(
				"_WorldOrigin"
			)

		if not WorldOrigin then
			return 0
		end

		local Locations =
			WorldOrigin:FindFirstChild(
				"Locations"
			)

		if not Locations then
			return 0
		end

		local BestSea =
			0

		local BestScore =
			0

		for sea, locationList in pairs(
			SeaLocations
		) do

			local Score =
				0

			for _, locationName in ipairs(
				locationList
			) do

				if
					HasLocation(
						Locations,
						locationName
					)
				then

					Score =
						Score + 1
				end
			end

			if Score > BestScore then

				BestScore =
					Score

				BestSea =
					sea
			end
		end

		if BestScore > 0 then

			return BestSea
		end

		return 0
	end

	--==================================================
	-- DETECTOR PRINCIPAL
	--==================================================

	local function DetectSea()

		-- Já detectado
		if CachedSea then
			return CachedSea
		end

		-- Método 1:
		-- PlaceId conhecido

		local ByPlaceId =
			KnownPlaceIds[
				game.PlaceId
			]

		if ByPlaceId then

			CachedSea =
				ByPlaceId

			return CachedSea
		end

		-- Método 2:
		-- Estrutura do mapa

		local ByMap =
			DetectFromWorld()

		if ByMap > 0 then

			CachedSea =
				ByMap

			return CachedSea
		end

		-- Não armazenamos 0 em cache.
		-- Assim o script continua tentando
		-- enquanto o mapa termina de carregar.

		return 0
	end

	--==================================================
	-- SUBSTITUIR FUNÇÃO
	--==================================================

	Quests.GetSea =
		DetectSea

	--==================================================
	-- DEBUG
	--==================================================

	task.spawn(function()

		task.wait(1)

		local sea =
			DetectSea()

		print(
			"[DEAL BLOX / SEA] PlaceId="
			..
			tostring(game.PlaceId)
			..
			" | GameId="
			..
			tostring(game.GameId)
			..
			" | Sea="
			..
			tostring(sea)
		)

		if sea > 0 then

			Debug.Log(
				"✅ Sea detectado: SEA "
				..
				tostring(sea)
			)

		else

			Debug.Warn(
				"⚠️ Sea não detectado. PlaceId: "
				..
				tostring(game.PlaceId)
			)
		end
	end)

	return DetectSea
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

			--==================================================
			-- CORE
			--==================================================

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

			--==================================================
			-- DATA
			--==================================================

			local Quests =
				LoadModule(
					"data/quests.lua"
				)

			--==================================================
			-- SEA DETECTOR
			--==================================================

			local DetectSea =
				ConfigureSeaDetector(
					Quests,
					Debug
				)

			--==================================================
			-- COMPONENTES
			--==================================================

			local Components =
				LoadModule(
					"ui/components.lua"
				)

			--==================================================
			-- INTERFACE
			--==================================================

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

			-- Atualiza o SEA do topo
			-- imediatamente.

			if App.SeaBadge then

				local sea =
					DetectSea()

				if sea > 0 then

					App.SeaBadge.Text =
						"SEA "
						..
						tostring(sea)

				else

					App.SeaBadge.Text =
						"SEA ?"
				end
			end

			--==================================================
			-- PRINCIPAL
			--==================================================

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

			--==================================================
			-- FARM ENGINE
			--==================================================

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

			--==================================================
			-- CONFIG FARM
			--==================================================

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

			--==================================================
			-- FARM UI
			--==================================================

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

			--==================================================
			-- GLOBAL
			--==================================================

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
				"SEA atual: "
				..
				tostring(
					DetectSea()
				)
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
