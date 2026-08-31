--==================================================
-- DEAL BLOX
-- Interface Base
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

while not Player do
	task.wait()
	Player = Players.LocalPlayer
end

--==================================================
-- CONFIGURAÇÕES
--==================================================

local CONFIG = {
	Name = "DEAL BLOX",
	Version = "2.0 DEV",

	Site = "dealblox.com.br",
	SiteURL = "https://dealblox.com.br",

	Discord = "discord.gg/rPFN7BMC5k",

	-- Logo que você usava no script antigo
	Logo = "rbxassetid://92760392968513",

	Colors = {
		Blue = Color3.fromRGB(0, 125, 255),
		BlueNeon = Color3.fromRGB(0, 180, 255),

		Red = Color3.fromRGB(220, 25, 45),
		RedNeon = Color3.fromRGB(255, 45, 70),

		Background = Color3.fromRGB(7, 10, 17),
		Panel = Color3.fromRGB(11, 15, 24),
		Panel2 = Color3.fromRGB(18, 23, 35),

		Text = Color3.fromRGB(245, 248, 255),
		SubText = Color3.fromRGB(165, 175, 195)
	}
}

--==================================================
-- REMOVER GUI ANTIGA
--==================================================

pcall(function()
	local old = CoreGui:FindFirstChild("DealBlox")

	if old then
		old:Destroy()
	end
end)

pcall(function()
	local old = CoreGui:FindFirstChild("DealBloxV2")

	if old then
		old:Destroy()
	end
end)

--==================================================
-- DEBUG
--==================================================

local function Log(text)
	print("[DEAL BLOX] " .. tostring(text))
end

local function SafeCall(name, callback)

	local success, result =
		xpcall(callback, debug.traceback)

	if not success then
		warn("[DEAL BLOX] ERRO EM: " .. name)
		warn(result)
	end

	return success, result
end

--==================================================
-- FUNÇÕES ÚTEIS
--==================================================

local function GetValue(parent, name, default)

	if not parent then
		return default
	end

	local object = parent:FindFirstChild(name)

	if object then
		local success, value = pcall(function()
			return object.Value
		end)

		if success then
			return value
		end
	end

	return default
end

local function FormatNumber(number)

	number = tonumber(number) or 0

	if number >= 1000000000 then
		return string.format("%.2fB", number / 1000000000)

	elseif number >= 1000000 then
		return string.format("%.2fM", number / 1000000)

	elseif number >= 1000 then
		return string.format("%.1fK", number / 1000)
	end

	return tostring(math.floor(number))
end

local function GetSea()

	if game.PlaceId == 2753915549 then
		return "Sea 1"

	elseif game.PlaceId == 4442272183 then
		return "Sea 2"

	elseif game.PlaceId == 7449423635 then
		return "Sea 3"
	end

	return "Desconhecido"
end

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "DealBlox"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentSuccess = pcall(function()
	Gui.Parent = CoreGui
end)

if not parentSuccess or not Gui.Parent then
	Gui.Parent = Player:WaitForChild("PlayerGui")
end

--==================================================
-- BOTÃO FLUTUANTE
--==================================================

local OpenButton = Instance.new("ImageButton")

OpenButton.Name = "OpenButton"
OpenButton.Parent = Gui

OpenButton.Size = UDim2.fromOffset(62, 62)
OpenButton.Position = UDim2.new(0, 22, 0.5, -31)

OpenButton.BackgroundColor3 = CONFIG.Colors.Panel
OpenButton.BackgroundTransparency = 0.12

OpenButton.BorderSizePixel = 0

OpenButton.Image = CONFIG.Logo
OpenButton.ScaleType = Enum.ScaleType.Fit

OpenButton.Active = true
OpenButton.AutoButtonColor = true

OpenButton.ZIndex = 1000

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")

OpenStroke.Color = CONFIG.Colors.BlueNeon
OpenStroke.Thickness = 3
OpenStroke.Transparency = 0.05
OpenStroke.Parent = OpenButton

--==================================================
-- PAINEL PRINCIPAL
--==================================================

