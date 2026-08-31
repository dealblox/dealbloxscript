--==================================================
-- DEAL BLOX
-- MODULES / FARM
-- Motor do Auto Farm
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

	--==================================================
	-- CONTROLE DE REEXECUÇÃO
	--==================================================

	local Environment =
		getgenv and getgenv() or _G

	Environment.DealBloxFarmToken =
		(Environment.DealBloxFarmToken or 0) + 1

	local MyToken =
		Environment.DealBloxFarmToken

	--==================================================
	-- HELPERS
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

	local function GetLevel()

		local data =
			Player:FindFirstChild("Data")

		if not data then
			return 0
		end

		local level =
			data:FindFirstChild("Level")

		if not level then
			return 0
		end

		return tonumber(level.Value) or 0
	end

	local function GetRemote()

		local remotes =
			ReplicatedStorage:FindFirstChild(
				"Remotes"
			)

		if not remotes then
			return nil
		end

		return remotes:FindFirstChild(
			"CommF_"
		)
	end

	--==================================================
	-- AVISO
	--==================================================

	local function ShowWarning(text)

		State:SetWarning(
			text,
			5
		)

		pcall(function()

			StarterGui:SetCore(
				"SendNotification",
				{
					Title = "DEAL BLOX",
					Text = text,
					Duration = 5
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

			ShowWarning(
				"Este mapa não foi reconhecido pelo Auto Farm."
			)

			return false
		end

		if currentSea ~= requiredSea then

			local message =
				"Seu level "
				.. tostring(level)
				.. " pertence ao Sea "
				.. tostring(requiredSea)
				.. ". Vá para o Sea correto para usar o Auto Farm."

			ShowWarning(message)

			State:SetRuntime(
				"Status",
				"Sea incorreto"
			)

			return false
		end

		return true
	end

	--==================================================
	-- MOVIMENTAÇÃO
	--==================================================

	local CurrentTween = nil

	local function StopTween()

		if CurrentTween then

			pcall(function()
				CurrentTween:Cancel()
			end)

		end

		CurrentTween = nil
	end

	local function MoveTo(targetCFrame)

		if not State.Settings.AutoFarm then
			return false
		end

		local character, humanoid, root =
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

		if distance <= 8 then

			root.CFrame =
				targetCFrame

			return true
		end

		StopTween()

		local speed =
			math.max(
				State.Settings.TweenSpeed,
				100
			)

		local duration =
			math.clamp(
				distance / speed,
				0.08,
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

		local start =
			tick()

		while
			State.Settings.AutoFarm
			and
			root.Parent
			and
			CurrentTween
			and
			CurrentTween.PlaybackState
				== Enum.PlaybackState.Playing
		do

			if tick() - start > duration + 1 then
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

		if not State.Settings.AutoBuso then
			return
		end

		local character =
			Player.Character

		if not character then
			return
		end

		if character:FindFirstChild(
			"HasBuso"
		) then
			return
		end

		local remote =
			GetRemote()

		if remote then

			pcall(function()
				remote:InvokeServer(
					"Buso"
				)
			end)

		end
	end

	--==================================================
	-- EQUIPAR CATEGORIA DE ATAQUE
	--==================================================

	local function EquipAttack()

		local character, humanoid =
			GetCharacter()

		if not character or not humanoid then
			return
		end

		local selected =
			State.Settings.AttackType

		local tooltip = nil

		if selected == "Estilo de luta" then
			tooltip = "Melee"

		elseif selected == "Fruta" then
			tooltip = "Blox Fruit"

		end

		if not tooltip then
			return
		end

		-- Já equipado

		for _, tool in ipairs(
			character:GetChildren()
		) do

			if
				tool:IsA("Tool")
				and
				tool.ToolTip == tooltip
			then
				return tool
			end
		end

		-- Procurar na mochila

		local backpack =
			Player:FindFirstChild(
				"Backpack"
			)

		if not backpack then
			return
		end

		for _, tool in ipairs(
			backpack:GetChildren()
		) do

			if
				tool:IsA("Tool")
				and
				tool.ToolTip == tooltip
			then

				humanoid:EquipTool(
					tool
				)

				return tool
			end
		end
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

			task.wait(0.025)

			VirtualUser:Button1Up(
				Vector2.new(
					1280,
					672
				)
			)

		end)
	end

	--==================================================
	-- QUEST ATUAL
	--==================================================

	local function HasCorrectQuest(
		questData
	)

		local playerGui =
			Player:FindFirstChild(
				"PlayerGui"
			)

		if not playerGui then
			return false
		end

		local main =
			playerGui:FindFirstChild(
				"Main"
			)

		if not main then
			return false
		end

		local quest =
			main:FindFirstChild(
				"Quest"
			)

		if
			not quest
			or
			not quest.Visible
		then
			return false
		end

		local success, title =
			pcall(function()

				return quest
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
				questData.Mob
			),
			1,
			true
		) ~= nil
	end

	--==================================================
	-- PEGAR QUEST
	--==================================================

	local function StartQuest(
		questData
	)

		if not State.Settings.AutoFarm then
			return false
		end

		State:SetRuntime(
			"Status",
			"Pegando missão"
		)

		State:SetRuntime(
			"Quest",
			questData.Mob
		)

		MoveTo(
			questData.QuestPos
				*
			CFrame.new(
				0,
				4,
				0
			)
		)

		if not State.Settings.AutoFarm then
			return false
		end

		task.wait(0.25)

		local remote =
			GetRemote()

		if not remote then

			State:SetRuntime(
				"Status",
				"Remote não encontrado"
			)

			return false
		end

		pcall(function()

			remote:InvokeServer(
				"StartQuest",
				questData.Quest,
				questData.QuestNum
			)

		end)

		task.wait(0.55)

		return true
	end

	--==================================================
	-- ENCONTRAR NPC
	--==================================================

	local function FindTarget(
		questData
	)

		local enemies =
			workspace:FindFirstChild(
				"Enemies"
			)

		if not enemies then
			return nil
		end

		local closest = nil
		local closestDistance = math.huge

		local _, _, root =
			GetCharacter()

		for _, enemy in ipairs(
			enemies:GetChildren()
		) do

			local humanoid =
				enemy:FindFirstChildOfClass(
					"Humanoid"
				)

			local enemyRoot =
				enemy:FindFirstChild(
					"HumanoidRootPart"
				)

			local nameMatches =
				string.find(
					string.lower(
						enemy.Name
					),
					string.lower(
						questData.Mob
					),
					1,
					true
				)

			if
				nameMatches
				and
				humanoid
				and
				enemyRoot
				and
				humanoid.Health > 0
			then

				local distance = 0

				if root then

					distance =
						(
							root.Position
							-
							enemyRoot.Position
						).Magnitude

				end

				if distance < closestDistance then

					closest = enemy
					closestDistance = distance

				end
			end
		end

		return closest
	end

	--==================================================
	-- LUTAR
	--==================================================

	local function FightTarget(
		target,
		questData
	)

		local humanoid =
			target:FindFirstChildOfClass(
				"Humanoid"
			)

		local targetRoot =
			target:FindFirstChild(
				"HumanoidRootPart"
			)

		if not humanoid or not targetRoot then
			return
		end

		State:SetRuntime(
			"Target",
			questData.Mob
		)

		State:SetRuntime(
			"Status",
			"Farmando"
		)

		ActivateBuso()
		EquipAttack()

		while
			State.Settings.AutoFarm
			and
			target.Parent
			and
			humanoid.Parent
			and
			humanoid.Health > 0
		do

			local character, playerHumanoid, root =
				GetCharacter()

			if not root then

				State:SetRuntime(
					"Status",
					"Aguardando respawn"
				)

				task.wait(1)

				continue
			end

			if not targetRoot.Parent then
				break
			end

			--==================================================
			-- FICAR ACIMA DO NPC
			--==================================================

			local height =
				State.Settings.FarmHeight

			local targetPosition =
				targetRoot.Position

			local above =
				targetPosition
				+
				Vector3.new(
					0,
					height,
					0
				)

			root.AssemblyLinearVelocity =
				Vector3.zero

			root.AssemblyAngularVelocity =
				Vector3.zero

			root.CFrame =
				CFrame.new(
					above,
					targetPosition
				)

			-- Evitar colisão local
			pcall(function()

				root.CanCollide =
					false

			end)

			ActivateBuso()
			EquipAttack()
			Attack()

			task.wait(
				State.Settings.AttackDelay
			)
		end

		State:SetRuntime(
			"Target",
			"Nenhum"
		)
	end

	--==================================================
	-- UM CICLO DO FARM
	--==================================================

	local function FarmStep()

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

		if sea ~= requiredSea then

			State:SetSetting(
				"AutoFarm",
				false
			)

			State:SetRuntime(
				"Status",
				"Sea incorreto"
			)

			ShowWarning(
				"Seu level "
				.. level
				.. " pertence ao Sea "
				.. requiredSea
				.. ". Vá para o Sea correto."
			)

			return
		end

		local questData =
			Quests.GetForLevel(
				level,
				sea
			)

		if not questData then

			State:SetRuntime(
				"Status",
				"Quest não encontrada"
			)

			task.wait(1)

			return
		end

		State:SetRuntime(
			"Quest",
			questData.Mob
		)

		-- Quest errada ou nenhuma quest

		if not HasCorrectQuest(
			questData
		) then

			StartQuest(
				questData
			)

			return
		end

		-- Procurar NPC

		local target =
			FindTarget(
				questData
			)

		if target then

			FightTarget(
				target,
				questData
			)

		else

			State:SetRuntime(
				"Status",
				"Procurando NPC"
			)

			State:SetRuntime(
				"Target",
				questData.Mob
			)

			MoveTo(
				questData.MobPos
					*
				CFrame.new(
					0,
					State.Settings.FarmHeight,
					0
				)
			)

			task.wait(0.8)
		end
	end

	--==================================================
	-- API
	--==================================================

	local API = {}

	function API:SetEnabled(enabled)

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

		else

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
	end

	function API:GetSea()
		return Quests.GetSea()
	end

	function API:GetRequiredSea()
		return Quests.GetRequiredSea(
			GetLevel()
		)
	end

	function API:GetLevel()
		return GetLevel()
	end

	--==================================================
	-- NOCLIP LOCAL
	--==================================================

	RunService.Stepped:Connect(function()

		if
			not State.Settings.AutoFarm
			or
			Environment.DealBloxFarmToken
				~= MyToken
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

			if object:IsA(
				"BasePart"
			) then

				object.CanCollide =
					false
			end
		end
	end)

	--==================================================
	-- LOOP PRINCIPAL
	--==================================================

	task.spawn(function()

		Debug.Log(
			"Motor Auto Farm iniciado."
		)

		while
			Environment.DealBloxFarmToken
				== MyToken
		do

			if State.Settings.AutoFarm then

				local success, errorMessage =
					xpcall(
						FarmStep,
						debug.traceback
					)

				if not success then

					Debug.Warn(
						"Auto Farm: "
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
