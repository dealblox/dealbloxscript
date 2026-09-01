--==================================================
-- DEAL BLOX
-- MODULES / FARM
--==================================================

local Farm = {}

function Farm.Create(
	State,
	Quests,
	Debug
)

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

		if not Data then
			return 0
		end

		local Level =
			Data:FindFirstChild(
				"Level"
			)

		if not Level then
			return 0
		end

		return tonumber(
			Level.Value
		)
		or
		0
	end

	--==================================================
	-- REMOTE
	--==================================================

	local function GetRemote()

		local Remotes =
			ReplicatedStorage:FindFirstChild(
				"Remotes"
			)

		if not Remotes then
			return nil
		end

		return Remotes:FindFirstChild(
			"CommF_"
		)
	end

	--==================================================
	-- AVISO
	--==================================================

	local function Warning(
		text
	)

		State:SetWarning(
			text,
			5
		)

		pcall(function()

			StarterGui:SetCore(
				"SendNotification",
				{
					Title =
						"DEAL BLOX",

					Text =
						text,

					Duration =
						5
				}
			)

		end)
	end

	--==================================================
	-- VALIDAR SEA
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

	local function MoveTo(
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

			root.CFrame =
				targetCFrame

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

		local time =
			math.clamp(
				distance / speed,
				0.10,
				15
			)

		CurrentTween =
			TweenService:Create(
				root,

				TweenInfo.new(
					time,
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
				time + 1
			then
				break
			end

			task.wait(0.05)
		end

		return true
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
			character:FindFirstChild(
				"HasBuso"
			)
		then
			return
		end

		local Remote =
			GetRemote()

		if Remote then

			pcall(function()

				Remote:InvokeServer(
					"Buso"
				)

			end)
		end
	end

	--==================================================
	-- ARMAMENTO
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

			["Estilo de luta"] =
				"Melee",

			["Espada"] =
				"Sword",

			["Arma"] =
				"Gun",

			["Fruta"] =
				"Blox Fruit"
		}

		local selected =
			State.Settings.AttackType

		local targetTooltip =
			WeaponMap[selected]

		if not targetTooltip then
			return nil
		end

		-- Já está equipado

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

		-- Mochila

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

					humanoid:EquipTool(
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

		local character =
			Player.Character

		if not character then
			return
		end

		local tool =
			character:FindFirstChildOfClass(
				"Tool"
			)

		if tool then

			pcall(function()

				tool:Activate()

			end)
		end

		pcall(function()

			VirtualUser:CaptureController()

			VirtualUser:Button1Down(
				Vector2.new(
					1280,
					672
				)
			)

			task.wait(0.02)

			VirtualUser:Button1Up(
				Vector2.new(
					1280,
					672
				)
			)

		end)
	end

	--==================================================
	-- QUEST CORRETA?
	--==================================================

	local function HasCorrectQuest(
		QuestData
	)

		local PlayerGui =
			Player:FindFirstChild(
				"PlayerGui"
			)

		if not PlayerGui then
			return false
		end

		local Main =
			PlayerGui:FindFirstChild(
				"Main"
			)

		if not Main then
			return false
		end

		local Quest =
			Main:FindFirstChild(
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

		if not success then
			return false
		end

		return string.find(
			string.lower(title),
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
	-- PEGAR QUEST
	--==================================================

	local function StartQuest(
		QuestData
	)

		if
			not State.Settings.AutoFarm
		then
			return
		end

		State:SetRuntime(
			"Status",
			"Pegando missão"
		)

		State:SetRuntime(
			"Quest",
			QuestData.Mob
		)

		MoveTo(
			QuestData.QuestPos
				*
			CFrame.new(
				0,
				4,
				0
			)
		)

		if
			not State.Settings.AutoFarm
		then
			return
		end

		task.wait(0.30)

		local Remote =
			GetRemote()

		if not Remote then

			State:SetRuntime(
				"Status",
				"Remote não encontrado"
			)

			return
		end

		pcall(function()

			Remote:InvokeServer(
				"StartQuest",
				QuestData.Quest,
				QuestData.QuestNum
			)

		end)

		task.wait(0.60)
	end

	--==================================================
	-- ENCONTRAR NPC
	--==================================================

	local function FindTarget(
		QuestData
	)

		local Enemies =
			workspace:FindFirstChild(
				"Enemies"
			)

		if not Enemies then
			return nil
		end

		local _, _, playerRoot =
			GetCharacter()

		local Closest =
			nil

		local ClosestDistance =
			math.huge

		for _, enemy in ipairs(
			Enemies:GetChildren()
		) do

			local humanoid =
				enemy:FindFirstChildOfClass(
					"Humanoid"
				)

			local root =
				enemy:FindFirstChild(
					"HumanoidRootPart"
				)

			local matches =
				string.find(
					string.lower(
						enemy.Name
					),
					string.lower(
						QuestData.Mob
					),
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
					ClosestDistance
				then

					Closest =
						enemy

					ClosestDistance =
						distance
				end
			end
		end

		return Closest
	end

	--==================================================
	-- LUTAR
	--==================================================

	local function Fight(
		Target,
		QuestData
	)

		local humanoid =
			Target:FindFirstChildOfClass(
				"Humanoid"
			)

		local enemyRoot =
			Target:FindFirstChild(
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
					State.Settings.FarmHeight
						or
						24,
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

	RunService.Stepped:Connect(
		function()

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

			for _, part in ipairs(
				character:GetDescendants()
			) do

				if
					part:IsA(
						"BasePart"
					)
				then

					part.CanCollide =
						false
				end
			end
		end
	)

	--==================================================
	-- LOOP
	--==================================================

	task.spawn(function()

		Debug.Log(
			"Motor de Auto Farm iniciado."
		)

		while
			Environment.DealBloxFarmToken
				==
			Token
		do

			if State.Settings.AutoFarm then

				local success, errorMessage =
					xpcall(
						Step,
						debug.traceback
					)

				if not success then

					Debug.Warn(
						"Erro no Auto Farm: "
						..
						tostring(
							errorMessage
						)
					)

					State:SetRuntime(
						"Status",
						"Erro - tentando novamente"
					)

					task.wait(1)
				end
			else

				task.wait(0.25)
			end

			task.wait(0.05)
		end
	end)

	return API
end

return Farm