local Main = Instance.new("Frame")

Main.Name = "Main"
Main.Parent = Gui

Main.Size = UDim2.new(0.84, 0, 0.78, 0)
Main.Position = UDim2.fromScale(0.5, 0.5)

Main.AnchorPoint = Vector2.new(0.5, 0.5)

Main.BackgroundColor3 = CONFIG.Colors.Background
Main.BackgroundTransparency = 0.12

Main.BorderSizePixel = 0

Main.Visible = false
Main.Active = true
Main.ClipsDescendants = true

local SizeConstraint = Instance.new("UISizeConstraint")

SizeConstraint.MinSize = Vector2.new(500, 330)
SizeConstraint.MaxSize = Vector2.new(900, 560)

SizeConstraint.Parent = Main

local MainCorner = Instance.new("UICorner")

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")

MainStroke.Color = CONFIG.Colors.BlueNeon
MainStroke.Thickness = 2
MainStroke.Transparency = 0.1

MainStroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")

TopBar.Name = "TopBar"
TopBar.Parent = Main

TopBar.Size = UDim2.new(1, 0, 0, 54)

TopBar.BackgroundColor3 = Color3.fromRGB(10, 22, 42)
TopBar.BackgroundTransparency = 0.08

TopBar.BorderSizePixel = 0

TopBar.ZIndex = 10

local TopCorner = Instance.new("UICorner")

TopCorner.CornerRadius = UDim.new(0, 15)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")

TopFix.Parent = TopBar

TopFix.Size = UDim2.new(1, 0, 0, 14)
TopFix.Position = UDim2.new(0, 0, 1, -14)

TopFix.BackgroundColor3 = TopBar.BackgroundColor3
TopFix.BackgroundTransparency = TopBar.BackgroundTransparency

TopFix.BorderSizePixel = 0

-- Linha neon azul

local BlueLine = Instance.new("Frame")

BlueLine.Parent = TopBar

BlueLine.Size = UDim2.new(0.5, 0, 0, 2)
BlueLine.Position = UDim2.new(0, 0, 1, -2)

BlueLine.BackgroundColor3 = CONFIG.Colors.BlueNeon
BlueLine.BorderSizePixel = 0

-- Linha neon vermelha

local RedLine = Instance.new("Frame")

RedLine.Parent = TopBar

RedLine.Size = UDim2.new(0.5, 0, 0, 2)
RedLine.Position = UDim2.new(0.5, 0, 1, -2)

RedLine.BackgroundColor3 = CONFIG.Colors.RedNeon
RedLine.BorderSizePixel = 0

--==================================================
-- LOGO TOP BAR
--==================================================

local TopLogo = Instance.new("ImageLabel")

TopLogo.Parent = TopBar

TopLogo.Size = UDim2.fromOffset(38, 38)
TopLogo.Position = UDim2.fromOffset(12, 8)

TopLogo.BackgroundTransparency = 1

TopLogo.Image = CONFIG.Logo
TopLogo.ScaleType = Enum.ScaleType.Fit

TopLogo.ZIndex = 11

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")

Title.Parent = TopBar

Title.Size = UDim2.fromOffset(125, 54)
Title.Position = UDim2.fromOffset(56, 0)

Title.BackgroundTransparency = 1

Title.Text = "DEAL BLOX"

Title.TextColor3 = CONFIG.Colors.Text
Title.TextSize = 18

Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.ZIndex = 11

--==================================================
-- SITE PEQUENO
--==================================================

local SiteLabel = Instance.new("TextLabel")

SiteLabel.Parent = TopBar

SiteLabel.Size = UDim2.fromOffset(150, 54)
SiteLabel.Position = UDim2.fromOffset(173, 0)

SiteLabel.BackgroundTransparency = 1

SiteLabel.Text = "dealblox.com.br"

SiteLabel.TextColor3 = CONFIG.Colors.BlueNeon
SiteLabel.TextSize = 11

SiteLabel.Font = Enum.Font.Gotham

SiteLabel.TextXAlignment =
	Enum.TextXAlignment.Left

SiteLabel.ZIndex = 11

