--==================================================
-- DEAL BLOX
-- MODULES / FARM
-- Auto Farm modular
--==================================================

local Farm = {}

function Farm.Create(
	State,
	Quests,
	Debug
)
	--==================================================
	-- SERVICES
	--==================================================

	local Players =
		game:GetService("Players")

	local ReplicatedStorage =
		game:GetService("ReplicatedStorage")

	local TweenService =
		game:GetService("TweenService")

	local RunService =
		game:GetService("RunService")

	local VirtualUser =
		game:GetService("VirtualUser")

	local StarterGui =
		game:GetService("StarterGui")

	local Player =
		Players.LocalPlayer

	local Environment =
		getgenv and getgenv() or _G

	Environment.DealBloxFarmToken =
		(
			Environment.DealBloxFarmToken
			or
			0
		)
		+
		1

	local Token =
		Environment.DealBloxFarmToken

	--==================================================
	-- CONSTANTS
	--==================================================

	local TIKI_SUBMARINE =
		CFrame.new(
			-16269.7041,
			25.2288,
			1373.6596
		)

	local SAFE_OCEAN_HEIGHT =
		450

	local SUBMERGED_DISTANCE_LIMIT =
		10000

	--==================================================
	-- HELPERS
	--==================================================

	local function Log(text)
		if
			Debug
			and
			Debug.Log
		then
			Debug.Log(text)
		else
			print(
				"[DEAL BLOX] "
				..
				tostring(text)
			)
		end
	end

	local function Warn(text)
		if
			Debug
			and
			Debug.Warn
		then
			Debug.Warn(text)
		else
			warn(
				"[DEAL BLOX] "
				..
				tostring(text)
			)
		end
	end

	local function Warning(text)
		State:SetWarning(
			text,
			5
		)

		pcall(function()
			StarterGui:SetCore(
				"SendNotification",
				{
					Title = "DEAL BLOX",
					Text = tostring(text),
					Duration = 5
				}
			)
		end)
	end

	--==================================================
	-- CHARACTER
	--==================================================

	local function GetCharacter()
		local character =
			Player.Character

		if not character then
			return nil
		end

		local humanoid =
			character:FindFirstChildOfClass(
				"Humanoid"
			)

		local root =
			character:FindFirstChild(
				"HumanoidRootPart"
			)

		if
			not humanoid
			or
			not root
			or
			humanoid.Health <= 0
		then
			return nil
		end

		return character, humanoid, root
	end

	--==================================================
	-- LEVEL
	--==================================================

	local function GetLevel()
		local Data =
			Player:FindFirstChild(
				"Data"
			)

		local Level =
			Data
			and
			Data:FindFirstChild(
				"Level"
			)

		return
			tonumber(
				Level
				and
				Level.Value
			)
			or
			1
	end

	--==================================================
	-- REMOTES
	--==================================================

	local function GetCommF()
		local Remotes =
			ReplicatedStorage:
			FindFirstChild(
				"Remotes"
			)

		if not Remotes then
			return nil
		end

		return Remotes:
			FindFirstChild(
				"CommF_"
			)
	end

	local function GetNet()
		local Modules =
			ReplicatedStorage:
			FindFirstChild(
				"Modules"
			)

		if not Modules then
			return nil
		end

		return Modules:
			FindFirstChild(
				"Net"
			)
	end

	local function GetSubmarineRemote()
		local Net =
			GetNet()

		if not Net then
			return nil
		end

		return Net:
			FindFirstChild(
				"RF/SubmarineWorkerSpeak"
			)
	end

	--==================================================
	-- SEA
	--==================================================

	local function ValidateSea()
		local level =
			GetLevel()

		local currentSea =
			Quests.GetSea()

		local requiredSea =
			Quests.GetRequiredSea(
				level
			)

		State:SetRuntime(
			"Level",
			level
		)

		State:SetRuntime(
			"Sea",
			currentSea
		)

		if currentSea == 0 then
			State:SetRuntime(
				"Status",
				"Mapa não reconhecido"
			)

			Warning(
				"O Deal Blox não reconheceu este Sea."
			)

			return false
		end

		if
			currentSea
			~=
			requiredSea
		then
			State:SetRuntime(
				"Status",
				"Sea incorreto"
			)

			Warning(
				"Seu level "
				..
				tostring(level)
				..
				" pertence ao Sea "
				..
				tostring(requiredSea)
				..
				". Vá para o Sea correto para usar o Auto Farm."
			)

			return false
		end

		return true
	end

	--==================================================
	-- MOVIMENTO
	--==================================================

	local CurrentTween =
		nil

	local function StopTween()
		if CurrentTween then
			pcall(function()
				CurrentTween:Cancel()
			end)
		end

		CurrentTween =
			nil
	end

	local function TweenTo(
		targetCFrame
	)
		if
			not State.Settings.AutoFarm
		then
			return false
		end

		local _, _, root =
			GetCharacter()

		if not root then
			return false
		end

		local distance =
			(
				root.Position
				-
				targetCFrame.Position
			).Magnitude

		if distance <= 10 then
			pcall(function()
				root.CFrame =
					targetCFrame
			end)

			return true
		end

		StopTween()

		local speed =
			math.max(
				State.Settings.TweenSpeed
				or
				350,
				100
			)

		local duration =
			math.clamp(
				distance / speed,
				0.10,
				15
			)

		CurrentTween =
			TweenService:Create(
				root,
				TweenInfo.new(
					duration,
					Enum.EasingStyle.Linear
				),
				{
					CFrame =
						targetCFrame
				}
			)

		CurrentTween:Play()

		local started =
			tick()

		while
			State.Settings.AutoFarm
			and
			CurrentTween
			and
			CurrentTween.PlaybackState
				==
				Enum.PlaybackState.Playing
		do
			if
				tick() - started
				>
				duration + 1
			then
				break
			end

			task.wait(0.05)
		end

		return
			State.Settings.AutoFarm
	end

	local function MoveTo(
		targetCFrame
	)
		return TweenTo(
			targetCFrame
		)
	end

	-- Viagem longa no Sea 3:
	-- sobe primeiro, atravessa acima do oceano,
	-- e só depois desce no ponto da Tiki.
	local function MoveToTikiSubmarine()
		if
			not State.Settings.AutoFarm
		then
			return false
		end

		local _, _, root =
			GetCharacter()

		if not root then
			return false
		end

		State:SetRuntime(
			"Status",
			"Indo para Tiki"
		)

		local safeY =
			math.max(
				root.Position.Y,
				SAFE_OCEAN_HEIGHT
			)

		local up =
			CFrame.new(
				root.Position.X,
				safeY,
				root.Position.Z
			)

		if
			math.abs(
				root.Position.Y
				-
				safeY
			)
			>
			20
		then
			if not TweenTo(up) then
				return false
			end
		end

		local across =
			CFrame.new(
				TIKI_SUBMARINE.Position.X,
				safeY,
				TIKI_SUBMARINE.Position.Z
			)

		if not TweenTo(across) then
			return false
		end

		local descend =
			TIKI_SUBMARINE
			*
			CFrame.new(
				0,
				4,
				0
			)

		if not TweenTo(descend) then
			return false
		end

		return true
	end

	--==================================================
	-- SUBMERGED ISLAND
	--==================================================

	local function IsInsideSubmerged(
		QuestData
	)
		if
			not QuestData
			or
			not QuestData.RequiresSubmerged
		then
			return false
		end

		local _, _, root =
			GetCharacter()

		if not root then
			return false
		end

		-- A área fica muito abaixo do Sea 3 normal.
		if root.Position.Y < -1000 then
			return true
		end

		-- Segunda verificação por distância da quest.
		local distance =
			(
				root.Position
				-
				QuestData.QuestPos.Position
			).Magnitude

		return
			distance
			<
			SUBMERGED_DISTANCE_LIMIT
	end

	local function TravelToSubmerged(
		QuestData
	)
		if IsInsideSubmerged(
			QuestData
		) then
			return true
		end

		State:SetRuntime(
			"Status",
			"Entrando na Submerged"
		)

		if not MoveToTikiSubmarine() then
			return false
		end

		if
			not State.Settings.AutoFarm
		then
			return false
		end

		task.wait(1.5)

		local Remote =
			GetSubmarineRemote()

		if not Remote then
			State:SetRuntime(
				"Status",
				"Submarino não encontrado"
			)

			Warning(
				"Não encontrei o Remote do submarino. Entre na Submerged Island manualmente e ligue o Auto Farm novamente."
			)

			return false
		end

		local success, result =
			pcall(function()
				return Remote:InvokeServer(
					"TravelToSubmergedIsland"
				)
			end)

		if not success then
			Warn(
				"Falha ao usar o submarino: "
				..
				tostring(result)
			)

			State:SetRuntime(
				"Status",
				"Falha no submarino"
			)

			Warning(
				"Não consegui entrar na Submerged Island. Verifique se sua conta já liberou o acesso pelo Submarine Worker."
			)

			return false
		end

		State:SetRuntime(
			"Status",
			"Aguardando Submerged"
		)

		local started =
			tick()

		while
			State.Settings.AutoFarm
			and
			tick() - started < 10
		do
			task.wait(0.25)

			if IsInsideSubmerged(
				QuestData
			) then
				Log(
					"✅ Submerged Island detectada."
				)

				return true
			end
		end

		Warning(
			"O submarino foi acionado, mas a Submerged Island não foi detectada."
		)

		return false
	end

	local function EnsureQuestArea(
		QuestData
	)
		if
			not QuestData.RequiresSubmerged
		then
			return true
		end

		if IsInsideSubmerged(
			QuestData
		) then
			return true
		end

		return TravelToSubmerged(
			QuestData
		)
	end

	--==================================================
	-- HAKI
	--==================================================

	local function ActivateBuso()
		if
			not State.Settings.AutoBuso
		then
			return
		end

		local character =
			Player.Character

		if not character then
			return
		end

		if
			character:
			FindFirstChild(
				"HasBuso"
			)
		then
			return
		end

		local Remote =
			GetCommF()

		if Remote then
			pcall(function()
				Remote:InvokeServer(
					"Buso"
				)
			end)
		end
	end

	--==================================================
	-- EQUIPAR CATEGORIA
	--==================================================

	local function EquipAttack()
		local character, humanoid =
			GetCharacter()

		if
			not character
			or
			not humanoid
		then
			return nil
		end

		local WeaponMap = {
			["Estilo de luta"] = "Melee",
			["Espada"] = "Sword",
			["Arma"] = "Gun",
			["Fruta"] = "Blox Fruit",
		}

		local selected =
			State.Settings.AttackType

		local targetTooltip =
			WeaponMap[selected]

		if not targetTooltip then
			return nil
		end

		for _, tool in ipairs(
			character:GetChildren()
		) do
			if
				tool:IsA("Tool")
				and
				tool.ToolTip
					==
				targetTooltip
			then
				return tool
			end
		end

		local Backpack =
			Player:FindFirstChild(
				"Backpack"
			)

		if not Backpack then
			return nil
		end

		for _, tool in ipairs(
			Backpack:GetChildren()
		) do
			if
				tool:IsA("Tool")
				and
				tool.ToolTip
					==
				targetTooltip
			then
				pcall(function()
					humanoid:
						EquipTool(
							tool
						)
				end)

				return tool
			end
		end

		return nil
	end

	--==================================================
	-- AUTO CLICK
	--==================================================

	local function Attack()
		pcall(function()
			VirtualUser:
				CaptureController()

			VirtualUser:
				Button1Down(
					Vector2.new(
						1280,
						672
					)
				)

			task.wait(0.02)

			VirtualUser:
				Button1Up(
					Vector2.new(
						1280,
						672
					)
				)
		end)
	end

	--==================================================
	-- QUEST GUI
	--==================================================

	local function HasCorrectQuest(
		QuestData
	)
		local PlayerGui =
			Player:
			FindFirstChild(
				"PlayerGui"
			)

		if not PlayerGui then
			return false
		end

		local Main =
			PlayerGui:
			FindFirstChild(
				"Main"
			)

		if not Main then
			return false
		end

		local Quest =
			Main:
			FindFirstChild(
				"Quest"
			)

		if
			not Quest
			or
			not Quest.Visible
		then
			return false
		end

		local success, title =
			pcall(function()
				return Quest
					.Container
					.QuestTitle
					.Title
					.Text
			end)

		if
			not success
			or
			not title
		then
			return false
		end

		return
			string.find(
				string.lower(
					tostring(title)
				),
				string.lower(
					QuestData.Mob
				),
				1,
				true
			)
			~=
			nil
	end

	--==================================================
	-- START QUEST
	--==================================================

	local function StartQuest(
		QuestData
	)
		if
			not State.Settings.AutoFarm
		then
			return false
		end

		if
			not EnsureQuestArea(
				QuestData
			)
		then
			return false
		end

		State:SetRuntime(
			"Status",
			"Pegando missão"
		)

		State:SetRuntime(
			"Quest",
			QuestData.Mob
		)

		if not MoveTo(
			QuestData.QuestPos
				*
				CFrame.new(
					0,
					4,
					0
				)
		) then
			return false
		end

		if
			not State.Settings.AutoFarm
		then
			return false
		end

		task.wait(0.30)

		local Remote =
			GetCommF()

		if not Remote then
			State:SetRuntime(
				"Status",
				"Remote não encontrado"
			)

			return false
		end

		local success, result =
			pcall(function()
				return Remote:
					InvokeServer(
						"StartQuest",
						QuestData.Quest,
						QuestData.QuestNum
					)
			end)

		if not success then
			Warn(
				"Erro StartQuest: "
				..
				tostring(result)
			)

			return false
		end

		task.wait(0.60)

		return true
	end

	--==================================================
	-- ENCONTRAR NPC
	--==================================================

	local function FindTarget(
		QuestData
	)
		local Enemies =
			workspace:
			FindFirstChild(
				"Enemies"
			)

		if not Enemies then
			return nil
		end

		local _, _, playerRoot =
			GetCharacter()

		local closest =
			nil

		local closestDistance =
			math.huge

		local wanted =
			string.lower(
				QuestData.Mob
			)

		for _, enemy in ipairs(
			Enemies:GetChildren()
		) do
			local humanoid =
				enemy:
				FindFirstChildOfClass(
					"Humanoid"
				)

			local root =
				enemy:
				FindFirstChild(
					"HumanoidRootPart"
				)

			local matches =
				string.find(
					string.lower(
						enemy.Name
					),
					wanted,
					1,
					true
				)

			if
				matches
				and
				humanoid
				and
				root
				and
				humanoid.Health > 0
			then
				local distance =
					0

				if playerRoot then
					distance =
						(
							playerRoot.Position
							-
							root.Position
						).Magnitude
				end

				if
					distance
					<
					closestDistance
				then
					closest =
						enemy

					closestDistance =
						distance
				end
			end
		end

		return closest
	end

	--==================================================
	-- FIGHT
	--==================================================

	local function Fight(
		Target,
		QuestData
	)
		local humanoid =
			Target:
			FindFirstChildOfClass(
				"Humanoid"
			)

		local enemyRoot =
			Target:
			FindFirstChild(
				"HumanoidRootPart"
			)

		if
			not humanoid
			or
			not enemyRoot
		then
			return
		end

		State:SetRuntime(
			"Status",
			"Farmando"
		)

		State:SetRuntime(
			"Target",
			QuestData.Mob
		)

		ActivateBuso()
		EquipAttack()

		while
			State.Settings.AutoFarm
			and
			Target.Parent
			and
			humanoid.Parent
			and
			humanoid.Health > 0
		do
			local _, _, playerRoot =
				GetCharacter()

			if not playerRoot then
				State:SetRuntime(
					"Status",
					"Aguardando respawn"
				)

				task.wait(1)
				continue
			end

			if not enemyRoot.Parent then
				break
			end

			local enemyPosition =
				enemyRoot.Position

			local height =
				State.Settings.FarmHeight
				or
				24

			-- Dentro da Submerged não sobe demais.
			if QuestData.RequiresSubmerged then
				height =
					math.clamp(
						height,
						10,
						30
					)
			end

			local above =
				enemyPosition
				+
				Vector3.new(
					0,
					height,
					0
				)

			pcall(function()
				playerRoot.AssemblyLinearVelocity =
					Vector3.zero

				playerRoot.AssemblyAngularVelocity =
					Vector3.zero

				playerRoot.CFrame =
					CFrame.new(
						above,
						enemyPosition
					)
			end)

			ActivateBuso()
			EquipAttack()
			Attack()

			task.wait(
				State.Settings.AttackDelay
					or
					0.10
			)
		end

		State:SetRuntime(
			"Target",
			"Nenhum"
		)
	end

	--==================================================
	-- FARM STEP
	--==================================================

	local function Step()
		local level =
			GetLevel()

		local sea =
			Quests.GetSea()

		State:SetRuntime(
			"Level",
			level
		)

		State:SetRuntime(
			"Sea",
			sea
		)

		local requiredSea =
			Quests.GetRequiredSea(
				level
			)

		if
			sea
			~=
			requiredSea
		then
			State:SetSetting(
				"AutoFarm",
				false
			)

			State:SetRuntime(
				"Status",
				"Sea incorreto"
			)

			Warning(
				"Seu level "
				..
				tostring(level)
				..
				" pertence ao Sea "
				..
				tostring(requiredSea)
				..
				". Vá para o Sea correto."
			)

			return
		end

		local QuestData =
			Quests.GetForLevel(
				level,
				sea
			)

		if not QuestData then
			State:SetRuntime(
				"Status",
				"Quest não encontrada"
			)

			task.wait(1)
			return
		end

		State:SetRuntime(
			"Quest",
			QuestData.Mob
		)

		if
			not EnsureQuestArea(
				QuestData
			)
		then
			State:SetSetting(
				"AutoFarm",
				false
			)

			return
		end

		if
			not HasCorrectQuest(
				QuestData
			)
		then
			StartQuest(
				QuestData
			)

			return
		end

		local Target =
			FindTarget(
				QuestData
			)

		if Target then
			Fight(
				Target,
				QuestData
			)
		else
			State:SetRuntime(
				"Status",
				"Procurando NPC"
			)

			State:SetRuntime(
				"Target",
				QuestData.Mob
			)

			MoveTo(
				QuestData.MobPos
					*
					CFrame.new(
						0,
						QuestData.RequiresSubmerged
							and
							18
							or
							(
								State.Settings.FarmHeight
								or
								24
							),
						0
					)
			)

			task.wait(0.7)
		end
	end

	--==================================================
	-- API
	--==================================================

	local API = {}

	function API:SetEnabled(
		enabled
	)
		enabled =
			enabled == true

		if enabled then
			if not ValidateSea() then
				State:SetSetting(
					"AutoFarm",
					false
				)

				return false
			end

			State:SetSetting(
				"AutoFarm",
				true
			)

			State:SetRuntime(
				"Status",
				"Iniciando"
			)

			return true
		end

		State:SetSetting(
			"AutoFarm",
			false
		)

		StopTween()

		State:SetRuntime(
			"Status",
			"Parado"
		)

		State:SetRuntime(
			"Target",
			"Nenhum"
		)

		return true
	end

	function API:GetSea()
		return Quests.GetSea()
	end

	function API:GetLevel()
		return GetLevel()
	end

	function API:GetRequiredSea()
		return Quests.GetRequiredSea(
			GetLevel()
		)
	end

	--==================================================
	-- NOCLIP
	--==================================================

	RunService.Stepped:
		Connect(function()
			if
				Environment.DealBloxFarmToken
				~=
				Token
			then
				return
			end

			if
				not State.Settings.AutoFarm
			then
				return
			end

			local character =
				Player.Character

			if not character then
				return
			end

			for _, object in ipairs(
				character:GetDescendants()
			) do
				if
					object:IsA(
						"BasePart"
					)
				then
					object.CanCollide =
						false
				end
			end
		end)

	--==================================================
	-- LOOP
	--==================================================

	task.spawn(function()
		while
			Environment.DealBloxFarmToken
			==
			Token
		do
			if
				State.Settings.AutoFarm
			then
				local success, errorMessage =
					xpcall(
						Step,
						debug.traceback
					)

				if not success then
					Warn(
						"Erro no Auto Farm:"
					)

					Warn(
						errorMessage
					)

					State:SetRuntime(
						"Status",
						"Erro no Auto Farm"
					)

					task.wait(1)
				end
			else
				task.wait(0.15)
			end

			task.wait(0.05)
		end
	end)

	Log(
		"Farm Engine carregado."
	)

	return API
end

return Farm
