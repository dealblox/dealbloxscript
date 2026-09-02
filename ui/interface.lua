--==================================================
-- DEAL BLOX
-- UI / INTERFACE
-- V4 - Bolinha arrastável
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
	--==================================================
	-- SERVICES
	--==================================================

	local Players =
		game:GetService("Players")

	local TweenService =
		game:GetService("TweenService")

	local UserInputService =
		game:GetService("UserInputService")

	local CoreGui =
		game:GetService("CoreGui")

	local Workspace =
		game:GetService("Workspace")

	local Player =
		Players.LocalPlayer

	while not Player do
		task.wait()
		Player =
			Players.LocalPlayer
	end

	--==================================================
	-- CORES
	--==================================================

	local Colors =
		Config.Colors
		or
		{}

	local BackgroundColor =
		Colors.Background
		or
		Color3.fromRGB(
			8,
			12,
			22
		)

	local PanelColor =
		Colors.Panel
		or
		Color3.fromRGB(
			13,
			19,
			31
		)

	local Panel2Color =
		Colors.Panel2
		or
		Color3.fromRGB(
			20,
			27,
			41
		)

	local TextColor =
		Colors.Text
		or
		Color3.fromRGB(
			245,
			247,
			255
		)

	local SubTextColor =
		Colors.SubText
		or
		Color3.fromRGB(
			155,
			166,
			185
		)

	local BlueColor =
		Colors.Blue
		or
		Color3.fromRGB(
			30,
			90,
			190
		)

	local BlueNeon =
		Colors.BlueNeon
		or
		Color3.fromRGB(
			0,
			180,
			255
		)

	local RedColor =
		Colors.Red
		or
		Color3.fromRGB(
			165,
			38,
			58
		)

	local RedNeon =
		Colors.RedNeon
		or
		Color3.fromRGB(
			255,
			55,
			85
		)

	--==================================================
	-- HELPERS
	--==================================================

	local function Corner(
		parent,
		radius
	)
		local object =
			Instance.new(
				"UICorner"
			)

		object.CornerRadius =
			UDim.new(
				0,
				radius
				or
				8
			)

		object.Parent =
			parent

		return object
	end

	local function Stroke(
		parent,
		color,
		thickness,
		transparency
	)
		local object =
			Instance.new(
				"UIStroke"
			)

		object.Color =
			color
			or
			BlueNeon

		object.Thickness =
			thickness
			or
			1

		object.Transparency =
			transparency
			or
			0

		object.Parent =
			parent

		return object
	end

	local function Label(
		parent,
		text,
		position,
		size,
		textSize,
		font,
		color
	)
		local object =
			Instance.new(
				"TextLabel"
			)

		object.Parent =
			parent

		object.Position =
			position

		object.Size =
			size

		object.BackgroundTransparency =
			1

		object.BorderSizePixel =
			0

		object.Text =
			text
			or
			""

		object.TextColor3 =
			color
			or
			TextColor

		object.TextSize =
			textSize
			or
			12

		object.Font =
			font
			or
			Enum.Font.Gotham

		object.TextXAlignment =
			Enum.TextXAlignment.Left

		object.TextYAlignment =
			Enum.TextYAlignment.Center

		return object
	end

	local function GetViewportSize()
		local camera =
			Workspace.CurrentCamera

		if camera then
			return
				camera.ViewportSize
		end

		return
			Vector2.new(
				1280,
				720
			)
	end

	--==================================================
	-- REMOVER INTERFACE ANTIGA
	--==================================================

	pcall(function()
		local old =
			CoreGui:
				FindFirstChild(
					"DealBlox"
				)

		if old then
			old:
				Destroy()
		end
	end)

	pcall(function()
		local PlayerGui =
			Player:
				FindFirstChild(
					"PlayerGui"
				)

		local old =
			PlayerGui
			and
			PlayerGui:
				FindFirstChild(
					"DealBlox"
				)

		if old then
			old:
				Destroy()
		end
	end)

	--==================================================
	-- SCREEN GUI
	--==================================================

	local Gui =
		Instance.new(
			"ScreenGui"
		)

	Gui.Name =
		"DealBlox"

	Gui.ResetOnSpawn =
		false

	Gui.IgnoreGuiInset =
		true

	Gui.ZIndexBehavior =
		Enum.ZIndexBehavior.Sibling

	Gui.DisplayOrder =
		999

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
			Player:
				WaitForChild(
					"PlayerGui"
				)
	end

	--==================================================
	-- BOLINHA FLUTUANTE
	--==================================================

	local OpenButton =
		Instance.new(
			"ImageButton"
		)

	OpenButton.Name =
		"OpenButton"

	OpenButton.Parent =
		Gui

	OpenButton.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	OpenButton.Size =
		UDim2.fromOffset(
			64,
			64
		)

	OpenButton.Position =
		UDim2.new(
			0,
			52,
			0.5,
			0
		)

	OpenButton.BackgroundColor3 =
		PanelColor

	OpenButton.BackgroundTransparency =
		0.08

	OpenButton.BorderSizePixel =
		0

	OpenButton.Image =
		Config.Logo
		or
		""

	OpenButton.ScaleType =
		Enum.ScaleType.Fit

	OpenButton.AutoButtonColor =
		false

	OpenButton.Active =
		true

	OpenButton.ZIndex =
		1000

	Corner(
		OpenButton,
		999
	)

	local OpenStroke =
		Stroke(
			OpenButton,
			BlueNeon,
			2.5,
			0
		)

	--==================================================
	-- ANIMAÇÃO DA BOLINHA
	--==================================================

	task.spawn(function()
		while OpenButton.Parent do
			local tween1 =
				TweenService:
					Create(
						OpenStroke,
						TweenInfo.new(
							1.3
						),
						{
							Color =
								RedNeon
						}
					)

			tween1:
				Play()

			task.wait(
				1.3
			)

			if not OpenStroke.Parent then
				break
			end

			local tween2 =
				TweenService:
					Create(
						OpenStroke,
						TweenInfo.new(
							1.3
						),
						{
							Color =
								BlueNeon
						}
					)

			tween2:
				Play()

			task.wait(
				1.3
			)
		end
	end)

	--==================================================
	-- MAIN
	--==================================================

	local Main =
		Instance.new(
			"Frame"
		)

	Main.Name =
		"Main"

	Main.Parent =
		Gui

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
		BackgroundColor

	Main.BackgroundTransparency =
		0.10

	Main.BorderSizePixel =
		0

	Main.ClipsDescendants =
		true

	Main.Active =
		true

	Main.Visible =
		false

	Main.ZIndex =
		10

	Corner(
		Main,
		15
	)

	local MainStroke =
		Stroke(
			Main,
			BlueNeon,
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
			TweenService:
				Create(
					MainStroke,
					TweenInfo.new(
						2
					),
					{
						Color =
							RedNeon
					}
				):
				Play()

			task.wait(
				2
			)

			if not MainStroke.Parent then
				break
			end

			TweenService:
				Create(
					MainStroke,
					TweenInfo.new(
						2
					),
					{
						Color =
							BlueNeon
					}
				):
				Play()

			task.wait(
				2
			)
		end
	end)

	--==================================================
	-- TOPBAR
	--==================================================

	local TopBar =
		Instance.new(
			"Frame"
		)

	TopBar.Name =
		"TopBar"

	TopBar.Parent =
		Main

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

	TopBar.Active =
		true

	TopBar.ZIndex =
		20

	Corner(
		TopBar,
		15
	)

	local TopFix =
		Instance.new(
			"Frame"
		)

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
		Instance.new(
			"Frame"
		)

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
		BlueNeon

	BlueLine.BorderSizePixel =
		0

	BlueLine.ZIndex =
		25

	local RedLine =
		Instance.new(
			"Frame"
		)

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
		RedNeon

	RedLine.BorderSizePixel =
		0

	RedLine.ZIndex =
		25

	--==================================================
	-- LOGO
	--==================================================

	local Logo =
		Instance.new(
			"ImageLabel"
		)

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
		or
		""

	Logo.ScaleType =
		Enum.ScaleType.Fit

	Logo.ZIndex =
		30

	--==================================================
	-- TÍTULO / SITE
	--==================================================

	local Title =
		Label(
			TopBar,
			"DEAL BLOX",
			UDim2.fromOffset(
				59,
				0
			),
			UDim2.fromOffset(
				120,
				56
			),
			18,
			Enum.Font.GothamBold,
			TextColor
		)

	Title.ZIndex =
		30

	local Site =
		Label(
			TopBar,
			"dealblox.com.br",
			UDim2.fromOffset(
				178,
				0
			),
			UDim2.fromOffset(
				112,
				56
			),
			11,
			Enum.Font.Gotham,
			BlueNeon
		)

	Site.Name =
		"Site"

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
		SeaMap[
			game.PlaceId
		]

	local SeaBadge =
		Instance.new(
			"TextLabel"
		)

	SeaBadge.Name =
		"SeaBadge"

	SeaBadge.Parent =
		TopBar

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
		Panel2Color

	SeaBadge.BackgroundTransparency =
		0.02

	SeaBadge.BorderSizePixel =
		0

	SeaBadge.Text =
		CurrentSea
			and
			(
				"SEA "
				..
				tostring(
					CurrentSea
				)
			)
			or
			"SEA ?"

	SeaBadge.TextColor3 =
		TextColor

	SeaBadge.TextSize =
		11

	SeaBadge.Font =
		Enum.Font.GothamBold

	SeaBadge.ZIndex =
		31

	Corner(
		SeaBadge,
		7
	)

	Stroke(
		SeaBadge,
		BlueNeon,
		1.5,
		0.05
	)

	--==================================================
	-- MINIMIZAR
	--==================================================

	local Minimize =
		Instance.new(
			"TextButton"
		)

	Minimize.Name =
		"Minimize"

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
		BlueColor

	Minimize.BorderSizePixel =
		0

	Minimize.Text =
		"—"

	Minimize.TextColor3 =
		TextColor

	Minimize.TextSize =
		20

	Minimize.Font =
		Enum.Font.GothamBold

	Minimize.ZIndex =
		35

	Corner(
		Minimize,
		8
	)

	--==================================================
	-- FECHAR
	--==================================================

	local Close =
		Instance.new(
			"TextButton"
		)

	Close.Name =
		"Close"

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
		RedColor

	Close.BorderSizePixel =
		0

	Close.Text =
		"X"

	Close.TextColor3 =
		TextColor

	Close.TextSize =
		14

	Close.Font =
		Enum.Font.GothamBold

	Close.ZIndex =
		35

	Corner(
		Close,
		8
	)

	--==================================================
	-- BODY
	--==================================================

	local Body =
		Instance.new(
			"Frame"
		)

	Body.Name =
		"Body"

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

	Body.BorderSizePixel =
		0

	Body.ZIndex =
		11

	--==================================================
	-- SIDEBAR
	--==================================================

	local Sidebar =
		Instance.new(
			"ScrollingFrame"
		)

	Sidebar.Name =
		"Sidebar"

	Sidebar.Parent =
		Body

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
		BlueNeon

	Sidebar.AutomaticCanvasSize =
		Enum.AutomaticSize.Y

	Sidebar.CanvasSize =
		UDim2.new()

	Sidebar.ZIndex =
		12

	local SidebarPadding =
		Instance.new(
			"UIPadding"
		)

	SidebarPadding.Parent =
		Sidebar

	SidebarPadding.PaddingTop =
		UDim.new(
			0,
			12
		)

	SidebarPadding.PaddingBottom =
		UDim.new(
			0,
			12
		)

	SidebarPadding.PaddingLeft =
		UDim.new(
			0,
			10
		)

	SidebarPadding.PaddingRight =
		UDim.new(
			0,
			10
		)

	local SidebarList =
		Instance.new(
			"UIListLayout"
		)

	SidebarList.Parent =
		Sidebar

	SidebarList.Padding =
		UDim.new(
			0,
			7
		)

	SidebarList.SortOrder =
		Enum.SortOrder.LayoutOrder

	--==================================================
	-- CONTENT
	--==================================================

	local Content =
		Instance.new(
			"Frame"
		)

	Content.Name =
		"Content"

	Content.Parent =
		Body

	Content.Position =
		UDim2.fromOffset(
			185,
			0
		)

	Content.Size =
		UDim2.new(
			1,
			-185,
			1,
			0
		)

	Content.BackgroundTransparency =
		1

	Content.BorderSizePixel =
		0

	Content.ClipsDescendants =
		true

	Content.ZIndex =
		12

	--==================================================
	-- ABAS
	--==================================================

	local Tabs = {}

	local function CreateTab(
		Name,
		Index
	)
		local Button =
			Instance.new(
				"TextButton"
			)

		Button.Name =
			Name
			..
			"Button"

		Button.Parent =
			Sidebar

		Button.LayoutOrder =
			Index

		Button.Size =
			UDim2.new(
				1,
				0,
				0,
				40
			)

		Button.BackgroundColor3 =
			Panel2Color

		Button.BackgroundTransparency =
			0.38

		Button.BorderSizePixel =
			0

		Button.AutoButtonColor =
			false

		Button.Text =
			Name

		Button.TextColor3 =
			SubTextColor

		Button.TextSize =
			11

		Button.Font =
			Enum.Font.GothamSemibold

		Button.TextWrapped =
			true

		Button.ZIndex =
			15

		Corner(
			Button,
			8
		)

		local ButtonStroke =
			Stroke(
				Button,
				BlueNeon,
				1,
				0.78
			)

		local Page =
			Instance.new(
				"Frame"
			)

		Page.Name =
			Name

		Page.Parent =
			Content

		Page.Position =
			UDim2.fromOffset(
				0,
				0
			)

		Page.Size =
			UDim2.fromScale(
				1,
				1
			)

		Page.BackgroundTransparency =
			1

		Page.BorderSizePixel =
			0

		Page.Visible =
			false

		Page.ClipsDescendants =
			true

		Page.ZIndex =
			13

		Tabs[Name] = {
			Button =
				Button,

			ButtonStroke =
				ButtonStroke,

			Page =
				Page
		}

		return
			Tabs[Name]
	end

	for Index, Name in ipairs(
		TAB_NAMES
	) do
		CreateTab(
			Name,
			Index
		)
	end

	local CurrentTab =
		nil

	local function SelectTab(
		Name
	)
		local Selected =
			Tabs[
				Name
			]

		if not Selected then
			return
		end

		CurrentTab =
			Name

		for TabName, Tab in pairs(
			Tabs
		) do
			local active =
				TabName
				==
				Name

			Tab.Page.Visible =
				active

			Tab.Button.BackgroundTransparency =
				active
					and
					0.05
					or
					0.38

			Tab.Button.BackgroundColor3 =
				active
					and
					BlueColor
					or
					Panel2Color

			Tab.Button.TextColor3 =
				active
					and
					TextColor
					or
					SubTextColor

			Tab.ButtonStroke.Transparency =
				active
					and
					0.15
					or
					0.78
		end
	end

	for Name, Tab in pairs(
		Tabs
	) do
		Tab.Button.Activated:
			Connect(function()
				SelectTab(
					Name
				)
			end)
	end

	SelectTab(
		"Principal"
	)

	--==================================================
	-- ABRIR / MINIMIZAR
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
			==
			true

		Main.Visible =
			Opened
	end

	local function SetMinimized(
		State
	)
		Minimized =
			State
			==
			true

		if Minimized then
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

	Close.Activated:
		Connect(function()
			SetOpen(
				false
			)
		end)

	Minimize.Activated:
		Connect(function()
			SetMinimized(
				not Minimized
			)
		end)

	--==================================================
	-- DRAG DO PAINEL
	--==================================================

	local MainDragging =
		false

	local MainDragStart =
		nil

	local MainStartPosition =
		nil

	TopBar.InputBegan:
		Connect(function(
			Input
		)
			if
				Input.UserInputType
					==
					Enum.UserInputType.MouseButton1
				or
				Input.UserInputType
					==
					Enum.UserInputType.Touch
			then
				-- Não inicia drag se começou nos botões.
				local inputX =
					Input.Position.X

				local inputY =
					Input.Position.Y

				local function Inside(
					Object
				)
					local Position =
						Object.AbsolutePosition

					local Size =
						Object.AbsoluteSize

					return
						inputX
							>=
							Position.X
						and
						inputX
							<=
							Position.X
								+
								Size.X
						and
						inputY
							>=
							Position.Y
						and
						inputY
							<=
							Position.Y
								+
								Size.Y
				end

				if
					Inside(
						Minimize
					)
					or
					Inside(
						Close
					)
				then
					return
				end

				MainDragging =
					true

				MainDragStart =
					Input.Position

				MainStartPosition =
					Main.Position
			end
		end)

	UserInputService.InputChanged:
		Connect(function(
			Input
		)
			if
				not MainDragging
			then
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
					MainDragStart

				Main.Position =
					UDim2.new(
						MainStartPosition.X.Scale,
						MainStartPosition.X.Offset
							+
							Delta.X,
						MainStartPosition.Y.Scale,
						MainStartPosition.Y.Offset
							+
							Delta.Y
					)
			end
		end)

	UserInputService.InputEnded:
		Connect(function(
			Input
		)
			if
				Input.UserInputType
					==
					Enum.UserInputType.MouseButton1
				or
				Input.UserInputType
					==
					Enum.UserInputType.Touch
			then
				MainDragging =
					false
			end
		end)

	--==================================================
	-- DRAG DA BOLINHA
	--==================================================
	--
	-- Clique curto:
	--     abre / fecha o painel.
	--
	-- Arrastar:
	--     move a bolinha pela tela sem abrir/fechar.
	--
	-- Funciona em mouse e touch.
	--==================================================

	local BubbleDragging =
		false

	local BubbleDragStart =
		nil

	local BubbleStartCenter =
		nil

	local BubbleMoved =
		false

	local SuppressOpen =
		false

	local DRAG_THRESHOLD =
		6

	local function ClampBubble(
		X,
		Y
	)
		local Viewport =
			GetViewportSize()

		local HalfWidth =
			math.max(
				OpenButton.AbsoluteSize.X
					/
					2,
				32
			)

		local HalfHeight =
			math.max(
				OpenButton.AbsoluteSize.Y
					/
					2,
				32
			)

		local ClampedX =
			math.clamp(
				X,
				HalfWidth
					+
					4,
				math.max(
					HalfWidth
						+
						4,
					Viewport.X
						-
						HalfWidth
						-
						4
				)
			)

		local ClampedY =
			math.clamp(
				Y,
				HalfHeight
					+
					4,
				math.max(
					HalfHeight
						+
						4,
					Viewport.Y
						-
						HalfHeight
						-
						4
				)
			)

		return
			ClampedX,
			ClampedY
	end

	OpenButton.InputBegan:
		Connect(function(
			Input
		)
			if
				Input.UserInputType
					==
					Enum.UserInputType.MouseButton1
				or
				Input.UserInputType
					==
					Enum.UserInputType.Touch
			then
				BubbleDragging =
					true

				BubbleDragStart =
					Input.Position

				local AbsolutePosition =
					OpenButton.AbsolutePosition

				local AbsoluteSize =
					OpenButton.AbsoluteSize

				BubbleStartCenter =
					Vector2.new(
						AbsolutePosition.X
							+
							AbsoluteSize.X
								/
								2,
						AbsolutePosition.Y
							+
							AbsoluteSize.Y
								/
								2
					)

				BubbleMoved =
					false
			end
		end)

	UserInputService.InputChanged:
		Connect(function(
			Input
		)
			if
				not BubbleDragging
			then
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
					BubbleDragStart

				if
					Delta.Magnitude
					>=
					DRAG_THRESHOLD
				then
					BubbleMoved =
						true
				end

				if BubbleMoved then
					local Wanted =
						BubbleStartCenter
						+
						Vector2.new(
							Delta.X,
							Delta.Y
						)

					local X,
						Y =
							ClampBubble(
								Wanted.X,
								Wanted.Y
							)

					OpenButton.Position =
						UDim2.fromOffset(
							X,
							Y
						)
				end
			end
		end)

	UserInputService.InputEnded:
		Connect(function(
			Input
		)
			if
				Input.UserInputType
					==
					Enum.UserInputType.MouseButton1
				or
				Input.UserInputType
					==
					Enum.UserInputType.Touch
			then
				if
					BubbleDragging
					and
					BubbleMoved
				then
					SuppressOpen =
						true

					task.delay(
						0.12,
						function()
							SuppressOpen =
								false
						end
					)
				end

				BubbleDragging =
					false
			end
		end)

	OpenButton.Activated:
		Connect(function()
			if
				SuppressOpen
				or
				BubbleMoved
			then
				BubbleMoved =
					false

				return
			end

			if Minimized then
				SetMinimized(
					false
				)
			end

			SetOpen(
				not Opened
			)
		end)

	--==================================================
	-- GARANTIR QUE A BOLINHA FIQUE NA TELA
	--==================================================

	task.spawn(function()
		while
			Gui.Parent
			and
			OpenButton.Parent
		do
			local AbsolutePosition =
				OpenButton.AbsolutePosition

			local AbsoluteSize =
				OpenButton.AbsoluteSize

			local Center =
				Vector2.new(
					AbsolutePosition.X
						+
						AbsoluteSize.X
							/
							2,
					AbsolutePosition.Y
						+
						AbsoluteSize.Y
							/
							2
				)

			local X,
				Y =
					ClampBubble(
						Center.X,
						Center.Y
					)

			if
				math.abs(
					X
						-
						Center.X
				)
					>
					1
				or
				math.abs(
					Y
						-
						Center.Y
				)
					>
					1
			then
				OpenButton.Position =
					UDim2.fromOffset(
						X,
						Y
					)
			end

			task.wait(
				0.5
			)
		end
	end)

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

	App.SetMinimized =
		SetMinimized

	function App:GetPage(
		Name
	)
		local Tab =
			self.Tabs[
				Name
			]

		if Tab then
			return
				Tab.Page
		end

		return nil
	end

	function App:GetCurrentTab()
		return
			CurrentTab
	end

	Debug.Log(
		"✅ Interface V4 criada - bolinha arrastável."
	)

	return App
end

return Interface