--==================================================
-- MINIMIZAR
--==================================================

local Minimize = Instance.new("TextButton")

Minimize.Name = "Minimize"
Minimize.Parent = TopBar

Minimize.Size = UDim2.fromOffset(34, 34)
Minimize.Position = UDim2.new(1, -86, 0.5, -17)

Minimize.BackgroundColor3 =
	Color3.fromRGB(20, 90, 170)

Minimize.BackgroundTransparency = 0.1

Minimize.BorderSizePixel = 0

Minimize.Text = "—"
Minimize.TextColor3 = CONFIG.Colors.Text

Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold

Minimize.ZIndex = 12

local MinimizeCorner =
	Instance.new("UICorner")

MinimizeCorner.CornerRadius =
	UDim.new(0, 8)

MinimizeCorner.Parent = Minimize

--==================================================
-- FECHAR
--==================================================

local Close = Instance.new("TextButton")

Close.Name = "Close"
Close.Parent = TopBar

Close.Size = UDim2.fromOffset(34, 34)
Close.Position = UDim2.new(1, -44, 0.5, -17)

Close.BackgroundColor3 = CONFIG.Colors.Red
Close.BackgroundTransparency = 0.05

Close.BorderSizePixel = 0

Close.Text = "X"

Close.TextColor3 = CONFIG.Colors.Text

Close.Font = Enum.Font.GothamBold
Close.TextSize = 14

Close.ZIndex = 12

local CloseCorner =
	Instance.new("UICorner")

CloseCorner.CornerRadius =
	UDim.new(0, 8)

CloseCorner.Parent = Close

--==================================================
-- BODY
--==================================================

local Body = Instance.new("Frame")

Body.Name = "Body"
Body.Parent = Main

Body.Position = UDim2.fromOffset(0, 54)
Body.Size = UDim2.new(1, 0, 1, -54)

Body.BackgroundTransparency = 1

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("ScrollingFrame")

Sidebar.Name = "Sidebar"
Sidebar.Parent = Body

Sidebar.Size = UDim2.new(0, 185, 1, 0)

Sidebar.BackgroundColor3 =
	Color3.fromRGB(10, 14, 23)

Sidebar.BackgroundTransparency = 0.18

Sidebar.BorderSizePixel = 0

Sidebar.ScrollBarThickness = 3

Sidebar.ScrollBarImageColor3 =
	CONFIG.Colors.BlueNeon

Sidebar.CanvasSize = UDim2.new()

Sidebar.AutomaticCanvasSize =
	Enum.AutomaticSize.Y

local SidebarLayout =
	Instance.new("UIListLayout")

SidebarLayout.Parent = Sidebar

SidebarLayout.Padding =
	UDim.new(0, 6)

SidebarLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Center

SidebarLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

local SidebarPadding =
	Instance.new("UIPadding")

SidebarPadding.Parent = Sidebar

SidebarPadding.PaddingTop =
	UDim.new(0, 10)

SidebarPadding.PaddingBottom =
	UDim.new(0, 10)

SidebarPadding.PaddingLeft =
	UDim.new(0, 7)

SidebarPadding.PaddingRight =
	UDim.new(0, 7)

--==================================================
-- CONTEÚDO
--==================================================

local Content = Instance.new("Frame")

Content.Name = "Content"
Content.Parent = Body

Content.Position = UDim2.new(0, 185, 0, 0)
Content.Size = UDim2.new(1, -185, 1, 0)

Content.BackgroundColor3 =
	CONFIG.Colors.Panel

Content.BackgroundTransparency = 0.18

Content.BorderSizePixel = 0

--==================================================
-- ABAS
--==================================================

local TabNames = {

	"Principal",
	"Loja",
	"Status servidor",
	"Teleporte",
	"Configurações de Farm",
	"Farm",
	"Farm Sea",
	"Outros farm",
	"Raids e Dungeons",
	"Frutas e Berry",
	"Eventos do Mar",
	"Raças",
	"Itens",
	"Draco",
	"ESP",
	"PVP",
	"Configurações"

}

