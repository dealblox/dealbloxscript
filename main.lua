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
-- CACHE BUSTER
--==================================================

local function CacheKey()
	return
		tostring(
			math.floor(
				tick() * 1000
			)
		)
		..
		"-"
		..
		tostring(
			math.random(
				100000,
				999999
			)
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

	local url =
		BASE_URL
		..
		path
		..
		"?dealblox="
		..
		CacheKey()

	local downloadSuccess, source =
		pcall(function()
			return game:HttpGet(
				url
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

local function TryLoadModule(path)
	local success, result =
		xpcall(
			function()
				return LoadModule(
					path
				)
			end,
			debug.traceback
		)

	if success then
		return result, nil
	end

	Warn(result)

	return nil, result
end

--==================================================
-- ERRO VISUAL EM UMA ABA
--==================================================

local function ShowPageError(
	App,
	pageName,
	title,
	message
)
	if
		not App
		or
		not App.GetPage
	then
		return
	end

	local Page =
		App:GetPage(
			pageName
		)

	if not Page then
		return
	end

	for _, object in ipairs(
		Page:GetChildren()
	) do
		object:Destroy()
	end

	local Holder =
		Instance.new(
			"Frame"
		)

	Holder.Parent =
		Page

	Holder.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	Holder.Position =
		UDim2.fromScale(
			0.5,
			0.5
		)

	Holder.Size =
		UDim2.new(
			1,
			-30,
			0,
			220
		)

	Holder.BackgroundColor3 =
		Color3.fromRGB(
			22,
			27,
			38
		)

	Holder.BorderSizePixel =
		0

	local Corner =
		Instance.new(
			"UICorner"
		)

	Corner.CornerRadius =
		UDim.new(
			0,
			12
		)

	Corner.Parent =
		Holder

	local Stroke =
		Instance.new(
			"UIStroke"
		)

	Stroke.Color =
		Color3.fromRGB(
			255,
			70,
			90
		)

	Stroke.Thickness =
		1.5

	Stroke.Parent =
		Holder

	local Title =
		Instance.new(
			"TextLabel"
		)

	Title.Parent =
		Holder

	Title.Position =
		UDim2.fromOffset(
			16,
			14
		)

	Title.Size =
		UDim2.new(
			1,
			-32,
			0,
			32
		)

	Title.BackgroundTransparency =
		1

	Title.Text =
		title

	Title.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	Title.Font =
		Enum.Font.GothamBold

	Title.TextSize =
		16

	Title.TextXAlignment =
		Enum.TextXAlignment.Left

	local Message =
		Instance.new(
			"TextLabel"
		)

	Message.Parent =
		Holder

	Message.Position =
		UDim2.fromOffset(
			16,
			55
		)

	Message.Size =
		UDim2.new(
			1,
			-32,
			1,
			-70
		)

	Message.BackgroundTransparency =
		1

	Message.Text =
		tostring(message)

	Message.TextColor3 =
		Color3.fromRGB(
			210,
			215,
			225
		)

	Message.Font =
		Enum.Font.Gotham

	Message.TextSize =
		12

	Message.TextWrapped =
		true

	Message.TextXAlignment =
		Enum.TextXAlignment.Left

	Message.TextYAlignment =
		Enum.TextYAlignment.Top
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

			local ShopData =
				LoadModule(
					"data/shop.lua"
				)

			--==================================================
			-- UI COMPONENTS
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

			--==================================================
			-- PRINCIPAL
			--==================================================

			local Principal,
				principalError =
				TryLoadModule(
					"ui/principal.lua"
				)

			if Principal then
				local principalSuccess,
					principalCreateError =
					xpcall(
						function()
							Principal.Create(
								App,
								Config,
								Components,
								Debug
							)
						end,
						debug.traceback
					)

				if not principalSuccess then
					Warn(
						principalCreateError
					)
				end
			else
				Warn(
					principalError
				)
			end

			--==================================================
			-- FARM ENGINE
			--==================================================

			local FarmModule,
				farmModuleError =
				TryLoadModule(
					"modules/farm.lua"
				)

			local FarmEngine =
				nil

			if FarmModule then
				local farmCreateSuccess,
					farmResult =
					xpcall(
						function()
							return FarmModule.Create(
								State,
								Quests,
								Debug
							)
						end,
						debug.traceback
					)

				if farmCreateSuccess then
					FarmEngine =
						farmResult
				else
					farmModuleError =
						farmResult

					Warn(
						farmResult
					)
				end
			end

			--==================================================
			-- CONFIG FARM
			--==================================================

			local FarmConfig,
				farmConfigError =
				TryLoadModule(
					"ui/farmconfig.lua"
				)

			if FarmConfig then
				local configSuccess,
					configCreateError =
					xpcall(
						function()
							FarmConfig.Create(
								App,
								Config,
								Components,
								Debug,
								State
							)
						end,
						debug.traceback
					)

				if not configSuccess then
					farmConfigError =
						configCreateError

					Warn(
						configCreateError
					)
				end
			end

			--==================================================
			-- FARM UI
			--==================================================

			if not FarmEngine then
				ShowPageError(
					App,
					"Farm",
					"❌ AUTO FARM NÃO CARREGOU",
					farmModuleError
						or
						"FarmEngine não foi criado."
				)
			else
				local FarmUI,
					farmUIError =
					TryLoadModule(
						"ui/farm.lua"
					)

				if FarmUI then
					local uiSuccess,
						uiCreateError =
						xpcall(
							function()
								FarmUI.Create(
									App,
									Config,
									Components,
									Debug,
									State,
									FarmEngine
								)
							end,
							debug.traceback
						)

					if not uiSuccess then
						farmUIError =
							uiCreateError

						Warn(
							uiCreateError
						)
					end
				end

				if
					not FarmUI
					or
					farmUIError
				then
					ShowPageError(
						App,
						"Farm",
						"❌ ERRO NA ABA FARM",
						farmUIError
							or
							"ui/farm.lua não retornou um módulo válido."
					)
				end
			end

			--==================================================
			-- SHOP ENGINE
			--==================================================

			local ShopModule,
				shopModuleError =
				TryLoadModule(
					"modules/shop.lua"
				)

			local ShopEngine =
				nil

			if ShopModule then
				local shopCreateSuccess,
					shopResult =
					xpcall(
						function()
							return ShopModule.Create(
								ShopData,
								Debug
							)
						end,
						debug.traceback
					)

				if shopCreateSuccess then
					ShopEngine =
						shopResult
				else
					shopModuleError =
						shopResult

					Warn(
						shopResult
					)
				end
			end

			--==================================================
			-- SHOP UI
			--==================================================

			if ShopEngine then
				local ShopUI,
					shopUIError =
					TryLoadModule(
						"ui/shop.lua"
					)

				if ShopUI then
					local shopUISuccess,
						shopUICreateError =
						xpcall(
							function()
								ShopUI.Create(
									App,
									Config,
									Debug,
									ShopEngine
								)
							end,
							debug.traceback
						)

					if not shopUISuccess then
						Warn(
							shopUICreateError
						)

						ShowPageError(
							App,
							"Loja",
							"❌ ERRO NA ABA LOJA",
							shopUICreateError
						)
					end
				else
					ShowPageError(
						App,
						"Loja",
						"❌ LOJA NÃO CARREGOU",
						shopUIError
							or
							"ui/shop.lua não carregou."
					)
				end
			else
				ShowPageError(
					App,
					"Loja",
					"❌ SHOP ENGINE NÃO CARREGOU",
					shopModuleError
						or
						"modules/shop.lua não carregou."
				)
			end

			--==================================================
			-- ESP ENGINE
			--==================================================

			local ESPModule,
				espModuleError =
				TryLoadModule(
					"modules/esp.lua"
				)

			local ESPEngine =
				nil

			if ESPModule then
				local espCreateSuccess,
					espResult =
					xpcall(
						function()
							return ESPModule.Create(
								Debug
							)
						end,
						debug.traceback
					)

				if espCreateSuccess then
					ESPEngine =
						espResult
				else
					espModuleError =
						espResult

					Warn(
						espResult
					)
				end
			end

			--==================================================
			-- ESP UI
			--==================================================

			if ESPEngine then
				local ESPUI,
					espUIError =
					TryLoadModule(
						"ui/esp.lua"
					)

				if ESPUI then
					local espUISuccess,
						espUICreateError =
						xpcall(
							function()
								ESPUI.Create(
									App,
									Config,
									Debug,
									ESPEngine
								)
							end,
							debug.traceback
						)

					if not espUISuccess then
						Warn(
							espUICreateError
						)
					end
				else
					Warn(
						espUIError
					)
				end
			else
				Warn(
					espModuleError
						or
						"ESP Engine não carregou."
				)
			end

			--==================================================
			-- SEA TOPBAR
			--==================================================

			if
				App.SeaBadge
				and
				Quests.GetSea
			then
				local sea =
					Quests.GetSea()

				App.SeaBadge.Text =
					sea > 0
						and
						(
							"SEA "
							..
							tostring(sea)
						)
						or
						"SEA ?"
			end

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

				ESP =
					ESPEngine,

				Shop =
					ShopEngine,

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

			if FarmEngine then
				Debug.Log(
					"✅ Farm Engine disponível."
				)
			else
				Debug.Warn(
					"❌ Farm Engine indisponível."
				)
			end

			Debug.Log(
				"============================="
			)
		end,
		debug.traceback
	)

--==================================================
-- ERRO GERAL
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
