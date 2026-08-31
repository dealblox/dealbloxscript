--==================================================
-- DEAL BLOX V2
-- Interface Base
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

while not Player do
	task.wait()
	Player = Players.LocalPlayer
end

--==================================================
-- REMOVER GUI ANTIGA
--==================================================

pcall(function()
	local old = game:GetService("CoreGui"):FindFirstChild("DealBloxV2")
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

local function SafeCall(nome, callback)
	local success, result = xpcall(callback, debug.traceback)

	if not success then
		warn("[DEAL BLOX] ERRO EM: " .. nome)
		warn(result)
	end

	return success, result
end

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "DealBloxV2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function()
	Gui.Parent = game:GetService("CoreGui")
end)

if not successParent or not Gui.Parent then
	Gui.Parent = Player:WaitForChild("PlayerGui")
end

--==================================================
-- BOTÃO DB
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = Gui
OpenButton.Size = UDim2.fromOffset(60, 60)
OpenButton.Position = UDim2.new(0, 20, 0.5, -30)
OpenButton.BackgroundColor3 = Color3.fromRGB(42, 101, 190)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "DB"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Active = true
OpenButton.AutoButtonColor = true
OpenButton.ZIndex = 1000

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(70, 155, 255)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

--==================================================
-- PAINEL PRINCIPAL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = Gui

-- Responsivo para PC e celular
Main.Size = UDim2.new(0.82, 0, 0.78, 0)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)

Main.BackgroundColor3 = Color3.fromRGB(13, 16, 23)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.ClipsDescendants = true

local SizeConstraint = Instance.new("UISizeConstraint")
SizeConstraint.MinSize = Vector2.new(500, 330)
SizeConstraint.MaxSize = Vector2.new(850, 520)
SizeConstraint.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 110, 210)
MainStroke.Thickness = 2
MainStroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3 = Color3.fromRGB(43, 101, 188)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Parent = TopBar
TopFix.Size = UDim2.new(1, 0, 0, 15)
TopFix.Position = UDim2.new(0, 0, 1, -15)
TopFix.BackgroundColor3 = TopBar.BackgroundColor3
TopFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.fromOffset(18, 0)
Title.BackgroundTransparency = 1
Title.Text = "DEAL BLOX V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6

--==================================================
-- BOTÃO FECHAR
--==================================================

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Parent = TopBar
Close.Size = UDim2.fromOffset(34, 34)
Close.Position = UDim2.new(1, -44, 0.5, -17)
Close.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.ZIndex = 7

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

--==================================================
-- ÁREA DAS ABAS
--==================================================

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Parent = Main
Body.Position = UDim2.fromOffset(0, 52)
Body.Size = UDim2.new(1, 0, 1, -52)
Body.BackgroundTransparency = 1

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = Body
Sidebar.Size = UDim2.new(0, 185, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(17, 22, 32)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 4
Sidebar.ScrollBarImageColor3 = Color3.fromRGB(45, 110, 210)
Sidebar.CanvasSize = UDim2.new()
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingBottom = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 7)
SidebarPadding.PaddingRight = UDim.new(0, 7)

--==================================================
-- ÁREA DE CONTEÚDO
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Body
Content.Position = UDim2.new(0, 185, 0, 0)
Content.Size = UDim2.new(1, -185, 1, 0)
Content.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
Content.BorderSizePixel = 0

--==================================================
-- LISTA DE ABAS
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
-- CONTEÚDO "EM OBRA"
--==================================================