local Tabs = {}
local CurrentTab = nil

--==================================================
-- EM OBRA
--==================================================

local function CreateConstructionPage(parent, name)

	local Icon = Instance.new("TextLabel")

	Icon.Parent = parent

	Icon.Size = UDim2.new(1, 0, 0, 70)
	Icon.Position = UDim2.new(0, 0, 0.5, -90)

	Icon.BackgroundTransparency = 1

	Icon.Text = "🚧"
	Icon.TextSize = 50

	local PageTitle =
		Instance.new("TextLabel")

	PageTitle.Parent = parent

	PageTitle.Size =
		UDim2.new(1, -40, 0, 35)

	PageTitle.Position =
		UDim2.new(0, 20, 0.5, -15)

	PageTitle.BackgroundTransparency = 1

	PageTitle.Text = name

	PageTitle.TextColor3 =
		CONFIG.Colors.Text

	PageTitle.TextSize = 21

	PageTitle.Font =
		Enum.Font.GothamBold

	local Construction =
		Instance.new("TextLabel")

	Construction.Parent = parent

	Construction.Size =
		UDim2.new(1, -50, 0, 60)

	Construction.Position =
		UDim2.new(0, 25, 0.5, 25)

	Construction.BackgroundTransparency = 1

	Construction.Text =
		"Esta aba ainda está em obra.\n" ..
		"Estamos desenvolvendo esta funcionalidade."

	Construction.TextColor3 =
		CONFIG.Colors.SubText

	Construction.TextSize = 13

	Construction.Font =
		Enum.Font.Gotham

	Construction.TextWrapped = true
end

--==================================================
-- CRIAR PRINCIPAL
--==================================================

