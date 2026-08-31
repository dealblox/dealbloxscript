--==================================================
-- DEAL BLOX
-- UI / FARM CONFIG
--==================================================

local FarmConfig = {}

function FarmConfig.Create(
	App,
	Config,
	Components,
	Debug,
	State
)

	local Page =
		App:GetPage(
			"Configurações de Farm"
		)

	if not Page then
		return
	end

	for _, child in ipairs(
		Page:GetChildren()
	) do
		child:Destroy()
	end

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

	Components.List(
		Scroll,
		12
	)

	--==================================================
	-- TÍTULO
	--==================================================

	Components.Title(
		Scroll,
		"Configurações de Farm",
		Config
	)

	Components.Subtitle(
		Scroll,
		"Personalize como o Auto Farm irá funcionar.",
		Config
	)

	Components.Divider(
		Scroll,
		Config
	)

	--==================================================
	-- CATEGORIA DE ATAQUE
	--==================================================

	local AttackCard =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.BlueNeon
		)

	AttackCard.Size =
		UDim2.new(
			1,
			0,
			0,
			165
		)

	local title =
		Components.Title(
			AttackCard,
			"Categoria de ataque",
			Config
		)

	title.Position =
		UDim2.fromOffset(
			15,
			8
		)

	local CurrentAttack =
		Instance.new("TextLabel")

	CurrentAttack.Parent =
		AttackCard

	CurrentAttack.Position =
		UDim2.fromOffset(
			15,
			47
		)

	CurrentAttack.Size =
		UDim2.new(
			1,
			-30,
			0,
			25
		)

	CurrentAttack.BackgroundTransparency =
		1

	CurrentAttack.TextColor3 =
		Config.Colors.SubText

	CurrentAttack.TextSize = 12

	CurrentAttack.Font =
		Enum.Font.Gotham

	CurrentAttack.TextXAlignment =
		Enum.TextXAlignment.Left

	local MeleeButton =
		Components.Button(
			AttackCard,
			"Estilo de luta",
			Config,
			Config.Colors.Blue
		)

	MeleeButton.Position =
		UDim2.fromOffset(
			15,
			88
		)

	MeleeButton.Size =
		UDim2.new(
			0.48,
			-15,
			0,
			44
		)

	local FruitButton =
		Components.Button(
			AttackCard,
			"Fruta",
			Config,
			Config.Colors.Red
		)

	FruitButton.Position =
		UDim2.new(
			0.5,
			5,
			0,
			88
		)

	FruitButton.Size =
		UDim2.new(
			0.48,
			-15,
			0,
			44
		)

	local function RefreshAttack()

		CurrentAttack.Text =
			"Selecionado: "
			..
			State.Settings.AttackType

	end

	MeleeButton.Activated:Connect(
		function()

			State:SetSetting(
				"AttackType",
				"Estilo de luta"
			)

			RefreshAttack()

		end
	)

	FruitButton.Activated:Connect(
		function()

			State:SetSetting(
				"AttackType",
				"Fruta"
			)

			RefreshAttack()

		end
	)

	RefreshAttack()

	--==================================================
	-- ALTURA
	--==================================================

	local HeightCard =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.RedNeon
		)

	HeightCard.Size =
		UDim2.new(
			1,
			0,
			0,
			125
		)

	local HeightTitle =
		Components.Title(
			HeightCard,
			"Altura acima do NPC",
			Config
		)

	HeightTitle.Position =
		UDim2.fromOffset(
			15,
			8
		)

	local HeightButton =
		Components.Button(
			HeightCard,
			"",
			Config,
			Config.Colors.Red
		)

	HeightButton.Position =
		UDim2.fromOffset(
			15,
			60
		)

	HeightButton.Size =
		UDim2.new(
			1,
			-30,
			0,
			43
		)

	local Heights = {
		15,
		24,
		32,
		40
	}

	local function RefreshHeight()

		HeightButton.Text =
			tostring(
				State.Settings.FarmHeight
			)
			..
			" studs  • clique para alterar"

	end

	HeightButton.Activated:Connect(
		function()

			local currentIndex = 1

			for index, value in ipairs(
				Heights
			) do

				if
					value
					==
					State.Settings.FarmHeight
				then
					currentIndex = index
					break
				end
			end

			currentIndex =
				currentIndex + 1

			if currentIndex > #Heights then
				currentIndex = 1
			end

			State:SetSetting(
				"FarmHeight",
				Heights[currentIndex]
			)

			RefreshHeight()

		end
	)

	RefreshHeight()

	--==================================================
	-- VELOCIDADE DO ATAQUE
	--==================================================

	local SpeedCard =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.BlueNeon
		)

	SpeedCard.Size =
		UDim2.new(
			1,
			0,
			0,
			180
		)

	local SpeedTitle =
		Components.Title(
			SpeedCard,
			"Velocidade",
			Config
		)

	SpeedTitle.Position =
		UDim2.fromOffset(
			15,
			8
		)

	local AttackSpeed =
		Components.Button(
			SpeedCard,
			"",
			Config,
			Config.Colors.Blue
		)

	AttackSpeed.Position =
		UDim2.fromOffset(
			15,
			55
		)

	AttackSpeed.Size =
		UDim2.new(
			1,
			-30,
			0,
			43
		)

	local MoveSpeed =
		Components.Button(
			SpeedCard,
			"",
			Config,
			Config.Colors.Red
		)

	MoveSpeed.Position =
		UDim2.fromOffset(
			15,
			113
		)

	MoveSpeed.Size =
		UDim2.new(
			1,
			-30,
			0,
			43
		)

	local AttackDelays = {
		0.16,
		0.10,
		0.06
	}

	local TweenSpeeds = {
		250,
		350,
		450
	}

	local function RefreshSpeed()

		AttackSpeed.Text =
			"Auto Click: "
			..
			string.format(
				"%.2fs",
				State.Settings.AttackDelay
			)

		MoveSpeed.Text =
			"Movimento: "
			..
			tostring(
				State.Settings.TweenSpeed
			)

	end

	AttackSpeed.Activated:Connect(
		function()

			local current = 1

			for i, value in ipairs(
				AttackDelays
			) do

				if
					value
					==
					State.Settings.AttackDelay
				then
					current = i
					break
				end
			end

			current = current + 1

			if current > #AttackDelays then
				current = 1
			end

			State:SetSetting(
				"AttackDelay",
				AttackDelays[current]
			)

			RefreshSpeed()

		end
	)

	MoveSpeed.Activated:Connect(
		function()

			local current = 1

			for i, value in ipairs(
				TweenSpeeds
			) do

				if
					value
					==
					State.Settings.TweenSpeed
				then
					current = i
					break
				end
			end

			current = current + 1

			if current > #TweenSpeeds then
				current = 1
			end

			State:SetSetting(
				"TweenSpeed",
				TweenSpeeds[current]
			)

			RefreshSpeed()

		end
	)

	RefreshSpeed()

	--==================================================
	-- HAKI
	--==================================================

	local HakiButton =
		Components.Button(
			Scroll,
			"",
			Config,
			Config.Colors.Blue
		)

	HakiButton.Size =
		UDim2.new(
			1,
			0,
			0,
			45
		)

	local function RefreshHaki()

		if State.Settings.AutoBuso then

			HakiButton.Text =
				"✅ Haki automático: ATIVADO"

		else

			HakiButton.Text =
				"❌ Haki automático: DESATIVADO"

		end
	end

	HakiButton.Activated:Connect(
		function()

			State:SetSetting(
				"AutoBuso",
				not State.Settings.AutoBuso
			)

			RefreshHaki()

		end
	)

	RefreshHaki()

	Debug.Log(
		"Configurações de Farm criadas."
	)
end

return FarmConfig
