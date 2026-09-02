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

	-- Posição usada por hubs de Auto Farm para acionar
	-- diretamente a viagem da Tiki para a Submerged.
	-- O script cruza o oceano no alto e depois faz um
	-- SNAP instantâneo para este ponto, evitando tween
	-- vertical através da água.
	local TIKI_SUBMARINE_CFRAME =
		CFrame.new(
			-16269.7041,
			25.2288494,
			1373.65955,
			0.997390985,
			1.47309942e-09,
			-0.0721890926,
			-4.00651912e-09,
			0.99999994,
			-2.51183763e-09,
			0.0721890852,
			5.75363091e-10,
			0.997390926
		)

	local TIKI_APPROACH_HEIGHT =
		180

	-- Tempo máximo esperando o NPC carregar depois
	-- que chegamos na região da Tiki.
	local WORKER_SEARCH_TIME =
		10

	-- Distância que ficamos acima do Submarine Worker
	-- para interagir sem cair na água.
	local WORKER_SAFE_OFFSET =
		6

	-- Tempo máximo para confirmar a entrada na Submerged.
	local SUBMERGED_TRAVEL_TIMEOUT =
		10

	local SAFE_OCEAN_HEIGHT =
		450

	-- Distância horizontal mínima para considerar
	-- que o personagem está viajando entre ilhas.
	local LONG_TRAVEL_DISTANCE =
		1200

	-- Altura extra acima do ponto mais alto
	-- entre origem e destino.
	local LONG_TRAVEL_EXTRA_HEIGHT =
		120

	-- Velocidade usada apenas para subir/descer
	-- durante viagens longas.
	local LONG_TRAVEL_VERTICAL_SPEED =
		700

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
		targetCFrame,
		speedOverride
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
				speedOverride
				or
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

	--==================================================
	-- VIAGEM SEGURA ENTRE ILHAS
	--==================================================

	local function IsSubmergedPosition(
		position
	)
		return
			position.Y
			<
			-500
	end

	local function HorizontalDistance(
		a,
		b
	)
		return
			(
				Vector3.new(
					a.X,
					0,
					a.Z
				)
				-
				Vector3.new(
					b.X,
					0,
					b.Z
				)
			).Magnitude
	end

	local function SafeLongTravel(
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

		local origin =
			root.Position

		local target =
			targetCFrame.Position

		-- Dentro da Submerged não usamos o modo de
		-- viagem alta. Subir demais lá pode fazer o
		-- jogo devolver o jogador para Tiki.
		if
			IsSubmergedPosition(
				origin
			)
			or
			IsSubmergedPosition(
				target
			)
		then
			return TweenTo(
				targetCFrame
			)
		end

		local horizontal =
			HorizontalDistance(
				origin,
				target
			)

		-- Se for perto, continua com o movimento normal.
		if
			horizontal
			<
			LONG_TRAVEL_DISTANCE
		then
			return TweenTo(
				targetCFrame
			)
		end

		-- Para trajetos entre ilhas:
		-- 1. sobe;
		-- 2. cruza o oceano no alto;
		-- 3. desce somente em cima do destino.

		local safeY =
			math.max(
				SAFE_OCEAN_HEIGHT,
				origin.Y
					+
					LONG_TRAVEL_EXTRA_HEIGHT,
				target.Y
					+
					LONG_TRAVEL_EXTRA_HEIGHT
			)

		State:SetRuntime(
			"Status",
			"Subindo para viagem"
		)

		local lift =
			CFrame.new(
				origin.X,
				safeY,
				origin.Z
			)

		if
			math.abs(
				root.Position.Y
					-
					safeY
			)
			>
			15
		then
			if
				not TweenTo(
					lift,
					LONG_TRAVEL_VERTICAL_SPEED
				)
			then
				return false
			end
		end

		if
			not State.Settings.AutoFarm
		then
			return false
		end

		State:SetRuntime(
			"Status",
			"Viajando entre ilhas"
		)

		local across =
			CFrame.new(
				target.X,
				safeY,
				target.Z
			)

		if
			not TweenTo(
				across
			)
		then
			return false
		end

		if
			not State.Settings.AutoFarm
		then
			return false
		end

		State:SetRuntime(
			"Status",
			"Descendo no destino"
		)

		if
			not TweenTo(
				targetCFrame,
				LONG_TRAVEL_VERTICAL_SPEED
			)
		then
			return false
		end

		return true
	end

	local function MoveTo(
		targetCFrame
	)
		return SafeLongTravel(
			targetCFrame
		)
	end

	--==================================================
	-- SUBMARINE WORKER
	--==================================================

	local function NormalizeName(
		text
	)
		text =
			string.lower(
				tostring(
					text
					or
					""
				)
			)

		text =
			string.gsub(
				text,
				"[%s%p_]+",
				""
			)

		return text
	end

	local function FindTikiLocation()
		local origin =
			workspace:
			FindFirstChild(
				"_WorldOrigin"
			)

		local locations =
			origin
			and
			origin:
			FindFirstChild(
				"Locations"
			)

		if not locations then
			return nil
		end

		for _, location in ipairs(
			locations:GetChildren()
		) do
			local name =
				NormalizeName(
					location.Name
				)

			if
				string.find(
					name,
					"tiki",
					1,
					true
				)
			then
				return location
			end
		end

		return nil
	end

	local function FindSubmarineWorkerOnce()
		for _, object in ipairs(
			workspace:GetDescendants()
		) do
			if
				object:IsA(
					"Model"
				)
			then
				local name =
					NormalizeName(
						object.Name
					)

				if
					string.find(
						name,
						"submarine",
						1,
						true
					)
					and
					string.find(
						name,
						"worker",
						1,
						true
					)
				then
					local part =
						object:
						FindFirstChild(
							"HumanoidRootPart"
						)
						or
						object:
						FindFirstChild(
							"Head"
						)
						or
						object:
						FindFirstChildWhichIsA(
							"BasePart",
							true
						)

					if part then
						return object, part
					end
				end
			end
		end

		return nil, nil
	end

	local function WaitForSubmarineWorker()
		local started =
			tick()

		while
			State.Settings.AutoFarm
			and
			tick() - started
				<
				WORKER_SEARCH_TIME
		do
			local worker,
				part =
				FindSubmarineWorkerOnce()

			if
				worker
				and
				part
			then
				return worker, part
			end

			task.wait(
				0.25
			)
		end

		return nil, nil
	end


	local function GetObjectCFrame(
		object
	)
		if not object then
			return nil
		end

		if object:IsA(
			"BasePart"
		) then
			return object.CFrame
		end

		if object:IsA(
			"Attachment"
		) then
			return object.WorldCFrame
		end

		if object:IsA(
			"Model"
		) then
			local success,
				result =
				pcall(function()
					return object:GetPivot()
				end)

			if success then
				return result
			end
		end

		local part =
			object:
			FindFirstChildWhichIsA(
				"BasePart",
				true
			)

		return
			part
			and
			part.CFrame
			or
			nil
	end

	local function FindSubmarinePrompt(
		worker,
		workerPart
	)
		-- Primeiro procura um prompt dentro do próprio NPC.
		if worker then
			for _, object in ipairs(
				worker:GetDescendants()
			) do
				if object:IsA(
					"ProximityPrompt"
				) then
					return object
				end
			end
		end

		-- Alguns NPCs deixam o prompt em uma peça/attachment
		-- próximo ao modelo, então fazemos uma busca curta.
		if not workerPart then
			return nil
		end

		local bestPrompt =
			nil

		local bestDistance =
			math.huge

		for _, object in ipairs(
			workspace:GetDescendants()
		) do
			if object:IsA(
				"ProximityPrompt"
			) then
				local parent =
					object.Parent

				local position =
					nil

				if parent then
					if parent:IsA(
						"Attachment"
					) then
						position =
							parent.WorldPosition
					elseif parent:IsA(
						"BasePart"
					) then
						position =
							parent.Position
					end
				end

				if position then
					local distance =
						(
							position
							-
							workerPart.Position
						).Magnitude

					if
						distance < 30
						and
						distance < bestDistance
					then
						bestPrompt =
							object

						bestDistance =
							distance
					end
				end
			end
		end

		return bestPrompt
	end

	local function TriggerSubmarinePrompt(
		prompt
	)
		if not prompt then
			return false
		end

		State:SetRuntime(
			"Status",
			"Conversando com Submarine Worker"
		)

		-- Executores como Delta/Xeno normalmente expõem
		-- fireproximityprompt. Se não existir, tentamos
		-- os métodos normais do ProximityPrompt.
		local fired =
			false

		if
			type(
				fireproximityprompt
			)
			==
			"function"
		then
			local success =
				pcall(function()
					fireproximityprompt(
						prompt
					)
				end)

			if success then
				fired =
					true
			end
		end

		if not fired then
			local success =
				pcall(function()
					prompt:
						InputHoldBegin()

					task.wait(
						math.clamp(
							tonumber(
								prompt.HoldDuration
							)
							or
							0,
							0,
							1.5
						)
						+
						0.12
					)

					prompt:
						InputHoldEnd()
				end)

			if success then
				fired =
					true
			end
		end

		return fired
	end

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
			"Indo para Sub Port 01"
		)

		-- Primeiro cruza o oceano no alto.
		local target =
			TIKI_SUBMARINE_CFRAME.Position

		local highY =
			math.max(
				SAFE_OCEAN_HEIGHT,
				root.Position.Y
					+
					LONG_TRAVEL_EXTRA_HEIGHT
			)

		local highTarget =
			CFrame.new(
				target.X,
				highY,
				target.Z
			)

		if
			not SafeLongTravel(
				highTarget
			)
		then
			return false
		end

		if
			not State.Settings.AutoFarm
		then
			return false
		end

		StopTween()

		-- IMPORTANTE:
		-- Não descemos por Tween. O Sub Port fica abaixo
		-- da parte alta da Tiki e o Tween estava fazendo
		-- o personagem tocar a água / zona de retorno.
		State:SetRuntime(
			"Status",
			"Entrando no Sub Port"
		)

		local _, humanoid,
			finalRoot =
				GetCharacter()

		if
			not humanoid
			or
			not finalRoot
		then
			return false
		end

		pcall(function()
			finalRoot.AssemblyLinearVelocity =
				Vector3.zero

			finalRoot.AssemblyAngularVelocity =
				Vector3.zero

			finalRoot.CFrame =
				TIKI_SUBMARINE_CFRAME
		end)

		-- O fluxo usado por Auto Farms atuais espera
		-- o local carregar antes de chamar a Remote.
		task.wait(
			2
		)

		local _, checkHumanoid,
			checkRoot =
				GetCharacter()

		if
			not checkHumanoid
			or
			not checkRoot
		then
			State:SetRuntime(
				"Status",
				"Morreu no Sub Port"
			)

			return false
		end

		local distance =
			(
				checkRoot.Position
				-
				TIKI_SUBMARINE_CFRAME.Position
			).Magnitude

		Log(
			"Distância do Sub Port: "
			..
			string.format(
				"%.1f",
				distance
			)
			..
			" studs"
		)

		return
			distance
			<=
			80
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
			"Preparando Submerged"
		)

		if
			not MoveToTikiSubmarine()
		then
			State:SetSetting(
				"AutoFarm",
				false
			)

			Warning(
				"Não consegui chegar com segurança ao Sub Port 01."
			)

			return false
		end

		if
			not State.Settings.AutoFarm
		then
			return false
		end

		local Remote =
			GetSubmarineRemote()

		if not Remote then
			State:SetRuntime(
				"Status",
				"Remote do submarino não encontrada"
			)

			State:SetSetting(
				"AutoFarm",
				false
			)

			Warning(
				"A Remote do Submarine Worker não foi encontrada."
			)

			return false
		end

		State:SetRuntime(
			"Status",
			"Acionando submarino"
		)

		local success, result =
			pcall(function()
				return Remote:
					InvokeServer(
						"TravelToSubmergedIsland"
					)
			end)

		if not success then
			Warn(
				"Erro do submarino: "
				..
				tostring(result)
			)

			State:SetRuntime(
				"Status",
				"Falha ao acionar submarino"
			)

			State:SetSetting(
				"AutoFarm",
				false
			)

			Warning(
				"O submarino não respondeu. Auto Farm desligado."
			)

			return false
		end

		if result ~= nil then
			Log(
				"Resposta do submarino: "
				..
				tostring(result)
			)
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
			tick() - started
				<
				10
		do
			if IsInsideSubmerged(
				QuestData
			) then
				State:SetRuntime(
					"Status",
					"Submerged detectada"
				)

				Log(
					"✅ Submerged Island detectada."
				)

				return true
			end

			local _, aliveHumanoid =
				GetCharacter()

			if not aliveHumanoid then
				State:SetRuntime(
					"Status",
					"Morreu tentando entrar"
				)

				State:SetSetting(
					"AutoFarm",
					false
				)

				return false
			end

			task.wait(
				0.20
			)
		end

		-- Sem loop infinito: uma tentativa por ativação.
		State:SetRuntime(
			"Status",
			"Submerged não detectada"
		)

		State:SetSetting(
			"AutoFarm",
			false
		)

		Warning(
			"O submarino foi acionado, mas a Submerged não foi detectada. Auto Farm desligado."
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
	-- COMBAT FRAMEWORK
	--==================================================

	local CombatFrameworkCache =
		nil

	local RigLibCache =
		nil

	local function GetCombatFramework()
		if CombatFrameworkCache then
			return CombatFrameworkCache
		end

		local PlayerScripts =
			Player:
			FindFirstChild(
				"PlayerScripts"
			)

		local Module =
			PlayerScripts
			and
			PlayerScripts:
				FindFirstChild(
					"CombatFramework"
				)

		if not Module then
			return nil
		end

		-- Forma 1: módulo já retorna uma tabela
		-- com activeController.
		local success, result =
			pcall(function()
				return require(
					Module
				)
			end)

		if
			success
			and
			type(result)
				==
				"table"
			and
			result.activeController
		then
			CombatFrameworkCache =
				result

			return
				CombatFrameworkCache
		end

		-- Forma 2: versões do Blox Fruits onde
		-- activeController está em um upvalue.
		if
			success
			and
			type(debug)
				==
				"table"
			and
			type(
				debug.getupvalues
			)
				==
				"function"
		then
			local upSuccess,
				upvalues =
					pcall(function()
						return debug.getupvalues(
							require(
								Module
							)
						)
					end)

			if
				upSuccess
				and
				type(upvalues)
					==
					"table"
			then
				for _, value in pairs(
					upvalues
				) do
					if
						type(value)
							==
							"table"
						and
						value.activeController
					then
						CombatFrameworkCache =
							value

						return
							CombatFrameworkCache
					end
				end
			end
		end

		return nil
	end

	local function GetRigLib()
		if RigLibCache then
			return RigLibCache
		end

		local CombatFolder =
			ReplicatedStorage:
			FindFirstChild(
				"CombatFramework"
			)

		local RigModule =
			CombatFolder
			and
			CombatFolder:
				FindFirstChild(
					"RigLib"
				)

		if not RigModule then
			return nil
		end

		local success, result =
			pcall(function()
				return require(
					RigModule
				)
			end)

		if success then
			RigLibCache =
				result
		end

		return
			RigLibCache
	end

	local function PrepareCombatController()
		local framework =
			GetCombatFramework()

		local controller =
			framework
			and
			framework.activeController

		if not controller then
			return nil
		end

		pcall(function()
			controller.increment =
				3

			controller.timeToNextAttack =
				0

			controller.timeToNextBlock =
				0

			controller.focusStart =
				0

			controller.attacking =
				false

			controller.blocking =
				false

			controller.hitboxMagnitude =
				60

			if controller.humanoid then
				controller.humanoid.AutoRotate =
					true
			end
		end)

		return controller
	end

	local function GetBladeName(
		controller
	)
		if
			not controller
			or
			type(controller.blades)
				~=
				"table"
		then
			return nil
		end

		local blade =
			controller.blades[1]

		if not blade then
			return nil
		end

		pcall(function()
			while
				blade
				and
				blade.Parent
				and
				blade.Parent
					~=
					Player.Character
			do
				blade =
					blade.Parent
			end
		end)

		return
			blade
			and
			tostring(blade)
			or
			nil
	end

	local function CombatFrameworkHit(
		Target
	)
		local character, _,
			playerRoot =
				GetCharacter()

		if
			not character
			or
			not playerRoot
			or
			not Target
		then
			return false
		end

		local controller =
			PrepareCombatController()

		local attacked =
			false

		-- Faz o controller executar o ataque normal.
		if
			controller
			and
			type(controller.attack)
				==
				"function"
		then
			local success =
				pcall(function()
					controller:
						attack()
				end)

			if success then
				attacked =
					true
			end
		end

		-- Registro de hit usado pelo CombatFramework
		-- atual. Se alguma parte não existir, cai
		-- silenciosamente para os outros métodos.
		local RigLib =
			GetRigLib()

		local RigControllerEvent =
			ReplicatedStorage:
			FindFirstChild(
				"RigControllerEvent"
			)

		if
			controller
			and
			RigLib
			and
			RigControllerEvent
			and
			type(
				RigLib.getBladeHits
			)
				==
				"function"
		then
			pcall(function()
				local rawHits =
					RigLib.getBladeHits(
						character,
						{
							playerRoot
						},
						60
					)

				local hits =
					{}

				local seen =
					{}

				for _, hit in pairs(
					rawHits
					or
					{}
				) do
					local model =
						hit
						and
						hit.Parent

					local root =
						model
						and
						model:
							FindFirstChild(
								"HumanoidRootPart"
							)

					local humanoid =
						model
						and
						model:
							FindFirstChildOfClass(
								"Humanoid"
							)

					if
						root
						and
						humanoid
						and
						humanoid.Health > 0
						and
						not seen[model]
					then
						seen[model] =
							true

						table.insert(
							hits,
							root
						)
					end
				end

				if #hits > 0 then
					local bladeName =
						GetBladeName(
							controller
						)

					if bladeName then
						RigControllerEvent:
							FireServer(
								"weaponChange",
								bladeName
							)
					end

					RigControllerEvent:
						FireServer(
							"hit",
							hits,
							1,
							""
						)

					attacked =
						true
				end
			end)
		end

		return attacked
	end

	--==================================================
	-- AUTO CLICK
	--==================================================

	local function Attack(
		Target
	)
		local character, humanoid,
			playerRoot =
				GetCharacter()

		if
			not character
			or
			not humanoid
			or
			not playerRoot
		then
			return false
		end

		local tool =
			EquipAttack()

		if not tool then
			State:SetRuntime(
				"Status",
				"Armamento não encontrado"
			)

			return false
		end

		-- Dá um instante para a Tool sair da Backpack
		-- e entrar no Character.
		task.wait(
			0.03
		)

		local equippedTool =
			nil

		for _, object in ipairs(
			character:GetChildren()
		) do
			if object:IsA(
				"Tool"
			) then
				equippedTool =
					object

				break
			end
		end

		equippedTool =
			equippedTool
			or
			tool

		local attacked =
			CombatFrameworkHit(
				Target
			)

		-- Ativação normal da Tool para manter a animação
		-- quando o executor/jogo permitir.
		pcall(function()
			equippedTool:
				Activate()
		end)

		-- Auto-click compatível com o padrão usado por
		-- hubs de Blox Fruits.
		pcall(function()
			VirtualUser:
				CaptureController()

			VirtualUser:
				Button1Down(
					Vector2.new(
						math.huge,
						math.huge
					)
				)
		end)

		task.wait(
			0.015
		)

		pcall(function()
			VirtualUser:
				Button1Up(
					Vector2.new(
						math.huge,
						math.huge
					)
				)
		end)

		return attacked
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
			"Farmando / atacando"
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

			local configuredHeight =
				tonumber(
					State.Settings.FarmHeight
				)
				or
				8

			local attackType =
				State.Settings.AttackType
				or
				"Estilo de luta"

			local height =
				configuredHeight

			-- O antigo padrão de 24 studs deixava o
			-- personagem fora do alcance do M1.
			if
				attackType
					==
					"Estilo de luta"
				or
				attackType
					==
					"Espada"
			then
				height =
					math.clamp(
						configuredHeight,
						5,
						8
					)
			else
				height =
					math.clamp(
						configuredHeight,
						5,
						12
					)
			end

			-- Na Submerged continuamos baixos para
			-- evitar sair da área e manter alcance.
			if QuestData.RequiresSubmerged then
				height =
					math.clamp(
						height,
						5,
						9
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
			Attack(
				Target
			)

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
							8
							or
							math.clamp(
								tonumber(
									State.Settings.FarmHeight
								)
								or
								8,
								5,
								12
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