local function CreatePrincipalPage(parent)

	-- Scroll da Principal

	local Scroll =
		Instance.new("ScrollingFrame")

	Scroll.Parent = parent

	Scroll.Size =
		UDim2.fromScale(1, 1)

	Scroll.BackgroundTransparency = 1

	Scroll.BorderSizePixel = 0

	Scroll.ScrollBarThickness = 3

	Scroll.ScrollBarImageColor3 =
		CONFIG.Colors.BlueNeon

	Scroll.CanvasSize =
		UDim2.new(0, 0, 0, 650)

	--==================================================
	-- TÍTULO PRINCIPAL
	--==================================================

	local Welcome =
		Instance.new("TextLabel")

	Welcome.Parent = Scroll

	Welcome.Size =
		UDim2.new(1, -30, 0, 36)

	Welcome.Position =
		UDim2.fromOffset(15, 14)

	Welcome.BackgroundTransparency = 1

	Welcome.Text =
		"Bem-vindo ao DEAL BLOX"

	Welcome.TextColor3 =
		CONFIG.Colors.Text

	Welcome.TextSize = 20

	Welcome.Font =
		Enum.Font.GothamBold

	Welcome.TextXAlignment =
		Enum.TextXAlignment.Left

	--==================================================
	-- IDENTIDADE
	--==================================================

	local Identity =
		Instance.new("Frame")

	Identity.Parent = Scroll

	Identity.Size =
		UDim2.new(1, -30, 0, 180)

	Identity.Position =
		UDim2.fromOffset(15, 58)

	Identity.BackgroundColor3 =
		CONFIG.Colors.Panel2

	Identity.BackgroundTransparency = 0.16

	Identity.BorderSizePixel = 0

	local IdentityCorner =
		Instance.new("UICorner")

	IdentityCorner.CornerRadius =
		UDim.new(0, 12)

	IdentityCorner.Parent = Identity

	local IdentityStroke =
		Instance.new("UIStroke")

	IdentityStroke.Color =
		CONFIG.Colors.BlueNeon

	IdentityStroke.Thickness = 1.5

	IdentityStroke.Transparency = 0.15

	IdentityStroke.Parent = Identity

	local IdentityTitle =
		Instance.new("TextLabel")

	IdentityTitle.Parent = Identity

	IdentityTitle.Size =
		UDim2.new(1, -20, 0, 30)

	IdentityTitle.Position =
		UDim2.fromOffset(12, 8)

	IdentityTitle.BackgroundTransparency = 1

	IdentityTitle.Text =
		"IDENTIDADE DA CONTA"

	IdentityTitle.TextColor3 =
		CONFIG.Colors.BlueNeon

	IdentityTitle.TextSize = 13

	IdentityTitle.Font =
		Enum.Font.GothamBold

	IdentityTitle.TextXAlignment =
		Enum.TextXAlignment.Left

	--==================================================
	-- AVATAR
	--==================================================

	local Avatar =
		Instance.new("ImageLabel")

	Avatar.Parent = Identity

	Avatar.Size =
		UDim2.fromOffset(105, 105)

	Avatar.Position =
		UDim2.fromOffset(16, 52)

	Avatar.BackgroundColor3 =
		Color3.fromRGB(25, 30, 42)

	Avatar.BorderSizePixel = 0

	local AvatarCorner =
		Instance.new("UICorner")

	AvatarCorner.CornerRadius =
		UDim.new(1, 0)

	AvatarCorner.Parent = Avatar

	local AvatarStroke =
		Instance.new("UIStroke")

	AvatarStroke.Color =
		CONFIG.Colors.RedNeon

	AvatarStroke.Thickness = 2

	AvatarStroke.Parent = Avatar

	task.spawn(function()

		local success, image =
			pcall(function()

				return Players:GetUserThumbnailAsync(
					Player.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size420x420
				)

			end)

		if success then
			Avatar.Image = image
		end

	end)

	--==================================================
	-- DADOS DA IDENTIDADE
	--==================================================

	local IdentityInfo =
		Instance.new("TextLabel")

	IdentityInfo.Parent = Identity

	IdentityInfo.Size =
		UDim2.new(1, -150, 0, 120)

	IdentityInfo.Position =
		UDim2.fromOffset(140, 47)

	IdentityInfo.BackgroundTransparency = 1

	IdentityInfo.Text =
		"Nome: " ..
		Player.DisplayName ..

		"\nUsuário: @" ..
		Player.Name ..

		"\nUser ID: " ..
		Player.UserId ..

		"\nIdade da conta: " ..
		Player.AccountAge ..
		" dias"

	IdentityInfo.TextColor3 =
		CONFIG.Colors.Text

	IdentityInfo.TextSize = 14

	IdentityInfo.Font =
		Enum.Font.Gotham

	IdentityInfo.TextXAlignment =
		Enum.TextXAlignment.Left

	IdentityInfo.TextYAlignment =
		Enum.TextYAlignment.Top

	--==================================================
	-- INFORMAÇÕES NO JOGO
	--==================================================

	local GameData =
		Instance.new("Frame")

	GameData.Parent = Scroll

	GameData.Size =
		UDim2.new(1, -30, 0, 205)

	GameData.Position =
		UDim2.fromOffset(15, 252)

	GameData.BackgroundColor3 =
		CONFIG.Colors.Panel2

	GameData.BackgroundTransparency = 0.16

	GameData.BorderSizePixel = 0

	local GameCorner =
		Instance.new("UICorner")

	GameCorner.CornerRadius =
		UDim.new(0, 12)

	GameCorner.Parent = GameData

	local GameStroke =
		Instance.new("UIStroke")

	GameStroke.Color =
		CONFIG.Colors.RedNeon

	GameStroke.Thickness = 1.5

	GameStroke.Transparency = 0.15

	GameStroke.Parent = GameData

	local GameTitle =
		Instance.new("TextLabel")

	GameTitle.Parent = GameData

	GameTitle.Size =
		UDim2.new(1, -20, 0, 30)

	GameTitle.Position =
		UDim2.fromOffset(12, 8)

	GameTitle.BackgroundTransparency = 1

	GameTitle.Text =
		"INFORMAÇÕES NO BLOX FRUITS"

	GameTitle.TextColor3 =
		CONFIG.Colors.RedNeon

	GameTitle.TextSize = 13

	GameTitle.Font =
		Enum.Font.GothamBold

	GameTitle.TextXAlignment =
		Enum.TextXAlignment.Left

	local Info =
		Instance.new("TextLabel")

	Info.Parent = GameData

	Info.Size =
		UDim2.new(1, -30, 1, -55)

	Info.Position =
		UDim2.fromOffset(15, 46)

	Info.BackgroundTransparency = 1

	Info.TextColor3 =
		CONFIG.Colors.Text

	Info.TextSize = 14

	Info.Font =
		Enum.Font.Gotham

	Info.TextXAlignment =
		Enum.TextXAlignment.Left

	Info.TextYAlignment =
		Enum.TextYAlignment.Top

	local function UpdateGameInfo()

		local Data =
			Player:FindFirstChild("Data")

		local level =
			GetValue(
				Data,
				"Level",
				"Carregando..."
			)

		local beli =
			GetValue(
				Data,
				"Beli",
				0
			)

		local fragments =
			GetValue(
				Data,
				"Fragments",
				0
			)

		local fruit =
			GetValue(
				Data,
				"DevilFruit",
				"Nenhuma"
			)

		local race =
			GetValue(
				Data,
				"Race",
				"Desconhecida"
			)

		Info.Text =
			"⭐ Level: " ..
			tostring(level) ..

			"\n💰 Dinheiro: $" ..
			FormatNumber(beli) ..

			"\n💎 Fragmentos: " ..
			FormatNumber(fragments) ..

			"\n🍎 Fruta ingerida: " ..
			tostring(fruit) ..

			"\n🧬 Raça: " ..
			tostring(race) ..

			"\n🌊 Mar atual: " ..
			GetSea()

	end

	UpdateGameInfo()

	task.spawn(function()

		while Gui.Parent do

			task.wait(3)

			SafeCall(
				"Atualizar Principal",
				UpdateGameInfo
			)

		end

	end)

	--==================================================
	-- COMUNIDADE
	--==================================================

	local Community =
		Instance.new("Frame")

	Community.Parent = Scroll

	Community.Size =
		UDim2.new(1, -30, 0, 125)

	Community.Position =
		UDim2.fromOffset(15, 472)

	Community.BackgroundColor3 =
		CONFIG.Colors.Panel2

	Community.BackgroundTransparency = 0.16

	Community.BorderSizePixel = 0

	local CommunityCorner =
		Instance.new("UICorner")

	CommunityCorner.CornerRadius =
		UDim.new(0, 12)

	CommunityCorner.Parent = Community

	local CommunityStroke =
		Instance.new("UIStroke")

	CommunityStroke.Color =
		CONFIG.Colors.BlueNeon

	CommunityStroke.Thickness = 1

	CommunityStroke.Parent = Community

	local CommunityTitle =
		Instance.new("TextLabel")

	CommunityTitle.Parent = Community

	CommunityTitle.Size =
		UDim2.new(1, -20, 0, 30)

	CommunityTitle.Position =
		UDim2.fromOffset(12, 8)

	CommunityTitle.BackgroundTransparency = 1

	CommunityTitle.Text =
		"DEAL BLOX"

	CommunityTitle.TextColor3 =
		CONFIG.Colors.Text

	CommunityTitle.Font =
		Enum.Font.GothamBold

	CommunityTitle.TextSize = 14

	CommunityTitle.TextXAlignment =
		Enum.TextXAlignment.Left

	-- Discord

	local DiscordButton =
		Instance.new("TextButton")

	DiscordButton.Parent = Community

	DiscordButton.Size =
		UDim2.new(0.48, 0, 0, 45)

	DiscordButton.Position =
		UDim2.new(0.02, 0, 0, 55)

	DiscordButton.BackgroundColor3 =
		Color3.fromRGB(20, 90, 180)

	DiscordButton.BorderSizePixel = 0

	DiscordButton.Text =
		"Discord\n" ..
		CONFIG.Discord

	DiscordButton.TextColor3 =
		CONFIG.Colors.Text

	DiscordButton.TextSize = 11

	DiscordButton.Font =
		Enum.Font.GothamBold

	local DiscordCorner =
		Instance.new("UICorner")

	DiscordCorner.CornerRadius =
		UDim.new(0, 8)

	DiscordCorner.Parent =
		DiscordButton

	DiscordButton.Activated:Connect(function()

		SafeCall("Copiar Discord", function()

			if setclipboard then
				setclipboard(CONFIG.Discord)

				DiscordButton.Text =
					"✅ Discord copiado!"
			else
				DiscordButton.Text =
					CONFIG.Discord
			end

			task.wait(2)

			DiscordButton.Text =
				"Discord\n" ..
				CONFIG.Discord

		end)

	end)

	-- Site

	local SiteButton =
		Instance.new("TextButton")

	SiteButton.Parent = Community

	SiteButton.Size =
		UDim2.new(0.48, 0, 0, 45)

	SiteButton.Position =
		UDim2.new(0.50, 0, 0, 55)

	SiteButton.BackgroundColor3 =
		Color3.fromRGB(175, 25, 45)

	SiteButton.BorderSizePixel = 0

	SiteButton.Text =
		"Site\n" ..
		CONFIG.Site

	SiteButton.TextColor3 =
		CONFIG.Colors.Text

	SiteButton.TextSize = 11

	SiteButton.Font =
		Enum.Font.GothamBold

	local SiteCorner =
		Instance.new("UICorner")

	SiteCorner.CornerRadius =
		UDim.new(0, 8)

	SiteCorner.Parent =
		SiteButton

	SiteButton.Activated:Connect(function()

		SafeCall("Copiar site", function()

			if setclipboard then

				setclipboard(
					CONFIG.SiteURL
				)

				SiteButton.Text =
					"✅ Site copiado!"

			else

				SiteButton.Text =
					CONFIG.Site

			end

			task.wait(2)

			SiteButton.Text =
				"Site\n" ..
				CONFIG.Site

		end)

	end)
