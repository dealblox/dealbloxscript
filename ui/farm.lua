--==================================================
-- DEAL BLOX
-- UI / FARM
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

	for _, object in ipairs(
		Page:GetChildren()
	) do

		object:Destroy()
	end

	Debug.Log(
		"Criando aba Farm..."
	)

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
		"Auto Farm Level",
		Config
	)

	Components.Subtitle(
		Scroll,
		"Farm automático por level, Sea e missão.",
		Config
	)

	Components.Divider(
		Scroll,
		Config
	)

	--==================================================
	-- AVISO
	--==================================================

	local Warning =
		Instance.new("TextLabel")

	Warning.Parent =
		Scroll

	Warning.Size =
		UDim2.new(
			1,
			0,
			0,
			62
		)

	Warning.BackgroundColor3 =
		Config.Colors.Red

	Warning.BackgroundTransparency =
		0.05

	Warning.BorderSizePixel =
		0

	Warning.Text =
		""

	Warning.TextColor3 =
		Config.Colors.Text

	Warning.TextSize =
		12

	Warning.Font =
		Enum.Font.GothamBold

	Warning.TextWrapped =
		true

	Warning.Visible =
		false

	Components.Corner(
		Warning,
		9
	)

	Components.Stroke(
		Warning,
		Config.Colors.RedNeon,
		1.5,
		0
	)

	--==================================================
	-- STATUS
	--==================================================

	local StatusCard =
		Components.Card(
			Scroll,
			Config,
			Config.Colors.BlueNeon
		)

	StatusCard.Size =
		UDim2.new(
			1,
			0,
			0,
			270
		)

	local StatusTitle =
		Components.Title(
			StatusCard,
			"STATUS DO AUTO FARM",
			Config
		)

	StatusTitle.Position =
		UDim2.fromOffset(
			15,
			8
		)

	local Info =
		Instance.new("Frame")

	Info.Parent =
		StatusCard

	Info.Position =
		UDim2.fromOffset(
			15,
			50
		)

	Info.Size =
		UDim2.new(
			1,
			-30,
			1,
			-65
		)

	Info.BackgroundTransparency =
		1

	Components.List(
		Info,
		4
	)

	local _, StatusValue =
		Components.InfoRow(
			Info,
			"Status",
			"Parado",
			Config
		)

	local _, SeaValue =
		Components.InfoRow(
			Info,
			"Sea atual",
			"—",
			Config
		)

	local _, LevelValue =
		Components.InfoRow(
			Info,
			"Level",
			"—",
			Config
		)

	local _, QuestValue =
		Components.InfoRow(
			Info,
			"Missão",
			"—",
			Config
		)

	local _, TargetValue =
		Components.InfoRow(
			Info,
			"NPC alvo",
			"—",
			Config
		)

	local _, WeaponValue =
		Components.InfoRow(
			Info,
			"Armamento",
			"—",
			Config
		)

	local _, HeightValue =
		Components.InfoRow(
			Info,
			"Altura",
			"—",
			Config
		)

	--==================================================
	-- BOTÃO
	--==================================================

	local Toggle =
		Components.Button(
			Scroll,
			"",
			Config,
			Config.Colors.Blue
		)

	Toggle.Size =
		UDim2.new(
			1,
			0,
			0,
			56
		)

	Toggle.TextSize =
		14

	local function RefreshButton()

		if State.Settings.AutoFarm then

			Toggle.Text =
				"🟢 AUTO FARM LEVEL • LIGADO"

			Toggle.BackgroundColor3 =
				Color3.fromRGB(
					25,
					125,
					75
				)

		else

			Toggle.Text =
				"⚪ AUTO FARM LEVEL • DESLIGADO"

			Toggle.BackgroundColor3 =
				Config.Colors.Blue
		end
	end

	Toggle.Activated:Connect(
		function()

			if State.Settings.AutoFarm then

				FarmEngine:SetEnabled(
					false
				)

			else

				FarmEngine:SetEnabled(
					true
				)
			end

			RefreshButton()
		end
	)

	--==================================================
	-- ATUALIZAÇÃO
	--==================================================

	task.spawn(function()

		while
			App.Gui
			and
			App.Gui.Parent
		do

			local sea =
				FarmEngine:GetSea()

			local level =
				FarmEngine:GetLevel()

			-- SEA TOPBAR

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

			StatusValue.Text =
				tostring(
					State.Runtime.Status
				)

			SeaValue.Text =
				sea > 0
					and
					("Sea " .. tostring(sea))
					or
					"Desconhecido"

			LevelValue.Text =
				tostring(level)

			QuestValue.Text =
				tostring(
					State.Runtime.Quest
				)

			TargetValue.Text =
				tostring(
					State.Runtime.Target
				)

			WeaponValue.Text =
				tostring(
					State.Settings.AttackType
				)

			HeightValue.Text =
				tostring(
					State.Settings.FarmHeight
				)
				..
				" studs"

			-- AVISO 5 SEGUNDOS

			if
				State.Runtime.Warning
					~=
				""
				and
				tick()
					<
				State.Runtime.WarningUntil
			then

				Warning.Visible =
					true

				Warning.Text =
					"⚠️ "
					..
					State.Runtime.Warning

			else

				Warning.Visible =
					false
			end

			RefreshButton()

			task.wait(0.20)
		end
	end)

	RefreshButton()

	Debug.Log(
		"✅ Aba Farm criada."
	)
end

return FarmUI
