--==================================================
-- DEAL BLOX
-- UI / PRINCIPAL
-- Página inicial do script
--==================================================

local Principal = {}

--==================================================
-- FUNÇÕES AUXILIARES
--==================================================

local function GetValue(parent, name, default)

	if not parent then
		return default
	end

	local object = parent:FindFirstChild(name)

	if not object then
		return default
	end

	local success, value = pcall(function()
		return object.Value
	end)

	if success then
		return value
	end

	return default
end

local function GetFirstValue(parent, names, default)

	if not parent then
		return default
	end

	for _, name in ipairs(names) do

		local object = parent:FindFirstChild(name)

		if object then

			local success, value = pcall(function()
				return object.Value
			end)

			if success then
				return value
			end

		end
	end

	return default
end

local function FormatNumber(number)

	number = tonumber(number) or 0

	if number >= 1000000000 then
		return string.format(
			"%.2fB",
			number / 1000000000
		)

	elseif number >= 1000000 then

		return string.format(
			"%.2fM",
			number / 1000000
		)

	elseif number >= 1000 then

		return string.format(
			"%.1fK",
			number / 1000
		)

	end

	return tostring(
		math.floor(number)
	)
end

local function GetSea()

	if game.PlaceId == 2753915549 then
		return "Primeiro Mar"

	elseif game.PlaceId == 4442272183 then
		return "Segundo Mar"

	elseif game.PlaceId == 7449423635 then
		return "Terceiro Mar"
	end

	return "Desconhecido"
end

--==================================================
-- CRIAR PRINCIPAL
--==================================================

