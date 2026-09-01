--==================================================
-- DEAL BLOX
-- UI / CONFIGURAÇÕES DE FARM
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

		Debug.Warn(
			"Configurações de Farm não encontrada."
		)

		return
	end

	for _, object in ipairs(
		Page:GetChildren()
	) do

		object:Destroy()
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
		20
	)

	Components.List(
		Scroll,
		12
	)

	Components.Title(
		Scroll,
		"Configurações de Farm",
		Config
	)

	Components.Subtitle(
		Scroll,
		"Configure como o Deal Blox irá realizar o Auto Farm.",
		Config
	)

	Components.Divider(
		Scroll,
		Config
	)

	--==================================================
	-- ARMAMENTO
	--==================================================

	Components.Section(
		Scroll,
		"⚔️ Armamento",
		Config,
		Config.Colors.Blue
	)

	Components.Dropdown(
		Scroll,

		"Categoria de ataque",

		{
			"Estilo de luta",
			"Espada",
			"Arma",
			"Fruta"
		},

		State.Settings.AttackType,

		Config,

		function(value)

			State:SetSetting(
				"AttackType",
				value
			)

			Debug.Log(
				"Categoria: "
				..
				value
			)
		end
	)

	--==================================================
	-- ALTURA
	--==================================================

	Components.Section(
		Scroll,
		"📍 Posicionamento",
		Config,
		Config.Colors.Red
	)

	Components.Dropdown(
		Scroll,

		"Altura acima do NPC",

		{
			"15 studs",
			"20 studs",
			"24 studs",
			"30 studs",
			"35 studs",
			"40 studs"
		},

		tostring(
			State.Settings.FarmHeight
		)
		..
		" studs",

		Config,

		function(value)

			local number =
				tonumber(
					value:match(
						"%d+"
					)
				)

			if number then

				State:SetSetting(
					"FarmHeight",
					number
				)
			end
		end
	)

	--==================================================
	-- ATAQUE
	--==================================================

	Components.Section(
		Scroll,
		"⚡ Ataque",
		Config,
		Config.Colors.Blue
	)

	Components.Dropdown(
		Scroll,

		"Velocidade do Auto Click",

		{
			"Normal",
			"Rápido",
			"Muito rápido"
		},

		"Rápido",

		Config,

		function(value)

			if value == "Normal" then

				State:SetSetting(
					"AttackDelay",
					0.16
				)

			elseif value == "Rápido" then

				State:SetSetting(
					"AttackDelay",
					0.10
				)

			else

				State:SetSetting(
					"AttackDelay",
					0.06
				)
			end
		end
	)

	Components.Dropdown(
		Scroll,

		"Velocidade de movimentação",

		{
			"Segura",
			"Normal",
			"Rápida"
		},

		"Normal",

		Config,

		function(value)

			if value == "Segura" then

				State:SetSetting(
					"TweenSpeed",
					250
				)

			elseif value == "Normal" then

				State:SetSetting(
					"TweenSpeed",
					350
				)

			else

				State:SetSetting(
					"TweenSpeed",
					450
				)
			end
		end
	)

	--==================================================
	-- HAKI
	--==================================================

	Components.Section(
		Scroll,
		"🛡️ Haki",
		Config,
		Config.Colors.Red
	)

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
			46
		)

	local function RefreshHaki()

		if State.Settings.AutoBuso then

			HakiButton.Text =
				"✅ Haki de Armamento automático"

		else

			HakiButton.Text =
				"❌ Haki de Armamento automático"
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
