--==================================================
-- DEAL BLOX
-- MAIN / BOOTSTRAP
-- Responsável apenas por carregar os módulos
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

--==================================================
-- CONFIGURAÇÃO DO REPOSITÓRIO
--==================================================

local BASE_URL =
	"https://raw.githubusercontent.com/dealblox/dealbloxscript/refs/heads/main/"

--==================================================
-- ESTADO GLOBAL
--==================================================

local Environment

if getgenv then
	Environment = getgenv()
else
	Environment = _G
end

-- Permite atualizar o script sem precisar
-- sair e entrar novamente no jogo.
Environment.DealBloxLoading = true

--==================================================
-- LOG INICIAL
--==================================================

local function BootstrapLog(message)
	print(
		"[DEAL BLOX / MAIN] "
		.. tostring(message)
	)
end

local function BootstrapWarn(message)
	warn(
		"[DEAL BLOX / MAIN] "
		.. tostring(message)
	)
end

--==================================================
-- CARREGADOR DE MÓDULOS
--==================================================

local LoadedModules = {}

local function LoadModule(path, required)

	BootstrapLog(
		"Carregando " .. path .. "..."
	)

	--==============================
	-- DOWNLOAD
	--==============================

	local downloadSuccess, source =
		pcall(function()

			return game:HttpGet(
				BASE_URL .. path
			)

		end)

	if not downloadSuccess then

		BootstrapWarn(
			"❌ Falha ao baixar: "
			.. path
		)

		BootstrapWarn(source)

		if required then
			error(
				"Módulo obrigatório não carregou: "
				.. path
			)
		end

		return nil
	end

	--==============================
	-- VERIFICAÇÃO DO ARQUIVO
	--==============================

	if not source or source == "" then

		BootstrapWarn(
			"❌ Arquivo vazio: "
			.. path
		)

		if required then
			error(
				"Arquivo obrigatório vazio: "
				.. path
			)
		end

		return nil
	end

	--==============================
	-- COMPILAÇÃO
	--==============================

	local compiled, compileError =
		loadstring(source)

	if not compiled then

		BootstrapWarn(
			"❌ Erro de compilação em: "
			.. path
		)

		BootstrapWarn(
			compileError
		)

		if required then
			error(
				"Erro de compilação: "
				.. path
			)
		end

		return nil
	end

	--==============================
	-- EXECUÇÃO
	--==============================

	local executeSuccess
	local result

	if debug and debug.traceback then

		executeSuccess, result =
			xpcall(
				compiled,
				debug.traceback
			)

	else

		executeSuccess, result =
			pcall(compiled)

	end

	if not executeSuccess then

		BootstrapWarn(
			"❌ Erro executando: "
			.. path
		)

		BootstrapWarn(result)

		if required then
			error(
				"Erro executando módulo: "
				.. path
			)
		end

		return nil
	end

	--==============================
	-- SALVAR MÓDULO
	--==============================

	LoadedModules[path] = result

	BootstrapLog(
		"✅ " .. path
	)

	return result
end

--==================================================
-- INICIALIZAÇÃO
--==================================================

local success, startupError =
	xpcall(

		function()

			BootstrapLog(
				"=============================="
			)

			BootstrapLog(
				"Iniciando DEAL BLOX..."
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

			Debug.Log(
				"Core carregado."
			)

			--==========================================
			-- COMPONENTES DA INTERFACE
			--==========================================

			local Components =
				LoadModule(
					"ui/components.lua",
					true
				)

			Debug.Log(
				"Componentes carregados."
			)

			--==========================================
			-- INTERFACE
			--==========================================

			local Interface =
				LoadModule(
					"ui/interface.lua",
					true
				)

			if
				type(Interface) ~= "table"
				or
				type(Interface.Create) ~= "function"
			then

				error(
					"ui/interface.lua não retornou Interface.Create"
				)

			end

			local App =
				Interface.Create(
					Config,
					Components,
					Debug
				)

			if not App then
				error(
					"A interface não retornou App."
				)
			end

			Debug.Log(
				"Interface principal criada."
			)

			--==========================================
			-- PÁGINA PRINCIPAL
			--==========================================

			local Principal =
				LoadModule(
					"ui/principal.lua",
					true
				)

			if
				type(Principal) ~= "table"
				or
				type(Principal.Create) ~= "function"
			then

				error(
					"ui/principal.lua não retornou Principal.Create"
				)

			end

			Principal.Create(
				App,
				Config,
				Components,
				Debug
			)

			--==========================================
			-- MÓDULOS FUTUROS
			--==========================================

			-- Esses arquivos podem existir,
			-- mas ainda não precisam fazer nada.

			LoadModule(
				"data/index.lua",
				false
			)

			LoadModule(
				"modules/index.lua",
				false
			)

			--==========================================
			-- COMPARTILHAR ESTADO
			--==========================================

			Environment.DealBlox = {

				Config = Config,

				Debug = Debug,

				Components = Components,

				Interface = Interface,

				Principal = Principal,

				App = App,

				Modules = LoadedModules

			}

			Environment.DealBloxLoading =
				false

			Environment.DealBloxLoaded =
				true

			--==========================================
			-- FINAL
			--==========================================

			Debug.Log(
				"=============================="
			)

			Debug.Log(
				"✅ DEAL BLOX CARREGADO!"
			)

			Debug.Log(
				"Site: "
				.. Config.Site
			)

			Debug.Log(
				"Discord: "
				.. Config.Discord
			)

			Debug.Log(
				"=============================="
			)

		end,

		function(errorMessage)

			if debug and debug.traceback then
				return debug.traceback(
					tostring(errorMessage)
				)
			end

			return tostring(errorMessage)

		end

	)

--==================================================
-- ERRO CRÍTICO
--==================================================

if not success then

	Environment.DealBloxLoading = false
	Environment.DealBloxLoaded = false

	BootstrapWarn(
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	)

	BootstrapWarn(
		"❌ FALHA AO INICIAR DEAL BLOX"
	)

	BootstrapWarn(
		startupError
	)

	BootstrapWarn(
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	)

	return
end
