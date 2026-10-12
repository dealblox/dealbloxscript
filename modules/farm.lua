-- DEAL BLOX | modules/farm.lua | V3 Submerged + localizacao de NPCs
-- Baseado no arquivo enviado pelo autor em 12/10/2026.
-- Mantem API Farm.Create(State, Quests, Debug), combate e interface.
-- IMPORTANTE: A chamada remota do jogo nao foi validada em tempo real.
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

	local VirtualInputManager =
		game:GetService("VirtualInputManager")

	local UserInputService =
		game:GetService("UserInputService")

	local GuiService =
		game:GetService("GuiService")

	local CoreGui =
		game:GetService("CoreGui")

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

	local function TweenTo(targetCFrame, speedOverride)
		if not State.Settings.AutoFarm then
			return false
		end
		if typeof(targetCFrame) ~= "CFrame" then
			Warn("TweenTo: destino inválido")
			return false
		end

		local character, humanoid, root = GetCharacter()
		if not root then
			return false
		end

		local distance = (root.Position - targetCFrame.Position).Magnitude
		if distance <= 10 then
			return true
		end

		StopTween()
		local speed = math.max(
			tonumber(speedOverride) or tonumber(State.Settings.TweenSpeed) or 350,
			100
		)
		-- Não comprime viagens longas em apenas 15 segundos.
		local duration = math.max(distance / speed, 0.10)
		if duration > 180 then
			Warn("Destino longe demais para uma viagem segura")
			return false
		end

		local ok, tween = pcall(function()
			return TweenService:Create(
				root,
				TweenInfo.new(duration, Enum.EasingStyle.Linear),
				{ CFrame = targetCFrame }
			)
		end)
		if not ok or not tween then
			Warn("Não consegui criar movimento: " .. tostring(tween))
			return false
		end

		CurrentTween = tween
		tween:Play()
		local started = tick()
		local reached = false

		while State.Settings.AutoFarm
			and Environment.DealBloxFarmToken == Token do
			if Player.Character ~= character
				or not root.Parent
				or humanoid.Health <= 0 then
				break
			end

			local remaining = (root.Position - targetCFrame.Position).Magnitude
			if remaining <= 12 then
				reached = true
				break
			end
			if tween.PlaybackState ~= Enum.PlaybackState.Playing then
				break
			end
			if tick() - started > duration + 2 then
				break
			end
			task.wait(0.05)
		end

		-- Nunca retornar sucesso apenas porque o tween terminou.
		if root.Parent and humanoid.Health > 0
			and Player.Character == character then
			reached = reached or
				(root.Position - targetCFrame.Position).Magnitude <= 12
		end
		if CurrentTween == tween then
			StopTween()
		end

		if not reached then
			Warn("Movimento interrompido antes do destino")
		end
		return reached
			and State.Settings.AutoFarm
			and Environment.DealBloxFarmToken == Token
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
		local originSubmerged = IsSubmergedPosition(origin)
		local targetSubmerged = IsSubmergedPosition(target)
		if originSubmerged ~= targetSubmerged then
			State:SetRuntime("Status", "Mudança de área bloqueada")
			Warn("Não é permitido cruzar diretamente entre superfície e Submerged")
			return false
		end
		if originSubmerged then
			return TweenTo(targetCFrame)
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
		local bestWorker, bestPart = nil, nil
		local bestDistance = math.huge
		-- Existem Workers em áreas diferentes; restringimos à Tiki.
		for _, object in ipairs(workspace:GetDescendants()) do
			if object:IsA("Model") then
				local name = NormalizeName(object.Name)
				if string.find(name, "submarine", 1, true)
					and string.find(name, "worker", 1, true) then
					local part = object:FindFirstChild("HumanoidRootPart")
						or object:FindFirstChild("Head")
						or object:FindFirstChildWhichIsA("BasePart", true)
					if part then
						local distance =
							(part.Position - TIKI_SUBMARINE_CFRAME.Position).Magnitude
						if distance <= 600 and distance < bestDistance then
							bestWorker, bestPart = object, part
							bestDistance = distance
						end
					end
				end
			end
		end
		return bestWorker, bestPart
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
		if not State.Settings.AutoFarm then
			return false
		end
		local _, _, root = GetCharacter()
		if not root then
			return false
		end

		State:SetRuntime("Status", "Localizando Sub Port 01")
		local worker, workerPart = FindSubmarineWorkerOnce()
		local port = TIKI_SUBMARINE_CFRAME.Position

		-- Já está perto do Worker? Não viaja de volta para o céu.
		local nearWorker = workerPart
			and (root.Position - workerPart.Position).Magnitude <= 100

		if not nearWorker then
			State:SetRuntime("Status", "Aproximando da Tiki")
			local approach = CFrame.new(port.X, port.Y + 180, port.Z)
			if not SafeLongTravel(approach) then
				Warn("Falha na aproximação da Tiki")
				return false
			end
		end

		if not State.Settings.AutoFarm then
			return false
		end
		State:SetRuntime("Status", "Procurando Submarine Worker")
		worker, workerPart = WaitForSubmarineWorker()

		if not workerPart then
			-- Segundo ponto de streaming: aproxima sem mergulhar na água.
			local retry = CFrame.new(port.X, port.Y + 70, port.Z)
			if not TweenTo(retry, 200) then
				return false
			end
			worker, workerPart = WaitForSubmarineWorker()
		end

		if not worker or not workerPart or not workerPart.Parent then
			State:SetRuntime("Status", "Worker da Tiki não encontrado")
			Warn("Submarine Worker não carregou; viagem cancelada")
			return false
		end

		State:SetRuntime("Status", "Aproximando do Submarine Worker")
		local destination = CFrame.new(
			workerPart.Position + Vector3.new(0, WORKER_SAFE_OFFSET, 0)
		)
		if not TweenTo(destination, 200) then
			return false
		end

		task.wait(0.6)
		local _, humanoid, finalRoot = GetCharacter()
		if not humanoid or not finalRoot or not workerPart.Parent then
			return false
		end
		local distance = (finalRoot.Position - workerPart.Position).Magnitude
		Log("Distância do Submarine Worker: " .. string.format("%.1f", distance))
		if distance > 24 then
			State:SetRuntime("Status", "Distância inválida do submarino")
			return false
		end
		if humanoid:GetState() == Enum.HumanoidStateType.Swimming then
			State:SetRuntime("Status", "Entrou na água próximo ao submarino")
			Warn("Cancelado: personagem entrou na água antes do embarque")
			return false
		end

		State:SetRuntime("Status", "Pronto para acionar submarino")
		return State.Settings.AutoFarm
	end

	--==================================================
	-- SUBMERGED ISLAND
	--==================================================

	local function IsInsideSubmerged(QuestData)
		if not QuestData or not QuestData.RequiresSubmerged
			or typeof(QuestData.QuestPos) ~= "CFrame" then
			return false
		end
		local _, _, root = GetCharacter()
		if not root then
			return false
		end

		-- Distância de 10 mil studs não comprovava a entrada na ilha.
		-- A posição precisa estar na região baixa E próxima da missão.
		local position = root.Position
		local quest = QuestData.QuestPos.Position
		if position.Y >= -500 or quest.Y >= -500 then
			return false
		end
		return (position - quest).Magnitude <= 4000
	end

	local function TravelToSubmerged(QuestData)
		if IsInsideSubmerged(QuestData) then
			return true
		end

		local function Abort(status, message)
			StopTween()
			State:SetRuntime("Status", status)
			State:SetSetting("AutoFarm", false)
			Warn("[Submerged] " .. message)
			Warning(message)
			return false
		end

		State:SetRuntime("Status", "Preparando Submerged")
		if not MoveToTikiSubmarine() then
			if not State.Settings.AutoFarm then
				return false
			end
			return Abort("Falha ao chegar no Worker",
				"Não foi possível chegar ao Submarine Worker da Tiki.")
		end

		if not State.Settings.AutoFarm then
			return false
		end

		local remote = GetSubmarineRemote()
		if not remote or not remote:IsA("RemoteFunction") then
			return Abort("Remote do submarino ausente",
				"RF/SubmarineWorkerSpeak não foi encontrada.")
		end

		State:SetRuntime("Status", "Acionando submarino")
		-- Não bloqueamos o loop caso InvokeServer fique sem resposta.
		local finished, ok, reply = false, false, nil
		task.spawn(function()
			ok, reply = pcall(function()
				return remote:InvokeServer("TravelToSubmergedIsland")
			end)
			finished = true
		end)

		local started = tick()
		local entered = false
		State:SetRuntime("Status", "Aguardando Submerged")
		while State.Settings.AutoFarm
			and Environment.DealBloxFarmToken == Token
			and tick() - started < 20 do
			local _, humanoid, root = GetCharacter()
			if not humanoid or not root then
				return Abort("Morreu durante a viagem",
					"O personagem morreu antes de entrar na Submerged.")
			end
			if IsInsideSubmerged(QuestData) then
				entered = true
				break
			end
			if finished and not ok then
				return Abort("Erro do submarino", tostring(reply))
			end
			if finished and reply == false then
				return Abort("Viagem recusada", "O servidor recusou a viagem.")
			end
			task.wait(0.2)
		end

		if not State.Settings.AutoFarm
			or Environment.DealBloxFarmToken ~= Token then
			return false
		end
		if not entered then
			return Abort("Submerged não detectada",
				"A viagem foi acionada, mas a chegada não foi confirmada.")
		end

		State:SetRuntime("Status", "Validando posição na Submerged")
		task.wait(0.8)
		if not IsInsideSubmerged(QuestData) then
			return Abort("Entrada instável",
				"O personagem saiu da região Submerged após a viagem.")
		end
		State:SetRuntime("Status", "Submerged detectada")
		Log("Submerged confirmada. Quest: " .. tostring(QuestData.Mob))
		return true
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
	-- FAST ATTACK / NET
	--==================================================

	local RegisterAttackCache =
		nil

	local RegisterHitCache =
		nil

	local function GetFastAttackRemotes()
		if
			RegisterAttackCache
			and
			RegisterHitCache
			and
			RegisterAttackCache.Parent
			and
			RegisterHitCache.Parent
		then
			return
				RegisterAttackCache,
				RegisterHitCache
		end

		local Modules =
			ReplicatedStorage:
			FindFirstChild(
				"Modules"
			)

		local Net =
			Modules
			and
			Modules:
				FindFirstChild(
					"Net"
				)

		if not Net then
			return nil, nil
		end

		RegisterAttackCache =
			Net:
				FindFirstChild(
					"RE/RegisterAttack"
				)

		RegisterHitCache =
			Net:
				FindFirstChild(
					"RE/RegisterHit"
				)

		return
			RegisterAttackCache,
			RegisterHitCache
	end

	local function GetEnemyHitPart(
		Target
	)
		if not Target then
			return nil
		end

		return
			Target:
				FindFirstChild(
					"Head"
				)
			or
			Target:
				FindFirstChild(
					"HumanoidRootPart"
				)
			or
			Target:
				FindFirstChildWhichIsA(
					"BasePart"
				)
	end

	local function NetAttack(
		Target
	)
		if
			not Target
			or
			not Target.Parent
		then
			return false
		end

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

		local hitPart =
			GetEnemyHitPart(
				Target
			)

		if
			not humanoid
			or
			humanoid.Health <= 0
			or
			not enemyRoot
			or
			not hitPart
		then
			return false
		end

		local character, _,
			playerRoot =
				GetCharacter()

		if
			not character
			or
			not playerRoot
		then
			return false
		end

		local equippedTool =
			character:
				FindFirstChildOfClass(
					"Tool"
				)

		if not equippedTool then
			return false
		end

		-- Algumas armas/frutas possuem a própria
		-- LeftClickRemote. Quando existir usamos ela.
		local leftClick =
			equippedTool:
				FindFirstChild(
					"LeftClickRemote"
				)

		if
			leftClick
			and
			leftClick:IsA(
				"RemoteEvent"
			)
		then
			local direction =
				enemyRoot.Position
				-
				playerRoot.Position

			if direction.Magnitude > 0 then
				direction =
					direction.Unit
			else
				direction =
					Vector3.new(
						0,
						0,
						-1
					)
			end

			local success =
				pcall(function()
					leftClick:
						FireServer(
							direction,
							1
						)
				end)

			return success
		end

		local RegisterAttack,
			RegisterHit =
				GetFastAttackRemotes()

		if
			not RegisterAttack
			or
			not RegisterHit
		then
			return false
		end

		local hitList = {
			{
				Target,
				hitPart
			}
		}

		local success =
			pcall(function()

				RegisterAttack:
					FireServer(
						State.Settings.AttackDelay
							or
							0
					)

				RegisterHit:
					FireServer(
						hitPart,
						hitList
					)
			end)

		return success
	end

	--==================================================
	-- PROTEÇÃO DA INTERFACE
	--==================================================

	local function GetDealBloxGui()
		local gui =
			CoreGui:
				FindFirstChild(
					"DealBlox"
				)

		if gui then
			return gui
		end

		local PlayerGui =
			Player:
				FindFirstChild(
					"PlayerGui"
				)

		return
			PlayerGui
			and
			PlayerGui:
				FindFirstChild(
					"DealBlox"
				)
			or
			nil
	end

	local function IsPointInsideGui(
		point,
		guiObject
	)
		if
			not guiObject
			or
			not guiObject:IsA(
				"GuiObject"
			)
			or
			not guiObject.Visible
		then
			return false
		end

		local position =
			guiObject.AbsolutePosition

		local size =
			guiObject.AbsoluteSize

		return
			point.X
				>=
				position.X
			and
			point.X
				<=
				position.X
					+
					size.X
			and
			point.Y
				>=
				position.Y
			and
			point.Y
				<=
				position.Y
					+
					size.Y
	end

	local function GetSafeClickPosition()
		local camera =
			workspace.CurrentCamera

		local viewport =
			camera
			and
			camera.ViewportSize
			or
			Vector2.new(
				1280,
				720
			)

		local gui =
			GetDealBloxGui()

		local main =
			gui
			and
			gui:
				FindFirstChild(
					"Main"
				)

		local openButton =
			gui
			and
			gui:
				FindFirstChild(
					"OpenButton"
				)

		-- Pontos candidatos nas bordas da tela.
		-- Evitamos o centro porque o painel DEAL BLOX
		-- ocupa justamente essa região.
		local candidates = {
			Vector2.new(
				math.max(
					viewport.X - 8,
					1
				),
				math.floor(
					viewport.Y * 0.50
				)
			),

			Vector2.new(
				math.max(
					viewport.X - 8,
					1
				),
				math.floor(
					viewport.Y * 0.68
				)
			),

			Vector2.new(
				math.max(
					viewport.X - 8,
					1
				),
				math.floor(
					viewport.Y * 0.32
				)
			),

			Vector2.new(
				8,
				math.floor(
					viewport.Y * 0.75
				)
			)
		}

		for _, point in ipairs(
			candidates
		) do
			if
				not IsPointInsideGui(
					point,
					main
				)
				and
				not IsPointInsideGui(
					point,
					openButton
				)
			then
				return point
			end
		end

		-- Fallback extremo na lateral direita.
		return
			Vector2.new(
				math.max(
					viewport.X - 2,
					1
				),
				math.floor(
					viewport.Y / 2
				)
			)
	end

	--==================================================
	-- INPUT / AUTO CLICK
	--==================================================

	local function GetExecutorFunction(
		name
	)
		local environments = {}

		pcall(function()
			table.insert(
				environments,
				getgenv()
			)
		end)

		pcall(function()
			table.insert(
				environments,
				getrenv()
			)
		end)

		table.insert(
			environments,
			_G
		)

		for _, env in ipairs(
			environments
		) do
			if
				type(env)
					==
					"table"
				and
				type(
					rawget(
						env,
						name
					)
				)
					==
					"function"
			then
				return
					rawget(
						env,
						name
					)
			end
		end

		return nil
	end

	local function ClickWithExecutor()
		-- DESATIVADO no V10.
		--
		-- mouse1click/mouse1press usam a posição REAL
		-- do cursor e por isso clicavam no painel.
		-- Mantemos esta função apenas para compatibilidade.
		return false
	end

	local function ClickWithVirtualInput()
		local point =
			GetSafeClickPosition()

		local success =
			pcall(function()
				VirtualInputManager:
					SendMouseButtonEvent(
						math.floor(
							point.X
						),
						math.floor(
							point.Y
						),
						0,
						true,
						game,
						0
					)

				task.wait(
					0.015
				)

				VirtualInputManager:
					SendMouseButtonEvent(
						math.floor(
							point.X
						),
						math.floor(
							point.Y
						),
						0,
						false,
						game,
						0
					)
			end)

		return success
	end

	local function ClickWithVirtualUser()
		local camera =
			workspace.CurrentCamera

		local position =
			GetSafeClickPosition()

		local success =
			pcall(function()
				VirtualUser:
					CaptureController()

				VirtualUser:
					Button1Down(
						position,
						camera
							and
							camera.CFrame
							or
							CFrame.new()
					)

				task.wait(
					0.015
				)

				VirtualUser:
					Button1Up(
						position,
						camera
							and
							camera.CFrame
							or
							CFrame.new()
					)
			end)

		return success
	end

	local function FireToolActivated(
		tool
	)
		if not tool then
			return false
		end

		local worked =
			false

		local success =
			pcall(function()
				tool:
					Activate()
			end)

		if success then
			worked =
				true
		end

		local fireSignal =
			GetExecutorFunction(
				"firesignal"
			)

		if fireSignal then
			local signalSuccess =
				pcall(function()
					fireSignal(
						tool.Activated
					)
				end)

			if signalSuccess then
				worked =
					true
			end
		end

		return worked
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

		task.wait(
			0.03
		)

		local equippedTool =
			character:
				FindFirstChildOfClass(
					"Tool"
				)
			or
			tool

		local worked =
			false

		-- 1. Sistema de hit do jogo.
		if
			NetAttack(
				Target
			)
		then
			worked =
				true
		end

		-- 2. Ativação da Tool.
		if
			FireToolActivated(
				equippedTool
			)
		then
			worked =
				true
		end

		-- 3. NÃO usamos mais mouse1click do executor.
		-- Ele usa o cursor real e atrapalha a interface.

		-- 4. Clique virtual em uma coordenada segura
		-- fora do painel.
		if ClickWithVirtualInput() then
			worked =
				true
		end

		-- 5. Segundo fallback, também fora do painel.
		if ClickWithVirtualUser() then
			worked =
				true
		end

		return worked
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

	local LastNpcReportAt = 0

	local function FindTarget(QuestData)
		local enemiesFolder = workspace:FindFirstChild("Enemies")
		local _, _, playerRoot = GetCharacter()
		local wanted = NormalizeName(QuestData.Mob)
		local closest = nil
		local closestDistance = math.huge
		local foundNames = {}
		local inspected = 0

		if enemiesFolder then
			for _, enemy in ipairs(enemiesFolder:GetChildren()) do
				if enemy:IsA("Model") then
					inspected += 1
					if #foundNames < 6 then
						table.insert(foundNames, enemy.Name)
					end

					local humanoid = enemy:FindFirstChildOfClass("Humanoid")
					local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
					local enemyName = NormalizeName(enemy.Name)
					local matches = wanted ~= "" and string.find(enemyName, wanted, 1, true) ~= nil
					local rightArea = not QuestData.RequiresSubmerged
						or (enemyRoot ~= nil and enemyRoot.Position.Y < -500)

					if matches and rightArea and humanoid and enemyRoot
						and humanoid.Health > 0 then
						local distance = playerRoot
							and (playerRoot.Position - enemyRoot.Position).Magnitude
							or 0
						if distance < closestDistance then
							closest = enemy
							closestDistance = distance
						end
					end
				end
			end
		end

		-- Quando o mob não aparece, registra quais modelos estão carregados.
		-- Evita deixar o jogador preso sem explicação.
		if not closest and tick() - LastNpcReportAt >= 8 then
			LastNpcReportAt = tick()
			Warn("NPC '" .. tostring(QuestData.Mob) .. "' não encontrado. "
				.. "Modelos em Enemies: " .. tostring(inspected)
				.. ". Exemplos: " .. table.concat(foundNames, ", "))
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

		-- Um NPC encontrado pode estar longe: não iniciar combate
		-- antes de chegar até ele na mesma região.
		local _, _, startingRoot = GetCharacter()
		if not startingRoot then
			return
		end
		local approachHeight = math.clamp(
			tonumber(State.Settings.FarmHeight) or 9, 8, 12
		)
		local approachPosition = enemyRoot.Position
			+ Vector3.new(0, approachHeight, 4)
		local firstDistance = (startingRoot.Position - approachPosition).Magnitude
		if firstDistance > 25 then
			State:SetRuntime("Status", "Indo até " .. tostring(QuestData.Mob))
			Log("Aproximando do alvo; distância: "
				.. string.format("%.1f", firstDistance) .. " studs")
			if not MoveTo(CFrame.new(approachPosition)) then
				Warn("Não foi possível chegar perto de " .. tostring(QuestData.Mob))
				return
			end
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

		local lastHealth =
			humanoid.Health

		local noDamageCycles =
			0

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

				StopTween()

				-- Sai desta luta. O loop principal
				-- vai pegar missão/alvo de novo após
				-- o personagem renascer.
				return
			end

			if not enemyRoot.Parent then
				break
			end

			if QuestData.RequiresSubmerged
				and not IsInsideSubmerged(QuestData) then
				State:SetRuntime("Status", "Saiu da Submerged")
				State:SetSetting("AutoFarm", false)
				Warning("Saiu da Submerged durante o combate.")
				return
			end

			local enemyPosition =
				enemyRoot.Position

			local configuredHeight =
				tonumber(
					State.Settings.FarmHeight
				)
				or
				10

			local attackType =
				State.Settings.AttackType
				or
				"Estilo de luta"

			local height =
				configuredHeight

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
						8,
						11
					)
			else
				height =
					math.clamp(
						configuredHeight,
						8,
						14
					)
			end

			if QuestData.RequiresSubmerged then
				height =
					math.clamp(
						height,
						9,
						12
					)
			end

			-- Se o alvo se afastar, aproxime primeiro, sem dar
			-- um teleporte gigante em cada ciclo do combate.
			local distanceToEnemy =
				(playerRoot.Position - enemyPosition).Magnitude
			if distanceToEnemy > 40 then
				State:SetRuntime("Status", "Reaproximando do NPC")
				if not MoveTo(CFrame.new(
					enemyPosition + Vector3.new(0, height, 4)
				)) then
					return
				end
			end

			-- Fica acima e um pouco atrás do NPC,
			-- reduzindo a chance de tomar golpe frontal.
			local attackCFrame =
				enemyRoot.CFrame
				*
				CFrame.new(
					0,
					height,
					4
				)

			pcall(function()
				playerRoot.AssemblyLinearVelocity =
					Vector3.zero

				playerRoot.AssemblyAngularVelocity =
					Vector3.zero

				playerRoot.CFrame =
					CFrame.new(
						attackCFrame.Position,
						enemyPosition
					)
			end)

			ActivateBuso()
			EquipAttack()

			Attack(
				Target
			)

			task.wait(
				math.max(
					tonumber(
						State.Settings.AttackDelay
					)
					or
					0.10,
					0.05
				)
			)

			if
				humanoid.Health
				<
				lastHealth
			then
				noDamageCycles =
					0

				State:SetRuntime(
					"Status",
					"Farmando / dando dano"
				)
			else
				noDamageCycles +=
					1

				if noDamageCycles >= 20 then
					State:SetRuntime(
						"Status",
						"Atacando, mas sem dano"
					)
				end
			end

			lastHealth =
				humanoid.Health
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
		local character,
			humanoid,
			root =
				GetCharacter()

		if
			not character
			or
			not humanoid
			or
			not root
		then
			State:SetRuntime(
				"Status",
				"Aguardando respawn"
			)

			StopTween()

			task.wait(
				0.75
			)

			return
		end

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

		if not HasCorrectQuest(QuestData) then
			local started = StartQuest(QuestData)
			if started and not HasCorrectQuest(QuestData) then
				State:SetRuntime("Status", "Aguardando missão aparecer na tela")
				Warn("StartQuest respondeu, mas título da missão não confirmou: "
					.. tostring(QuestData.Mob))
			end
			return
		end

		-- Após aceitar a missão, localizar os mobs que já carregaram.
		local Target = FindTarget(QuestData)
		if Target then
			Fight(Target, QuestData)
			return
		end

		-- Se os inimigos ainda não carregaram, vá até a região
		-- de spawn declarada em data/quests.lua e procure outra vez.
		State:SetRuntime("Target", tostring(QuestData.Mob))
		if typeof(QuestData.MobPos) ~= "CFrame" then
			State:SetRuntime("Status", "Spawn do NPC não configurado")
			State:SetSetting("AutoFarm", false)
			Warning("MobPos inválido em data/quests.lua para "
				.. tostring(QuestData.Mob))
			return
		end

		local mobHeight = QuestData.RequiresSubmerged and 8
			or math.clamp(tonumber(State.Settings.FarmHeight) or 8, 5, 12)
		local destination = QuestData.MobPos * CFrame.new(0, mobHeight, 0)
		local _, _, currentRoot = GetCharacter()
		if not currentRoot then
			return
		end

		local distance = (currentRoot.Position - destination.Position).Magnitude
		if distance > 25 then
			State:SetRuntime("Status", "Indo ao spawn de " .. tostring(QuestData.Mob))
			Log("Movendo para MobPos: " .. tostring(QuestData.MobPos.Position)
				.. " (distância " .. string.format("%.1f", distance) .. " studs)")
			if not MoveTo(destination) then
				State:SetRuntime("Status", "Falha ao chegar ao spawn do NPC")
				if QuestData.RequiresSubmerged and State.Settings.AutoFarm then
					State:SetSetting("AutoFarm", false)
					Warning("Movimentação ao spawn falhou. Veja o log do Deal Blox.")
				end
				return
			end
		end

		State:SetRuntime("Status", "Procurando NPC perto do spawn")
		task.wait(1.0) -- permite que os modelos apareçam em workspace.Enemies
		if not State.Settings.AutoFarm then
			return
		end

		Target = FindTarget(QuestData)
		if Target then
			State:SetRuntime("Status", "NPC encontrado: iniciando combate")
			Fight(Target, QuestData)
		else
			State:SetRuntime("Status", "Aguardando spawn: " .. tostring(QuestData.Mob))
			task.wait(0.8)
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
	-- RESPAWN
	--==================================================

	Player.CharacterAdded:
		Connect(function(
			character
		)
			if
				Environment.DealBloxFarmToken
				~=
				Token
			then
				return
			end

			StopTween()

			if
				State.Settings.AutoFarm
			then
				State:SetRuntime(
					"Status",
					"Respawn detectado"
				)

				task.spawn(function()
					local humanoid =
						character:
							WaitForChild(
								"Humanoid",
								10
							)

					local root =
						character:
							WaitForChild(
								"HumanoidRootPart",
								10
							)

					if
						humanoid
						and
						root
					then
						task.wait(
							1.5
						)

						if
							State.Settings.AutoFarm
						then
							State:SetRuntime(
								"Status",
								"Retomando Auto Farm"
							)
						end
					end
				end)
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
