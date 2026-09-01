--==================================================
-- DEAL BLOX
-- UI / INTERFACE
--==================================================

local Interface = {}

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

function Interface.Create(
	Config,
	Components,
	Debug
)

	local Players =
		game:GetService("Players")

	local TweenService =
		game:GetService("TweenService")

	local UserInputService =
		game:GetService("UserInputService")

	local CoreGui =
		game:GetService("CoreGui")

	local Player =
		Players.LocalPlayer

	while not Player do

		task.wait()

		Player =
			Players.LocalPlayer
	end

	--==================================================
	-- REMOVER GUI ANTIGA
	--==================================================

	pcall(function()

		local old =
			CoreGui:FindFirstChild(
				"DealBlox"
			)

		if old then
			old:Destroy()
		end

	end)

	pcall(function()

		local playerGui =
			Player:FindFirstChild(
				"PlayerGui"
			)

		if playerGui then

			local old =
				playerGui:FindFirstChild(
					"DealBlox"
				)

			if old then
				old:Destroy()
			end
		end

	end)

	--==================================================
	-- SCREEN GUI
	--==================================================

	local Gui =
		Instance.new("ScreenGui")

	Gui.Name =
		"DealBlox"

	Gui.ResetOnSpawn =
		false

	Gui.IgnoreGuiInset =
		true

	Gui.ZIndexBehavior =
		Enum.ZIndexBehavior.Sibling

	local parentSuccess =
		pcall(function()

			Gui.Parent =
				CoreGui

		end)

	if
		not parentSuccess
		or
		not Gui.Parent
	then

		Gui.Parent =
			Player:WaitForChild(
				"PlayerGui"
			)
	end

	--==================================================
	-- BOTÃO FLUTUANTE
	--==================================================

	local OpenButton =
		Instance.new("ImageButton")

	OpenButton.Parent =
		Gui

	OpenButton.Name =
		"OpenButton"

	OpenButton.Size =
		UDim2.fromOffset(
			64,
			64
		)

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
		0.10

	OpenButton.BorderSizePixel =
		0

	OpenButton.Image =
		Config.Logo

	OpenButton.ScaleType =
		Enum.ScaleType.Fit

	OpenButton.ZIndex =
		1000

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

	task.spawn(function()

		while OpenButton.Parent do

			TweenService:Create(
				OpenStroke,
				TweenInfo.new(1.3),
				{
					Color =
						Config.Colors.RedNeon
				}
			):Play()

			task.wait(1.3)

			TweenService:Create(
				OpenStroke,
				TweenInfo.new(1.3),
				{
					Color =
						Config.Colors.BlueNeon
				}
			):Play()

			task.wait(1.3)
		end
	end)

	--==================================================
	-- MAIN
	--==================================================

	local Main =
		Instance.new("Frame")

	Main.Parent =
		Gui

	Main.Name =
		"Main"

	Main.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

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
		0.12

	Main.BorderSizePixel =
		0

	Main.ClipsDescendants =
		true

	Main.Active =
		true

	Main.Visible =
		false

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

	local SizeConstraint =
		Instance.new(
			"UISizeConstraint"
		)

	SizeConstraint.Parent =
		Main

	SizeConstraint.MinSize =
		Vector2.new(
			500,
			320
		)

	SizeConstraint.MaxSize =
		Vector2.new(
			920,
			570
		)

	task.spawn(function()

		while Main.Parent do

			TweenService:Create(
				MainStroke,
				TweenInfo.new(2),
				{
					Color =
						Config.Colors.RedNeon
				}
			):Play()

			task.wait(2)

			TweenService:Create(
				MainStroke,
				TweenInfo.new(2),
				{
					Color =
						Config.Colors.BlueNeon
				}
			):Play()

			task.wait(2)
		end
	end)

	--==================================================
	-- TOPBAR
	--==================================================

	local TopBar =
		Instance.new("Frame")

	TopBar.Parent =
		Main

	TopBar.Name =
		"TopBar"

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
		0.05

	TopBar.BorderSizePixel =
		0

	TopBar.ZIndex =
		20

	Components.Corner(
		TopBar,
		15
	)

	local TopFix =
		Instance.new("Frame")

	TopFix.Parent =
		TopBar

	TopFix.Position =
		UDim2.new(
			0,
			0,
			1,
			-15
		)

	TopFix.Size =
		UDim2.new(
			1,
			0,
			0,
			15
		)

	TopFix.BackgroundColor3 =
		TopBar.BackgroundColor3

	TopFix.BackgroundTransparency =
		TopBar.BackgroundTransparency

	TopFix.BorderSizePixel =
		0

	TopFix.ZIndex =
		20

	local BlueLine =
		Instance.new("Frame")

	BlueLine.Parent =
		TopBar

	BlueLine.Position =
		UDim2.new(
			0,
			0,
			1,
			-2
		)

	BlueLine.Size =
		UDim2.new(
			0.5,
			0,
			0,
			2
		)

	BlueLine.BackgroundColor3 =
		Config.Colors.BlueNeon

	BlueLine.BorderSizePixel =
		0

	BlueLine.ZIndex =
		25

	local RedLine =
		Instance.new("Frame")

	RedLine.Parent =
		TopBar

	RedLine.Position =
		UDim2.new(
			0.5,
			0,
			1,
			-2
		)

	RedLine.Size =
		UDim2.new(
			0.5,
			0,
			0,
			2
		)

	RedLine.BackgroundColor3 =
		Config.Colors.RedNeon

	RedLine.BorderSizePixel =
		0

	RedLine.ZIndex =
		25

	--==================================================
	-- LOGO
	--==================================================

	local Logo =
		Instance.new("ImageLabel")

	Logo.Parent =
		TopBar

	Logo.Position =
		UDim2.fromOffset(
			12,
			8
		)

	Logo.Size =
		UDim2.fromOffset(
			40,
			40
		)

	Logo.BackgroundTransparency =
		1

	Logo.Image =
		Config.Logo

	Logo.ScaleType =
		Enum.ScaleType.Fit

	Logo.ZIndex =
		30

	--==================================================
	-- TÍTULO
	--==================================================

	local Title =
		Instance.new("TextLabel")

	Title.Parent =
		TopBar

	Title.Position =
		UDim2.fromOffset(
			59,
			0
		)

	Title.Size =
		UDim2.fromOffset(
			120,
			56
		)

	Title.BackgroundTransparency =
		1

	Title.Text =
		"DEAL BLOX"

	Title.TextColor3 =
		Config.Colors.Text

	Title.TextSize =
		18

	Title.Font =
		Enum.Font.GothamBold

	Title.TextXAlignment =
		Enum.TextXAlignment.Left

	Title.ZIndex =
		30

	--==================================================
	-- SITE
	--==================================================

	local Site =
		Instance.new("TextLabel")

	Site.Parent =
		TopBar

	Site.Name =
		"Site"

	Site.Position =
		UDim2.fromOffset(
			178,
			0
		)

	Site.Size =
		UDim2.fromOffset(
			112,
			56
		)

	Site.BackgroundTransparency =
		1

	Site.Text =
		"dealblox.com.br"

	Site.TextColor3 =
		Config.Colors.BlueNeon

	Site.TextSize =
		11

	Site.Font =
		Enum.Font.Gotham

	Site.TextXAlignment =
		Enum.TextXAlignment.Left

	Site.ZIndex =
		30

	--==================================================
	-- SEA
	--==================================================

	local SeaMap = {
		[2753915549] = 1,
		[4442272183] = 2,
		[7449423635] = 3
	}

	local CurrentSea =
		SeaMap[game.PlaceId]

	local SeaBadge =
		Instance.new("TextLabel")

	SeaBadge.Parent =
		TopBar

	SeaBadge.Name =
		"SeaBadge"

	SeaBadge.Position =
		UDim2.fromOffset(
			294,
			14
		)

	SeaBadge.Size =
		UDim2.fromOffset(
			64,
			28
		)

	SeaBadge.BackgroundColor3 =
		Config.Colors.Panel2

	SeaBadge.BackgroundTransparency =
		0.02

	SeaBadge.BorderSizePixel =
		0

	SeaBadge.Text =
		CurrentSea
			and
			("SEA " .. CurrentSea)
			or
			"SEA ?"

	SeaBadge.TextColor3 =
		Config.Colors.Text

	SeaBadge.TextSize =
		11

	SeaBadge.Font =
		Enum.Font.GothamBold

	SeaBadge.ZIndex =
		31

	Components.Corner(
		SeaBadge,
		7
	)

	Components.Stroke(
		SeaBadge,
		Config.Colors.BlueNeon,
		1.5,
		0.05
	)

	--==================================================
	-- MINIMIZAR
	--==================================================

	local Minimize =
		Instance.new("TextButton")

	Minimize.Parent =
		TopBar

	Minimize.Position =
		UDim2.new(
			1,
			-88,
			0.5,
			-17
		)

	Minimize.Size =
		UDim2.fromOffset(
			35,
			35
		)

	Minimize.BackgroundColor3 =
		Config.Colors.Blue

	Minimize.BorderSizePixel =
		0

	Minimize.Text =
		"—"

	Minimize.TextColor3 =
		Config.Colors.Text

	Minimize.TextSize =
		20

	Minimize.Font =
		Enum.Font.GothamBold

	Minimize.ZIndex =
		35

	Components.Corner(
		Minimize,
		8
	)

	--==================================================
	-- X
	--==================================================

	local Close =
		Instance.new("TextButton")

	Close.Parent =
		TopBar

	Close.Position =
		UDim2.new(
			1,
			-45,
			0.5,
			-17
		)

	Close.Size =
		UDim2.fromOffset(
			35,
			35
		)

	Close.BackgroundColor3 =
		Config.Colors.Red

	Close.BorderSizePixel =
		0

	Close.Text =
		"X"

	Close.TextColor3 =
		Config.Colors.Text

	Close.TextSize =
		14

	Close.Font =
		Enum.Font.GothamBold

	Close.ZIndex =
		35

	Components.Corner(
		Close,
		8
	)

	--==================================================
	-- BODY
	--==================================================

	local Body =
		Instance.new("Frame")

	Body.Parent =
		Main

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

	Body.BackgroundTransparency =
		1

	--==================================================
	-- SIDEBAR
	--==================================================

	local Sidebar =
		Instance.new("ScrollingFrame")

	Sidebar.Parent =
		Body

	Sidebar.Name =
		"Sidebar"

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
		0.13

	Sidebar.BorderSizePixel =
		0

	Sidebar.ScrollBarThickness =
		3

	Sidebar.ScrollBarImageColor3 =
		Config.Colors.BlueNeon

	Sidebar.AutomaticCanvasSize =
		Enum.AutomaticSize.Y

	Sidebar.CanvasSize =
		UDim2.new()

	local SidebarPadding =
		Instance.new("UIPadding")

	SidebarPadding.Parent =
		Sidebar

	SidebarPadding.PaddingTop =
		UDim.new(0, 10)

	SidebarPadding.PaddingBottom =
		UDim.new(0, 10)

	SidebarPadding.PaddingLeft =
		UDim.new(0, 7)

	SidebarPadding.PaddingRight =
		UDim.new(0, 7)

	local SidebarLayout =
		Instance.new("UIListLayout")

	SidebarLayout.Parent =
		Sidebar

	SidebarLayout.Padding =
		UDim.new(0, 6)

	SidebarLayout.SortOrder =
		Enum.SortOrder.LayoutOrder

	--==================================================
	-- CONTENT
	--==================================================

	local Content =
		Instance.new("Frame")

	Content.Parent =
		Body

	Content.Name =
		"Content"

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
		0.16

	Content.BorderSizePixel =
		0

	--==================================================
	-- ABAS
	--==================================================

	local Tabs = {}

	local function ConstructionPage(
		Page,
		Name
	)

		local icon =
			Instance.new("TextLabel")

		icon.Parent =
			Page

		icon.Position =
			UDim2.new(
				0,
				0,
				0.5,
				-90
			)

		icon.Size =
			UDim2.new(
				1,
				0,
				0,
				60
			)

		icon.BackgroundTransparency =
			1

		icon.Text =
			"🚧"

		icon.TextSize =
			46

		local title =
			Instance.new("TextLabel")

		title.Parent =
			Page

		title.Position =
			UDim2.new(
				0,
				20,
				0.5,
				-20
			)

		title.Size =
			UDim2.new(
				1,
				-40,
				0,
				35
			)

		title.BackgroundTransparency =
			1

		title.Text =
			Name

		title.TextColor3 =
			Config.Colors.Text

		title.TextSize =
			20

		title.Font =
			Enum.Font.GothamBold

		local text =
			Instance.new("TextLabel")

		text.Parent =
			Page

		text.Position =
			UDim2.new(
				0,
				20,
				0.5,
				20
			)

		text.Size =
			UDim2.new(
				1,
				-40,
				0,
				50
			)

		text.BackgroundTransparency =
			1

		text.Text =
			"Esta aba ainda está em obra."

		text.TextColor3 =
			Config.Colors.SubText

		text.TextSize =
			13

		text.Font =
			Enum.Font.Gotham
	end

	local function SelectTab(
		Name
	)

		if not Tabs[Name] then
			return
		end

		for _, tab in pairs(Tabs) do

			tab.Page.Visible =
				false

			tab.Button.BackgroundColor3 =
				Color3.fromRGB(
					17,
					23,
					35
				)

			tab.Stroke.Thickness =
				0
		end

		local Selected =
			Tabs[Name]

		Selected.Page.Visible =
			true

		Selected.Button.BackgroundColor3 =
			Color3.fromRGB(
				15,
				55,
				105
			)

		Selected.Stroke.Thickness =
			1.5
	end

	for Order, Name in ipairs(
		TAB_NAMES
	) do

		local Button =
			Instance.new("TextButton")

		Button.Parent =
			Sidebar

		Button.Size =
			UDim2.new(
				1,
				0,
				0,
				37
			)

		Button.BackgroundColor3 =
			Color3.fromRGB(
				17,
				23,
				35
			)

		Button.BorderSizePixel =
			0

		Button.Text =
			Name

		Button.TextColor3 =
			Config.Colors.Text

		Button.TextSize =
			11

		Button.Font =
			Enum.Font.Gotham

		Button.LayoutOrder =
			Order

		Components.Corner(
			Button,
			7
		)

		local Stroke =
			Components.Stroke(
				Button,
				Order % 2 == 0
					and
					Config.Colors.RedNeon
					or
					Config.Colors.BlueNeon,
				0,
				0.1
			)

		local Page =
			Instance.new("Frame")

		Page.Parent =
			Content

		Page.Name =
			Name

		Page.Size =
			UDim2.fromScale(
				1,
				1
			)

		Page.BackgroundTransparency =
			1

		Page.Visible =
			false

		Tabs[Name] = {
			Button = Button,
			Stroke = Stroke,
			Page = Page
		}

		if
			Name ~= "Principal"
			and
			Name ~= "Farm"
			and
			Name ~= "Configurações de Farm"
		then

			ConstructionPage(
				Page,
				Name
			)
		end

		Button.Activated:Connect(
			function()

				SelectTab(
					Name
				)

			end
		)
	end

	SelectTab(
		"Principal"
	)

	--==================================================
	-- ABRIR
	--==================================================

	local Opened =
		false

	local Minimized =
		false

	local NormalSize =
		UDim2.new(
			0.84,
			0,
			0.80,
			0
		)

	local function SetOpen(
		State
	)

		Opened =
			State

		Main.Visible =
			State
	end

	local function SetMinimized(
		State
	)

		Minimized =
			State

		if State then

			Body.Visible =
				false

			SizeConstraint.MinSize =
				Vector2.new(
					400,
					56
				)

			SizeConstraint.MaxSize =
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

			Minimize.Text =
				"+"

		else

			SizeConstraint.MinSize =
				Vector2.new(
					500,
					320
				)

			SizeConstraint.MaxSize =
				Vector2.new(
					920,
					570
				)

			Main.Size =
				NormalSize

			Body.Visible =
				true

			Minimize.Text =
				"—"
		end
	end

	OpenButton.Activated:Connect(
		function()

			if Minimized then
				SetMinimized(false)
			end

			SetOpen(
				not Opened
			)
		end
	)

	Close.Activated:Connect(
		function()

			SetOpen(false)

		end
	)

	Minimize.Activated:Connect(
		function()

			SetMinimized(
				not Minimized
			)

		end
	)

	--==================================================
	-- DRAG
	--==================================================

	local Dragging =
		false

	local DragStart =
		nil

	local StartPosition =
		nil

	TopBar.InputBegan:Connect(
		function(Input)

			if
				Input.UserInputType
					==
				Enum.UserInputType.MouseButton1
				or
				Input.UserInputType
					==
				Enum.UserInputType.Touch
			then

				Dragging =
					true

				DragStart =
					Input.Position

				StartPosition =
					Main.Position
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(Input)

			if not Dragging then
				return
			end

			if
				Input.UserInputType
					==
				Enum.UserInputType.MouseMovement
				or
				Input.UserInputType
					==
				Enum.UserInputType.Touch
			then

				local Delta =
					Input.Position
					-
					DragStart

				Main.Position =
					UDim2.new(
						StartPosition.X.Scale,
						StartPosition.X.Offset
							+
							Delta.X,
						StartPosition.Y.Scale,
						StartPosition.Y.Offset
							+
							Delta.Y
					)
			end
		end
	)

	UserInputService.InputEnded:Connect(
		function(Input)

			if
				Input.UserInputType
					==
				Enum.UserInputType.MouseButton1
				or
				Input.UserInputType
					==
				Enum.UserInputType.Touch
			then

				Dragging =
					false
			end
		end
	)

	--==================================================
	-- APP
	--==================================================

	local App = {}

	App.Gui =
		Gui

	App.Main =
		Main

	App.TopBar =
		TopBar

	App.Body =
		Body

	App.Sidebar =
		Sidebar

	App.Content =
		Content

	App.Tabs =
		Tabs

	App.SeaBadge =
		SeaBadge

	App.Site =
		Site

	App.OpenButton =
		OpenButton

	App.SelectTab =
		SelectTab

	App.SetOpen =
		SetOpen

	function App:GetPage(
		Name
	)

		local Tab =
			self.Tabs[Name]

		if Tab then
			return Tab.Page
		end

		return nil
	end

	Debug.Log(
		"Interface criada."
	)

	return App
end

return Interface