local function CreateConstructionPage(parent, nome)
	local Icon = Instance.new("TextLabel")
	Icon.Parent = parent
	Icon.Size = UDim2.fromOffset(100, 80)
	Icon.Position = UDim2.new(0.5, -50, 0.5, -100)
	Icon.BackgroundTransparency = 1
	Icon.Text = "🚧"
	Icon.TextSize = 55

	local PageTitle = Instance.new("TextLabel")
	PageTitle.Parent = parent
	PageTitle.Size = UDim2.new(1, -40, 0, 40)
	PageTitle.Position = UDim2.new(0, 20, 0.5, -20)
	PageTitle.BackgroundTransparency = 1
	PageTitle.Text = nome
	PageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	PageTitle.TextSize = 22
	PageTitle.Font = Enum.Font.GothamBold

	local Construction = Instance.new("TextLabel")
	Construction.Parent = parent
	Construction.Size = UDim2.new(1, -40, 0, 70)
	Construction.Position = UDim2.new(0, 20, 0.5, 25)
	Construction.BackgroundTransparency = 1
	Construction.Text =
		"Esta aba ainda está em obra.\n" ..
		"Em breve adicionaremos as funcionalidades."
	Construction.TextColor3 = Color3.fromRGB(175, 180, 195)
	Construction.TextSize = 14
	Construction.Font = Enum.Font.Gotham
	Construction.TextWrapped = true
end

--==================================================
-- CRIAR ABA
--==================================================

local function CreateTab(nome, ordem)

	local Button = Instance.new("TextButton")
	Button.Name = nome
	Button.Parent = Sidebar
	Button.Size = UDim2.new(1, -4, 0, 36)
	Button.BackgroundColor3 = Color3.fromRGB(24, 30, 43)
	Button.BorderSizePixel = 0
	Button.Text = nome
	Button.TextColor3 = Color3.fromRGB(215, 220, 230)
	Button.TextSize = 11
	Button.Font = Enum.Font.Gotham
	Button.LayoutOrder = ordem

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 7)
	ButtonCorner.Parent = Button

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(50, 120, 220)
	Stroke.Thickness = 0
	Stroke.Parent = Button

	local Page = Instance.new("Frame")
	Page.Name = nome
	Page.Parent = Content
	Page.Size = UDim2.fromScale(1, 1)
	Page.BackgroundTransparency = 1
	Page.Visible = false

	CreateConstructionPage(Page, nome)

	Tabs[nome] = {
		Button = Button,
		Page = Page,
		Stroke = Stroke
	}

	Button.Activated:Connect(function()

		for _, tab in pairs(Tabs) do
			tab.Page.Visible = false
			tab.Button.BackgroundColor3 =
				Color3.fromRGB(24, 30, 43)
			tab.Stroke.Thickness = 0
		end

		Page.Visible = true
		Button.BackgroundColor3 =
			Color3.fromRGB(43, 101, 188)

		Stroke.Thickness = 1

		CurrentTab = nome

		Log("Aba aberta: " .. nome)
	end)
end

--==================================================
-- GERAR TODAS AS ABAS
--==================================================

for index, nome in ipairs(TabNames) do
	CreateTab(nome, index)
end

--==================================================
-- ABRIR PRINCIPAL POR PADRÃO
--==================================================

if Tabs["Principal"] then
	Tabs["Principal"].Page.Visible = true
	Tabs["Principal"].Button.BackgroundColor3 =
		Color3.fromRGB(43, 101, 188)

	Tabs["Principal"].Stroke.Thickness = 1

	CurrentTab = "Principal"
end

--==================================================
-- ABRIR / FECHAR GUI
--==================================================

local opened = false
local debounce = false

local function SetOpen(state)

	if debounce then
		return
	end

	debounce = true
	opened = state

	if state then

		Main.Visible = true

		Main.BackgroundTransparency = 1

		TweenService:Create(
			Main,
			TweenInfo.new(0.2),
			{
				BackgroundTransparency = 0
			}
		):Play()

	else

		local tween = TweenService:Create(
			Main,
			TweenInfo.new(0.18),
			{
				BackgroundTransparency = 1
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
		SetOpen(not opened)
	end)
end)

Close.Activated:Connect(function()
	SafeCall("Fechar GUI", function()
		SetOpen(false)
	end)
end)

--==================================================
-- ARRASTAR GUI
--==================================================

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

--==================================================
-- FINAL
--==================================================

Log("Interface criada.")
Log(#TabNames .. " abas carregadas.")
Log("Deal Blox V2 pronto.")