function Principal.Create(
	App,
	Config,
	Components,
	Debug
)

	local Players =
		game:GetService("Players")

	local Player =
		Players.LocalPlayer

	if not Player then
		Debug.Warn(
			"LocalPlayer não encontrado."
		)

		return
	end

	local Page =
		App:GetPage("Principal")

	if not Page then

		Debug.Warn(
			"Página Principal não encontrada."
		)

		return
	end

	--==================================================
	-- LIMPAR PRINCIPAL
	--==================================================

	for _, child in ipairs(Page:GetChildren()) do
		child:Destroy()
	end

	--==================================================
	-- SCROLL
	--==================================================

	local Scroll =
		Components.Scroll(
			Page,
			Config
		)

	Components.Padding(
		Scroll,
		14,
		14,
		14,
		18
	)

	local Layout =
		Components.List(
			Scroll,
			12
		)

	--==================================================
	-- BOAS-VINDAS
	--==================================================

	local Welcome =
		Components.Title(
			Scroll,
			"Bem-vindo ao DEAL BLOX",
			Config
		)

	Welcome.LayoutOrder = 1

	local WelcomeSub =
		Components.Subtitle(
			Scroll,
			"Suas informações e status atual.",
			Config
		)

	WelcomeSub.LayoutOrder = 2

	local Divider =
		Components.Divider(
			Scroll,
			Config
		)

	Divider.LayoutOrder = 3

	--==================================================
	-- IDENTIDADE DA CONTA
	--==================================================

	local Identity =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.BlueNeon
		)

	Identity.Name =
		"IdentityCard"

	Identity.Size =
		UDim2.new(
			1,
			0,
			0,
			185
		)

	Identity.LayoutOrder = 4

	-- Título

	local IdentityTitle =
		Instance.new("TextLabel")

	IdentityTitle.Parent = Identity

	IdentityTitle.Position =
		UDim2.fromOffset(
			15,
			10
		)

	IdentityTitle.Size =
		UDim2.new(
			1,
			-30,
			0,
			28
		)

	IdentityTitle.BackgroundTransparency =
		1

	IdentityTitle.Text =
		"IDENTIDADE DA CONTA"

	IdentityTitle.TextColor3 =
		Config.Colors.BlueNeon

	IdentityTitle.Font =
		Enum.Font.GothamBold

	IdentityTitle.TextSize = 13

	IdentityTitle.TextXAlignment =
		Enum.TextXAlignment.Left

	--==================================================
	-- AVATAR
	--==================================================

	local Avatar =
		Components.Avatar(
			Identity,
			Player,
			Config
		)

	Avatar.Size =
		UDim2.fromOffset(
			105,
			105
		)

	Avatar.Position =
		UDim2.fromOffset(
			18,
			52
		)

	--==================================================
	-- DADOS DA CONTA
	--==================================================

	local AccountInfo =
		Instance.new("Frame")

	AccountInfo.Parent = Identity

	AccountInfo.Position =
		UDim2.fromOffset(
			145,
			48
		)

	AccountInfo.Size =
		UDim2.new(
			1,
			-165,
			0,
			115
		)

	AccountInfo.BackgroundTransparency =
		1

	local AccountLayout =
		Components.List(
			AccountInfo,
			1
		)

	local _, DisplayValue =
		Components.InfoRow(
			AccountInfo,
			"Nome",
			Player.DisplayName,
			Config
		)

	local _, UsernameValue =
		Components.InfoRow(
			AccountInfo,
			"Usuário",
			"@" .. Player.Name,
			Config
		)

	local _, IDValue =
		Components.InfoRow(
			AccountInfo,
			"User ID",
			Player.UserId,
			Config
		)

	local _, AgeValue =
		Components.InfoRow(
			AccountInfo,
			"Conta criada há",
			Player.AccountAge .. " dias",
			Config
		)

	--==================================================
	-- INFORMAÇÕES DO BLOX FRUITS
	--==================================================

	local GameCard =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.RedNeon
		)

	GameCard.Name =
		"GameInformation"

	GameCard.Size =
		UDim2.new(
			1,
			0,
			0,
			245
		)

	GameCard.LayoutOrder = 5

	local GameTitle =
		Instance.new("TextLabel")

	GameTitle.Parent = GameCard

	GameTitle.Position =
		UDim2.fromOffset(
			15,
			10
		)

	GameTitle.Size =
		UDim2.new(
			1,
			-30,
			0,
			28
		)

	GameTitle.BackgroundTransparency =
		1

	GameTitle.Text =
		"INFORMAÇÕES NO BLOX FRUITS"

	GameTitle.TextColor3 =
		Config.Colors.RedNeon

	GameTitle.Font =
		Enum.Font.GothamBold

	GameTitle.TextSize = 13

	GameTitle.TextXAlignment =
		Enum.TextXAlignment.Left

	--==================================================
	-- LISTA DE INFORMAÇÕES
	--==================================================

	local GameInfo =
		Instance.new("Frame")

	GameInfo.Parent = GameCard

	GameInfo.Position =
		UDim2.fromOffset(
			15,
			47
		)

	GameInfo.Size =
		UDim2.new(
			1,
			-30,
			1,
			-60
		)

	GameInfo.BackgroundTransparency =
		1

	local GameLayout =
		Components.List(
			GameInfo,
			2
		)

	local _, LevelValue =
		Components.InfoRow(
			GameInfo,
			"⭐ Level",
			"Carregando...",
			Config
		)

	local _, MoneyValue =
		Components.InfoRow(
			GameInfo,
			"💰 Dinheiro",
			"Carregando...",
			Config
		)

	local _, FragmentValue =
		Components.InfoRow(
			GameInfo,
			"💎 Fragmentos",
			"Carregando...",
			Config
		)

	local _, FruitValue =
		Components.InfoRow(
			GameInfo,
			"🍎 Fruta ingerida",
			"Carregando...",
			Config
		)

	local _, RaceValue =
		Components.InfoRow(
			GameInfo,
			"🧬 Raça",
			"Carregando...",
			Config
		)

	local _, SeaValue =
		Components.InfoRow(
			GameInfo,
			"🌊 Mar atual",
			GetSea(),
			Config
		)

	--==================================================
	-- ATUALIZAR INFORMAÇÕES
	--==================================================

	local function UpdateGameData()

		local Data =
			Player:FindFirstChild(
				"Data"
			)

		if not Data then

			LevelValue.Text =
				"Aguardando dados..."

			MoneyValue.Text = "—"
			FragmentValue.Text = "—"
			FruitValue.Text = "—"
			RaceValue.Text = "—"

			return
		end

		local Level =
			GetValue(
				Data,
				"Level",
				0
			)

		local Money =
			GetFirstValue(
				Data,
				{
					"Beli",
					"Money"
				},
				0
			)

		local Fragments =
			GetFirstValue(
				Data,
				{
					"Fragments",
					"Fragment"
				},
				0
			)

		local Fruit =
			GetFirstValue(
				Data,
				{
					"DevilFruit",
					"BloxFruit",
					"Fruit"
				},
				"Nenhuma"
			)

		local Race =
			GetFirstValue(
				Data,
				{
					"Race"
				},
				"Desconhecida"
			)

		LevelValue.Text =
			tostring(Level)

		MoneyValue.Text =
			"$" ..
			FormatNumber(Money)

		FragmentValue.Text =
			FormatNumber(
				Fragments
			)

		FruitValue.Text =
			tostring(Fruit)

		RaceValue.Text =
			tostring(Race)

		SeaValue.Text =
			GetSea()
	end

	-- primeira atualização

	Debug.SafeCall(
		"Dados da Principal",

		UpdateGameData
	)

	-- atualização automática

	task.spawn(function()

		while
			Page.Parent
			and
			App.Gui.Parent
		do

			task.wait(3)

			Debug.SafeCall(
				"Atualizar informações do jogador",

				UpdateGameData
			)

		end

	end)

	--==================================================
	-- DEAL BLOX / COMUNIDADE
	--==================================================

	local Community =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.BlueNeon
		)

	Community.Size =
		UDim2.new(
			1,
			0,
			0,
			145
		)

	Community.LayoutOrder = 6

	local CommunityTitle =
		Instance.new("TextLabel")

	CommunityTitle.Parent =
		Community

	CommunityTitle.Position =
		UDim2.fromOffset(
			15,
			10
		)

	CommunityTitle.Size =
		UDim2.new(
			1,
			-30,
			0,
			25
		)

	CommunityTitle.BackgroundTransparency =
		1

	CommunityTitle.Text =
		"DEAL BLOX"

	CommunityTitle.TextColor3 =
		Config.Colors.Text

	CommunityTitle.TextSize = 14

	CommunityTitle.Font =
		Enum.Font.GothamBold

	CommunityTitle.TextXAlignment =
		Enum.TextXAlignment.Left

	local CommunityDescription =
		Instance.new("TextLabel")

	CommunityDescription.Parent =
		Community

	CommunityDescription.Position =
		UDim2.fromOffset(
			15,
			37
		)

	CommunityDescription.Size =
		UDim2.new(
			1,
			-30,
			0,
			25
		)

	CommunityDescription.BackgroundTransparency =
		1

	CommunityDescription.Text =
		"Entre na comunidade ou visite nosso site."

	CommunityDescription.TextColor3 =
		Config.Colors.SubText

	CommunityDescription.TextSize = 11

	CommunityDescription.Font =
		Enum.Font.Gotham

	CommunityDescription.TextXAlignment =
		Enum.TextXAlignment.Left

	--==================================================
	-- BOTÕES
	--==================================================

	local Buttons =
		Instance.new("Frame")

	Buttons.Parent =
		Community

	Buttons.Position =
		UDim2.fromOffset(
			15,
			78
		)

	Buttons.Size =
		UDim2.new(
			1,
			-30,
			0,
			48
		)

	Buttons.BackgroundTransparency = 1

	local DiscordButton =
		Components.Button(
			Buttons,
			"Discord",
			Config,
			Config.Colors.Blue
		)

	DiscordButton.Size =
		UDim2.new(
			0.49,
			0,
			1,
			0
		)

	DiscordButton.Position =
		UDim2.new(
			0,
			0,
			0,
			0
		)

	DiscordButton.Text =
		"Discord\n" ..
		Config.Discord

	DiscordButton.TextWrapped = true

	local SiteButton =
		Components.Button(
			Buttons,
			"Site",
			Config,
			Config.Colors.Red
		)

	SiteButton.Size =
		UDim2.new(
			0.49,
			0,
			1,
			0
		)

	SiteButton.Position =
		UDim2.new(
			0.51,
			0,
			0,
			0
		)

	SiteButton.Text =
		"Site\n" ..
		"dealblox.com.br"

	SiteButton.TextWrapped = true

	--==================================================
	-- COPIAR DISCORD
	--==================================================

	DiscordButton.Activated:Connect(function()

		Debug.SafeCall(
			"Copiar Discord",

			function()

				if setclipboard then

					setclipboard(
						Config.Discord
					)

					DiscordButton.Text =
						"✅ Discord copiado!"

				else

					DiscordButton.Text =
						Config.Discord
				end

				task.wait(2)

				if DiscordButton.Parent then

					DiscordButton.Text =
						"Discord\n" ..
						Config.Discord
				end

			end
		)

	end)

	--==================================================
	-- COPIAR SITE
	--==================================================

	SiteButton.Activated:Connect(function()

		Debug.SafeCall(
			"Copiar site",

			function()

				if setclipboard then

					setclipboard(
						Config.Site
					)

					SiteButton.Text =
						"✅ Site copiado!"

				else

					SiteButton.Text =
						"dealblox.com.br"
				end

				task.wait(2)

				if SiteButton.Parent then

					SiteButton.Text =
						"Site\n" ..
						"dealblox.com.br"
				end

			end
		)

	end)

	Debug.Log(
		"Página Principal criada."
	)
end

return Principal
