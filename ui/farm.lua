--==================================================
-- DEAL BLOX
-- UI / FARM
-- Versão independente dos Components
--==================================================

local FarmUI = {}

function FarmUI.Create(
	App,
	Config,
	Components,
	Debug,
	State,
	FarmEngine
)

	--==================================================
	-- PAGE
	--==================================================

	local Page =
		App:GetPage(
			"Farm"
		)

	if not Page then
		Debug.Warn(
			"Aba Farm não encontrada."
		)

		return
	end

	-- Limpa qualquer conteúdo antigo da aba.
	for _, object in ipairs(
		Page:GetChildren()
	) do
		object:Destroy()
	end

	Debug.Log(
		"Criando aba Farm V3..."
	)

	--==================================================
	-- CORES
	--==================================================

	local Colors =
		Config.Colors

	local Background =
		Colors.Panel
		or
		Color3.fromRGB(
			10,
			15,
			25
		)

	local Panel =
		Colors.Panel2
		or
		Color3.fromRGB(
			18,
			24,
			36
		)

	local Text =
		Colors.Text
		or
		Color3.fromRGB(
			245,
			245,
			250
		)

	local SubText =
		Colors.SubText
		or
		Color3.fromRGB(
			160,
			170,
			185
		)

	local Blue =
		Colors.Blue
		or
		Color3.fromRGB(
			25,
			95,
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

	local Red =
		Colors.Red
		or
		Color3.fromRGB(
			155,
			35,
			55
		)

	--==================================================
	-- HELPERS VISUAIS
	--==================================================

	local function Corner(
		parent,
		radius
	)
		local corner =
			Instance.new(
				"UICorner"
			)

		corner.CornerRadius =
			UDim.new(
				0,
				radius or 8
			)

		corner.Parent =
			parent

		return corner
	end

	local function Stroke(
		parent,
		color,
		thickness,
		transparency
	)
		local stroke =
			Instance.new(
				"UIStroke"
			)

		stroke.Color =
			color
			or
			BlueNeon

		stroke.Thickness =
			thickness
			or
			1

		stroke.Transparency =
			transparency
			or
			0

		stroke.Parent =
			parent

		return stroke
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
		local label =
			Instance.new(
				"TextLabel"
			)

		label.Parent =
			parent

		label.Position =
			position

		label.Size =
			size

		label.BackgroundTransparency =
			1

		label.BorderSizePixel =
			0

		label.Text =
			text
			or
			""

		label.TextColor3 =
			color
			or
			Text

		label.TextSize =
			textSize
			or
			12

		label.Font =
			font
			or
			Enum.Font.Gotham

		label.TextXAlignment =
			Enum.TextXAlignment.Left

		label.TextYAlignment =
			Enum.TextYAlignment.Center

		label.ZIndex =
			7

		return label
	end

	local function InfoRow(
		parent,
		y,
		title,
		value
	)
		local titleLabel =
			Label(
				parent,
				title,
				UDim2.fromOffset(
					16,
					y
				),
				UDim2.new(
					0.45,
					-16,
					0,
					25
				),
				12,
				Enum.Font.Gotham,
				SubText
			)

		local valueLabel =
			Label(
				parent,
				value,
				UDim2.new(
					0.45,
					0,
					0,
					y
				),
				UDim2.new(
					0.55,
					-16,
					0,
					25
				),
				12,
				Enum.Font.GothamBold,
				Text
			)

		valueLabel.TextXAlignment =
			Enum.TextXAlignment.Right

		return
			titleLabel,
			valueLabel
	end

	--==================================================
	-- SCROLL PRINCIPAL
	--==================================================

	local Scroll =
		Instance.new(
			"ScrollingFrame"
		)

	Scroll.Name =
		"DealBloxFarmScroll"

	Scroll.Parent =
		Page

	Scroll.Position =
		UDim2.fromOffset(
			0,
			0
		)

	Scroll.Size =
		UDim2.fromScale(
			1,
			1
		)

	Scroll.BackgroundTransparency =
		1

	Scroll.BorderSizePixel =
		0

	Scroll.ScrollBarThickness =
		4

	Scroll.ScrollBarImageColor3 =
		BlueNeon

	Scroll.CanvasSize =
		UDim2.fromOffset(
			0,
			640
		)

	Scroll.ZIndex =
		5

	--==================================================
	-- CABEÇALHO
	--==================================================

	local Title =
		Label(
			Scroll,
			"AUTO FARM LEVEL",
			UDim2.fromOffset(
				18,
				14
			),
			UDim2.new(
				1,
				-36,
				0,
				30
			),
			20,
			Enum.Font.GothamBold,
			Text
		)

	local Subtitle =
		Label(
			Scroll,
			"Farm automático pelo seu level, Sea e missão.",
			UDim2.fromOffset(
				18,
				45
			),
			UDim2.new(
				1,
				-36,
				0,
				24
			),
			12,
			Enum.Font.Gotham,
			SubText
		)

	local Divider =
		Instance.new(
			"Frame"
		)

	Divider.Parent =
		Scroll

	Divider.Position =
		UDim2.fromOffset(
			18,
			78
		)

	Divider.Size =
		UDim2.new(
			1,
			-36,
			0,
			2
		)

	Divider.BackgroundColor3 =
		BlueNeon

	Divider.BorderSizePixel =
		0

	Divider.ZIndex =
		7

	--==================================================
	-- MARCADOR DE TESTE
	--==================================================

	local TestBadge =
		Instance.new(
			"TextLabel"
		)

	TestBadge.Parent =
		Scroll

	TestBadge.Position =
		UDim2.new(
			1,
			-130,
			0,
			12
		)

	TestBadge.Size =
		UDim2.fromOffset(
			112,
			24
		)

	TestBadge.BackgroundColor3 =
		Blue

	TestBadge.BackgroundTransparency =
		0.10

	TestBadge.BorderSizePixel =
		0

	TestBadge.Text =
		"UI FARM V3"

	TestBadge.TextColor3 =
		Text

	TestBadge.TextSize =
		10

	TestBadge.Font =
		Enum.Font.GothamBold

	TestBadge.ZIndex =
		8

	Corner(
		TestBadge,
		6
	)

	--==================================================
	-- AVISO
	--==================================================

	local Warning =
		Instance.new(
			"TextLabel"
		)

	Warning.Name =
		"Warning"

	Warning.Parent =
		Scroll

	Warning.Position =
		UDim2.fromOffset(
			18,
			94
		)

	Warning.Size =
		UDim2.new(
			1,
			-36,
			0,
			54
		)

	Warning.BackgroundColor3 =
		Red

	Warning.BackgroundTransparency =
		0.08

	Warning.BorderSizePixel =
		0

	Warning.Text =
		""

	Warning.TextColor3 =
		Text

	Warning.TextSize =
		12

	Warning.Font =
		Enum.Font.GothamBold

	Warning.TextWrapped =
		true

	Warning.Visible =
		false

	Warning.ZIndex =
		8

	Corner(
		Warning,
		9
	)

	--==================================================
	-- STATUS CARD
	--==================================================

	local StatusCard =
		Instance.new(
			"Frame"
		)

	StatusCard.Name =
		"StatusCard"

	StatusCard.Parent =
		Scroll

	StatusCard.Position =
		UDim2.fromOffset(
			18,
			164
		)

	StatusCard.Size =
		UDim2.new(
			1,
			-36,
			0,
			265
		)

	StatusCard.BackgroundColor3 =
		Panel

	StatusCard.BackgroundTransparency =
		0.06

	StatusCard.BorderSizePixel =
		0

	StatusCard.ZIndex =
		6

	Corner(
		StatusCard,
		12
	)

	Stroke(
		StatusCard,
		BlueNeon,
		1.5,
		0.15
	)

	Label(
		StatusCard,
		"STATUS DO AUTO FARM",
		UDim2.fromOffset(
			16,
			10
		),
		UDim2.new(
			1,
			-32,
			0,
			30
		),
		14,
		Enum.Font.GothamBold,
		Text
	)

	local _, StatusValue =
		InfoRow(
			StatusCard,
			45,
			"Status",
			"Parado"
		)

	local _, SeaValue =
		InfoRow(
			StatusCard,
			73,
			"Sea atual",
			"—"
		)

	local _, LevelValue =
		InfoRow(
			StatusCard,
			101,
			"Level",
			"—"
		)

	local _, QuestValue =
		InfoRow(
			StatusCard,
			129,
			"Missão",
			"—"
		)

	local _, TargetValue =
		InfoRow(
			StatusCard,
			157,
			"NPC alvo",
			"—"
		)

	local _, WeaponValue =
		InfoRow(
			StatusCard,
			185,
			"Armamento",
			"—"
		)

	local _, HeightValue =
		InfoRow(
			StatusCard,
			213,
			"Altura",
			"—"
		)

	--==================================================
	-- BOTÃO AUTO FARM
	--==================================================

	local Toggle =
		Instance.new(
			"TextButton"
		)

	Toggle.Name =
		"AutoFarmToggle"

	Toggle.Parent =
		Scroll

	Toggle.Position =
		UDim2.fromOffset(
			18,
			450
		)

	Toggle.Size =
		UDim2.new(
			1,
			-36,
			0,
			58
		)

	Toggle.BackgroundColor3 =
		Blue

	Toggle.BackgroundTransparency =
		0.04

	Toggle.BorderSizePixel =
		0

	Toggle.Text =
		"AUTO FARM LEVEL - DESLIGADO"

	Toggle.TextColor3 =
		Text

	Toggle.TextSize =
		14

	Toggle.Font =
		Enum.Font.GothamBold

	Toggle.AutoButtonColor =
		true

	Toggle.Active =
		true

	Toggle.ZIndex =
		8

	Corner(
		Toggle,
		10
	)

	Stroke(
		Toggle,
		BlueNeon,
		1.5,
		0.12
	)

	--==================================================
	-- TEXTO AUXILIAR
	--==================================================

	local Help =
		Label(
			Scroll,
			"Configure armamento, altura e velocidade na aba Configurações de Farm.",
			UDim2.fromOffset(
				18,
				522
			),
			UDim2.new(
				1,
				-36,
				0,
				45
			),
			11,
			Enum.Font.Gotham,
			SubText
		)

	Help.TextWrapped =
		true

	Help.TextYAlignment =
		Enum.TextYAlignment.Top

	--==================================================
	-- REFRESH
	--==================================================

	local function RefreshButton()
		if
			State
			and
			State.Settings
			and
			State.Settings.AutoFarm
		then
			Toggle.Text =
				"AUTO FARM LEVEL - LIGADO"

			Toggle.BackgroundColor3 =
				Color3.fromRGB(
					25,
					125,
					75
				)

		else
			Toggle.Text =
				"AUTO FARM LEVEL - DESLIGADO"

			Toggle.BackgroundColor3 =
				Blue
		end
	end

	--==================================================
	-- CLICK
	--==================================================

	Toggle.Activated:
		Connect(function()

			if not FarmEngine then
				Warning.Visible =
					true

				Warning.Text =
					"FarmEngine não está disponível."

				return
			end

			local current =
				State
				and
				State.Settings
				and
				State.Settings.AutoFarm
				or
				false

			local success, result =
				pcall(function()

					return FarmEngine:
						SetEnabled(
							not current
						)
				end)

			if not success then
				Warning.Visible =
					true

				Warning.Text =
					"Erro ao alterar Auto Farm: "
					..
					tostring(result)

				Debug.Warn(
					result
				)
			end

			task.wait()

			RefreshButton()
		end)

	--==================================================
	-- LOOP DE ATUALIZAÇÃO
	--==================================================

	task.spawn(function()

		while
			App
			and
			App.Gui
			and
			App.Gui.Parent
			and
			Scroll.Parent
		do

			local sea =
				0

			local level =
				0

			if FarmEngine then
				local seaSuccess,
					seaResult =
					pcall(function()

						return FarmEngine:
							GetSea()
					end)

				if seaSuccess then
					sea =
						tonumber(
							seaResult
						)
						or
						0
				end

				local levelSuccess,
					levelResult =
					pcall(function()

						return FarmEngine:
							GetLevel()
					end)

				if levelSuccess then
					level =
						tonumber(
							levelResult
						)
						or
						0
				end
			end

			-- SEA NO TOPO
			if App.SeaBadge then
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

			-- STATUS
			if
				State
				and
				State.Runtime
			then
				StatusValue.Text =
					tostring(
						State.Runtime.Status
						or
						"Parado"
					)

				QuestValue.Text =
					tostring(
						State.Runtime.Quest
						or
						"Nenhuma"
					)

				TargetValue.Text =
					tostring(
						State.Runtime.Target
						or
						"Nenhum"
					)
			end

			if sea > 0 then
				SeaValue.Text =
					"Sea "
					..
					tostring(sea)
			else
				SeaValue.Text =
					"Desconhecido"
			end

			LevelValue.Text =
				level > 0
					and
					tostring(level)
					or
					"—"

			if
				State
				and
				State.Settings
			then
				WeaponValue.Text =
					tostring(
						State.Settings.AttackType
						or
						"Estilo de luta"
					)

				HeightValue.Text =
					tostring(
						State.Settings.FarmHeight
						or
						24
					)
					..
					" studs"
			end

			-- AVISO DE 5 SEGUNDOS
			if
				State
				and
				State.Runtime
				and
				tostring(
					State.Runtime.Warning
					or
					""
				)
				~=
				""
				and
				tick()
				<
				tonumber(
					State.Runtime.WarningUntil
					or
					0
				)
			then
				Warning.Visible =
					true

				Warning.Text =
					"AVISO: "
					..
					tostring(
						State.Runtime.Warning
					)
			else
				Warning.Visible =
					false
			end

			RefreshButton()

			task.wait(
				0.20
			)
		end
	end)

	RefreshButton()

	Debug.Log(
		"✅ Aba Farm V3 criada."
	)

	return {
		Page =
			Page,

		Scroll =
			Scroll,

		Toggle =
			Toggle
	}
end

return FarmUI