end

--==================================================
-- CRIAR ABA
--==================================================

local function CreateTab(name, order)

	local Button =
		Instance.new("TextButton")

	Button.Name = name
	Button.Parent = Sidebar

	Button.Size =
		UDim2.new(1, -4, 0, 36)

	Button.BackgroundColor3 =
		Color3.fromRGB(18, 25, 38)

	Button.BackgroundTransparency = 0.08

	Button.BorderSizePixel = 0

	Button.Text = name

	Button.TextColor3 =
		CONFIG.Colors.Text

	Button.TextSize = 11

	Button.Font =
		Enum.Font.Gotham

	Button.LayoutOrder = order

	local ButtonCorner =
		Instance.new("UICorner")

	ButtonCorner.CornerRadius =
		UDim.new(0, 7)

	ButtonCorner.Parent = Button

	local Stroke =
		Instance.new("UIStroke")

	Stroke.Color =
		CONFIG.Colors.BlueNeon

	Stroke.Thickness = 0

	Stroke.Parent = Button

	local Page =
		Instance.new("Frame")

	Page.Name = name
	Page.Parent = Content

	Page.Size =
		UDim2.fromScale(1, 1)

	Page.BackgroundTransparency = 1
	Page.Visible = false

	if name == "Principal" then
		CreatePrincipalPage(Page)
	else
		CreateConstructionPage(
			Page,
			name
		)
	end

	Tabs[name] = {

		Button = Button,
		Page = Page,
		Stroke = Stroke

	}

	Button.Activated:Connect(function()

		for _, tab in pairs(Tabs) do

			tab.Page.Visible = false

			tab.Button.BackgroundColor3 =
				Color3.fromRGB(
					18,
					25,
					38
				)

			tab.Stroke.Thickness = 0

		end

		Page.Visible = true

		Button.BackgroundColor3 =
			Color3.fromRGB(
				15,
				55,
				100
			)

		Stroke.Thickness = 1.5

		if order % 2 == 0 then
			Stroke.Color =
				CONFIG.Colors.RedNeon
		else
			Stroke.Color =
				CONFIG.Colors.BlueNeon
		end

		CurrentTab = name

		Log(
			"Aba aberta: " ..
			name
		)

	end)
