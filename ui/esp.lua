--==================================================
-- DEAL BLOX
-- UI / ESP
--==================================================

local ESPUI = {}

function ESPUI.Create(
	App,
	Config,
	Debug,
	ESPEngine
)
	local Page = App:GetPage("ESP")

	if not Page then
		Debug.Warn("Aba ESP não encontrada.")
		return
	end

	-- Remove a tela "em obra".
	for _, object in ipairs(Page:GetChildren()) do
		object:Destroy()
	end

	local Colors = Config.Colors

	local function Corner(parent, radius)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius or 8)
		corner.Parent = parent
	end

	local function Stroke(parent, color)
		local stroke = Instance.new("UIStroke")
		stroke.Color = color
		stroke.Thickness = 1.3
		stroke.Transparency = 0.15
		stroke.Parent = parent
	end

	local Scroll = Instance.new("ScrollingFrame")
	Scroll.Parent = Page
	Scroll.Name = "ESPScroll"
	Scroll.Size = UDim2.fromScale(1, 1)
	Scroll.BackgroundTransparency = 1
	Scroll.BorderSizePixel = 0
	Scroll.ScrollBarThickness = 4
	Scroll.ScrollBarImageColor3 = Colors.BlueNeon
	Scroll.CanvasSize = UDim2.fromOffset(0, 430)

	local Title = Instance.new("TextLabel")
	Title.Parent = Scroll
	Title.Position = UDim2.fromOffset(20, 18)
	Title.Size = UDim2.new(1, -40, 0, 30)
	Title.BackgroundTransparency = 1
	Title.Text = "ESP"
	Title.TextColor3 = Colors.Text
	Title.TextSize = 22
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Subtitle = Instance.new("TextLabel")
	Subtitle.Parent = Scroll
	Subtitle.Position = UDim2.fromOffset(20, 51)
	Subtitle.Size = UDim2.new(1, -40, 0, 38)
	Subtitle.BackgroundTransparency = 1
	Subtitle.Text = "Mostra nome e distância dos objetos no mapa."
	Subtitle.TextColor3 = Colors.SubText
	Subtitle.TextSize = 12
	Subtitle.Font = Enum.Font.Gotham
	Subtitle.TextWrapped = true
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left

	local function MakeToggle(
		y,
		title,
		description,
		isEnabled,
		setEnabled
	)
		local Card = Instance.new("Frame")
		Card.Parent = Scroll
		Card.Position = UDim2.fromOffset(20, y)
		Card.Size = UDim2.new(1, -40, 0, 82)
		Card.BackgroundColor3 = Colors.Panel2
		Card.BackgroundTransparency = 0.04
		Card.BorderSizePixel = 0
		Corner(Card, 11)
		Stroke(Card, Colors.BlueNeon)

		local Name = Instance.new("TextLabel")
		Name.Parent = Card
		Name.Position = UDim2.fromOffset(15, 12)
		Name.Size = UDim2.new(1, -150, 0, 24)
		Name.BackgroundTransparency = 1
		Name.Text = title
		Name.TextColor3 = Colors.Text
		Name.TextSize = 14
		Name.Font = Enum.Font.GothamBold
		Name.TextXAlignment = Enum.TextXAlignment.Left

		local Description = Instance.new("TextLabel")
		Description.Parent = Card
		Description.Position = UDim2.fromOffset(15, 39)
		Description.Size = UDim2.new(1, -150, 0, 30)
		Description.BackgroundTransparency = 1
		Description.Text = description
		Description.TextColor3 = Colors.SubText
		Description.TextSize = 11
		Description.Font = Enum.Font.Gotham
		Description.TextWrapped = true
		Description.TextXAlignment = Enum.TextXAlignment.Left

		local Button = Instance.new("TextButton")
		Button.Parent = Card
		Button.AnchorPoint = Vector2.new(1, 0.5)
		Button.Position = UDim2.new(1, -14, 0.5, 0)
		Button.Size = UDim2.fromOffset(112, 42)
		Button.BorderSizePixel = 0
		Button.TextColor3 = Colors.Text
		Button.TextSize = 11
		Button.Font = Enum.Font.GothamBold
		Corner(Button, 9)

		local function Refresh()
			local enabled = isEnabled()

			Button.Text =
				enabled
				and "LIGADO"
				or "DESLIGADO"

			Button.BackgroundColor3 =
				enabled
				and Color3.fromRGB(22, 125, 78)
				or Colors.Blue
		end

		Button.Activated:Connect(function()
			setEnabled(not isEnabled())
			Refresh()
		end)

		Refresh()

		return Button
	end

	MakeToggle(
		105,
		"ESP Ilhas",
		"Mostra o nome de cada ilha e a distância em studs.",
		function()
			return ESPEngine:GetIslands()
		end,
		function(value)
			ESPEngine:SetIslands(value)
		end
	)

	MakeToggle(
		197,
		"ESP Frutas",
		"Mostra frutas spawnadas no mapa, nome e distância.",
		function()
			return ESPEngine:GetFruits()
		end,
		function(value)
			ESPEngine:SetFruits(value)
		end
	)

	MakeToggle(
		289,
		"ESP Berries",
		"Mostra berries presentes nos arbustos, nome e distância.",
		function()
			return ESPEngine:GetBerries()
		end,
		function(value)
			ESPEngine:SetBerries(value)
		end
	)

	Debug.Log("✅ Aba ESP criada.")
end

return ESPUI
