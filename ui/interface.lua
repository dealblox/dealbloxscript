--==================================================
-- DEAL BLOX
-- UI / INTERFACE
-- Janela principal, abas e navegação
--==================================================

local Interface = {}

--==================================================
-- ABAS DO DEAL BLOX
--==================================================

local TAB_NAMES = {
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

--==================================================
-- CRIAR INTERFACE
--==================================================

function Interface.Create(Config, Components, Debug)

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local CoreGui = game:GetService("CoreGui")

	local Player = Players.LocalPlayer

	while not Player do
		task.wait()
		Player = Players.LocalPlayer
	end

	Debug.Log("Criando interface...")

	--==================================================
	-- REMOVER INTERFACE ANTIGA
	--==================================================

	pcall(function()

		local oldGui =
			CoreGui:FindFirstChild("DealBlox")

		if oldGui then
			oldGui:Destroy()
		end

	end)

	pcall(function()

		local playerGui =
			Player:FindFirstChild("PlayerGui")

		if playerGui then

			local oldGui =
				playerGui:FindFirstChild("DealBlox")

			if oldGui then
				oldGui:Destroy()
			end

		end

	end)

	--==================================================
	-- SCREEN GUI
	--==================================================

	local Gui = Instance.new("ScreenGui")

	Gui.Name = "DealBlox"
	Gui.ResetOnSpawn = false
	Gui.IgnoreGuiInset = true

	Gui.ZIndexBehavior =
		Enum.ZIndexBehavior.Sibling

	local parentSuccess = pcall(function()
		Gui.Parent = CoreGui
	end)

	if not parentSuccess or not Gui.Parent then

		Gui.Parent =
			Player:WaitForChild("PlayerGui")

	end

	--==================================================
	-- BOTÃO FLUTUANTE DEAL BLOX
	--==================================================

	local OpenButton =
		Instance.new("ImageButton")

	OpenButton.Name = "OpenButton"

	OpenButton.Parent = Gui

	OpenButton.Size =
		UDim2.fromOffset(64, 64)

	OpenButton.Position =
		UDim2.new(
			0,
			20,
			0.5,
			-32
		)

	OpenButton.BackgroundColor3 =
		Config.Colors.Panel

	OpenButton.BackgroundTransparency =
		0.12

	OpenButton.BorderSizePixel = 0

	OpenButton.Image =
		Config.Logo

	OpenButton.ScaleType =
		Enum.ScaleType.Fit

	OpenButton.Active = true
	OpenButton.AutoButtonColor = true

	OpenButton.ZIndex = 1000

	Components.Corner(
		OpenButton,
		999
	)

	local OpenStroke =
		Components.Stroke(
			OpenButton,
			Config.Colors.BlueNeon,
			2.5,
			0
		)

	--==================================================
	-- PULSO NEON DA BOLINHA
	--==================================================

	task.spawn(function()

		while OpenButton.Parent do

			TweenService:Create(
				OpenStroke,
				TweenInfo.new(
					1.2,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut
				),
				{
					Color =
						Config.Colors.RedNeon
				}
			):Play()

			task.wait(1.2)

			TweenService:Create(
				OpenStroke,
				TweenInfo.new(
					1.2,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut
				),
				{
					Color =
						Config.Colors.BlueNeon
				}
			):Play()

			task.wait(1.2)

		end

	end)

	--==================================================
	-- PAINEL PRINCIPAL
	--==================================================

	local Main =
		Instance.new("Frame")

	Main.Name = "Main"

	Main.Parent = Gui

	Main.AnchorPoint =
		Vector2.new(0.5, 0.5)

	Main.Position =
		UDim2.fromScale(
			0.5,
			0.5
		)

	Main.Size =
		UDim2.new(
			0.84,
			0,
			0.80,
			0
		)

	Main.BackgroundColor3 =
		Config.Colors.Background

	Main.BackgroundTransparency =
		0.14

	Main.BorderSizePixel = 0

	Main.ClipsDescendants = true

	Main.Active = true

	Main.Visible = false

	local MainConstraint =
		Instance.new("UISizeConstraint")

	MainConstraint.MinSize =
		Vector2.new(
			500,
			320
		)

	MainConstraint.MaxSize =
		Vector2.new(
			920,
			570
		)

	MainConstraint.Parent = Main

	Components.Corner(
		Main,
		15
	)

	local MainStroke =
		Components.Stroke(
			Main,
			Config.Colors.BlueNeon,
			2,
			0.05
		)

	--==================================================
	-- EFEITO NEON DO PAINEL
	--==================================================

	task.spawn(function()

		while Main.Parent do

			TweenService:Create(
				MainStroke,
				TweenInfo.new(
					2,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut
				),
				{
					Color =
						Config.Colors.RedNeon
				}
			):Play()

			task.wait(2)

			TweenService:Create(
				MainStroke,
				TweenInfo.new(
					2,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut
				),
				{
					Color =
						Config.Colors.BlueNeon
				}
			):Play()

			task.wait(2)

		end

	end)

	--==================================================
	-- TOP BAR
	--==================================================

	local TopBar =
		Instance.new("Frame")

	TopBar.Name = "TopBar"

	TopBar.Parent = Main

	TopBar.Size =
		UDim2.new(
			1,
			0,
			0,
			56
		)

	TopBar.BackgroundColor3 =
		Color3.fromRGB(
			8,
			18,
			35
		)

	TopBar.BackgroundTransparency =
		0.08

	TopBar.BorderSizePixel = 0

	TopBar.ZIndex = 20

	Components.Corner(
		TopBar,
		15
	)

	-- corrige canto inferior da TopBar

	local TopFix =
		Instance.new("Frame")

	TopFix.Parent = TopBar

	TopFix.Size =
		UDim2.new(
			1,
			0,
			0,
			16
		)

	TopFix.Position =
		UDim2.new(
			0,
			0,
			1,
			-16
		)

	TopFix.BackgroundColor3 =
		TopBar.BackgroundColor3

	TopFix.BackgroundTransparency =
		TopBar.BackgroundTransparency

	TopFix.BorderSizePixel = 0

	TopFix.ZIndex = 20

	--==================================================
	-- LINHAS NEON
	--==================================================

	local BlueLine =
		Instance.new("Frame")

	BlueLine.Parent = TopBar

	BlueLine.Size =
		UDim2.new(
			0.5,
			0,
			0,
			2
		)

	BlueLine.Position =
		UDim2.new(
			0,
			0,
			1,
			-2
		)

	BlueLine.BackgroundColor3 =
		Config.Colors.BlueNeon

	BlueLine.BorderSizePixel = 0

	BlueLine.ZIndex = 22

	local RedLine =
		Instance.new("Frame")

	RedLine.Parent = TopBar

	RedLine.Size =
		UDim2.new(
			0.5,
			0,
			0,
			2
		)

	RedLine.Position =
		UDim2.new(
			0.5,
			0,
			1,
			-2
		)

	RedLine.BackgroundColor3 =
		Config.Colors.RedNeon

	RedLine.BorderSizePixel = 0

	RedLine.ZIndex = 22

	--==================================================
	-- LOGO
	--==================================================

	local Logo =
		Instance.new("ImageLabel")

	Logo.Name = "Logo"

	Logo.Parent = TopBar

	Logo.Size =
		UDim2.fromOffset(
			40,
			40
		)

	Logo.Position =
		UDim2.fromOffset(
			12,
			8
		)

	Logo.BackgroundTransparency = 1

	Logo.Image =
		Config.Logo

	Logo.ScaleType =
		Enum.ScaleType.Fit

	Logo.ZIndex = 25

	--==================================================
	-- NOME DEAL BLOX
	--==================================================

	local Title =
		Instance.new("TextLabel")

	Title.Parent = TopBar

	Title.Size =
		UDim2.fromOffset(
			125,
			56
		)

	Title.Position =
		UDim2.fromOffset(
			59,
			0
		)

	Title.BackgroundTransparency = 1

	Title.Text =
		"DEAL BLOX"

	Title.TextColor3 =
		Config.Colors.Text

	Title.TextSize = 18

	Title.Font =
		Enum.Font.GothamBold

	Title.TextXAlignment =
		Enum.TextXAlignment.Left

	Title.ZIndex = 25

	--==================================================
	-- SITE
	--==================================================

	local Site =
		Instance.new("TextLabel")

	Site.Parent = TopBar

	Site.Size =
		UDim2.fromOffset(
			160,
			56
		)

	Site.Position =
		UDim2.fromOffset(
			178,
			0
		)

	Site.BackgroundTransparency = 1

	Site.Text =
		"dealblox.com.br"

	Site.TextColor3 =
		Config.Colors.BlueNeon

	Site.TextSize = 11

	Site.Font =
		Enum.Font.Gotham

	Site.TextXAlignment =
		Enum.TextXAlignment.Left

	Site.ZIndex = 25

	--==================================================
	-- BOTÃO MINIMIZAR
	--==================================================

	local Minimize =
		Instance.new("TextButton")

	Minimize.Name = "Minimize"

	Minimize.Parent = TopBar

	Minimize.Size =
		UDim2.fromOffset(
			35,
			35
		)

	Minimize.Position =
		UDim2.new(
			1,
			-88,
			0.5,
			-17
		)

	Minimize.BackgroundColor3 =
		Color3.fromRGB(
			10,
			90,
			180
		)

	Minimize.BackgroundTransparency =
		0.05

	Minimize.BorderSizePixel = 0

	Minimize.Text = "—"

	Minimize.TextColor3 =
		Config.Colors.Text

	Minimize.TextSize = 20

	Minimize.Font =
		Enum.Font.GothamBold

	Minimize.ZIndex = 30

	Components.Corner(
		Minimize,
		8
	)

	Components.Stroke(
		Minimize,
		Config.Colors.BlueNeon,
		1,
		0.2
	)

	--==================================================
	-- BOTÃO FECHAR
	--==================================================

	local Close =
		Instance.new("TextButton")

	Close.Name = "Close"

	Close.Parent = TopBar

	Close.Size =
		UDim2.fromOffset(
			35,
			35
		)

	Close.Position =
		UDim2.new(
			1,
			-45,
			0.5,
			-17
		)

	Close.BackgroundColor3 =
		Config.Colors.Red

	Close.BackgroundTransparency =
		0.04

	Close.BorderSizePixel = 0

	Close.Text = "X"

	Close.TextColor3 =
		Config.Colors.Text

	Close.TextSize = 14

	Close.Font =
		Enum.Font.GothamBold

	Close.ZIndex = 30

	Components.Corner(
		Close,
		8
	)

	Components.Stroke(
		Close,
		Config.Colors.RedNeon,
		1,
		0.1
	)

	--==================================================
	-- BODY
	--==================================================

	local Body =
		Instance.new("Frame")

	Body.Name = "Body"

	Body.Parent = Main

	Body.Position =
		UDim2.fromOffset(
			0,
			56
		)

	Body.Size =
		UDim2.new(
			1,
			0,
			1,
			-56
		)

	Body.BackgroundTransparency = 1

	--==================================================
	-- SIDEBAR
	--==================================================

	local Sidebar =
		Instance.new("ScrollingFrame")

	Sidebar.Name = "Sidebar"

	Sidebar.Parent = Body

	Sidebar.Size =
		UDim2.new(
			0,
			185,
			1,
			0
		)

	Sidebar.BackgroundColor3 =
		Color3.fromRGB(
			7,
			12,
			22
		)

	Sidebar.BackgroundTransparency =
		0.16

	Sidebar.BorderSizePixel = 0

	Sidebar.ScrollBarThickness = 3

	Sidebar.ScrollBarImageColor3 =
		Config.Colors.BlueNeon

	Sidebar.CanvasSize =
		UDim2.new()

	Sidebar.AutomaticCanvasSize =
		Enum.AutomaticSize.Y

	local SidebarLayout =
		Instance.new("UIListLayout")

	SidebarLayout.Parent = Sidebar

	SidebarLayout.Padding =
		UDim.new(
			0,
			6
		)

	SidebarLayout.SortOrder =
		Enum.SortOrder.LayoutOrder

	SidebarLayout.HorizontalAlignment =
		Enum.HorizontalAlignment.Center

	local SidebarPadding =
		Instance.new("UIPadding")

	SidebarPadding.Parent = Sidebar

	SidebarPadding.PaddingTop =
		UDim.new(
			0,
			10
		)

	SidebarPadding.PaddingBottom =
		UDim.new(
			0,
			10
		)

	SidebarPadding.PaddingLeft =
		UDim.new(
			0,
			7
		)

	SidebarPadding.PaddingRight =
		UDim.new(
			0,
			7
		)

	--==================================================
	-- CONTEÚDO DAS ABAS
	--==================================================

	local Content =
		Instance.new("Frame")

	Content.Name = "Content"

	Content.Parent = Body

	Content.Position =
		UDim2.new(
			0,
			185,
			0,
			0
		)

	Content.Size =
		UDim2.new(
			1,
			-185,
			1,
			0
		)

	Content.BackgroundColor3 =
		Config.Colors.Panel

	Content.BackgroundTransparency =
		0.18

	Content.BorderSizePixel = 0

	--==================================================
	-- TABELA DAS ABAS
	--==================================================

	local Tabs = {}

	local CurrentTab = nil

	--==================================================
	-- PÁGINA EM OBRA
	--==================================================

	local function CreateConstructionPage(
		Page,
		Name
	)

		local Icon =
			Instance.new("TextLabel")

		Icon.Parent = Page

		Icon.Size =
			UDim2.new(
				1,
				0,
				0,
				70
			)

		Icon.Position =
			UDim2.new(
				0,
				0,
				0.5,
				-85
			)

		Icon.BackgroundTransparency = 1

		Icon.Text = "🚧"

		Icon.TextSize = 48

		local ConstructionTitle =
			Instance.new("TextLabel")

		ConstructionTitle.Parent = Page

		ConstructionTitle.Size =
			UDim2.new(
				1,
				-40,
				0,
				35
			)

		ConstructionTitle.Position =
			UDim2.new(
				0,
				20,
				0.5,
				-10
			)

		ConstructionTitle.BackgroundTransparency = 1

		ConstructionTitle.Text =
			Name

		ConstructionTitle.TextColor3 =
			Config.Colors.Text

		ConstructionTitle.TextSize = 21

		ConstructionTitle.Font =
			Enum.Font.GothamBold

		local ConstructionText =
			Instance.new("TextLabel")

		ConstructionText.Parent = Page

		ConstructionText.Size =
			UDim2.new(
				1,
				-50,
				0,
				60
			)

		ConstructionText.Position =
			UDim2.new(
				0,
				25,
				0.5,
				30
			)

		ConstructionText.BackgroundTransparency = 1

		ConstructionText.Text =
			"Esta aba ainda está em obra.\n" ..
			"Estamos desenvolvendo esta funcionalidade."

		ConstructionText.TextColor3 =
			Config.Colors.SubText

		ConstructionText.TextSize = 13

		ConstructionText.Font =
			Enum.Font.Gotham

		ConstructionText.TextWrapped = true

	end

	--==================================================
	-- SELECIONAR ABA
	--==================================================

	local function SelectTab(Name)

		local Selected =
			Tabs[Name]

		if not Selected then
			return
		end

		for tabName, Tab in pairs(Tabs) do

			Tab.Page.Visible = false

			Tab.Button.BackgroundColor3 =
				Color3.fromRGB(
					17,
					23,
					35
				)

			Tab.Button.BackgroundTransparency =
				0.10

			Tab.Stroke.Thickness = 0

		end

		Selected.Page.Visible = true

		Selected.Button.BackgroundColor3 =
			Color3.fromRGB(
				15,
				55,
				105
			)

		Selected.Button.BackgroundTransparency =
			0

		Selected.Stroke.Thickness =
			1.5

		CurrentTab = Name

		Debug.Log(
			"Aba selecionada: " ..
			Name
		)

	end

	--==================================================
	-- CRIAR ABA
	--==================================================

	local function CreateTab(
		Name,
		Order
	)

		local Button =
			Instance.new("TextButton")

		Button.Name =
			Name .. "Button"

		Button.Parent = Sidebar

		Button.Size =
			UDim2.new(
				1,
				-4,
				0,
				37
			)

		Button.BackgroundColor3 =
			Color3.fromRGB(
				17,
				23,
				35
			)

		Button.BackgroundTransparency =
			0.10

		Button.BorderSizePixel = 0

		Button.Text = Name

		Button.TextColor3 =
			Config.Colors.Text

		Button.TextSize = 11

		Button.Font =
			Enum.Font.Gotham

		Button.LayoutOrder =
			Order

		Button.Active = true
		Button.AutoButtonColor = true

		Components.Corner(
			Button,
			7
		)

		local Stroke =
			Components.Stroke(
				Button,
				Config.Colors.BlueNeon,
				0,
				0.1
			)

		-- alterna azul/vermelho

		if Order % 2 == 0 then

			Stroke.Color =
				Config.Colors.RedNeon

		else

			Stroke.Color =
				Config.Colors.BlueNeon

		end

		local Page =
			Instance.new("Frame")

		Page.Name = Name

		Page.Parent = Content

		Page.Size =
			UDim2.fromScale(
				1,
				1
			)

		Page.BackgroundTransparency = 1

		Page.Visible = false

		Tabs[Name] = {

			Name = Name,

			Button = Button,

			Stroke = Stroke,

			Page = Page

		}

		-- Principal será criada pelo
		-- ui/principal.lua

		if Name ~= "Principal" then

			CreateConstructionPage(
				Page,
				Name
			)

		end

		Button.Activated:Connect(function()

			Debug.SafeCall(
				"Abrir aba " .. Name,

				function()

					SelectTab(
						Name
					)

				end
			)

		end)

	end

	--==================================================
	-- GERAR ABAS
	--==================================================

	for Order, Name in ipairs(TAB_NAMES) do

		CreateTab(
			Name,
			Order
		)

	end

	--==================================================
	-- PRINCIPAL PADRÃO
	--==================================================

	SelectTab(
		"Principal"
	)

	--==================================================
	-- ESTADOS DA JANELA
	--==================================================

	local Opened = false

	local Minimized = false

	local AnimationLock = false

	local NormalSize =
		UDim2.new(
			0.84,
			0,
			0.80,
			0
		)

	--==================================================
	-- ABRIR / FECHAR
	--==================================================

	local function SetOpen(State)

		if AnimationLock then
			return
		end

		AnimationLock = true

		Opened = State

		if State then

			Main.Visible = true

			Main.BackgroundTransparency =
				0.45

			TweenService:Create(
				Main,
				TweenInfo.new(
					0.22,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.Out
				),
				{
					BackgroundTransparency =
						0.14
				}
			):Play()

			task.wait(0.22)

		else

			local Tween =
				TweenService:Create(
					Main,
					TweenInfo.new(
						0.18,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.In
					),
					{
						BackgroundTransparency =
							1
					}
				)

			Tween:Play()

			Tween.Completed:Wait()

			Main.Visible = false

		end

		AnimationLock = false

	end

	--==================================================
	-- MINIMIZAR
	--==================================================

	local function SetMinimized(State)

		Minimized = State

		if State then

			Body.Visible = false

			MainConstraint.MinSize =
				Vector2.new(
					400,
					56
				)

			MainConstraint.MaxSize =
				Vector2.new(
					920,
					56
				)

			Main.Size =
				UDim2.new(
					0.84,
					0,
					0,
					56
				)

			Minimize.Text = "+"

		else

			MainConstraint.MinSize =
				Vector2.new(
					500,
					320
				)

			MainConstraint.MaxSize =
				Vector2.new(
					920,
					570
				)

			Main.Size =
				NormalSize

			Body.Visible = true

			Minimize.Text = "—"

		end

	end

	--==================================================
	-- EVENTOS
	--==================================================

	OpenButton.Activated:Connect(function()

		Debug.SafeCall(
			"Botão Deal Blox",

			function()

				if Minimized then
					SetMinimized(false)
				end

				SetOpen(
					not Opened
				)

			end
		)

	end)

	Close.Activated:Connect(function()

		Debug.SafeCall(
			"Fechar interface",

			function()

				SetOpen(false)

			end
		)

	end)

	Minimize.Activated:Connect(function()

		Debug.SafeCall(
			"Minimizar interface",

			function()

				SetMinimized(
					not Minimized
				)

			end
		)

	end)

	--==================================================
	-- ARRASTAR JANELA
	--==================================================

	local Dragging = false

	local DragStart = nil

	local StartPosition = nil

	TopBar.InputBegan:Connect(function(Input)

		if
			Input.UserInputType ==
				Enum.UserInputType.MouseButton1

			or

			Input.UserInputType ==
				Enum.UserInputType.Touch
		then

			Dragging = true

			DragStart =
				Input.Position

			StartPosition =
				Main.Position

		end

	end)

	UserInputService.InputChanged:Connect(
		function(Input)

			if not Dragging then
				return
			end

			if
				Input.UserInputType ==
					Enum.UserInputType.MouseMovement

				or

				Input.UserInputType ==
					Enum.UserInputType.Touch
			then

				local Delta =
					Input.Position -
					DragStart

				Main.Position =
					UDim2.new(

						StartPosition.X.Scale,

						StartPosition.X.Offset +
							Delta.X,

						StartPosition.Y.Scale,

						StartPosition.Y.Offset +
							Delta.Y
					)

			end

		end
	)

	UserInputService.InputEnded:Connect(
		function(Input)

			if
				Input.UserInputType ==
					Enum.UserInputType.MouseButton1

				or

				Input.UserInputType ==
					Enum.UserInputType.Touch
			then

				Dragging = false

			end

		end
	)

	--==================================================
	-- RETORNO DA INTERFACE
	--==================================================

	local App = {}

	App.Gui = Gui

	App.Main = Main
	App.TopBar = TopBar
	App.Body = Body

	App.Sidebar = Sidebar
	App.Content = Content

	App.OpenButton = OpenButton

	App.Tabs = Tabs

	App.SelectTab = SelectTab
	App.SetOpen = SetOpen
	App.SetMinimized = SetMinimized

	function App:GetPage(Name)

		if self.Tabs[Name] then

			return self.Tabs[Name].Page

		end

		return nil

	end

	function App:IsOpen()
		return Opened
	end

	function App:IsMinimized()
		return Minimized
	end

	Debug.Log(
		"Interface criada com " ..
		#TAB_NAMES ..
		" abas."
	)

	return App
end

return Interface