end

--==================================================
-- GERAR ABAS
--==================================================

for index, name in ipairs(TabNames) do
	CreateTab(name, index)
end

--==================================================
-- PRINCIPAL PADRÃO
--==================================================

if Tabs["Principal"] then

	Tabs["Principal"].Page.Visible = true

	Tabs["Principal"].Button.BackgroundColor3 =
		Color3.fromRGB(
			15,
			55,
			100
		)

	Tabs["Principal"].Stroke.Color =
		CONFIG.Colors.BlueNeon

	Tabs["Principal"].Stroke.Thickness = 1.5

	CurrentTab = "Principal"
end

--==================================================
-- ABRIR / FECHAR
--==================================================

local opened = false
local debounce = false
local minimized = false

local OriginalSize =
	UDim2.new(
		0.84,
		0,
		0.78,
		0
	)

local function SetOpen(state)

	if debounce then
		return
	end

	debounce = true
	opened = state

	if state then

		Main.Visible = true

		Main.BackgroundTransparency = 0.35

		TweenService:Create(
			Main,
			TweenInfo.new(0.2),
			{
				BackgroundTransparency =
					0.12
			}
		):Play()

	else

		local tween =
			TweenService:Create(

				Main,

				TweenInfo.new(0.17),

				{
					BackgroundTransparency =
						1
				}
			)

		tween:Play()

		tween.Completed:Wait()

		Main.Visible = false
	end

	debounce = false
end

OpenButton.Activated:Connect(function()

	SafeCall("Abrir GUI", function()

		if minimized then

			minimized = false

			Body.Visible = true

			SizeConstraint.MinSize =
				Vector2.new(500, 330)

			SizeConstraint.MaxSize =
				Vector2.new(900, 560)

			Main.Size = OriginalSize

		end

		SetOpen(not opened)

	end)

end)

Close.Activated:Connect(function()

	SafeCall("Fechar GUI", function()
		SetOpen(false)
	end)

end)

--==================================================
-- MINIMIZAR
--==================================================

Minimize.Activated:Connect(function()

	SafeCall("Minimizar", function()

		if not minimized then

			minimized = true

			Body.Visible = false

			SizeConstraint.MinSize =
				Vector2.new(400, 54)

			SizeConstraint.MaxSize =
				Vector2.new(900, 54)

			Main.Size =
				UDim2.new(
					0.84,
					0,
					0,
					54
				)

			Minimize.Text = "+"

		else

			minimized = false

			SizeConstraint.MinSize =
				Vector2.new(500, 330)

			SizeConstraint.MaxSize =
				Vector2.new(900, 560)

			Main.Size =
				OriginalSize

			Body.Visible = true

			Minimize.Text = "—"

		end

	end)

end)

--==================================================
-- ARRASTAR
--==================================================

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)

	if
		input.UserInputType ==
			Enum.UserInputType.MouseButton1

		or

		input.UserInputType ==
			Enum.UserInputType.Touch
	then

		dragging = true

		dragStart =
			input.Position

		startPosition =
			Main.Position
	end
end)

UserInputService.InputChanged:Connect(
	function(input)

		if not dragging then
			return
		end

		if
			input.UserInputType ==
				Enum.UserInputType.MouseMovement

			or

			input.UserInputType ==
				Enum.UserInputType.Touch
		then

			local delta =
				input.Position -
				dragStart

			Main.Position =
				UDim2.new(

					startPosition.X.Scale,

					startPosition.X.Offset +
						delta.X,

					startPosition.Y.Scale,

					startPosition.Y.Offset +
						delta.Y
				)
		end
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if
			input.UserInputType ==
				Enum.UserInputType.MouseButton1

			or

			input.UserInputType ==
				Enum.UserInputType.Touch
		then

			dragging = false
		end
	end
)

--==================================================
-- FINAL
--==================================================

Log("================================")
Log("DEAL BLOX")
Log("Site: " .. CONFIG.Site)
Log("Discord: " .. CONFIG.Discord)
Log(#TabNames .. " abas carregadas.")
Log("Interface carregada.")
Log("================================")
