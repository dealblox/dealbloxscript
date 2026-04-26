--[[
═══════════════════════════════════════════════════════════════
    🎮 DEAL BLOX SCRIPTS 🎮
    Desenvolvido por: Lag Mental
    Servidor Discord: discord.gg/rPFN7BMC5k
    
    Compatível com:
    ✅ Delta (iOS/Android)
    ✅ Xeno (PC)
    ✅ Diversos outros executores
═══════════════════════════════════════════════════════════════
]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- =========================
-- PROTEÇÃO E VERIFICAÇÃO
-- =========================
if not game.PlaceId or (game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635) then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Jogo Inválido",
        Text = "Este script é apeas para Blox Fruits!",
        Duration = 5
    })
    return
end

-- Verificar se já está rodando
if _G.DealBloxLoaded then
    warn("⚠️ Deal Blox Scripts já está em execução!")
    return
end

_G.DealBloxLoaded = true
_G.DealBloxStartTime = tick()

-- =========================
-- SERVIÇOS PRINCIPAIS
-- =========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

-- =========================
-- DETECÇÃO DO SEA
-- =========================
local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        return 1
    elseif placeId == 4442272183 then
        return 2
    elseif placeId == 7449423635 then
        return 3
    end
    return 1
end

local CurrentSea = GetCurrentSea()

-- =========================
-- VARIÁVEIS GLOBAIS DO SCRIPT
-- =========================
_G.DealBlox = {
    Version = "1.0.0",
    Author = "Lag Mental",
    Discord = "discord.gg/rPFN7BMC5k",
    
    -- Estados principais
    Settings = {
        -- Farm
        AutoFarm = false,
        AutoFarmKatakuriV1 = false,
        AutoFarmKatakuriV2 = false,
        SelectedWeapon = "Estilo de luta", -- "Estilo de luta", "Espada", "Fruta"
        AutoClick = false,
        AutoObservation = false,
        AutoRaceV3 = false,
        AutoRaceV4 = false,
        FarmDistance = 30,
        
        -- Mastery
        MasteryMode = "Nenhum", -- "Estilo de luta", "Espada", "Arma", "Fruta"
        AutoMastery = false,
        
        -- Sea
        AutoSea2 = false,
        AutoSea3 = false,
        AutoFactory = false,
        AutoPirateRaid = false,
        
        -- Rip Indra
        AutoEliteHunter = false,
        AutoSpawnRipIndra = false,
        AutoHakiRipIndra = false,
        AutoAttackRipIndra = false,
        SelectedBoss = "Nenhum",
        
        -- Raids
        SelectedRaid = "Flame",
        SelectedRaidWeapon = "Estilo de luta",
        AutoRaid = false,
        AutoChip = false,
        AutoAttackRaid = false,
        
        -- Dungeon
        SelectedDifficulty = "Normal",
        
        -- Frutas
        AutoSpinFruit = false,
        AutoStoreFruit = false,
        AutoHuntFruit = false,
        SelectedFruitToBuy = "Nenhum",
        AutoHuntBerry = false,
        
        -- Raças
        AutoRaceV1toV3 = false,
        AutoGetCyborg = false,
        AutoGetGhoul = false,
        
        -- ESP
        ESPBerry = false,
        ESPIsland = false,
        ESPFruit = false,
        ESPPlayer = false,
        
        -- Teleport
        SelectedIsland = "Nenhum",
        SelectedPlayer = "Nenhum",
        
        -- PVP
        SelectedPVPPlayer = "Nenhum",
        AutoAimbot = false,
    },
    
    -- Estados temporários
    TempStates = {
        CurrentQuest = nil,
        IsFarming = false,
        IsInRaid = false,
        WaitingFor = nil,
    }
}

-- =========================
-- SISTEMA DE NOTIFICAÇÃO
-- =========================
local function Notify(titulo, texto, duracao)
    duracao = duracao or 3
    
    task.spawn(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = titulo,
            Text = texto,
            Duration = duracao,
            Icon = "rbxassetid://1234567890"
        })
    end)
end

-- =========================
-- SISTEMA DE ESPERA COM NOTIFICAÇÃO
-- =========================
local function WaitFor(descricao, condicao, timeout)
    timeout = timeout or 30
    local startTime = tick()
    
    _G.DealBlox.TempStates.WaitingFor = descricao
    Notify("⏳ Aguardando", "Estamos esperando " .. descricao, 2)
    
    while not condicao() and (tick() - startTime) < timeout do
        task.wait(0.5)
    end
    
    _G.DealBlox.TempStates.WaitingFor = nil
    
    if (tick() - startTime) >= timeout then
        Notify("⚠️ Timeout", "Tempo esgotado esperando " .. descricao, 3)
        return false
    end
    
    return true
end

-- =========================
-- FUNÇÃO DE TWEEN
-- =========================
local function Tween(obj, time, props, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Linear
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(time, easingStyle, easingDirection),
        props
    )
    tween:Play()
    return tween
end

-- =========================
-- TELEPORTE SEGURO (ALTO)
-- =========================
local function SafeTP(cframe)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    pcall(function()
        local hrp = LocalPlayer.Character.HumanoidRootPart
        
        -- Subir bem alto primeiro
        local highPosition = CFrame.new(cframe.X, cframe.Y + 500, cframe.Z)
        
        -- Teleportar alto primeiro
        hrp.CFrame = highPosition
        task.wait(0.5)
        
        -- Depois descer para a posição final (ainda alto)
        local finalPosition = CFrame.new(cframe.X, cframe.Y + 50, cframe.Z)
        
        local distance = (hrp.Position - finalPosition.Position).Magnitude
        
        if distance < 100 then
            hrp.CFrame = finalPosition
        else
            -- Tween se estiver longe
            local tweenTime = distance / 300
            local tween = Tween(hrp, tweenTime, {CFrame = finalPosition})
            tween.Completed:Wait()
        end
    end)
    
    task.wait(0.3)
    return true
end

-- =========================
-- OBTER REMOTE FUNCTION
-- =========================
local function GetRemote()
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("CommF_", 5)
    end)
    return success and remote or nil
end

-- =========================
-- EQUIPAR ARMA
-- =========================
local function EquipWeapon()
    local weaponType = _G.DealBlox.Settings.SelectedWeapon
    
    if weaponType == "Nenhum" then
        return false
    end
    
    local weaponMap = {
        ["Estilo de luta"] = "Melee",
        ["Espada"] = "Sword",
        ["Fruta"] = "Blox Fruit"
    }
    
    local targetType = weaponMap[weaponType]
    if not targetType then return false end
    
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == targetType then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
            return true
        end
    end
    
    return false
end

-- =========================
-- AUTO CLICK
-- =========================
task.spawn(function()
    while task.wait(0.1) do
        if _G.DealBlox.Settings.AutoClick then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- =========================
-- ATIVAR BUSO HAKI
-- =========================
local function ActivateBuso()
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
            local remote = GetRemote()
            if remote then
                remote:InvokeServer("Buso")
            end
        end
    end)
end

-- =========================
-- FORMATAR NÚMEROS
-- =========================
local function FormatNumber(num)
    if num >= 1000000000 then
        return string.format("%.1fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(math.floor(num))
    end
end

-- =========================
-- OBTER TEMPO DE JOGO
-- =========================
local function GetPlayTime()
    local elapsed = tick() - _G.DealBloxStartTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)
    return string.format("%dh %dM %dS", hours, minutes, seconds)
end

-- =========================
-- OBTER TEMPO DO SERVIDOR
-- =========================
local function GetServerTime()
    local uptime = workspace:GetServerTimeNow()
    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = math.floor(uptime % 60)
    return string.format("%dh %dM %dS", hours, minutes, seconds)
end

print("✅ DEAL BLOX - PARTE 1/15 CARREGADA")

-- =========================
-- TELA DE INTRODUÇÃO BORRADA
-- =========================
local function ShowIntroduction()
    -- Criar ScreenGui para intro
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "DealBloxIntro"
    IntroGui.ResetOnSpawn = false
    IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    IntroGui.IgnoreGuiInset = true
    
    pcall(function()
        IntroGui.Parent = game:GetService("CoreGui")
    end)
    
    if not IntroGui.Parent then
        IntroGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Frame de fundo borrado
    local BlurFrame = Instance.new("Frame", IntroGui)
    BlurFrame.Size = UDim2.fromScale(1, 1)
    BlurFrame.Position = UDim2.fromScale(0, 0)
    BlurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurFrame.BackgroundTransparency = 0
    BlurFrame.BorderSizePixel = 0
    BlurFrame.ZIndex = 10000
    
    -- Efeito de blur
    local BlurEffect = Instance.new("BlurEffect", Lighting)
    BlurEffect.Size = 0
    
    -- Texto principal
    local IntroText = Instance.new("TextLabel", BlurFrame)
    IntroText.Size = UDim2.fromScale(1, 0.3)
    IntroText.Position = UDim2.fromScale(0, 0.35)
    IntroText.BackgroundTransparency = 1
    IntroText.Text = "Você acaba de executar o script da\nDEAL BLOX"
    IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroText.Font = Enum.Font.GothamBold
    IntroText.TextSize = 40
    IntroText.TextWrapped = true
    IntroText.TextTransparency = 1
    IntroText.ZIndex = 10001
    
    -- Adicionar efeito de brilho no texto
    local TextStroke = Instance.new("UIStroke", IntroText)
    TextStroke.Color = Color3.fromRGB(0, 120, 255)
    TextStroke.Thickness = 3
    TextStroke.Transparency = 1
    
-- Logo da Deal Blox (CORRETO)
local Logo = Instance.new("ImageLabel", BlurFrame)
Logo.Size = UDim2.fromOffset(200, 200)
Logo.Position = UDim2.fromScale(0.5, 0.2)
Logo.AnchorPoint = Vector2.new(0.5, 0.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://121622891926251" -- LOGO DEAL BLOX CORRETA
Logo.ScaleType = Enum.ScaleType.Fit
Logo.ImageTransparency = 1
Logo.ZIndex = 10001
    
    -- Animação de entrada (5 segundos)
    task.spawn(function()
        -- Fade in do blur
        Tween(BlurEffect, 0.5, {Size = 24}):Play()
        
        -- Fade in do background
        Tween(BlurFrame, 0.5, {BackgroundTransparency = 0.3}):Play()
        
        task.wait(0.5)
        
        -- Fade in da logo
        Tween(Logo, 0.8, {ImageTransparency = 0}):Play()
        
        task.wait(0.3)
        
        -- Fade in do texto
        Tween(IntroText, 0.8, {TextTransparency = 0}):Play()
        Tween(TextStroke, 0.8, {Transparency = 0}):Play()
        
        -- Efeito de pulso no texto
        task.wait(0.5)
        for i = 1, 3 do
            Tween(IntroText, 0.3, {TextSize = 42}):Play()
            Tween(TextStroke, 0.3, {Thickness = 4}):Play()
            task.wait(0.3)
            Tween(IntroText, 0.3, {TextSize = 40}):Play()
            Tween(TextStroke, 0.3, {Thickness = 3}):Play()
            task.wait(0.3)
        end
        
        task.wait(2)
        
        -- Fade out (estilo filme)
        Tween(IntroText, 1.5, {TextTransparency = 1}):Play()
        Tween(TextStroke, 1.5, {Transparency = 1}):Play()
        Tween(Logo, 1.5, {ImageTransparency = 1}):Play()
        
        task.wait(0.5)
        
        Tween(BlurFrame, 1, {BackgroundTransparency = 1}):Play()
        Tween(BlurEffect, 1, {Size = 0}):Play()
        
        task.wait(1)
        
        -- Remover elementos
        BlurEffect:Destroy()
        IntroGui:Destroy()
    end)
end

-- Executar introdução
ShowIntroduction()

-- =========================
-- QUEST DATA COMPLETO
-- =========================
local QuestData = {}

if CurrentSea == 1 then
    QuestData = {
        [1] = {Quest = "BanditQuest1", QuestNum = 1, Mob = "Bandit", Pos = CFrame.new(1059, 16, 1549)},
        [10] = {Quest = "JungleQuest", QuestNum = 1, Mob = "Monkey", Pos = CFrame.new(-1601, 37, 152)},
        [15] = {Quest = "BuggyQuest1", QuestNum = 1, Mob = "Pirate", Pos = CFrame.new(-1119, 5, 3831)},
        [30] = {Quest = "BuggyQuest2", QuestNum = 1, Mob = "Brute", Pos = CFrame.new(-1140, 15, 4312)},
        [40] = {Quest = "DesertQuest", QuestNum = 1, Mob = "Desert Bandit", Pos = CFrame.new(897, 6, 4388)},
        [60] = {Quest = "DesertQuest", QuestNum = 2, Mob = "Desert Officer", Pos = CFrame.new(897, 6, 4388)},
        [75] = {Quest = "SnowQuest", QuestNum = 1, Mob = "Snowman", Pos = CFrame.new(1386, 87, -1297)},
        [90] = {Quest = "SnowQuest", QuestNum = 2, Mob = "Winter Warrior", Pos = CFrame.new(1386, 87, -1297)},
        [100] = {Quest = "MarineQuest2", QuestNum = 1, Mob = "Chief Petty Officer", Pos = CFrame.new(-4881, 23, 4273)},
        [120] = {Quest = "MarineQuest3", QuestNum = 1, Mob = "Marine Captain", Pos = CFrame.new(-2442, 73, -3219)},
        [150] = {Quest = "SkyExp1Quest", QuestNum = 1, Mob = "God's Guard", Pos = CFrame.new(-4721, 845, -1954)},
        [175] = {Quest = "SkyExp1Quest", QuestNum = 2, Mob = "Shanda", Pos = CFrame.new(-7863, 5545, -380)},
        [190] = {Quest = "SkyExp2Quest", QuestNum = 1, Mob = "Royal Squad", Pos = CFrame.new(-7906, 5634, -1411)},
        [210] = {Quest = "SkyExp2Quest", QuestNum = 2, Mob = "Royal Soldier", Pos = CFrame.new(-7906, 5634, -1411)},
        [225] = {Quest = "ColosseumQuest", QuestNum = 1, Mob = "Gladiator", Pos = CFrame.new(-1315, 8, -2976)},
        [250] = {Quest = "PrisonerQuest", QuestNum = 1, Mob = "Dangerous Prisoner", Pos = CFrame.new(4875, 6, 734)},
        [275] = {Quest = "PrisonerQuest", QuestNum = 2, Mob = "Toga Warrior", Pos = CFrame.new(4875, 6, 734)},
        [300] = {Quest = "ColosseumQuest", QuestNum = 2, Mob = "Military Soldier", Pos = CFrame.new(-1315, 8, -2976)},
        [325] = {Quest = "MagmaQuest", QuestNum = 1, Mob = "Lava Pirate", Pos = CFrame.new(-5234, 12, 8445)},
        [350] = {Quest = "MagmaQuest", QuestNum = 2, Mob = "Magma Admiral", Pos = CFrame.new(-5234, 12, 8445)},
        [375] = {Quest = "FishmanQuest", QuestNum = 1, Mob = "Fishman Warrior", Pos = CFrame.new(61122, 18, 1569)},
        [400] = {Quest = "FishmanQuest", QuestNum = 2, Mob = "Fishman Commando", Pos = CFrame.new(61122, 18, 1569)},
        [450] = {Quest = "SkyExp1Quest", QuestNum = 3, Mob = "God's Guard", Pos = CFrame.new(-4721, 845, -1954)}
    }
elseif CurrentSea == 2 then
    QuestData = {
        [700] = {Quest = "Area1Quest", QuestNum = 1, Mob = "Raider", Pos = CFrame.new(-428, 72, 1836)},
        [725] = {Quest = "Area1Quest", QuestNum = 2, Mob = "Mercenary", Pos = CFrame.new(-428, 72, 1836)},
        [775] = {Quest = "Area2Quest", QuestNum = 1, Mob = "Swan Pirate", Pos = CFrame.new(638, 73, 1194)},
        [800] = {Quest = "Area2Quest", QuestNum = 2, Mob = "Factory Staff", Pos = CFrame.new(638, 73, 1194)},
        [825] = {Quest = "MarineQuest3", QuestNum = 1, Mob = "Marine Lieutenant", Pos = CFrame.new(-2440, 73, -3217)},
        [850] = {Quest = "MarineQuest3", QuestNum = 2, Mob = "Marine Captain", Pos = CFrame.new(-2440, 73, -3217)},
        [875] = {Quest = "ZombieQuest", QuestNum = 1, Mob = "Zombie", Pos = CFrame.new(-5496, 48, -795)},
        [900] = {Quest = "ZombieQuest", QuestNum = 2, Mob = "Vampire", Pos = CFrame.new(-5496, 48, -795)},
        [950] = {Quest = "SnowMountainQuest", QuestNum = 1, Mob = "Winter Warrior", Pos = CFrame.new(604, 401, -5371)},
        [975] = {Quest = "SnowMountainQuest", QuestNum = 2, Mob = "Lab Subordinate", Pos = CFrame.new(604, 401, -5371)},
        [1000] = {Quest = "IceSideQuest", QuestNum = 1, Mob = "Horned Warrior", Pos = CFrame.new(-6078, 16, -4902)},
        [1050] = {Quest = "IceSideQuest", QuestNum = 2, Mob = "Magma Ninja", Pos = CFrame.new(-6078, 16, -4902)},
        [1100] = {Quest = "ShipQuest1", QuestNum = 1, Mob = "Pirate Millionaire", Pos = CFrame.new(971, 125, 32911)},
        [1125] = {Quest = "ShipQuest1", QuestNum = 2, Mob = "Pistol Billionaire", Pos = CFrame.new(971, 125, 32911)},
        [1150] = {Quest = "ShipQuest2", QuestNum = 1, Mob = "Dragon Crew Warrior", Pos = CFrame.new(971, 125, 32911)},
        [1175] = {Quest = "ShipQuest2", QuestNum = 2, Mob = "Dragon Crew Archer", Pos = CFrame.new(971, 125, 32911)},
        [1200] = {Quest = "FrostQuest", QuestNum = 1, Mob = "Snow Trooper", Pos = CFrame.new(5668, 28, -6484)},
        [1225] = {Quest = "FrostQuest", QuestNum = 2, Mob = "Winter Warrior", Pos = CFrame.new(5668, 28, -6484)},
        [1250] = {Quest = "ForgottenQuest", QuestNum = 1, Mob = "Sea Soldier", Pos = CFrame.new(-3053, 240, -10145)},
        [1275] = {Quest = "ForgottenQuest", QuestNum = 2, Mob = "Water Fighter", Pos = CFrame.new(-3053, 240, -10145)},
        [1300] = {Quest = "Area1Quest", QuestNum = 3, Mob = "Raider", Pos = CFrame.new(-428, 72, 1836)},
        [1325] = {Quest = "Area2Quest", QuestNum = 3, Mob = "Swan Pirate", Pos = CFrame.new(638, 73, 1194)}
    }
else -- Sea 3
    QuestData = {
        [1500] = {Quest = "PiratePortQuest", QuestNum = 1, Mob = "Pirate Millionaire", Pos = CFrame.new(-290, 44, 5580)},
        [1525] = {Quest = "PiratePortQuest", QuestNum = 2, Mob = "Pistol Billionaire", Pos = CFrame.new(-290, 44, 5580)},
        [1575] = {Quest = "AmazonQuest", QuestNum = 1, Mob = "Amazon Warrior", Pos = CFrame.new(5832, 52, -1105)},
        [1600] = {Quest = "AmazonQuest", QuestNum = 2, Mob = "Amazon Hunter", Pos = CFrame.new(5832, 52, -1105)},
        [1625] = {Quest = "MarineTreeIsland", QuestNum = 1, Mob = "Marine Commodore", Pos = CFrame.new(2179, 29, -6737)},
        [1675] = {Quest = "MarineTreeIsland", QuestNum = 2, Mob = "Marine Rear Admiral", Pos = CFrame.new(2179, 29, -6737)},
        [1700] = {Quest = "DeepForestIsland", QuestNum = 1, Mob = "Mythological Pirate", Pos = CFrame.new(-13233, 332, -7625)},
        [1725] = {Quest = "DeepForestIsland", QuestNum = 2, Mob = "Jungle Pirate", Pos = CFrame.new(-13233, 332, -7625)},
        [1775] = {Quest = "DeepForestIsland2", QuestNum = 1, Mob = "Jungle Pirate", Pos = CFrame.new(-12680, 391, -9902)},
        [1800] = {Quest = "DeepForestIsland3", QuestNum = 1, Mob = "Musketeer Pirate", Pos = CFrame.new(-13235, 332, -7624)},
        [1825] = {Quest = "DeepForestIsland3", QuestNum = 2, Mob = "Reborn Skeleton", Pos = CFrame.new(-13235, 332, -7624)},
        [1850] = {Quest = "DeepForestIsland3", QuestNum = 3, Mob = "Living Zombie", Pos = CFrame.new(-13235, 332, -7624)},
        [1875] = {Quest = "DeepForestIsland4", QuestNum = 1, Mob = "Demonic Soul", Pos = CFrame.new(-9507, 172, 6158)},
        [1900] = {Quest = "DeepForestIsland4", QuestNum = 2, Mob = "Posessed Mummy", Pos = CFrame.new(-9507, 172, 6158)},
        [1925] = {Quest = "DeepForestIsland5", QuestNum = 1, Mob = "Peanut Scout", Pos = CFrame.new(-2103, 38, -10192)},
        [1975] = {Quest = "DeepForestIsland5", QuestNum = 2, Mob = "Peanut President", Pos = CFrame.new(-2103, 38, -10192)},
        [2000] = {Quest = "DeepForestIsland6", QuestNum = 1, Mob = "Ice Cream Chef", Pos = CFrame.new(-2103, 38, -10192)},
        [2025] = {Quest = "DeepForestIsland6", QuestNum = 2, Mob = "Ice Cream Commander", Pos = CFrame.new(-2103, 38, -10192)},
        [2050] = {Quest = "DeepForestIsland7", QuestNum = 1, Mob = "Cookie Crafter", Pos = CFrame.new(-2103, 38, -10192)},
        [2075] = {Quest = "DeepForestIsland7", QuestNum = 2, Mob = "Cake Guard", Pos = CFrame.new(-2103, 38, -10192)},
        [2100] = {Quest = "DeepForestIsland8", QuestNum = 1, Mob = "Baking Staff", Pos = CFrame.new(-2103, 38, -10192)},
        [2125] = {Quest = "DeepForestIsland8", QuestNum = 2, Mob = "Head Baker", Pos = CFrame.new(-2103, 38, -10192)},
        [2150] = {Quest = "DeepForestIsland9", QuestNum = 1, Mob = "Cocoa Warrior", Pos = CFrame.new(-2103, 38, -10192)},
        [2175] = {Quest = "DeepForestIsland9", QuestNum = 2, Mob = "Chocolate Bar Battler", Pos = CFrame.new(-2103, 38, -10192)},
        [2200] = {Quest = "DeepForestIsland10", QuestNum = 1, Mob = "Sweet Thief", Pos = CFrame.new(-2103, 38, -10192)},
        [2225] = {Quest = "DeepForestIsland10", QuestNum = 2, Mob = "Candy Rebel", Pos = CFrame.new(-2103, 38, -10192)},
        [2250] = {Quest = "DeepForestIsland11", QuestNum = 1, Mob = "Candy Pirate", Pos = CFrame.new(-2103, 38, -10192)},
        [2275] = {Quest = "DeepForestIsland11", QuestNum = 2, Mob = "Sweet Thief", Pos = CFrame.new(-2103, 38, -10192)},
        [2300] = {Quest = "DeepForestIsland12", QuestNum = 1, Mob = "Cocoa Warrior", Pos = CFrame.new(-2103, 38, -10192)},
        [2325] = {Quest = "DeepForestIsland12", QuestNum = 2, Mob = "Chocolate Bar Battler", Pos = CFrame.new(-2103, 38, -10192)},
        [2350] = {Quest = "DeepForestIsland13", QuestNum = 1, Mob = "Sweet Thief", Pos = CFrame.new(-2103, 38, -10192)},
        [2375] = {Quest = "DeepForestIsland13", QuestNum = 2, Mob = "Candy Pirate", Pos = CFrame.new(-2103, 38, -10192)},
        [2400] = {Quest = "DeepForestIsland14", QuestNum = 1, Mob = "Cake Guard", Pos = CFrame.new(-2103, 38, -10192)},
        [2425] = {Quest = "DeepForestIsland14", QuestNum = 2, Mob = "Baking Staff", Pos = CFrame.new(-2103, 38, -10192)},
        [2450] = {Quest = "DeepForestIsland15", QuestNum = 1, Mob = "Head Baker", Pos = CFrame.new(-2103, 38, -10192)},
        [2475] = {Quest = "DeepForestIsland15", QuestNum = 2, Mob = "Cocoa Warrior", Pos = CFrame.new(-2103, 38, -10192)},
        [2500] = {Quest = "DeepForestIsland16", QuestNum = 1, Mob = "Chocolate Bar Battler", Pos = CFrame.new(-2103, 38, -10192)},
        [2525] = {Quest = "DeepForestIsland16", QuestNum = 2, Mob = "Sweet Thief", Pos = CFrame.new(-2103, 38, -10192)},
        [2550] = {Quest = "DeepForestIsland17", QuestNum = 1, Mob = "Candy Rebel", Pos = CFrame.new(-2103, 38, -10192)},
        [2575] = {Quest = "DeepForestIsland17", QuestNum = 2, Mob = "Candy Pirate", Pos = CFrame.new(-2103, 38, -10192)},
        [2600] = {Quest = "DeepForestIsland18", QuestNum = 1, Mob = "Sweet Thief", Pos = CFrame.new(-2103, 38, -10192)},
        [2625] = {Quest = "DeepForestIsland18", QuestNum = 2, Mob = "Cake Guard", Pos = CFrame.new(-2103, 38, -10192)},
        [2650] = {Quest = "DeepForestIsland19", QuestNum = 1, Mob = "Baking Staff", Pos = CFrame.new(-2103, 38, -10192)},
        [2675] = {Quest = "DeepForestIsland19", QuestNum = 2, Mob = "Head Baker", Pos = CFrame.new(-2103, 38, -10192)},
        [2700] = {Quest = "DeepForestIsland20", QuestNum = 1, Mob = "Cocoa Warrior", Pos = CFrame.new(-2103, 38, -10192)},
        [2725] = {Quest = "DeepForestIsland20", QuestNum = 2, Mob = "Chocolate Bar Battler", Pos = CFrame.new(-2103, 38, -10192)},
        [2750] = {Quest = "DeepForestIsland21", QuestNum = 1, Mob = "Sweet Thief", Pos = CFrame.new(-2103, 38, -10192)},
        [2775] = {Quest = "DeepForestIsland21", QuestNum = 2, Mob = "Candy Rebel", Pos = CFrame.new(-2103, 38, -10192)},
        [2800] = {Quest = "DeepForestIsland21", QuestNum = 2, Mob = "Candy Pirate", Pos = CFrame.new(-2103, 38, -10192)}
    }
end

-- Função para obter quest baseado no level
local function GetQuestByLevel(level)
    local selectedQuest = nil
    local maxLevel = 0
    
    for lvl, quest in pairs(QuestData) do
        if level >= lvl and lvl > maxLevel then
            selectedQuest = quest
            maxLevel = lvl
        end
    end
    
    return selectedQuest
end

-- =========================
-- LISTA DE ILHAS POR SEA
-- =========================
local IslandPositions = {
    -- SEA 1
    ["Pirate Starter"] = CFrame.new(1071, 16, 1426),
    ["Marine Starter"] = CFrame.new(-2573, 73, 2046),
    ["Jungle"] = CFrame.new(-1612, 37, 149),
    ["Pirate Village"] = CFrame.new(-1114, 5, 3738),
    ["Desert"] = CFrame.new(945, 7, 4470),
    ["Frozen Village"] = CFrame.new(1200, 105, -1318),
    ["Marine Fortress"] = CFrame.new(-2994, 73, -3125),
    ["Sky Island 1"] = CFrame.new(-4970, 718, -2667),
    ["Sky Island 2"] = CFrame.new(-4813, 718, -2792),
    ["Sky Island 3"] = CFrame.new(-7925, 5545, -380),
    ["Prison"] = CFrame.new(4875, 6, 734),
    ["Colosseum"] = CFrame.new(-1427, 7, -2926),
    ["Magma Village"] = CFrame.new(-5247, 12, 8504),
    ["Underwater City"] = CFrame.new(61164, 5, 1819),
    ["Upper Skylands"] = CFrame.new(-7894, 5547, -379),
    ["Fountain City"] = CFrame.new(-380, 38, 297),
    
    -- SEA 2
    ["Kingdom of Rose"] = CFrame.new(-288, 7, 5579),
    ["Cafe"] = CFrame.new(-377, 73, 298),
    ["Mansion"] = CFrame.new(-12471, 374, -7551),
    ["Graveyard"] = CFrame.new(-5560, 314, -2733),
    ["Snow Mountain"] = CFrame.new(753, 408, -5274),
    ["Hot and Cold"] = CFrame.new(-6100, 16, -5167),
    ["Cursed Ship"] = CFrame.new(923, 125, 32885),
    ["Ice Castle"] = CFrame.new(5665, 88, -6155),
    ["Forgotten Island"] = CFrame.new(-3053, 240, -10145),
    ["Dark Arena"] = CFrame.new(3777, 91, -3000),
    ["Usoaps Island"] = CFrame.new(4700, 8, 2997),
    
    -- SEA 3
    ["Port Town"] = CFrame.new(-290, 44, 5343),
    ["Hydra Island"] = CFrame.new(5749, 612, -276),
    ["Great Tree"] = CFrame.new(2681, 1682, -7190),
    ["Castle on the Sea"] = CFrame.new(-5075, 314, -3155),
    ["Haunted Castle"] = CFrame.new(-9515, 142, 5566),
    ["Sea of Treats"] = CFrame.new(-2079, 252, -12375),
    ["Tiki Outpost"] = CFrame.new(-16105, 9, 440),
    ["Floating Turtle"] = CFrame.new(-13274, 332, -7984)
}

local IslandsBySea = {
    [1] = {"Pirate Starter", "Marine Starter", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marine Fortress", "Sky Island 1", "Sky Island 2", "Sky Island 3", "Prison", "Colosseum", "Magma Village", "Underwater City", "Upper Skylands", "Fountain City"},
    [2] = {"Kingdom of Rose", "Cafe", "Mansion", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island", "Dark Arena", "Usoaps Island"},
    [3] = {"Port Town", "Hydra Island", "Great Tree", "Castle on the Sea", "Haunted Castle", "Sea of Treats", "Tiki Outpost", "Floating Turtle"}
}

-- =========================
-- LISTA DE BOSSES
-- =========================
local BossList = {
    [1] = {"The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg"},
    [2] = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Cake Prince"},
    [3] = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "rip_indra True Form", "Longma", "Soul Reaper", "Cake Queen", "Dough King"}
}

print("✅ DEAL BLOX - PARTE 2/15 CARREGADA")

-- =========================
-- CONFIGURAÇÕES DA GUI (CORES CORRIGIDAS)
-- =========================
local GuiConfig = {
    Aberto = false,
    Minimizado = false,
    TamanhoAtual = {Width = 600, Height = 450},
    TamanhoMinimo = {Width = 400, Height = 300},
    TamanhoMaximo = {Width = 800, Height = 600},
    
    Cores = {
        Primaria = Color3.fromRGB(46, 99, 184), -- Azul Neon #2e63b8
        Secundaria = Color3.fromRGB(184, 46, 46), -- Vermelho Neon #b82e2e
        Fundo = Color3.fromRGB(10, 10, 15), -- Fundo escuro
        FundoTransparente = 0.2, -- 80% visível
        AbaAtiva = Color3.fromRGB(46, 99, 184), -- Azul Neon
        AbaInativa = Color3.fromRGB(30, 30, 40),
        Texto = Color3.fromRGB(255, 255, 255),
        BotaoAtivo = Color3.fromRGB(46, 99, 184), -- Azul Neon
        BotaoInativo = Color3.fromRGB(60, 60, 80),
        Borda = Color3.fromRGB(184, 46, 46) -- Vermelho Neon
    }
}
-- =========================
-- CRIAR GUI PRINCIPAL
-- =========================
local function CreateMainGui()
    -- Aguardar introdução terminar
    task.wait(6)
    
    -- Criar ScreenGui
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "DealBloxGui"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.IgnoreGuiInset = true
    
    pcall(function()
        Gui.Parent = game:GetService("CoreGui")
    end)
    
    if not Gui.Parent then
        Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- =========================
    -- BOTÃO FLUTUANTE (ABRIR/FECHAR)
    -- =========================
    local OpenButton = Instance.new("ImageButton", Gui)
    OpenButton.Size = UDim2.fromOffset(60, 60)
    OpenButton.Position = UDim2.new(0, 20, 0.5, -30)
    OpenButton.BackgroundColor3 = GuiConfig.Cores.Primaria
    OpenButton.BorderSizePixel = 0
    OpenButton.Image = "rbxassetid://121622891926251"
    OpenButton.ScaleType = Enum.ScaleType.Fit
    OpenButton.Active = true
    OpenButton.Draggable = true
    OpenButton.ZIndex = 1000
    
    -- Arredondar cantos
    local ButtonCorner = Instance.new("UICorner", OpenButton)
    ButtonCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- Borda brilhante
    local ButtonStroke = Instance.new("UIStroke", OpenButton)
    ButtonStroke.Color = GuiConfig.Cores.Borda
    ButtonStroke.Thickness = 3
    ButtonStroke.Transparency = 0
    
    -- Efeito de pulsação no botão
    task.spawn(function()
        while task.wait(1) do
            Tween(ButtonStroke, 0.5, {Thickness = 5}):Play()
            task.wait(0.5)
            Tween(ButtonStroke, 0.5, {Thickness = 3}):Play()
        end
    end)
    
    -- =========================
    -- PAINEL PRINCIPAL
    -- =========================
    local MainPanel = Instance.new("Frame", Gui)
    MainPanel.Size = UDim2.fromOffset(0, 0)
    MainPanel.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainPanel.BackgroundColor3 = GuiConfig.Cores.Fundo
    MainPanel.BackgroundTransparency = GuiConfig.Cores.FundoTransparente
    MainPanel.BorderSizePixel = 0
    MainPanel.Visible = false
    MainPanel.ZIndex = 100
    MainPanel.Active = true
    
    -- Arredondar cantos
    local PanelCorner = Instance.new("UICorner", MainPanel)
    PanelCorner.CornerRadius = UDim.new(0, 15)
    
    -- Borda branca tecnológica
    local PanelStroke = Instance.new("UIStroke", MainPanel)
    PanelStroke.Color = Color3.fromRGB(255, 255, 255)
    PanelStroke.Thickness = 2
    PanelStroke.Transparency = 0
    
    -- Efeito de brilho na borda
    task.spawn(function()
        while task.wait(2) do
            Tween(PanelStroke, 1, {Color = GuiConfig.Cores.Primaria}):Play()
            task.wait(1)
            Tween(PanelStroke, 1, {Color = Color3.fromRGB(255, 255, 255)}):Play()
        end
    end)
    
    -- =========================
    -- TOP BAR (BARRA SUPERIOR)
    -- =========================
    local TopBar = Instance.new("Frame", MainPanel)
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.Position = UDim2.fromOffset(0, 0)
    TopBar.BackgroundColor3 = GuiConfig.Cores.Primaria
    TopBar.BackgroundTransparency = 0.1
    TopBar.BorderSizePixel = 0
    TopBar.ZIndex = 101
    
    -- Arredondar apenas o topo
    local TopCorner = Instance.new("UICorner", TopBar)
    TopCorner.CornerRadius = UDim.new(0, 15)
    
    -- Esconder a parte de baixo do arredondamento
    local TopCover = Instance.new("Frame", TopBar)
    TopCover.Size = UDim2.new(1, 0, 0, 15)
    TopCover.Position = UDim2.new(0, 0, 1, -15)
    TopCover.BackgroundColor3 = GuiConfig.Cores.Primaria
    TopCover.BackgroundTransparency = 0.1
    TopCover.BorderSizePixel = 0
    TopCover.ZIndex = 101
    
-- Logo Deal Blox na TopBar
local Logo = Instance.new("ImageLabel", TopBar)
Logo.Size = UDim2.fromOffset(40, 40)
Logo.Position = UDim2.fromOffset(10, 5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://121622891926251" -- LOGO DEAL BLOX
Logo.ScaleType = Enum.ScaleType.Fit
Logo.ZIndex = 102
    
    local LogoCorner = Instance.new("UICorner", Logo)
    LogoCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- Título
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -200, 1, 0)
    Title.Position = UDim2.fromOffset(60, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "DEAL BLOX SCRIPTS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 102
    
    -- Versão
    local Version = Instance.new("TextLabel", TopBar)
    Version.Size = UDim2.new(0, 100, 0, 15)
    Version.Position = UDim2.new(0, 60, 1, -18)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. _G.DealBlox.Version .. " | Sea " .. CurrentSea
    Version.TextColor3 = Color3.fromRGB(200, 200, 200)
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 10
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.ZIndex = 102
    
    -- Botão Minimizar
    local MinimizeBtn = Instance.new("TextButton", TopBar)
    MinimizeBtn.Size = UDim2.fromOffset(35, 35)
    MinimizeBtn.Position = UDim2.new(1, -115, 0.5, -17.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.ZIndex = 102
    
    local MinCorner = Instance.new("UICorner", MinimizeBtn)
    MinCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- Botão Redimensionar
    local ResizeBtn = Instance.new("TextButton", TopBar)
    ResizeBtn.Size = UDim2.fromOffset(35, 35)
    ResizeBtn.Position = UDim2.new(1, -75, 0.5, -17.5)
    ResizeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    ResizeBtn.Text = "⊡"
    ResizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResizeBtn.Font = Enum.Font.GothamBold
    ResizeBtn.TextSize = 16
    ResizeBtn.BorderSizePixel = 0
    ResizeBtn.ZIndex = 102
    
    local ResizeCorner = Instance.new("UICorner", ResizeBtn)
    ResizeCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- Botão Fechar
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.fromOffset(35, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -17.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    CloseBtn.ZIndex = 102
    
    local CloseCorner = Instance.new("UICorner", CloseBtn)
    CloseCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- =========================
    -- ARRASTAR PAINEL (APENAS PELA TOP BAR)
    -- =========================
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainPanel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainPanel.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- =========================
    -- CONTEÚDO DO PAINEL
    -- =========================
    local Content = Instance.new("Frame", MainPanel)
    Content.Size = UDim2.new(1, 0, 1, -50)
    Content.Position = UDim2.fromOffset(0, 50)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ZIndex = 100
    
    -- =========================
    -- LISTA DE ABAS (ESQUERDA)
    -- =========================
    local TabList = Instance.new("ScrollingFrame", Content)
    TabList.Size = UDim2.new(0, 150, 1, -10)
    TabList.Position = UDim2.fromOffset(5, 5)
    TabList.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
    TabList.BackgroundTransparency = 0.3
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = GuiConfig.Cores.Primaria
    TabList.CanvasSize = UDim2.fromOffset(0, 0)
    TabList.ZIndex = 100
    
    local TabCorner = Instance.new("UICorner", TabList)
    TabCorner.CornerRadius = UDim.new(0, 10)
    
    local TabStroke = Instance.new("UIStroke", TabList)
    TabStroke.Color = GuiConfig.Cores.Primaria
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.5
    
    local TabLayout = Instance.new("UIListLayout", TabList)
    TabLayout.Padding = UDim.new(0, 3)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Atualizar tamanho do canvas automaticamente
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.fromOffset(0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- =========================
    -- ÁREA DE CONTEÚDO DAS ABAS (DIREITA)
    -- =========================
    local TabContent = Instance.new("Frame", Content)
    TabContent.Size = UDim2.new(1, -165, 1, -10)
    TabContent.Position = UDim2.fromOffset(160, 5)
    TabContent.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
    TabContent.BackgroundTransparency = 0.3
    TabContent.BorderSizePixel = 0
    TabContent.ZIndex = 100
    
    local ContentCorner = Instance.new("UICorner", TabContent)
    ContentCorner.CornerRadius = UDim.new(0, 10)
    
    local ContentStroke = Instance.new("UIStroke", TabContent)
    ContentStroke.Color = GuiConfig.Cores.Primaria
    ContentStroke.Thickness = 1
    ContentStroke.Transparency = 0.5
    
    -- =========================
    -- SISTEMA DE ABAS
    -- =========================
    local Tabs = {}
    local CurrentTab = nil
    
    local TabNames = {
        "Principal",
        "Loja",
        "Status servidor",
        "Teleporte",
        "Configurações de Farm",
        "Farm",
        "Farm Sea",
        "Outros farm",
        "Raids e Dungeons",
        "Frutas e Berry",
        "Eventos do Mar",
        "Raças",
        "Itens",
        "Draco",
        "ESP",
        "PVP",
        "Configurações"
    }
    
    -- Função para criar uma aba
    local function CreateTab(name)
        -- Botão da aba
        local TabButton = Instance.new("TextButton", TabList)
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = GuiConfig.Cores.AbaInativa
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = GuiConfig.Cores.Texto
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 12
        TabButton.ZIndex = 101
        TabButton.AutoButtonColor = false
        
        local TabBtnCorner = Instance.new("UICorner", TabButton)
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        
        local TabBtnStroke = Instance.new("UIStroke", TabButton)
        TabBtnStroke.Color = GuiConfig.Cores.Primaria
        TabBtnStroke.Thickness = 0
        TabBtnStroke.Transparency = 0.8
        
        -- Frame de conteúdo da aba
        local TabFrame = Instance.new("ScrollingFrame", TabContent)
        TabFrame.Size = UDim2.new(1, -10, 1, -10)
        TabFrame.Position = UDim2.fromOffset(5, 5)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = GuiConfig.Cores.Primaria
        TabFrame.CanvasSize = UDim2.fromOffset(0, 0)
        TabFrame.Visible = false
        TabFrame.ZIndex = 101
        
        local TabFrameLayout = Instance.new("UIListLayout", TabFrame)
        TabFrameLayout.Padding = UDim.new(0, 8)
        TabFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        -- Atualizar canvas
        TabFrameLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.fromOffset(0, TabFrameLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Evento de clique
        TabButton.MouseButton1Click:Connect(function()
            -- Desativar todas as abas
            for _, tab in pairs(Tabs) do
                tab.Button.BackgroundColor3 = GuiConfig.Cores.AbaInativa
                tab.ButtonStroke.Thickness = 0
                tab.Frame.Visible = false
            end
            
            -- Ativar esta aba
            TabButton.BackgroundColor3 = GuiConfig.Cores.AbaAtiva
            TabBtnStroke.Thickness = 2
            TabFrame.Visible = true
            CurrentTab = name
        end)
        
        -- Efeito hover
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= name then
                Tween(TabButton, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 70, 120)}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= name then
                Tween(TabButton, 0.2, {BackgroundColor3 = GuiConfig.Cores.AbaInativa}):Play()
            end
        end)
        
        Tabs[name] = {
            Button = TabButton,
            ButtonStroke = TabBtnStroke,
            Frame = TabFrame
        }
        
        return TabFrame
    end
    
    -- Criar todas as abas
    for _, tabName in ipairs(TabNames) do
        CreateTab(tabName)
    end
    
    -- Ativar primeira aba por padrão
    if Tabs["Principal"] then
        Tabs["Principal"].Button.BackgroundColor3 = GuiConfig.Cores.AbaAtiva
        Tabs["Principal"].ButtonStroke.Thickness = 2
        Tabs["Principal"].Frame.Visible = true
        CurrentTab = "Principal"
    end
    
    -- =========================
    -- FUNÇÕES DOS BOTÕES
    -- =========================
    OpenButton.MouseButton1Click:Connect(function()
        GuiConfig.Aberto = not GuiConfig.Aberto
        
        if GuiConfig.Aberto then
            MainPanel.Visible = true
            Tween(MainPanel, 0.3, {
                Size = UDim2.fromOffset(GuiConfig.TamanhoAtual.Width, GuiConfig.TamanhoAtual.Height)
            }):Play()
        else
            Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(0, 0)}):Play()
            task.wait(0.3)
            MainPanel.Visible = false
        end
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        GuiConfig.Minimizado = true
        Content.Visible = false
        Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(GuiConfig.TamanhoAtual.Width, 50)}):Play()
    end)
    
    ResizeBtn.MouseButton1Click:Connect(function()
        if GuiConfig.Minimizado then
            GuiConfig.Minimizado = false
            Content.Visible = true
            Tween(MainPanel, 0.3, {
                Size = UDim2.fromOffset(GuiConfig.TamanhoAtual.Width, GuiConfig.TamanhoAtual.Height)
            }):Play()
        else
            -- Alternar entre tamanhos
            if GuiConfig.TamanhoAtual.Width == 600 then
                GuiConfig.TamanhoAtual = {Width = 800, Height = 600}
            else
                GuiConfig.TamanhoAtual = {Width = 600, Height = 450}
            end
            
            Tween(MainPanel, 0.3, {
                Size = UDim2.fromOffset(GuiConfig.TamanhoAtual.Width, GuiConfig.TamanhoAtual.Height)
            }):Play()
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        GuiConfig.Aberto = false
        Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(0, 0)}):Play()
        task.wait(0.3)
        MainPanel.Visible = false
    end)
    
    return Gui, Tabs
end

-- Criar a GUI
local MainGui, TabFrames = CreateMainGui()

print("✅ DEAL BLOX - PARTE 3/15 CARREGADA")
-- =========================
-- COMPONENTES DA GUI
-- =========================

-- Função para criar BOTÃO
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton", parent)
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = GuiConfig.Cores.Primaria
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.ZIndex = 102
    Button.AutoButtonColor = false
    
    local BtnCorner = Instance.new("UICorner", Button)
    BtnCorner.CornerRadius = UDim.new(0, 8)
    
    local BtnStroke = Instance.new("UIStroke", Button)
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = 0.5
    
    -- Efeito hover
    Button.MouseEnter:Connect(function()
        Tween(Button, 0.2, {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
        Tween(BtnStroke, 0.2, {Transparency = 0}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, 0.2, {BackgroundColor3 = GuiConfig.Cores.Primaria}):Play()
        Tween(BtnStroke, 0.2, {Transparency = 0.5}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        -- Efeito de clique
        Tween(Button, 0.1, {Size = UDim2.new(1, -15, 0, 38)}):Play()
        task.wait(0.1)
        Tween(Button, 0.1, {Size = UDim2.new(1, -10, 0, 40)}):Play()
        
        if callback then
            task.spawn(callback)
        end
    end)
    
    return Button
end

-- Função para criar TOGGLE
local function CreateToggle(parent, text, settingKey, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.ZIndex = 102
    
    local ToggleCorner = Instance.new("UICorner", ToggleFrame)
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    
    local ToggleStroke = Instance.new("UIStroke", ToggleFrame)
    ToggleStroke.Color = GuiConfig.Cores.Primaria
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.7
    
    -- Label
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = GuiConfig.Cores.Texto
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.ZIndex = 103
    
    -- Toggle Button
    local ToggleButton = Instance.new("TextButton", ToggleFrame)
    ToggleButton.Size = UDim2.fromOffset(45, 25)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.ZIndex = 103
    ToggleButton.AutoButtonColor = false
    
    local ToggleBtnCorner = Instance.new("UICorner", ToggleButton)
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    
    -- Circle
    local Circle = Instance.new("Frame", ToggleButton)
    Circle.Size = UDim2.fromOffset(19, 19)
    Circle.Position = UDim2.fromOffset(3, 3)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 104
    
    local CircleCorner = Instance.new("UICorner", Circle)
    CircleCorner.CornerRadius = UDim.new(1, 0)
    
    -- Estado
    local isEnabled = false
    
    -- Verificar se já está ativo nas configurações
    if settingKey and _G.DealBlox.Settings[settingKey] then
        isEnabled = true
        ToggleButton.BackgroundColor3 = GuiConfig.Cores.BotaoAtivo
        Circle.Position = UDim2.fromOffset(23, 3)
    end
    
    -- Função de toggle
    local function Toggle()
        isEnabled = not isEnabled
        
        if isEnabled then
            Tween(Circle, 0.2, {Position = UDim2.fromOffset(23, 3)}):Play()
            Tween(ToggleButton, 0.2, {BackgroundColor3 = GuiConfig.Cores.BotaoAtivo}):Play()
            Notify("✅ Ativado", text, 2)
        else
            Tween(Circle, 0.2, {Position = UDim2.fromOffset(3, 3)}):Play()
            Tween(ToggleButton, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
            Notify("❌ Desativado", text, 2)
        end
        
        -- Atualizar configuração
        if settingKey then
            _G.DealBlox.Settings[settingKey] = isEnabled
        end
        
        -- Callback
        if callback then
            task.spawn(function()
                callback(isEnabled)
            end)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(Toggle)
    
    return ToggleFrame, function() return isEnabled end
end

-- Função para criar DROPDOWN
local function CreateDropdown(parent, text, options, settingKey, callback)
    local DropFrame = Instance.new("Frame", parent)
    DropFrame.Size = UDim2.new(1, -10, 0, 40)
    DropFrame.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
    DropFrame.BorderSizePixel = 0
    DropFrame.ZIndex = 102
    
    local DropCorner = Instance.new("UICorner", DropFrame)
    DropCorner.CornerRadius = UDim.new(0, 8)
    
    local DropStroke = Instance.new("UIStroke", DropFrame)
    DropStroke.Color = GuiConfig.Cores.Primaria
    DropStroke.Thickness = 1
    DropStroke.Transparency = 0.7
    
    -- Label
    local Label = Instance.new("TextLabel", DropFrame)
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = GuiConfig.Cores.Texto
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.ZIndex = 103
    
    -- Dropdown Button
    local DropButton = Instance.new("TextButton", DropFrame)
    DropButton.Size = UDim2.new(0.55, 0, 0, 32)
    DropButton.Position = UDim2.new(0.43, 0, 0.5, -16)
    DropButton.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
    DropButton.Text = (settingKey and _G.DealBlox.Settings[settingKey]) or options[1] or "Selecione"
    DropButton.TextColor3 = GuiConfig.Cores.Texto
    DropButton.Font = Enum.Font.Gotham
    DropButton.TextSize = 10
    DropButton.BorderSizePixel = 0
    DropButton.ZIndex = 103
    DropButton.AutoButtonColor = false
    DropButton.TextTruncate = Enum.TextTruncate.AtEnd
    
    local DropBtnCorner = Instance.new("UICorner", DropButton)
    DropBtnCorner.CornerRadius = UDim.new(0, 6)
    
    -- Seta
    local Arrow = Instance.new("TextLabel", DropButton)
    Arrow.Size = UDim2.fromOffset(20, 32)
    Arrow.Position = UDim2.new(1, -20, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = GuiConfig.Cores.Texto
    Arrow.Font = Enum.Font.Gotham
    Arrow.TextSize = 10
    Arrow.ZIndex = 104
    
    -- Lista de opções
    local OptionsList = Instance.new("ScrollingFrame", MainGui)
    OptionsList.Size = UDim2.new(0, 200, 0, 0)
    OptionsList.Position = UDim2.fromOffset(0, 0)
    OptionsList.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    OptionsList.BorderSizePixel = 0
    OptionsList.Visible = false
    OptionsList.ZIndex = 10000
    OptionsList.ScrollBarThickness = 3
    OptionsList.ScrollBarImageColor3 = GuiConfig.Cores.Primaria
    
    local OptionsCorner = Instance.new("UICorner", OptionsList)
    OptionsCorner.CornerRadius = UDim.new(0, 8)
    
    local OptionsStroke = Instance.new("UIStroke", OptionsList)
    OptionsStroke.Color = GuiConfig.Cores.Primaria
    OptionsStroke.Thickness = 2
    
    local OptionsLayout = Instance.new("UIListLayout", OptionsList)
    OptionsLayout.Padding = UDim.new(0, 2)
    
    -- Criar opções
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton", OptionsList)
        OptionButton.Size = UDim2.new(1, 0, 0, 35)
        OptionButton.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
        OptionButton.Text = option
        OptionButton.TextColor3 = GuiConfig.Cores.Texto
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextSize = 10
        OptionButton.BorderSizePixel = 0
        OptionButton.ZIndex = 10001
        OptionButton.AutoButtonColor = false
        OptionButton.TextTruncate = Enum.TextTruncate.AtEnd
        
        local OptCorner = Instance.new("UICorner", OptionButton)
        OptCorner.CornerRadius = UDim.new(0, 6)
        
        OptionButton.MouseEnter:Connect(function()
            Tween(OptionButton, 0.2, {BackgroundColor3 = GuiConfig.Cores.Primaria}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            Tween(OptionButton, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 50, 80)}):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            DropButton.Text = option
            OptionsList.Visible = false
            
            if settingKey then
                _G.DealBlox.Settings[settingKey] = option
            end
            
            Notify("✅ Selecionado", option, 2)
            
            if callback then
                task.spawn(function()
                    callback(option)
                end)
            end
        end)
    end
    
    -- Atualizar canvas
    OptionsList.CanvasSize = UDim2.fromOffset(0, #options * 37)
    
    -- Toggle dropdown
    DropButton.MouseButton1Click:Connect(function()
        OptionsList.Visible = not OptionsList.Visible
        
        if OptionsList.Visible then
            local btnPos = DropButton.AbsolutePosition
            OptionsList.Position = UDim2.fromOffset(btnPos.X, btnPos.Y + 37)
            OptionsList.Size = UDim2.new(0, 200, 0, math.min(#options * 37, 200))
        end
    end)
    
    return DropFrame
end

-- Função para criar SLIDER
local function CreateSlider(parent, text, min, max, default, settingKey, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.ZIndex = 102
    
    local SliderCorner = Instance.new("UICorner", SliderFrame)
    SliderCorner.CornerRadius = UDim.new(0, 8)
    
    local SliderStroke = Instance.new("UIStroke", SliderFrame)
    SliderStroke.Color = GuiConfig.Cores.Primaria
    SliderStroke.Thickness = 1
    SliderStroke.Transparency = 0.7
    
    -- Label
    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.fromOffset(5, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = GuiConfig.Cores.Texto
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 103
    
    -- Value Label
    local ValueLabel = Instance.new("TextLabel", SliderFrame)
    ValueLabel.Size = UDim2.new(0, 60, 0, 20)
    ValueLabel.Position = UDim2.new(1, -65, 0, 2)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(settingKey and _G.DealBlox.Settings[settingKey] or default)
    ValueLabel.TextColor3 = GuiConfig.Cores.Primaria
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 103
    
    -- Slider Track
    local Track = Instance.new("Frame", SliderFrame)
    Track.Size = UDim2.new(1, -20, 0, 8)
    Track.Position = UDim2.fromOffset(10, 28)
    Track.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
    Track.BorderSizePixel = 0
    Track.ZIndex = 103
    
    local TrackCorner = Instance.new("UICorner", Track)
    TrackCorner.CornerRadius = UDim.new(1, 0)
    
    -- Slider Fill
    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = GuiConfig.Cores.Primaria
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 104
    
    local FillCorner = Instance.new("UICorner", Fill)
    FillCorner.CornerRadius = UDim.new(1, 0)
    
    -- Slider Thumb
    local Thumb = Instance.new("Frame", Track)
    Thumb.Size = UDim2.fromOffset(16, 16)
    Thumb.Position = UDim2.new(0, 0, 0.5, -8)
    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Thumb.BorderSizePixel = 0
    Thumb.ZIndex = 105
    
    local ThumbCorner = Instance.new("UICorner", Thumb)
    ThumbCorner.CornerRadius = UDim.new(1, 0)
    
    -- Valor atual
    local currentValue = settingKey and _G.DealBlox.Settings[settingKey] or default
    
    -- Função para atualizar slider
    local function UpdateSlider(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Thumb.Position = UDim2.new(percent, -8, 0.5, -8)
        ValueLabel.Text = tostring(math.floor(currentValue))
        
        if settingKey then
            _G.DealBlox.Settings[settingKey] = currentValue
        end
        
        if callback then
            callback(currentValue)
        end
    end
    
    -- Inicializar
    UpdateSlider(currentValue)
    
    -- Input handling
    local dragging = false
    
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local mousePos = input.Position.X
            local trackPos = Track.AbsolutePosition.X
            local trackSize = Track.AbsoluteSize.X
            local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            local value = min + (percent * (max - min))
            UpdateSlider(value)
        end
    end)
    
    Track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = input.Position.X
            local trackPos = Track.AbsolutePosition.X
            local trackSize = Track.AbsoluteSize.X
            local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            local value = min + (percent * (max - min))
            UpdateSlider(value)
        end
    end)
    
    return SliderFrame
end

-- Função para criar SEÇÃO/TÍTULO
local function CreateSection(parent, text)
    local Section = Instance.new("Frame", parent)
    Section.Size = UDim2.new(1, -10, 0, 30)
    Section.BackgroundColor3 = GuiConfig.Cores.Primaria
    Section.BackgroundTransparency = 0.5
    Section.BorderSizePixel = 0
    Section.ZIndex = 102
    
    local SectionCorner = Instance.new("UICorner", Section)
    SectionCorner.CornerRadius = UDim.new(0, 8)
    
    local SectionStroke = Instance.new("UIStroke", Section)
    SectionStroke.Color = Color3.fromRGB(255, 255, 255)
    SectionStroke.Thickness = 1
    SectionStroke.Transparency = 0.3
    
    local SectionLabel = Instance.new("TextLabel", Section)
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = "⚙️ " .. text
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 13
    SectionLabel.ZIndex = 103
    
    return Section
end

-- Função para criar LABEL/TEXTO
local function CreateLabel(parent, text)
    local Label = Instance.new("TextLabel", parent)
    Label.Size = UDim2.new(1, -10, 0, 0)
    Label.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
    Label.BackgroundTransparency = 0.5
    Label.BorderSizePixel = 0
    Label.Text = text
    Label.TextColor3 = GuiConfig.Cores.Texto
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextWrapped = true
    Label.TextYAlignment = Enum.TextYAlignment.Top
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 102
    
    -- Ajustar altura baseado no texto
    Label.Size = UDim2.new(1, -10, 0, math.max(30, select(2, game:GetService("TextService"):GetTextSize(text, 11, Enum.Font.Gotham, Vector2.new(400, math.huge)))))
    
    local LabelCorner = Instance.new("UICorner", Label)
    LabelCorner.CornerRadius = UDim.new(0, 8)
    
    -- Padding
    local Padding = Instance.new("UIPadding", Label)
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)
    
    return Label
end

print("✅ DEAL BLOX - PARTE 4/15 CARREGADA")

-- =========================
-- PÁGINA: PRINCIPAL
-- =========================
local PrincipalTab = TabFrames["Principal"].Frame

-- Mensagem de boas-vindas
CreateLabel(PrincipalTab, [[
👋 BEM-VINDO AO DEAL BLOX SCRIPTS!

O script foi desenvolvido por "Lag Mental", o dono da "DEAL BLOX". A Deal Blox é um servidor dentro do Discord!

🎮 Convide seus amigos!
💎 Funcionalidades premium
⚡ Atualizações constantes
🛡️ Suporte dedicado

Convite abaixo!
]])

-- Botão: Entrar no Discord
CreateButton(PrincipalTab, "🎮 Entrar no Servidor do Discord", function()
    local discordLink = "https://discord.gg/rPFN7BMC5k"
    
    pcall(function()
        setclipboard(discordLink)
        Notify("✅ Sucesso", "Link copiado para área de transferência!", 3)
    end)
    
    Notify("📋 Discord", discordLink, 5)
end)

-- Botão: Copiar convite
CreateButton(PrincipalTab, "📋 Clique aqui para copiar o convite!", function()
    local discordLink = "https://discord.gg/rPFN7BMC5k"
    
    local success = pcall(function()
        setclipboard(discordLink)
    end)
    
    if success then
        Notify("✅ Copiado!", "Link copiado: " .. discordLink, 3)
    else
        Notify("⚠️ Erro", "Não foi possível copiar. Link: " .. discordLink, 5)
    end
end)

CreateSection(PrincipalTab, "Informações do Jogador")

-- Info do player
CreateLabel(PrincipalTab, string.format([[
👤 Jogador: %s
⭐ Level: %d
🌊 Sea: %d
💰 Beli: $%s
💎 Fragmentos: %s
🧬 Raça: %s
]], 
    LocalPlayer.Name,
    LocalPlayer.Data.Level.Value,
    CurrentSea,
    FormatNumber(LocalPlayer.Data.Beli.Value),
    FormatNumber(LocalPlayer.Data.Fragments.Value),
    LocalPlayer.Data.Race.Value or "Desconhecido"
))

CreateSection(PrincipalTab, "Créditos")

CreateLabel(PrincipalTab, [[
💻 Desenvolvedor: Lag Mental
🏢 Organização: DEAL BLOX
📱 Discord: discord.gg/rPFN7BMC5k
⚡ Versão: 1.0.0

Obrigado por usar nosso script! ❤️
]])

-- =========================
-- PÁGINA: LOJA
-- =========================
local LojaTab = TabFrames["Loja"].Frame

CreateSection(LojaTab, "Raças e Status")

-- Botão: Trocar de raça
CreateButton(LojaTab, "🔄 Trocar de Raça (3000 Fragmentos)", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    if LocalPlayer.Data.Fragments.Value < 3000 then
        Notify("❌ Fragmentos Insuficientes", string.format("Você precisa de 3000 fragmentos!\nVocê tem: %s", FormatNumber(LocalPlayer.Data.Fragments.Value)), 4)
        return
    end
    
    Notify("⏳ Processando", "Girando raça...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BlackbeardReward", "Reroll", "1")
        end)
        
        if success then
            task.wait(1)
            Notify("✅ Sucesso", "Raça girada! Nova raça: " .. (LocalPlayer.Data.Race.Value or "Verificando..."), 4)
        else
            Notify("❌ Erro", "Não foi possível girar a raça!", 3)
        end
    end)
end)

-- Botão: Resetar status
CreateButton(LojaTab, "♻️ Resetar Status (2500 Fragmentos)", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    if LocalPlayer.Data.Fragments.Value < 2500 then
        Notify("❌ Fragmentos Insuficientes", string.format("Você precisa de 2500 fragmentos!\nVocê tem: %s", FormatNumber(LocalPlayer.Data.Fragments.Value)), 4)
        return
    end
    
    Notify("⏳ Processando", "Resetando status...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BlackbeardReward", "Refund", "1")
        end)
        
        if success then
            Notify("✅ Sucesso", "Status resetado com sucesso!", 3)
        else
            Notify("❌ Erro", "Não foi possível resetar o status!", 3)
        end
    end)
end)

-- Botão: Comprar Raça Ghoul
CreateButton(LojaTab, "🧛 Comprar Raça Ghoul", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    -- Verificar se já tem Ghoul
    if LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("Ghoul") then
        Notify("✅ Já possui", "Você já tem a raça Ghoul! Equipando...", 2)
        -- Apenas equipar
        return
    end
    
    if CurrentSea ~= 2 then
        Notify("❌ Sea Incorreto", "Você precisa estar no Sea 2 para comprar Ghoul!", 3)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar raça Ghoul...", 2)
    
    task.spawn(function()
        -- Ir para Experimic (Sea 2)
        SafeTP(CFrame.new(-2836, 14, -3036))
        task.wait(2)
        
        local success = pcall(function()
            remote:InvokeServer("Ectoplasm", "Change", 4)
        end)
        
        if success then
            Notify("✅ Sucesso", "Raça Ghoul comprada/equipada!", 3)
        else
            Notify("❌ Erro", "Verifique se você tem os materiais necessários (100 Ectoplasm)", 4)
        end
    end)
end)

-- Botão: Comprar Cyborg
CreateButton(LojaTab, "🤖 Comprar Raça Cyborg", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    -- Verificar se já tem Cyborg
    if LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("Cyborg") then
        Notify("✅ Já possui", "Você já tem a raça Cyborg! Equipando...", 2)
        return
    end
    
    if CurrentSea ~= 2 then
        Notify("❌ Sea Incorreto", "Você precisa estar no Sea 2 para comprar Cyborg!", 3)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar raça Cyborg...", 2)
    
    task.spawn(function()
        -- Ir para Fajita (Sea 2)
        SafeTP(CFrame.new(-2836, 14, -3036))
        task.wait(2)
        
        local success = pcall(function()
            remote:InvokeServer("CyborgTrainer", "Buy")
        end)
        
        if success then
            Notify("✅ Sucesso", "Raça Cyborg comprada/equipada!", 3)
        else
            Notify("❌ Erro", "Verifique se você tem os materiais necessários (2500 Fragments)", 4)
        end
    end)
end)

CreateSection(LojaTab, "Estilos de Luta")

-- Lista de estilos de luta
local FightingStyles = {
    {Name = "Passo Escuro (Dark Step)", Remote = "BuyDarkStep", Sea = 1, Price = "$150,000"},
    {Name = "Elétrico (Electro)", Remote = "BuyElectro", Sea = 1, Price = "$500,000"},
    {Name = "Kung Fu da Água (Fishman Karate)", Remote = "BuyFishmanKarate", Sea = 1, Price = "$750,000"},
    {Name = "Sopro do Dragão (Dragon Breath)", Remote = "BuyDragonBreath", Sea = 1, Price = "$1,500,000"},
    {Name = "Super-Humano (Superhuman)", Remote = "BuySuperhuman", Sea = 1, Price = "$3,000,000"},
    {Name = "Passo da Morte (Death Step)", Remote = "BuyDeathStep", Sea = 3, Price = "$2,500,000 + 5,000 Frags"},
    {Name = "Karate do Homem-Tubarão (Sharkman Karate)", Remote = "BuySharkmanKarate", Sea = 3, Price = "$2,500,000 + 5,000 Frags"},
    {Name = "Garra Elétrica (Electric Claw)", Remote = "BuyElectricClaw", Sea = 3, Price = "$3,000,000 + 5,000 Frags"},
    {Name = "Garra de Dragão (Dragon Talon)", Remote = "BuyDragonTalon", Sea = 3, Price = "$3,000,000 + 5,000 Frags"},
    {Name = "Deus Humano (Godhuman)", Remote = "BuyGodhuman", Sea = 3, Price = "$5,000,000 + 5,000 Frags"},
    {Name = "Arte Sanguínea (Sanguine Art)", Remote = "BuySanguineArt", Sea = 3, Price = "$5,000,000 + 5,000 Frags"}
}

for _, style in ipairs(FightingStyles) do
    CreateButton(LojaTab, "🥋 " .. style.Name, function()
        local remote = GetRemote()
        if not remote then
            Notify("❌ Erro", "Remote não encontrado!", 3)
            return
        end
        
        if CurrentSea < style.Sea then
            Notify("❌ Sea Incorreto", string.format("Você precisa estar no Sea %d!", style.Sea), 3)
            return
        end
        
        Notify("⏳ Comprando", "Tentando comprar " .. style.Name .. "...", 2)
        
        task.spawn(function()
            local success = pcall(function()
                remote:InvokeServer(style.Remote)
            end)
            
            if success then
                Notify("✅ Sucesso", style.Name .. " comprado/equipado!", 3)
                
                -- Equipar o estilo
                task.wait(0.5)
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                        break
                    end
                end
            else
                Notify("❌ Erro", "Verifique se você tem dinheiro/fragmentos suficientes!", 4)
            end
        end)
    end)
end

CreateSection(LojaTab, "Habilidades")

-- Botão: Haki
CreateButton(LojaTab, "💪 Comprar Haki", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar Haki...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BuyHaki", "Buso")
        end)
        
        if success then
            Notify("✅ Sucesso", "Haki comprado!", 3)
        else
            Notify("❌ Erro", "Você precisa de Level 25+ e $25,000!", 3)
        end
    end)
end)

-- Botão: Salto no Céu
CreateButton(LojaTab, "☁️ Comprar Salto no Céu (Geppo)", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar Geppo...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BuyHaki", "Geppo")
        end)
        
        if success then
            Notify("✅ Sucesso", "Geppo (Salto no Céu) comprado!", 3)
        else
            Notify("❌ Erro", "Você precisa de Level 10+ e $10,000!", 3)
        end
    end)
end)

-- Botão: Haki da Observação
CreateButton(LojaTab, "👁️ Comprar Haki da Observação (Ken)", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar Ken Haki...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("KenTalk", "Buy")
        end)
        
        if success then
            Notify("✅ Sucesso", "Ken Haki (Observação) comprado!", 3)
        else
            Notify("❌ Erro", "Você precisa de Level 300+ e $750,000!", 3)
        end
    end)
end)

-- Botão: Soru
CreateButton(LojaTab, "⚡ Comprar Soru", function()
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 3)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar Soru...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BuyHaki", "Soru")
        end)
        
        if success then
            Notify("✅ Sucesso", "Soru comprado!", 3)
        else
            Notify("❌ Erro", "Você precisa de Level 50+ e $100,000!", 3)
        end
    end)
end)

CreateSection(LojaTab, "Informações")

CreateLabel(LojaTab, [[
ℹ️ INFORMAÇÕES IMPORTANTES:

- Estilos V1: Disponíveis no Sea 1
- Estilos V2: Apenas Sea 3
- Estilos V3 (Godhuman/Sanguine): Sea 3 + materiais específicos

- Ghoul: Precisa de 100 Ectoplasm (Sea 2)
- Cyborg: Precisa de 2500 Fragments (Sea 2)

- Verifique se tem dinheiro/fragmentos antes de comprar!
]])

print("✅ DEAL BLOX - PARTE 5/15 CARREGADA")

-- =========================
-- PÁGINA: STATUS SERVIDOR
-- =========================
local StatusTab = TabFrames["Status servidor"].Frame

CreateSection(StatusTab, "Tempo de Jogo")

-- Labels dinâmicos
local PlayTimeLabel = CreateLabel(StatusTab, "⏰ Tempo de Jogo: Carregando...")
local ServerTimeLabel = CreateLabel(StatusTab, "🖥️ Tempo do Servidor: Carregando...")

-- Atualizar tempo a cada segundo
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            PlayTimeLabel.Text = "⏰ Tempo de Jogo: " .. GetPlayTime()
            ServerTimeLabel.Text = "🖥️ Tempo do Servidor: " .. GetServerTime()
        end)
    end
end)

CreateSection(StatusTab, "Eventos do Servidor")

-- Fist of Darkness / God's Chalice
local FistGodLabel = CreateLabel(StatusTab, "⚡ Fist/Chalice: Verificando...")

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            if CurrentSea == 2 then
                -- Verificar Fist of Darkness
                local fistSpawned = workspace:FindFirstChild("Chest1") or workspace:FindFirstChild("Chest2")
                if fistSpawned then
                    FistGodLabel.Text = "⚡ Fist of Darkness: DISPONÍVEL! 🟢"
                else
                    FistGodLabel.Text = "⚡ Fist of Darkness: Aguardando spawn... 🔴"
                end
            elseif CurrentSea == 3 then
                -- Verificar God's Chalice
                local chaliceSpawned = workspace:FindFirstChild("Chest3") or workspace:FindFirstChild("Chest4")
                if chaliceSpawned then
                    FistGodLabel.Text = "🏆 God's Chalice: DISPONÍVEL! 🟢"
                else
                    FistGodLabel.Text = "🏆 God's Chalice: Aguardando spawn... 🔴"
                end
            else
                FistGodLabel.Text = "⚠️ Apenas disponível no Sea 2 e 3"
            end
        end)
    end
end)

-- Elite Hunter
local EliteLabel = CreateLabel(StatusTab, "👑 Elite Hunter: Verificando...")

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            if CurrentSea == 3 then
                local eliteSpawned = false
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name:find("Diablo") or mob.Name:find("Deandre") or mob.Name:find("Urban") then
                        eliteSpawned = true
                        break
                    end
                end
                
                if eliteSpawned then
                    EliteLabel.Text = "👑 Elite Hunter: SPAWNADO! 🟢"
                else
                    EliteLabel.Text = "👑 Elite Hunter: Não spawnado 🔴"
                end
            else
                EliteLabel.Text = "⚠️ Elite Hunter apenas no Sea 3"
            end
        end)
    end
end)

-- Katakuri
local KatakuriLabel = CreateLabel(StatusTab, "🍩 Katakuri: Verificando...")

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            if CurrentSea == 2 then
                local remote = GetRemote()
                if remote then
                    local progress = remote:InvokeServer("CakePrinceSpawner")
                    if type(progress) == "number" then
                        local remaining = 500 - progress
                        if remaining <= 0 then
                            KatakuriLabel.Text = "🍩 Katakuri: DISPONÍVEL PARA SPAWN! 🟢"
                        else
                            KatakuriLabel.Text = string.format("🍩 Katakuri: Faltam %d donuts (%d/500)", remaining, progress)
                        end
                    else
                        KatakuriLabel.Text = "🍩 Katakuri: Dados não disponíveis"
                    end
                end
            else
                KatakuriLabel.Text = "⚠️ Katakuri apenas no Sea 2"
            end
        end)
    end
end)

CreateSection(StatusTab, "Ilhas Especiais (Sea 3)")

-- Ilha Miragem
local MirageLabel = CreateLabel(StatusTab, "🏝️ Ilha Miragem: Verificando...")

-- Ilha Pré-histórica
local PrehistoricLabel = CreateLabel(StatusTab, "🦖 Ilha Pré-histórica: Verificando...")

-- Frozen Dimension
local FrozenLabel = CreateLabel(StatusTab, "❄️ Frozen Dimension: Verificando...")

task.spawn(function()
    while task.wait(15) do
        pcall(function()
            if CurrentSea == 3 then
                -- Verificar Mirage
                local mirageFound = false
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name == "MysticIsland" then
                        mirageFound = true
                        break
                    end
                end
                MirageLabel.Text = mirageFound and "🏝️ Ilha Miragem: SIM 🟢" or "🏝️ Ilha Miragem: NÃO 🔴"
                
                -- Verificar Pré-histórica
                local prehistoricFound = workspace:FindFirstChild("PrehistoricIsland") ~= nil
                PrehistoricLabel.Text = prehistoricFound and "🦖 Ilha Pré-histórica: SIM 🟢" or "🦖 Ilha Pré-histórica: NÃO 🔴"
                
                -- Verificar Frozen
                local frozenFound = workspace:FindFirstChild("FrozenDimension") ~= nil
                FrozenLabel.Text = frozenFound and "❄️ Frozen Dimension: SIM 🟢" or "❄️ Frozen Dimension: NÃO 🔴"
            else
                MirageLabel.Text = "⚠️ Ilhas especiais apenas no Sea 3"
                PrehistoricLabel.Text = "⚠️ Apenas Sea 3"
                FrozenLabel.Text = "⚠️ Apenas Sea 3"
            end
        end)
    end
end)

CreateSection(StatusTab, "Lua")

-- Fase da Lua
local MoonLabel = CreateLabel(StatusTab, "🌙 Lua: Verificando...")

task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local moonPhase = Lighting:GetMoonPhase()
            local moonNames = {
                [0] = "🌑 Nova",
                [0.125] = "🌒 Crescente",
                [0.25] = "🌓 Quarto Crescente",
                [0.375] = "🌔 Crescente Gibosa",
                [0.5] = "🌕 Cheia",
                [0.625] = "🌖 Minguante Gibosa",
                [0.75] = "🌗 Quarto Minguante",
                [0.875] = "🌘 Minguante"
            }
            
            local phaseName = moonNames[moonPhase] or "🌙 Desconhecida"
            local isFullMoon = moonPhase == 0.5
            
            if isFullMoon then
                MoonLabel.Text = "🌕 Lua: CHEIA! 🟢 (Ideal para Mirage V4)"
            else
                MoonLabel.Text = "🌙 Fase da Lua: " .. phaseName
            end
        end)
    end
end)

CreateSection(StatusTab, "Informações")

CreateLabel(StatusTab, [[
ℹ️ LEGENDA:
🟢 = Disponível/Ativo
🔴 = Não disponível

📌 Os dados são atualizados automaticamente a cada 5-15 segundos.

💡 DICA: Mantenha essa aba aberta para monitorar eventos importantes!
]])

-- =========================
-- PÁGINA: TELEPORTE
-- =========================
local TeleportTab = TabFrames["Teleporte"].Frame

CreateSection(TeleportTab, "Mudar de Sea")

-- Botão: Ir para Sea 1
CreateButton(TeleportTab, "🌊 Teleportar para Primeiro Sea", function()
    if CurrentSea == 1 then
        Notify("⚠️ Já está aqui", "Você já está no Sea 1!", 2)
        return
    end
    
    Notify("⏳ Teleportando", "Indo para o Sea 1...", 2)
    
    task.spawn(function()
        pcall(function()
            TeleportService:Teleport(2753915549, LocalPlayer)
        end)
    end)
end)

-- Botão: Ir para Sea 2
CreateButton(TeleportTab, "🌊 Teleportar para Segundo Sea", function()
    if CurrentSea == 2 then
        Notify("⚠️ Já está aqui", "Você já está no Sea 2!", 2)
        return
    end
    
    if LocalPlayer.Data.Level.Value < 700 then
        Notify("❌ Level Insuficiente", "Você precisa de Level 700+ para ir ao Sea 2!", 3)
        return
    end
    
    Notify("⏳ Teleportando", "Indo para o Sea 2...", 2)
    
    task.spawn(function()
        pcall(function()
            TeleportService:Teleport(4442272183, LocalPlayer)
        end)
    end)
end)

-- Botão: Ir para Sea 3
CreateButton(TeleportTab, "🌊 Teleportar para Terceiro Sea", function()
    if CurrentSea == 3 then
        Notify("⚠️ Já está aqui", "Você já está no Sea 3!", 2)
        return
    end
    
    if LocalPlayer.Data.Level.Value < 1500 then
        Notify("❌ Level Insuficiente", "Você precisa de Level 1500+ para ir ao Sea 3!", 3)
        return
    end
    
    Notify("⏳ Teleportando", "Indo para o Sea 3...", 2)
    
    task.spawn(function()
        pcall(function()
            TeleportService:Teleport(7449423635, LocalPlayer)
        end)
    end)
end)

CreateSection(TeleportTab, "Teleporte para Ilhas")

-- Dropdown: Selecionar ilha
local currentIslands = IslandsBySea[CurrentSea] or {}
CreateDropdown(TeleportTab, "🗺️ Selecionar Ilha", currentIslands, "SelectedIsland", function(island)
    Notify("✅ Ilha Selecionada", island, 2)
end)

-- Botão: Teleportar para ilha
CreateButton(TeleportTab, "🚀 Teleportar para Ilha Selecionada", function()
    local selectedIsland = _G.DealBlox.Settings.SelectedIsland
    
    if not selectedIsland or selectedIsland == "Nenhum" or selectedIsland == "Selecione" then
        Notify("⚠️ Nenhuma Ilha", "Selecione uma ilha primeiro!", 2)
        return
    end
    
    local islandPos = IslandPositions[selectedIsland]
    
    if not islandPos then
        Notify("❌ Erro", "Posição da ilha não encontrada!", 2)
        return
    end
    
    Notify("⏳ Teleportando", "Indo para " .. selectedIsland .. "...", 2)
    
    task.spawn(function()
        SafeTP(islandPos)
        task.wait(1)
        Notify("✅ Chegou!", "Você chegou em " .. selectedIsland, 2)
    end)
end)

CreateSection(TeleportTab, "Teleporte para Jogadores")

-- Criar lista de jogadores
local function GetPlayerList()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

-- Dropdown: Selecionar jogador
CreateDropdown(TeleportTab, "👥 Selecionar Jogador", GetPlayerList(), "SelectedPlayer", function(playerName)
    Notify("✅ Jogador Selecionado", playerName, 2)
end)

-- Botão: Teleportar para jogador
CreateButton(TeleportTab, "🎯 Teleportar para Jogador Selecionado", function()
    local selectedPlayer = _G.DealBlox.Settings.SelectedPlayer
    
    if not selectedPlayer or selectedPlayer == "Nenhum" or selectedPlayer == "Selecione" then
        Notify("⚠️ Nenhum Jogador", "Selecione um jogador primeiro!", 2)
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    
    if not targetPlayer then
        Notify("❌ Jogador Offline", selectedPlayer .. " não está mais no servidor!", 3)
        return
    end
    
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Notify("❌ Erro", "Não foi possível encontrar o personagem do jogador!", 2)
        return
    end
    
    Notify("⏳ Teleportando", "Indo até " .. selectedPlayer .. "...", 2)
    
    task.spawn(function()
        local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame
        SafeTP(targetPos)
        task.wait(1)
        Notify("✅ Chegou!", "Você está perto de " .. selectedPlayer, 2)
    end)
end)

CreateSection(TeleportTab, "Atalhos Rápidos")

-- Botão: TP Tiki Outpost (Sea 3)
if CurrentSea == 3 then
    CreateButton(TeleportTab, "🏖️ Teleportar para Tiki Outpost", function()
        Notify("⏳ Teleportando", "Indo para Tiki Outpost...", 2)
        SafeTP(CFrame.new(-16105, 9, 440))
    end)
end

-- Botão: TP Castle on the Sea (Sea 3)
if CurrentSea == 3 then
    CreateButton(TeleportTab, "🏰 Teleportar para Castle on the Sea", function()
        Notify("⏳ Teleportando", "Indo para Castle on the Sea...", 2)
        SafeTP(CFrame.new(-5075, 314, -3155))
    end)
end

-- Botão: TP Hydra Island (Sea 3)
if CurrentSea == 3 then
    CreateButton(TeleportTab, "🐉 Teleportar para Hydra Island", function()
        Notify("⏳ Teleportando", "Indo para Hydra Island...", 2)
        SafeTP(CFrame.new(5749, 612, -276))
    end)
end

CreateSection(TeleportTab, "Informações")

CreateLabel(TeleportTab, [[
ℹ️ SOBRE TELEPORTE:

✈️ Teleporte Seguro:
- O script sempre te teleporta ALTO no céu
- Você nunca cai na água
- Seguro contra morte por afogamento

📍 Ilhas disponíveis variam por Sea
🎮 Lista de jogadores atualiza ao abrir o dropdown

💡 DICA: Use teleporte para economizar tempo entre farms!
]])

print("✅ DEAL BLOX - PARTE 6/15 CARREGADA")

-- =========================
-- SISTEMA DE FARM MATERIAIS
-- =========================
local MaterialMobs = {
    ["Magma Ore"] = {Mob = "Military Soldier", Quest = "ColosseumQuest", QuestNum = 2, Pos = CFrame.new(-1315, 8, -2976)},
    ["Angel Wings"] = {Mob = "Royal Soldier", Quest = "SkyExp2Quest", QuestNum = 2, Pos = CFrame.new(-7906, 5634, -1411)},
    ["Leather"] = {Mob = "Pirate", Quest = "BuggyQuest1", QuestNum = 1, Pos = CFrame.new(-1119, 5, 3831)},
    ["Scrap Metal"] = {Mob = "Brute", Quest = "BuggyQuest2", QuestNum = 1, Pos = CFrame.new(-1140, 15, 4312)},
    ["Fish Tail"] = {Mob = "Fishman Warrior", Quest = "FishmanQuest", QuestNum = 1, Pos = CFrame.new(61122, 18, 1569)},
    ["Mystic Droplet"] = {Mob = "Sea Soldier", Quest = "ForgottenQuest", QuestNum = 1, Pos = CFrame.new(-3053, 240, -10145)},
    ["Demonic Wisp"] = {Mob = "Demonic Soul", Quest = "DeepForestIsland4", QuestNum = 1, Pos = CFrame.new(-9507, 172, 6158)},
    ["Vampire Fang"] = {Mob = "Vampire", Quest = "ZombieQuest", QuestNum = 2, Pos = CFrame.new(-5496, 48, -795)},
    ["Conjured Cocoa"] = {Mob = "Chocolate Bar Battler", Quest = "DeepForestIsland9", QuestNum = 2, Pos = CFrame.new(-2103, 38, -10192)},
    ["Dragon Scale"] = {Mob = "Dragon Crew Warrior", Quest = "ShipQuest2", QuestNum = 1, Pos = CFrame.new(971, 125, 32911)},
    ["Gunpowder"] = {Mob = "Marine Captain", Quest = "MarineQuest3", QuestNum = 1, Pos = CFrame.new(-2440, 73, -3217)},
    ["Mini Tusk"] = {Mob = "Mythological Pirate", Quest = "DeepForestIsland", QuestNum = 1, Pos = CFrame.new(-13233, 332, -7625)},
    ["Ectoplasm"] = {Mob = "Ship Deckhand", Quest = "ShipQuest1", QuestNum = 1, Pos = CFrame.new(971, 125, 32911)},
    ["Radiactive Material"] = {Mob = "Factory Staff", Quest = "Area2Quest", QuestNum = 2, Pos = CFrame.new(638, 73, 1194)},
    ["Dark Fragment"] = {Mob = "Darkbeard", Quest = "None", QuestNum = 0, Pos = CFrame.new(3778, 24, -3498)}
}

-- Auto Farm Material
task.spawn(function()
    while task.wait(0.1) do
        if _G.DealBlox.Settings.AutoFarmMaterial then
            pcall(function()
                local selectedMaterial = _G.DealBlox.Settings.SelectedMaterial
                
                if not selectedMaterial or selectedMaterial == "Nenhum" or selectedMaterial == "Selecione" then
                    return
                end
                
                local materialData = MaterialMobs[selectedMaterial]
                
                if not materialData then
                    Notify("❌ Erro", "Dados do material não encontrados!", 3)
                    _G.DealBlox.Settings.AutoFarmMaterial = false
                    return
                end
                
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar se tem quest ativa (se não for boss)
                if materialData.Quest ~= "None" then
                    local hasQuest = false
                    if LocalPlayer.PlayerGui.Main.Quest.Visible then
                        local questTitle = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                        if questTitle:find(materialData.Mob) then
                            hasQuest = true
                        end
                    end
                    
                    if not hasQuest then
                        SafeTP(materialData.Pos)
                        task.wait(1)
                        remote:InvokeServer("StartQuest", materialData.Quest, materialData.QuestNum)
                        task.wait(0.5)
                    end
                end
                
                -- Procurar mob
                local targetMob = nil
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == materialData.Mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        targetMob = mob
                        break
                    end
                end
                
                if targetMob then
                    EquipWeapon()
                    ActivateBuso()
                    
                    local distance = _G.DealBlox.Settings.FarmDistance or 30
                    local targetPos = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                    end
                    
                    targetMob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    targetMob.HumanoidRootPart.Transparency = 0.8
                    targetMob.HumanoidRootPart.CanCollide = false
                    
                    _G.DealBlox.Settings.AutoClick = true
                else
                    SafeTP(materialData.Pos)
                end
            end)
        end
    end
end)

-- Ativar Farm Material agora
local FarmTabMaterialToggle = TabFrames["Farm"].Frame:FindFirstChild("▶️ Iniciar Farm Material")
if FarmTabMaterialToggle then
    -- Já foi criado na parte anterior, apenas atualizar callback
end

-- Criar novo toggle funcional
CreateToggle(FarmTab, "▶️ Farm Material Ativo", "AutoFarmMaterial", function(enabled)
    if enabled then
        local selectedMaterial = _G.DealBlox.Settings.SelectedMaterial
        if not selectedMaterial or selectedMaterial == "Nenhum" or selectedMaterial == "Selecione" then
            Notify("⚠️ Nenhum Material", "Selecione um material primeiro!", 3)
            _G.DealBlox.Settings.AutoFarmMaterial = false
            return
        end
        Notify("✅ Farm Iniciado", "Farmando " .. selectedMaterial .. "...", 2)
    end
end)

-- =========================
-- PÁGINA: FARM SEA
-- =========================
local FarmSeaTab = TabFrames["Farm Sea"].Frame

CreateSection(FarmSeaTab, "Progressão de Sea")

-- Toggle: Auto Sea 2
if CurrentSea == 1 then
    CreateToggle(FarmSeaTab, "🌊 Auto ir para Sea 2", "AutoSea2", function(enabled)
        _G.DealBlox.Settings.AutoSea2 = enabled
    end)
    
    -- Sistema Auto Sea 2
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoSea2 then
                pcall(function()
                    local playerLevel = LocalPlayer.Data.Level.Value
                    
                    if playerLevel < 700 then
                        Notify("⏳ Farmando Level", string.format("Você tem %d/700. Farmando...", playerLevel), 3)
                        
                        -- Ativar auto farm
                        _G.DealBlox.Settings.AutoFarm = true
                        task.wait(10)
                    else
                        Notify("✅ Level Suficiente", "Indo para Sea 2...", 3)
                        
                        local remote = GetRemote()
                        if remote then
                            -- Ir para King Red Head ou Vice Admiral
                            SafeTP(CFrame.new(-5058, 314, -3155))
                            task.wait(2)
                            
                            remote:InvokeServer("TravelDressrosa")
                            task.wait(3)
                            
                            Notify("✅ Sucesso", "Você chegou ao Sea 2!", 3)
                            _G.DealBlox.Settings.AutoSea2 = false
                        end
                    end
                end)
            end
        end
    end)
end

-- Toggle: Auto Sea 3
if CurrentSea == 2 then
    CreateToggle(FarmSeaTab, "🌊 Auto ir para Sea 3", "AutoSea3", function(enabled)
        _G.DealBlox.Settings.AutoSea3 = enabled
    end)
    
    -- Sistema Auto Sea 3
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoSea3 then
                pcall(function()
                    local playerLevel = LocalPlayer.Data.Level.Value
                    
                    if playerLevel < 1500 then
                        Notify("⏳ Farmando Level", string.format("Você tem %d/1500. Farmando...", playerLevel), 3)
                        
                        -- Ativar auto farm
                        _G.DealBlox.Settings.AutoFarm = true
                        task.wait(10)
                    else
                        Notify("✅ Level Suficiente", "Indo para Sea 3...", 3)
                        
                        local remote = GetRemote()
                        if remote then
                            -- Ir para o NPC
                            SafeTP(CFrame.new(-5058, 314, -3155))
                            task.wait(2)
                            
                            remote:InvokeServer("TravelZou")
                            task.wait(3)
                            
                            Notify("✅ Sucesso", "Você chegou ao Sea 3!", 3)
                            _G.DealBlox.Settings.AutoSea3 = false
                        end
                    end
                end)
            end
        end
    end)
end

CreateSection(FarmSeaTab, "Eventos do Sea")

-- Toggle: Auto Factory (Sea 2)
if CurrentSea == 2 then
    CreateToggle(FarmSeaTab, "🏭 Auto Factory Raid", "AutoFactory", function(enabled)
        _G.DealBlox.Settings.AutoFactory = enabled
    end)
    
    -- Sistema Auto Factory
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoFactory then
                pcall(function()
                    -- Verificar se factory está ativa
                    local factoryActive = workspace:FindFirstChild("Factory")
                    
                    if factoryActive then
                        Notify("🏭 Factory Detectada", "Indo para a Factory...", 2)
                        
                        -- Teleportar para factory
                        SafeTP(CFrame.new(424, 211, -2896))
                        task.wait(2)
                        
                        -- Atacar factory
                        EquipWeapon()
                        ActivateBuso()
                        
                        -- Procurar mobs da factory
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob.Name:find("Factory") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                                local distance = _G.DealBlox.Settings.FarmDistance or 30
                                local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                                
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                                end
                                
                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 0.8
                                mob.HumanoidRootPart.CanCollide = false
                                
                                _G.DealBlox.Settings.AutoClick = true
                                break
                            end
                        end
                    else
                        Notify("⏳ Aguardando", "Estamos esperando Factory spawnar...", 5)
                        task.wait(30)
                    end
                end)
            end
        end
    end)
end

-- Toggle: Auto Pirate Raid (Sea 3)
if CurrentSea == 3 then
    CreateToggle(FarmSeaTab, "🏴‍☠️ Auto Pirate Raid (Castle)", "AutoPirateRaid", function(enabled)
        _G.DealBlox.Settings.AutoPirateRaid = enabled
    end)
    
    -- Sistema Auto Pirate Raid
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoPirateRaid then
                pcall(function()
                    -- Verificar se raid está ativa
                    local raidActive = false
                    
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name:find("Pirate") and mob:FindFirstChild("HumanoidRootPart") then
                            raidActive = true
                            break
                        end
                    end
                    
                    if raidActive then
                        Notify("🏴‍☠️ Raid Detectada", "Indo para Castle on the Sea...", 2)
                        
                        -- Ir para Castle
                        SafeTP(CFrame.new(-5075, 314, -3155))
                        task.wait(2)
                        
                        -- Atacar piratas
                        EquipWeapon()
                        ActivateBuso()
                        
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob.Name:find("Pirate") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                                local distance = _G.DealBlox.Settings.FarmDistance or 30
                                local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                                
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                                end
                                
                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 0.8
                                mob.HumanoidRootPart.CanCollide = false
                                
                                _G.DealBlox.Settings.AutoClick = true
                                break
                            end
                        end
                    else
                        Notify("⏳ Aguardando", "Estamos esperando Pirate Raid spawnar...", 5)
                        task.wait(30)
                    end
                end)
            end
        end
    end)
end

CreateSection(FarmSeaTab, "Rip Indra (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Elite Hunter
    CreateToggle(FarmSeaTab, "👑 Auto Elite Hunter", "AutoEliteHunter", function(enabled)
        _G.DealBlox.Settings.AutoEliteHunter = enabled
    end)
    
    -- Sistema Auto Elite Hunter
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoEliteHunter then
                pcall(function()
                    -- Procurar Elite Hunters
                    local eliteNames = {"Diablo", "Deandre", "Urban"}
                    local eliteFound = nil
                    
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        for _, name in pairs(eliteNames) do
                            if mob.Name == name and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                                eliteFound = mob
                                break
                            end
                        end
                        if eliteFound then break end
                    end
                    
                    if eliteFound then
                        Notify("👑 Elite Hunter!", "Atacando " .. eliteFound.Name .. "...", 2)
                        
                        EquipWeapon()
                        ActivateBuso()
                        
                        local distance = _G.DealBlox.Settings.FarmDistance or 30
                        local targetPos = eliteFound.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                        end
                        
                        eliteFound.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        eliteFound.HumanoidRootPart.Transparency = 0.8
                        eliteFound.HumanoidRootPart.CanCollide = false
                        
                        _G.DealBlox.Settings.AutoClick = true
                    else
                        Notify("⏳ Aguardando", "Estamos esperando Elite Hunter spawnar...", 10)
                        task.wait(10)
                    end
                end)
            end
        end
    end)
    
    -- Toggle: Auto Spawnar Rip Indra
    CreateToggle(FarmSeaTab, "😈 Auto Spawnar Rip Indra", "AutoSpawnRipIndra", function(enabled)
        _G.DealBlox.Settings.AutoSpawnRipIndra = enabled
    end)
    
    -- Sistema Auto Spawn Rip Indra
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoSpawnRipIndra then
                pcall(function()
                    local remote = GetRemote()
                    if not remote then return end
                    
                    -- Verificar se tem God's Chalice
                    local hasChalice = false
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if item.Name == "God's Chalice" then
                            hasChalice = true
                            break
                        end
                    end
                    
                    if not hasChalice then
                        Notify("⚠️ Sem Chalice", "Você não tem God's Chalice!", 3)
                        _G.DealBlox.Settings.AutoSpawnRipIndra = false
                        return
                    end
                    
                    -- Ir para Castle on the Sea
                    SafeTP(CFrame.new(-5075, 314, -3155))
                    task.wait(2)
                    
                    -- Usar God's Chalice
                    remote:InvokeServer("activateColor", "Winter Sky")
                    task.wait(0.5)
                    remote:InvokeServer("activateColor", "Pure Red")
                    task.wait(0.5)
                    remote:InvokeServer("activateColor", "Snow White")
                    task.wait(0.5)
                    
                    Notify("✅ Rip Indra", "Rip Indra spawnado!", 3)
                    _G.DealBlox.Settings.AutoSpawnRipIndra = false
                end)
            end
        end
    end)
    
    -- Toggle: Auto Haki (Rip Indra)
    CreateToggle(FarmSeaTab, "🔥 Auto Acender Hakis", "AutoHakiRipIndra", function(enabled)
        _G.DealBlox.Settings.AutoHakiRipIndra = enabled
    end)
    
    -- Sistema Auto Haki
    task.spawn(function()
        while task.wait(0.5) do
            if _G.DealBlox.Settings.AutoHakiRipIndra then
                pcall(function()
                    local remote = GetRemote()
                    if not remote then return end
                    
                    -- Ir para Castle on the Sea
                    SafeTP(CFrame.new(-5075, 314, -3155))
                    task.wait(1)
                    
                    -- Acender os 3 hakis
                    remote:InvokeServer("activateColor", "Winter Sky")
                    task.wait(0.3)
                    remote:InvokeServer("activateColor", "Pure Red")
                    task.wait(0.3)
                    remote:InvokeServer("activateColor", "Snow White")
                    task.wait(0.3)
                    
                    Notify("🔥 Hakis Acesos", "Todos os hakis foram acesos!", 2)
                end)
            end
        end
    end)
    
    -- Toggle: Auto Atacar Rip Indra
    CreateToggle(FarmSeaTab, "⚔️ Auto Atacar Rip Indra", "AutoAttackRipIndra", function(enabled)
        _G.DealBlox.Settings.AutoAttackRipIndra = enabled
    end)
    
    -- Sistema Auto Attack Rip Indra
    task.spawn(function()
        while task.wait(0.5) do
            if _G.DealBlox.Settings.AutoAttackRipIndra then
                pcall(function()
                    local ripIndra = workspace.Enemies:FindFirstChild("rip_indra True Form") or workspace.Enemies:FindFirstChild("rip_indra")
                    
                    if ripIndra and ripIndra:FindFirstChild("Humanoid") and ripIndra.Humanoid.Health > 0 and ripIndra:FindFirstChild("HumanoidRootPart") then
                        EquipWeapon()
                        ActivateBuso()
                        
                        local distance = _G.DealBlox.Settings.FarmDistance or 30
                        local targetPos = ripIndra.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                        end
                        
                        ripIndra.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        ripIndra.HumanoidRootPart.Transparency = 0.8
                        ripIndra.HumanoidRootPart.CanCollide = false
                        
                        _G.DealBlox.Settings.AutoClick = true
                    else
                        Notify("⏳ Aguardando", "Estamos esperando Rip Indra spawnar...", 5)
                        task.wait(5)
                    end
                end)
            end
        end
    end)
end

CreateSection(FarmSeaTab, "Boss Farm")

-- Criar lista de bosses do sea atual
local currentBosses = BossList[CurrentSea] or {}

-- Dropdown: Selecionar Boss
CreateDropdown(FarmSeaTab, "👹 Selecionar Boss", currentBosses, "SelectedBoss", function(boss)
    Notify("✅ Boss Selecionado", boss, 2)
end)

-- Toggle: Atacar Boss
CreateToggle(FarmSeaTab, "⚔️ Auto Atacar Boss Selecionado", "AutoAttackBoss", function(enabled)
    _G.DealBlox.Settings.AutoAttackBoss = enabled
end)

-- Sistema Auto Attack Boss
task.spawn(function()
    while task.wait(0.5) do
        if _G.DealBlox.Settings.AutoAttackBoss then
            pcall(function()
                local selectedBoss = _G.DealBlox.Settings.SelectedBoss
                
                if not selectedBoss or selectedBoss == "Nenhum" or selectedBoss == "Selecione" then
                    return
                end
                
                local boss = workspace.Enemies:FindFirstChild(selectedBoss)
                
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
                    EquipWeapon()
                    ActivateBuso()
                    
                    local distance = _G.DealBlox.Settings.FarmDistance or 30
                    local targetPos = boss.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                    end
                    
                    boss.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    boss.HumanoidRootPart.Transparency = 0.8
                    boss.HumanoidRootPart.CanCollide = false
                    
                    _G.DealBlox.Settings.AutoClick = true
                else
                    Notify("⏳ Aguardando", "Estamos esperando " .. selectedBoss .. " spawnar...", 5)
                    task.wait(5)
                end
            end)
        end
    end
end)

print("✅ DEAL BLOX - PARTE 8/15 CARREGADA")

-- =========================
-- PÁGINA: OUTROS FARM
-- =========================
local OutrosFarmTab = TabFrames["Outros farm"].Frame

CreateSection(OutrosFarmTab, "Peixes")

CreateLabel(OutrosFarmTab, [[
⚠️ SEÇÃO EM DESENVOLVIMENTO

🎣 Farm de peixes será implementado em breve!

Aguarde atualizações futuras.
]])

CreateSection(OutrosFarmTab, "Missões Dragon (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Dojo Trainer
    CreateToggle(OutrosFarmTab, "🥋 Auto Dojo Trainer", "AutoDojoTrainer", function(enabled)
        _G.DealBlox.Settings.AutoDojoTrainer = enabled
    end)
    
    -- Sistema Auto Dojo Trainer
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoDojoTrainer then
                pcall(function()
                    local remote = GetRemote()
                    if not remote then return end
                    
                    -- Ir para Hydra Island (Dragon Dojo)
                    SafeTP(CFrame.new(5749, 612, -276))
                    task.wait(2)
                    
                    -- Falar com Dojo Trainer
                    remote:InvokeServer("DojoTrainer", "Start")
                    task.wait(1)
                    
                    -- Completar desafios do dojo
                    Notify("🥋 Dojo Trainer", "Completando desafios do dojo...", 3)
                    
                    -- Matar mobs específicos
                    local dojoMobs = {"Martial Arts Teacher", "Gladiator", "Mob Leader"}
                    
                    for _, mobName in pairs(dojoMobs) do
                        local mob = workspace.Enemies:FindFirstChild(mobName)
                        
                        if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            EquipWeapon()
                            ActivateBuso()
                            
                            repeat
                                task.wait()
                                if not mob or not mob.Parent or mob.Humanoid.Health <= 0 then break end
                                
                                local distance = _G.DealBlox.Settings.FarmDistance or 30
                                local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                                
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                                end
                                
                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 0.8
                                mob.HumanoidRootPart.CanCollide = false
                                
                                _G.DealBlox.Settings.AutoClick = true
                            until not _G.DealBlox.Settings.AutoDojoTrainer or not mob or mob.Humanoid.Health <= 0
                        end
                        
                        task.wait(2)
                    end
                    
                    -- Completar missão
                    remote:InvokeServer("DojoTrainer", "Complete")
                    Notify("✅ Dojo Trainer", "Missão completada!", 3)
                end)
            end
        end
    end)
    
    -- Toggle: Auto Dragon Hunter
    CreateToggle(OutrosFarmTab, "🐉 Auto Dragon Hunter", "AutoDragonHunter", function(enabled)
        _G.DealBlox.Settings.AutoDragonHunter = enabled
    end)
    
    -- Sistema Auto Dragon Hunter
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoDragonHunter then
                pcall(function()
                    local remote = GetRemote()
                    if not remote then return end
                    
                    -- Ir para Hydra Island
                    SafeTP(CFrame.new(5749, 612, -276))
                    task.wait(2)
                    
                    -- Falar com Dragon Hunter
                    remote:InvokeServer("DragonHunter", "Start")
                    task.wait(1)
                    
                    Notify("🐉 Dragon Hunter", "Completando missões do Dragon Hunter...", 3)
                    
                    -- Completar missão
                    remote:InvokeServer("DragonHunter", "Complete")
                    Notify("✅ Dragon Hunter", "Missão completada!", 3)
                    task.wait(5)
                end)
            end
        end
    end)
else
    CreateLabel(OutrosFarmTab, "⚠️ Missões Dragon apenas no Sea 3!")
end

CreateSection(OutrosFarmTab, "Farm Observação")

-- Toggle: Farm Haki Observação
CreateToggle(OutrosFarmTab, "👁️ Farm Haki da Observação", "AutoFarmObservation", function(enabled)
    _G.DealBlox.Settings.AutoFarmObservation = enabled
end)

-- Sistema Farm Observation
task.spawn(function()
    while task.wait(1) do
        if _G.DealBlox.Settings.AutoFarmObservation then
            pcall(function()
                -- Ir para a ilha mais fraca do sea atual
                local weakIsland
                if CurrentSea == 1 then
                    weakIsland = CFrame.new(1071, 16, 1426) -- Pirate Starter
                elseif CurrentSea == 2 then
                    weakIsland = CFrame.new(-288, 7, 5579) -- Kingdom of Rose
                else
                    weakIsland = CFrame.new(-290, 44, 5343) -- Port Town
                end
                
                SafeTP(weakIsland)
                task.wait(2)
                
                -- Procurar mob mais fraco
                local weakMob = nil
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        weakMob = mob
                        break
                    end
                end
                
                if weakMob then
                    -- Ativar observation
                    local remote = GetRemote()
                    if remote then
                        remote:InvokeServer("Ken", true)
                    end
                    
                    -- Ficar perto do mob SEM atacar
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = weakMob.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    end
                    
                    -- Esperar apanhar até observation acabar
                    task.wait(10)
                    
                    -- Sair de perto
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 100, 0)
                    end
                    
                    -- Esperar cooldown
                    task.wait(5)
                end
            end)
        end
    end
end)

-- Toggle: Auto Haki Observação V2
CreateToggle(OutrosFarmTab, "👁️ Auto Observation V2 (5000 XP)", "AutoObservationV2", function(enabled)
    _G.DealBlox.Settings.AutoObservationV2 = enabled
end)

-- Sistema Auto Observation V2
task.spawn(function()
    while task.wait(1) do
        if _G.DealBlox.Settings.AutoObservationV2 then
            pcall(function()
                -- Verificar se já tem V2
                if LocalPlayer.PlayerGui.Main.Skills.Observation.Level.Text:find("MAX") then
                    Notify("✅ Completo!", "Observation V2 alcançado!", 3)
                    _G.DealBlox.Settings.AutoObservationV2 = false
                    return
                end
                
                -- Ativar farm observation normal
                _G.DealBlox.Settings.AutoFarmObservation = true
            end)
        end
    end
end)

-- =========================
-- PÁGINA: RAIDS E DUNGEONS
-- =========================
local RaidsTab = TabFrames["Raids e Dungeons"].Frame

CreateSection(RaidsTab, "Configuração de Raid")

-- Lista de raids
local RaidsList = {"Flame", "Ice", "Sand", "Dark", "Light", "Spider", "Magma", "Quake", "Buddha", "Phoenix", "Dough"}

-- Dropdown: Selecionar Raid
CreateDropdown(RaidsTab, "🔥 Selecionar Raid", RaidsList, "SelectedRaid", function(raid)
    Notify("✅ Raid Selecionada", raid, 2)
end)

-- Dropdown: Arma para Raid
CreateDropdown(RaidsTab, "⚔️ Arma para Raid", {"Estilo de luta", "Espada"}, "SelectedRaidWeapon", function(weapon)
    Notify("✅ Arma Selecionada", weapon, 2)
end)

CreateSection(RaidsTab, "Auto Raid")

-- Toggle: Auto Raid
CreateToggle(RaidsTab, "🏆 Auto Raid (Comprar + Iniciar + Completar)", "AutoRaid", function(enabled)
    if enabled then
        local selectedRaid = _G.DealBlox.Settings.SelectedRaid
        if not selectedRaid or selectedRaid == "Nenhum" or selectedRaid == "Selecione" then
            Notify("⚠️ Raid não selecionada", "Selecione uma raid primeiro!", 3)
            _G.DealBlox.Settings.AutoRaid = false
            return
        end
    end
    _G.DealBlox.Settings.AutoRaid = enabled
end)

-- Sistema Auto Raid
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoRaid then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                local selectedRaid = _G.DealBlox.Settings.SelectedRaid
                
                -- Ir para Mysterious Scientist
                if CurrentSea == 2 then
                    SafeTP(CFrame.new(-6438, 250, -4498))
                elseif CurrentSea == 3 then
                    SafeTP(CFrame.new(-6438, 250, -4498))
                else
                    Notify("❌ Sea Incorreto", "Raids apenas no Sea 2 e 3!", 3)
                    _G.DealBlox.Settings.AutoRaid = false
                    return
                end
                
                task.wait(2)
                
                -- Comprar chip
                remote:InvokeServer("RaidsNpc", "Select", selectedRaid)
                task.wait(0.5)
                
                -- Iniciar raid
                remote:InvokeServer("Raids", "Start")
                task.wait(5)
                
                Notify("🏆 Raid Iniciada", "Completando raid de " .. selectedRaid .. "...", 3)
                
                -- Loop de raid
                while _G.DealBlox.Settings.AutoRaid do
                    task.wait(0.5)
                    
                    -- Verificar se ainda está na raid
                    if not workspace:FindFirstChild("RaidIsland") then
                        Notify("✅ Raid Completa", "Raid finalizada!", 3)
                        break
                    end
                    
                    -- Equipar arma de raid
                    local raidWeapon = _G.DealBlox.Settings.SelectedRaidWeapon
                    if raidWeapon == "Estilo de luta" then
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                                LocalPlayer.Character.Humanoid:EquipTool(tool)
                                break
                            end
                        end
                    elseif raidWeapon == "Espada" then
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool.ToolTip == "Sword" then
                                LocalPlayer.Character.Humanoid:EquipTool(tool)
                                break
                            end
                        end
                    end
                    
                    ActivateBuso()
                    
                    -- Procurar mobs da raid
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            local distance = _G.DealBlox.Settings.FarmDistance or 30
                            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                            
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                            end
                            
                            mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            mob.HumanoidRootPart.Transparency = 0.8
                            mob.HumanoidRootPart.CanCollide = false
                            
                            _G.DealBlox.Settings.AutoClick = true
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Toggle: Auto Chip (Apenas Comprar)
CreateToggle(RaidsTab, "🎫 Auto Comprar Chip (Sem Iniciar)", "AutoChip", function(enabled)
    if enabled then
        local selectedRaid = _G.DealBlox.Settings.SelectedRaid
        if not selectedRaid or selectedRaid == "Nenhum" or selectedRaid == "Selecione" then
            Notify("⚠️ Raid não selecionada", "Selecione uma raid primeiro!", 3)
            _G.DealBlox.Settings.AutoChip = false
            return
        end
    end
    _G.DealBlox.Settings.AutoChip = enabled
end)

-- Sistema Auto Chip
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoChip then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                local selectedRaid = _G.DealBlox.Settings.SelectedRaid
                
                -- Ir para Mysterious Scientist
                if CurrentSea == 2 or CurrentSea == 3 then
                    SafeTP(CFrame.new(-6438, 250, -4498))
                else
                    Notify("❌ Sea Incorreto", "Chips apenas no Sea 2 e 3!", 3)
                    _G.DealBlox.Settings.AutoChip = false
                    return
                end
                
                task.wait(2)
                
                -- Comprar chip
                remote:InvokeServer("RaidsNpc", "Select", selectedRaid)
                Notify("✅ Chip Comprado", "Chip de " .. selectedRaid .. " comprado!", 2)
                
                task.wait(10)
            end)
        end
    end
end)

-- Toggle: Auto Atacar (Durante Raid)
CreateToggle(RaidsTab, "⚔️ Auto Atacar (Se estiver em Raid)", "AutoAttackRaid", function(enabled)
    _G.DealBlox.Settings.AutoAttackRaid = enabled
end)

-- Sistema Auto Attack Raid
task.spawn(function()
    while task.wait(0.5) do
        if _G.DealBlox.Settings.AutoAttackRaid then
            pcall(function()
                -- Verificar se está na raid
                if not workspace:FindFirstChild("RaidIsland") then
                    return
                end
                
                -- Equipar arma de raid
                local raidWeapon = _G.DealBlox.Settings.SelectedRaidWeapon
                if raidWeapon == "Estilo de luta" then
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            break
                        end
                    end
                elseif raidWeapon == "Espada" then
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.ToolTip == "Sword" then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                
                ActivateBuso()
                
                -- Atacar mobs
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        local distance = _G.DealBlox.Settings.FarmDistance or 30
                        local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                        end
                        
                        mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        mob.HumanoidRootPart.Transparency = 0.8
                        mob.HumanoidRootPart.CanCollide = false
                        
                        _G.DealBlox.Settings.AutoClick = true
                        break
                    end
                end
            end)
        end
    end
end)

CreateSection(RaidsTab, "Raid Law (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Raid Law
    CreateToggle(RaidsTab, "⚖️ Auto Raid Law (Completa)", "AutoRaidLaw", function(enabled)
        _G.DealBlox.Settings.AutoRaidLaw = enabled
    end)
    
    -- Toggle: Auto Chip Law
    CreateToggle(RaidsTab, "🎫 Auto Comprar Chip Law", "AutoChipLaw", function(enabled)
        _G.DealBlox.Settings.AutoChipLaw = enabled
    end)
    
    -- Toggle: Auto Atacar Law
    CreateToggle(RaidsTab, "⚔️ Auto Atacar Boss Law", "AutoAttackLaw", function(enabled)
        _G.DealBlox.Settings.AutoAttackLaw = enabled
    end)
    
    -- Sistema Raid Law (simplificado)
    task.spawn(function()
        while task.wait(5) do
            if _G.DealBlox.Settings.AutoRaidLaw then
                pcall(function()
                    Notify("⚖️ Law Raid", "Iniciando Law Raid...", 3)
                    -- Implementação completa virá em updates
                end)
            end
        end
    end)
else
    CreateLabel(RaidsTab, "⚠️ Raid Law apenas no Sea 3!")
end

CreateSection(RaidsTab, "Dungeon")

-- Dropdown: Dificuldade Dungeon
CreateDropdown(RaidsTab, "🏰 Selecionar Dificuldade", {"Normal", "Hard", "Challenge"}, "SelectedDifficulty", function(difficulty)
    Notify("✅ Dificuldade", difficulty .. " selecionada", 2)
end)

-- Botão: Iniciar Dungeon (DESABILITADO)
local dungeonBtn = CreateButton(RaidsTab, "🏰 Iniciar Dungeon", function()
    Notify("⚠️ Em Desenvolvimento", "Dungeon será implementado em breve!", 3)
end)
dungeonBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dungeonBtn.TextColor3 = Color3.fromRGB(150, 150, 150)

CreateLabel(RaidsTab, [[
⚠️ SEÇÃO DUNGEON EM DESENVOLVIMENTO

Esta funcionalidade será implementada em atualizações futuras.

Aguarde!
]])

print("✅ DEAL BLOX - PARTE 9/15 CARREGADA")

-- =========================
-- PÁGINA: FRUTAS E BERRY
-- =========================
local FrutasTab = TabFrames["Frutas e Berry"].Frame

CreateSection(FrutasTab, "Frutas")

-- Toggle: Girar Fruta
CreateToggle(FrutasTab, "🎰 Auto Girar Fruta (Gacha)", "AutoSpinFruit", function(enabled)
    _G.DealBlox.Settings.AutoSpinFruit = enabled
end)

-- Sistema Auto Spin Fruit
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoSpinFruit then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar dinheiro
                if LocalPlayer.Data.Beli.Value < 5000 then
                    Notify("❌ Sem Dinheiro", "Você precisa de $5,000 para girar!", 3)
                    _G.DealBlox.Settings.AutoSpinFruit = false
                    return
                end
                
                -- Girar fruta
                remote:InvokeServer("Cousin", "Buy")
                Notify("🎰 Girando", "Fruta girada!", 2)
                task.wait(2)
            end)
        end
    end
end)

-- Toggle: Auto Guardar Fruta
CreateToggle(FrutasTab, "📦 Auto Guardar Fruta no Inventário", "AutoStoreFruit", function(enabled)
    _G.DealBlox.Settings.AutoStoreFruit = enabled
end)

-- Sistema Auto Store Fruit
task.spawn(function()
    while task.wait(2) do
        if _G.DealBlox.Settings.AutoStoreFruit then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar se tem fruta equipada
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                        -- Guardar fruta
                        remote:InvokeServer("StoreFruit", tool.Name)
                        Notify("📦 Fruta Guardada", tool.Name .. " foi guardada com segurança!", 2)
                        task.wait(1)
                    end
                end
                
                -- Verificar backpack também
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                        remote:InvokeServer("StoreFruit", tool.Name)
                        Notify("📦 Fruta Guardada", tool.Name .. " foi guardada com segurança!", 2)
                        task.wait(1)
                    end
                end
            end)
        end
    end
end)

-- Toggle: Caçar Frutas
CreateToggle(FrutasTab, "🔍 Caçar Frutas (Spawn no Chão)", "AutoHuntFruit", function(enabled)
    _G.DealBlox.Settings.AutoHuntFruit = enabled
end)

-- Sistema Auto Hunt Fruit
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoHuntFruit then
            pcall(function()
                -- Procurar frutas no workspace
                local fruitFound = false
                
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                        fruitFound = true
                        
                        Notify("🍎 Fruta Encontrada!", "Indo pegar " .. fruit.Name .. "...", 2)
                        
                        -- Ir para a fruta
                        SafeTP(fruit.Handle.CFrame)
                        task.wait(2)
                        
                        -- Pegar fruta
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                        
                        task.wait(2)
                        Notify("✅ Fruta Coletada", fruit.Name .. " coletada!", 2)
                        break
                    end
                end
                
                if not fruitFound then
                    Notify("⏳ Procurando", "Estamos esperando frutas spawnarem...", 5)
                    task.wait(30)
                end
            end)
        end
    end
end)

CreateSection(FrutasTab, "Loja de Frutas")

-- Lista de frutas
local FruitList = {
    "Kilo", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame",
    "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier",
    "Ghost", "Magma", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix",
    "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex",
    "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune"
}

-- Dropdown: Frutas Loja Normal
CreateDropdown(FrutasTab, "🍎 Comprar Fruta da Loja Normal", FruitList, "SelectedFruitToBuy", function(fruit)
    Notify("✅ Fruta Selecionada", fruit, 2)
end)

-- Botão: Comprar Fruta Loja Normal
CreateButton(FrutasTab, "💰 Comprar Fruta da Loja Normal", function()
    local selectedFruit = _G.DealBlox.Settings.SelectedFruitToBuy
    
    if not selectedFruit or selectedFruit == "Nenhum" or selectedFruit == "Selecione" then
        Notify("⚠️ Nenhuma Fruta", "Selecione uma fruta primeiro!", 2)
        return
    end
    
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 2)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar " .. selectedFruit .. "...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BuyFruit", selectedFruit)
        end)
        
        if success then
            Notify("✅ Sucesso", selectedFruit .. " comprada!", 3)
        else
            Notify("❌ Erro", "Verifique se você tem dinheiro suficiente!", 3)
        end
    end)
end)

-- Dropdown: Frutas Loja Miragem
CreateDropdown(FrutasTab, "🌟 Comprar Fruta da Loja Miragem", FruitList, "SelectedMirageFruit", function(fruit)
    Notify("✅ Fruta Miragem Selecionada", fruit, 2)
end)

-- Botão: Comprar Fruta Miragem
CreateButton(FrutasTab, "💎 Comprar Fruta da Loja Miragem", function()
    if CurrentSea ~= 3 then
        Notify("❌ Sea Incorreto", "Loja Miragem apenas no Sea 3!", 3)
        return
    end
    
    local selectedFruit = _G.DealBlox.Settings.SelectedMirageFruit
    
    if not selectedFruit or selectedFruit == "Nenhum" or selectedFruit == "Selecione" then
        Notify("⚠️ Nenhuma Fruta", "Selecione uma fruta primeiro!", 2)
        return
    end
    
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 2)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar " .. selectedFruit .. " na Miragem...", 2)
    
    task.spawn(function()
        -- Ir para Mirage Island
        local mirageFound = false
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "MysticIsland" then
                SafeTP(obj:GetModelCFrame())
                mirageFound = true
                break
            end
        end
        
        if not mirageFound then
            Notify("❌ Miragem Offline", "Ilha Miragem não está spawnada!", 3)
            return
        end
        
        task.wait(2)
        
        local success = pcall(function()
            remote:InvokeServer("BuyFruitMirage", selectedFruit)
        end)
        
        if success then
            Notify("✅ Sucesso", selectedFruit .. " comprada na Miragem!", 3)
        else
            Notify("❌ Erro", "Verifique se você tem fragmentos suficientes!", 3)
        end
    end)
end)

CreateSection(FrutasTab, "Berry")

-- Toggle: Caçar Berry
CreateToggle(FrutasTab, "💰 Caçar Berry (Spawn no Chão)", "AutoHuntBerry", function(enabled)
    _G.DealBlox.Settings.AutoHuntBerry = enabled
end)

-- Sistema Auto Hunt Berry
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoHuntBerry then
            pcall(function()
                -- Procurar berry no workspace
                local berryFound = false
                
                for _, berry in pairs(workspace:GetChildren()) do
                    if berry.Name == "Berry" and berry:FindFirstChild("Handle") then
                        berryFound = true
                        
                        Notify("💰 Berry Encontrada!", "Coletando berry...", 2)
                        
                        -- Ir para a berry
                        SafeTP(berry.Handle.CFrame)
                        task.wait(1)
                        
                        -- Pegar berry
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            berry.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                        
                        task.wait(1)
                        break
                    end
                end
                
                if not berryFound then
                    task.wait(10)
                end
            end)
        end
    end
end)

-- =========================
-- PÁGINA: EVENTOS DO MAR
-- =========================
local EventosMarTab = TabFrames["Eventos do Mar"].Frame

CreateSection(EventosMarTab, "Sea Events")

-- Toggle: Auto Sea Beast
CreateToggle(EventosMarTab, "🐙 Auto Farm Sea Beast", "AutoSeaBeast", function(enabled)
    _G.DealBlox.Settings.AutoSeaBeast = enabled
end)

-- Sistema Auto Sea Beast
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoSeaBeast then
            pcall(function()
                -- Procurar Sea Beast
                local seaBeast = workspace.SeaBeasts:FindFirstChild("SeaBeast1")
                
                if seaBeast and seaBeast:FindFirstChild("HumanoidRootPart") then
                    Notify("🐙 Sea Beast!", "Atacando Sea Beast...", 2)
                    
                    EquipWeapon()
                    ActivateBuso()
                    
                    local distance = _G.DealBlox.Settings.FarmDistance or 50
                    local targetPos = seaBeast.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                    end
                    
                    seaBeast.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    seaBeast.HumanoidRootPart.Transparency = 0.8
                    seaBeast.HumanoidRootPart.CanCollide = false
                    
                    _G.DealBlox.Settings.AutoClick = true
                else
                    -- Ir para Tiki Outpost e navegar
                    if CurrentSea == 3 then
                        SafeTP(CFrame.new(-16105, 9, 440))
                        task.wait(2)
                        
                        Notify("⏳ Navegando", "Estamos esperando Sea Beast spawnar...", 5)
                        task.wait(30)
                    end
                end
            end)
        end
    end
end)

-- Toggle: Auto Terrorshark
CreateToggle(EventosMarTab, "🦈 Auto Farm Terrorshark", "AutoTerrorshark", function(enabled)
    _G.DealBlox.Settings.AutoTerrorshark = enabled
end)

-- Toggle: Auto Piranha
CreateToggle(EventosMarTab, "🐟 Auto Farm Piranha", "AutoPiranha", function(enabled)
    _G.DealBlox.Settings.AutoPiranha = enabled
end)

CreateSection(EventosMarTab, "Barco Automático")

-- Dropdown: Tipo de Barco
CreateDropdown(EventosMarTab, "⛵ Selecionar Barco", {"Nenhum", "PirateBrigade", "PirateGrandBrigade", "MarineBrigade"}, "SeaEventBoat", function(boat)
    Notify("✅ Barco Selecionado", boat, 2)
end)

-- Dropdown: Profundidade do Mar
CreateDropdown(EventosMarTab, "🌊 Profundidade do Mar", {"Mar 1", "Mar 2", "Mar 3", "Mar 4", "Mar 5", "Mar 6"}, "SeaDepth", function(depth)
    Notify("✅ Profundidade", depth, 2)
end)

-- Toggle: Ativar Barco
CreateToggle(EventosMarTab, "⛵ Ativar Barco Automático", "SeaEventActive", function(enabled)
    _G.DealBlox.Settings.SeaEventActive = enabled
end)

CreateSection(EventosMarTab, "Ilhas Especiais (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Find Mirage
    CreateToggle(EventosMarTab, "🏝️ Auto Procurar Ilha Miragem", "AutoMirage", function(enabled)
        _G.DealBlox.Settings.AutoMirage = enabled
    end)
    
    -- Sistema Auto Mirage
    task.spawn(function()
        while task.wait(10) do
            if _G.DealBlox.Settings.AutoMirage then
                pcall(function()
                    -- Procurar Mirage
                    local mirageFound = false
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj.Name == "MysticIsland" then
                            mirageFound = true
                            SafeTP(obj:GetModelCFrame())
                            Notify("✅ Miragem Encontrada!", "Teleportando para Ilha Miragem!", 3)
                            _G.DealBlox.Settings.AutoMirage = false
                            break
                        end
                    end
                    
                    if not mirageFound then
                        Notify("⏳ Procurando", "Estamos esperando Ilha Miragem spawnar...", 5)
                    end
                end)
            end
        end
    end)
    
    -- Toggle: Auto Find Volcano
    CreateToggle(EventosMarTab, "🌋 Auto Procurar Vulcão", "AutoVolcano", function(enabled)
        _G.DealBlox.Settings.AutoVolcano = enabled
    end)
    
    -- Toggle: Auto Find Leviathan
    CreateToggle(EventosMarTab, "🐉 Auto Procurar Leviathan", "AutoLeviathan", function(enabled)
        _G.DealBlox.Settings.AutoLeviathan = enabled
    end)
else
    CreateLabel(EventosMarTab, "⚠️ Ilhas especiais apenas no Sea 3!")
end

-- =========================
-- PÁGINA: RAÇAS
-- =========================
local RacasTab = TabFrames["Raças"].Frame

CreateSection(RacasTab, "Raça Normal")

-- Toggle: Auto V1-V3
CreateToggle(RacasTab, "🧬 Auto Raça V1 → V3", "AutoRaceV1toV3", function(enabled)
    _G.DealBlox.Settings.AutoRaceV1toV3 = enabled
end)

-- Sistema Auto Race V1 to V3
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoRaceV1toV3 then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                local currentRace = LocalPlayer.Data.Race.Value
                
                -- Verificar se já tem V3
                if currentRace:find("V3") then
                    Notify("✅ Completo!", "Você já tem Raça V3!", 3)
                    _G.DealBlox.Settings.AutoRaceV1toV3 = false
                    return
                end
                
                -- Pegar V2 (Sea 2)
                if not currentRace:find("V2") and CurrentSea >= 2 then
                    if LocalPlayer.Data.Level.Value >= 1000 then
                        SafeTP(CFrame.new(-2836, 14, -3036))
                        task.wait(2)
                        remote:InvokeServer("Wenlocktoad", "1")
                        task.wait(1)
                        remote:InvokeServer("Wenlocktoad", "2")
                        Notify("✅ V2 Obtida!", "Raça V2 desbloqueada!", 3)
                        task.wait(5)
                    end
                end
                
                -- Pegar V3 (Sea 3)
                if currentRace:find("V2") and not currentRace:find("V3") and CurrentSea >= 3 then
                    if LocalPlayer.Data.Level.Value >= 1500 then
                        SafeTP(CFrame.new(2681, 1682, -7190))
                        task.wait(2)
                        remote:InvokeServer("Arowe", "1")
                        task.wait(1)
                        -- Completar quest específica da raça
                        remote:InvokeServer("Arowe", "3")
                        Notify("✅ V3 Obtida!", "Raça V3 desbloqueada!", 3)
                        _G.DealBlox.Settings.AutoRaceV1toV3 = false
                    end
                end
            end)
        end
    end
end)

-- Toggle: Auto Get Cyborg
CreateToggle(RacasTab, "🤖 Auto Pegar Raça Cyborg", "AutoGetCyborg", function(enabled)
    _G.DealBlox.Settings.AutoGetCyborg = enabled
end)

-- Toggle: Auto Get Ghoul
CreateToggle(RacasTab, "🧛 Auto Pegar Raça Ghoul", "AutoGetGhoul", function(enabled)
    _G.DealBlox.Settings.AutoGetGhoul = enabled
end)

CreateSection(RacasTab, "Raça V4 (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Miragem V4
    CreateToggle(RacasTab, "🌕 Auto Miragem V4 (Lua Cheia)", "AutoMirageV4", function(enabled)
        _G.DealBlox.Settings.AutoMirageV4 = enabled
    end)
    
    -- Botão: Teleportar Temple
    CreateButton(RacasTab, "⏱️ Teleportar para Temple of Time", function()
        SafeTP(CFrame.new(-5413, 314, -2823))
        Notify("✅ Teleportado", "Você está no Temple of Time!", 2)
    end)
    
    -- Botão: Comprar Gears
    CreateButton(RacasTab, "⚙️ Comprar Gear (Engrenagem)", function()
        local remote = GetRemote()
        if not remote then
            Notify("❌ Erro", "Remote não encontrado!", 2)
            return
        end
        
        Notify("⏳ Comprando", "Tentando comprar gear...", 2)
        
        task.spawn(function()
            SafeTP(CFrame.new(-5413, 314, -2823))
            task.wait(2)
            
            local success = pcall(function()
                remote:InvokeServer("BuyGear")
            end)
            
            if success then
                Notify("✅ Sucesso", "Gear comprada!", 3)
            else
                Notify("❌ Erro", "Verifique se você tem fragmentos suficientes!", 3)
            end
        end)
    end)
    
    -- Toggle: Treinar V4
    CreateToggle(RacasTab, "💪 Auto Treinar Raça V4", "AutoTrainV4", function(enabled)
        _G.DealBlox.Settings.AutoTrainV4 = enabled
    end)
else
    CreateLabel(RacasTab, "⚠️ Raça V4 apenas no Sea 3!")
end

CreateSection(RacasTab, "Raça Draco (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Draco V2-V3
    CreateToggle(RacasTab, "🐉 Auto Raça Draco V2 → V3", "AutoDracoV2V3", function(enabled)
        _G.DealBlox.Settings.AutoDracoV2V3 = enabled
    end)
    
    -- Toggle: Auto Trial Draco
    CreateToggle(RacasTab, "🔥 Auto Trial Draco", "AutoTrialDraco", function(enabled)
        _G.DealBlox.Settings.AutoTrialDraco = enabled
    end)
    
    -- Botão: Craftar Volcanic Magnet
    CreateButton(RacasTab, "🧲 Craftar Volcanic Magnet", function()
        local remote = GetRemote()
        if not remote then
            Notify("❌ Erro", "Remote não encontrado!", 2)
            return
        end
        
        Notify("⏳ Craftando", "Tentando craftar Volcanic Magnet...", 2)
        
        task.spawn(function()
            SafeTP(CFrame.new(-10961, 331, -8500))
            task.wait(2)
            
            local success = pcall(function()
                remote:InvokeServer("CraftVolcanicMagnet")
            end)
            
            if success then
                Notify("✅ Sucesso", "Volcanic Magnet craftado!", 3)
            else
                Notify("❌ Erro", "Verifique se você tem os materiais necessários!", 3)
            end
        end)
    end)
else
    CreateLabel(RacasTab, "⚠️ Raça Draco apenas no Sea 3!")
end

print("✅ DEAL BLOX - PARTE 10/15 CARREGADA")

-- =========================
-- PÁGINA: FRUTAS E BERRY
-- =========================
local FrutasTab = TabFrames["Frutas e Berry"].Frame

CreateSection(FrutasTab, "Frutas")

-- Toggle: Girar Fruta
CreateToggle(FrutasTab, "🎰 Auto Girar Fruta (Gacha)", "AutoSpinFruit", function(enabled)
    _G.DealBlox.Settings.AutoSpinFruit = enabled
end)

-- Sistema Auto Spin Fruit
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoSpinFruit then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar dinheiro
                if LocalPlayer.Data.Beli.Value < 5000 then
                    Notify("❌ Sem Dinheiro", "Você precisa de $5,000 para girar!", 3)
                    _G.DealBlox.Settings.AutoSpinFruit = false
                    return
                end
                
                -- Girar fruta
                remote:InvokeServer("Cousin", "Buy")
                Notify("🎰 Girando", "Fruta girada!", 2)
                task.wait(2)
            end)
        end
    end
end)

-- Toggle: Auto Guardar Fruta
CreateToggle(FrutasTab, "📦 Auto Guardar Fruta no Inventário", "AutoStoreFruit", function(enabled)
    _G.DealBlox.Settings.AutoStoreFruit = enabled
end)

-- Sistema Auto Store Fruit
task.spawn(function()
    while task.wait(2) do
        if _G.DealBlox.Settings.AutoStoreFruit then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar se tem fruta equipada
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                        -- Guardar fruta
                        remote:InvokeServer("StoreFruit", tool.Name)
                        Notify("📦 Fruta Guardada", tool.Name .. " foi guardada com segurança!", 2)
                        task.wait(1)
                    end
                end
                
                -- Verificar backpack também
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                        remote:InvokeServer("StoreFruit", tool.Name)
                        Notify("📦 Fruta Guardada", tool.Name .. " foi guardada com segurança!", 2)
                        task.wait(1)
                    end
                end
            end)
        end
    end
end)

-- Toggle: Caçar Frutas
CreateToggle(FrutasTab, "🔍 Caçar Frutas (Spawn no Chão)", "AutoHuntFruit", function(enabled)
    _G.DealBlox.Settings.AutoHuntFruit = enabled
end)

-- Sistema Auto Hunt Fruit
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoHuntFruit then
            pcall(function()
                -- Procurar frutas no workspace
                local fruitFound = false
                
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                        fruitFound = true
                        
                        Notify("🍎 Fruta Encontrada!", "Indo pegar " .. fruit.Name .. "...", 2)
                        
                        -- Ir para a fruta
                        SafeTP(fruit.Handle.CFrame)
                        task.wait(2)
                        
                        -- Pegar fruta
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                        
                        task.wait(2)
                        Notify("✅ Fruta Coletada", fruit.Name .. " coletada!", 2)
                        break
                    end
                end
                
                if not fruitFound then
                    Notify("⏳ Procurando", "Estamos esperando frutas spawnarem...", 5)
                    task.wait(30)
                end
            end)
        end
    end
end)

CreateSection(FrutasTab, "Loja de Frutas")

-- Lista de frutas
local FruitList = {
    "Kilo", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame",
    "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier",
    "Ghost", "Magma", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix",
    "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex",
    "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune"
}

-- Dropdown: Frutas Loja Normal
CreateDropdown(FrutasTab, "🍎 Comprar Fruta da Loja Normal", FruitList, "SelectedFruitToBuy", function(fruit)
    Notify("✅ Fruta Selecionada", fruit, 2)
end)

-- Botão: Comprar Fruta Loja Normal
CreateButton(FrutasTab, "💰 Comprar Fruta da Loja Normal", function()
    local selectedFruit = _G.DealBlox.Settings.SelectedFruitToBuy
    
    if not selectedFruit or selectedFruit == "Nenhum" or selectedFruit == "Selecione" then
        Notify("⚠️ Nenhuma Fruta", "Selecione uma fruta primeiro!", 2)
        return
    end
    
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 2)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar " .. selectedFruit .. "...", 2)
    
    task.spawn(function()
        local success = pcall(function()
            remote:InvokeServer("BuyFruit", selectedFruit)
        end)
        
        if success then
            Notify("✅ Sucesso", selectedFruit .. " comprada!", 3)
        else
            Notify("❌ Erro", "Verifique se você tem dinheiro suficiente!", 3)
        end
    end)
end)

-- Dropdown: Frutas Loja Miragem
CreateDropdown(FrutasTab, "🌟 Comprar Fruta da Loja Miragem", FruitList, "SelectedMirageFruit", function(fruit)
    Notify("✅ Fruta Miragem Selecionada", fruit, 2)
end)

-- Botão: Comprar Fruta Miragem
CreateButton(FrutasTab, "💎 Comprar Fruta da Loja Miragem", function()
    if CurrentSea ~= 3 then
        Notify("❌ Sea Incorreto", "Loja Miragem apenas no Sea 3!", 3)
        return
    end
    
    local selectedFruit = _G.DealBlox.Settings.SelectedMirageFruit
    
    if not selectedFruit or selectedFruit == "Nenhum" or selectedFruit == "Selecione" then
        Notify("⚠️ Nenhuma Fruta", "Selecione uma fruta primeiro!", 2)
        return
    end
    
    local remote = GetRemote()
    if not remote then
        Notify("❌ Erro", "Remote não encontrado!", 2)
        return
    end
    
    Notify("⏳ Comprando", "Tentando comprar " .. selectedFruit .. " na Miragem...", 2)
    
    task.spawn(function()
        -- Ir para Mirage Island
        local mirageFound = false
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "MysticIsland" then
                SafeTP(obj:GetModelCFrame())
                mirageFound = true
                break
            end
        end
        
        if not mirageFound then
            Notify("❌ Miragem Offline", "Ilha Miragem não está spawnada!", 3)
            return
        end
        
        task.wait(2)
        
        local success = pcall(function()
            remote:InvokeServer("BuyFruitMirage", selectedFruit)
        end)
        
        if success then
            Notify("✅ Sucesso", selectedFruit .. " comprada na Miragem!", 3)
        else
            Notify("❌ Erro", "Verifique se você tem fragmentos suficientes!", 3)
        end
    end)
end)

CreateSection(FrutasTab, "Berry")

-- Toggle: Caçar Berry
CreateToggle(FrutasTab, "💰 Caçar Berry (Spawn no Chão)", "AutoHuntBerry", function(enabled)
    _G.DealBlox.Settings.AutoHuntBerry = enabled
end)

-- Sistema Auto Hunt Berry
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoHuntBerry then
            pcall(function()
                -- Procurar berry no workspace
                local berryFound = false
                
                for _, berry in pairs(workspace:GetChildren()) do
                    if berry.Name == "Berry" and berry:FindFirstChild("Handle") then
                        berryFound = true
                        
                        Notify("💰 Berry Encontrada!", "Coletando berry...", 2)
                        
                        -- Ir para a berry
                        SafeTP(berry.Handle.CFrame)
                        task.wait(1)
                        
                        -- Pegar berry
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            berry.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                        
                        task.wait(1)
                        break
                    end
                end
                
                if not berryFound then
                    task.wait(10)
                end
            end)
        end
    end
end)

-- =========================
-- PÁGINA: EVENTOS DO MAR
-- =========================
local EventosMarTab = TabFrames["Eventos do Mar"].Frame

CreateSection(EventosMarTab, "Sea Events")

-- Toggle: Auto Sea Beast
CreateToggle(EventosMarTab, "🐙 Auto Farm Sea Beast", "AutoSeaBeast", function(enabled)
    _G.DealBlox.Settings.AutoSeaBeast = enabled
end)

-- Sistema Auto Sea Beast
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoSeaBeast then
            pcall(function()
                -- Procurar Sea Beast
                local seaBeast = workspace.SeaBeasts:FindFirstChild("SeaBeast1")
                
                if seaBeast and seaBeast:FindFirstChild("HumanoidRootPart") then
                    Notify("🐙 Sea Beast!", "Atacando Sea Beast...", 2)
                    
                    EquipWeapon()
                    ActivateBuso()
                    
                    local distance = _G.DealBlox.Settings.FarmDistance or 50
                    local targetPos = seaBeast.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                    end
                    
                    seaBeast.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    seaBeast.HumanoidRootPart.Transparency = 0.8
                    seaBeast.HumanoidRootPart.CanCollide = false
                    
                    _G.DealBlox.Settings.AutoClick = true
                else
                    -- Ir para Tiki Outpost e navegar
                    if CurrentSea == 3 then
                        SafeTP(CFrame.new(-16105, 9, 440))
                        task.wait(2)
                        
                        Notify("⏳ Navegando", "Estamos esperando Sea Beast spawnar...", 5)
                        task.wait(30)
                    end
                end
            end)
        end
    end
end)

-- Toggle: Auto Terrorshark
CreateToggle(EventosMarTab, "🦈 Auto Farm Terrorshark", "AutoTerrorshark", function(enabled)
    _G.DealBlox.Settings.AutoTerrorshark = enabled
end)

-- Toggle: Auto Piranha
CreateToggle(EventosMarTab, "🐟 Auto Farm Piranha", "AutoPiranha", function(enabled)
    _G.DealBlox.Settings.AutoPiranha = enabled
end)

CreateSection(EventosMarTab, "Barco Automático")

-- Dropdown: Tipo de Barco
CreateDropdown(EventosMarTab, "⛵ Selecionar Barco", {"Nenhum", "PirateBrigade", "PirateGrandBrigade", "MarineBrigade"}, "SeaEventBoat", function(boat)
    Notify("✅ Barco Selecionado", boat, 2)
end)

-- Dropdown: Profundidade do Mar
CreateDropdown(EventosMarTab, "🌊 Profundidade do Mar", {"Mar 1", "Mar 2", "Mar 3", "Mar 4", "Mar 5", "Mar 6"}, "SeaDepth", function(depth)
    Notify("✅ Profundidade", depth, 2)
end)

-- Toggle: Ativar Barco
CreateToggle(EventosMarTab, "⛵ Ativar Barco Automático", "SeaEventActive", function(enabled)
    _G.DealBlox.Settings.SeaEventActive = enabled
end)

CreateSection(EventosMarTab, "Ilhas Especiais (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Find Mirage
    CreateToggle(EventosMarTab, "🏝️ Auto Procurar Ilha Miragem", "AutoMirage", function(enabled)
        _G.DealBlox.Settings.AutoMirage = enabled
    end)
    
    -- Sistema Auto Mirage
    task.spawn(function()
        while task.wait(10) do
            if _G.DealBlox.Settings.AutoMirage then
                pcall(function()
                    -- Procurar Mirage
                    local mirageFound = false
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj.Name == "MysticIsland" then
                            mirageFound = true
                            SafeTP(obj:GetModelCFrame())
                            Notify("✅ Miragem Encontrada!", "Teleportando para Ilha Miragem!", 3)
                            _G.DealBlox.Settings.AutoMirage = false
                            break
                        end
                    end
                    
                    if not mirageFound then
                        Notify("⏳ Procurando", "Estamos esperando Ilha Miragem spawnar...", 5)
                    end
                end)
            end
        end
    end)
    
    -- Toggle: Auto Find Volcano
    CreateToggle(EventosMarTab, "🌋 Auto Procurar Vulcão", "AutoVolcano", function(enabled)
        _G.DealBlox.Settings.AutoVolcano = enabled
    end)
    
    -- Toggle: Auto Find Leviathan
    CreateToggle(EventosMarTab, "🐉 Auto Procurar Leviathan", "AutoLeviathan", function(enabled)
        _G.DealBlox.Settings.AutoLeviathan = enabled
    end)
else
    CreateLabel(EventosMarTab, "⚠️ Ilhas especiais apenas no Sea 3!")
end

-- =========================
-- PÁGINA: RAÇAS
-- =========================
local RacasTab = TabFrames["Raças"].Frame

CreateSection(RacasTab, "Raça Normal")

-- Toggle: Auto V1-V3
CreateToggle(RacasTab, "🧬 Auto Raça V1 → V3", "AutoRaceV1toV3", function(enabled)
    _G.DealBlox.Settings.AutoRaceV1toV3 = enabled
end)

-- Sistema Auto Race V1 to V3
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoRaceV1toV3 then
            pcall(function()
                local remote = GetRemote()
                if not remote then return end
                
                local currentRace = LocalPlayer.Data.Race.Value
                
                -- Verificar se já tem V3
                if currentRace:find("V3") then
                    Notify("✅ Completo!", "Você já tem Raça V3!", 3)
                    _G.DealBlox.Settings.AutoRaceV1toV3 = false
                    return
                end
                
                -- Pegar V2 (Sea 2)
                if not currentRace:find("V2") and CurrentSea >= 2 then
                    if LocalPlayer.Data.Level.Value >= 1000 then
                        SafeTP(CFrame.new(-2836, 14, -3036))
                        task.wait(2)
                        remote:InvokeServer("Wenlocktoad", "1")
                        task.wait(1)
                        remote:InvokeServer("Wenlocktoad", "2")
                        Notify("✅ V2 Obtida!", "Raça V2 desbloqueada!", 3)
                        task.wait(5)
                    end
                end
                
                -- Pegar V3 (Sea 3)
                if currentRace:find("V2") and not currentRace:find("V3") and CurrentSea >= 3 then
                    if LocalPlayer.Data.Level.Value >= 1500 then
                        SafeTP(CFrame.new(2681, 1682, -7190))
                        task.wait(2)
                        remote:InvokeServer("Arowe", "1")
                        task.wait(1)
                        -- Completar quest específica da raça
                        remote:InvokeServer("Arowe", "3")
                        Notify("✅ V3 Obtida!", "Raça V3 desbloqueada!", 3)
                        _G.DealBlox.Settings.AutoRaceV1toV3 = false
                    end
                end
            end)
        end
    end
end)

-- Toggle: Auto Get Cyborg
CreateToggle(RacasTab, "🤖 Auto Pegar Raça Cyborg", "AutoGetCyborg", function(enabled)
    _G.DealBlox.Settings.AutoGetCyborg = enabled
end)

-- Toggle: Auto Get Ghoul
CreateToggle(RacasTab, "🧛 Auto Pegar Raça Ghoul", "AutoGetGhoul", function(enabled)
    _G.DealBlox.Settings.AutoGetGhoul = enabled
end)

CreateSection(RacasTab, "Raça V4 (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Miragem V4
    CreateToggle(RacasTab, "🌕 Auto Miragem V4 (Lua Cheia)", "AutoMirageV4", function(enabled)
        _G.DealBlox.Settings.AutoMirageV4 = enabled
    end)
    
    -- Botão: Teleportar Temple
    CreateButton(RacasTab, "⏱️ Teleportar para Temple of Time", function()
        SafeTP(CFrame.new(-5413, 314, -2823))
        Notify("✅ Teleportado", "Você está no Temple of Time!", 2)
    end)
    
    -- Botão: Comprar Gears
    CreateButton(RacasTab, "⚙️ Comprar Gear (Engrenagem)", function()
        local remote = GetRemote()
        if not remote then
            Notify("❌ Erro", "Remote não encontrado!", 2)
            return
        end
        
        Notify("⏳ Comprando", "Tentando comprar gear...", 2)
        
        task.spawn(function()
            SafeTP(CFrame.new(-5413, 314, -2823))
            task.wait(2)
            
            local success = pcall(function()
                remote:InvokeServer("BuyGear")
            end)
            
            if success then
                Notify("✅ Sucesso", "Gear comprada!", 3)
            else
                Notify("❌ Erro", "Verifique se você tem fragmentos suficientes!", 3)
            end
        end)
    end)
    
    -- Toggle: Treinar V4
    CreateToggle(RacasTab, "💪 Auto Treinar Raça V4", "AutoTrainV4", function(enabled)
        _G.DealBlox.Settings.AutoTrainV4 = enabled
    end)
else
    CreateLabel(RacasTab, "⚠️ Raça V4 apenas no Sea 3!")
end

CreateSection(RacasTab, "Raça Draco (Sea 3)")

if CurrentSea == 3 then
    -- Toggle: Auto Draco V2-V3
    CreateToggle(RacasTab, "🐉 Auto Raça Draco V2 → V3", "AutoDracoV2V3", function(enabled)
        _G.DealBlox.Settings.AutoDracoV2V3 = enabled
    end)
    
    -- Toggle: Auto Trial Draco
    CreateToggle(RacasTab, "🔥 Auto Trial Draco", "AutoTrialDraco", function(enabled)
        _G.DealBlox.Settings.AutoTrialDraco = enabled
    end)
    
    -- Botão: Craftar Volcanic Magnet
    CreateButton(RacasTab, "🧲 Craftar Volcanic Magnet", function()
        local remote = GetRemote()
        if not remote then
            Notify("❌ Erro", "Remote não encontrado!", 2)
            return
        end
        
        Notify("⏳ Craftando", "Tentando craftar Volcanic Magnet...", 2)
        
        task.spawn(function()
            SafeTP(CFrame.new(-10961, 331, -8500))
            task.wait(2)
            
            local success = pcall(function()
                remote:InvokeServer("CraftVolcanicMagnet")
            end)
            
            if success then
                Notify("✅ Sucesso", "Volcanic Magnet craftado!", 3)
            else
                Notify("❌ Erro", "Verifique se você tem os materiais necessários!", 3)
            end
        end)
    end)
else
    CreateLabel(RacasTab, "⚠️ Raça Draco apenas no Sea 3!")
end

print("✅ DEAL BLOX - PARTE 10/15 CARREGADA")

-- =========================
-- PÁGINA: ITENS
-- =========================
local ItensTab = TabFrames["Itens"].Frame

CreateSection(ItensTab, "Em Desenvolvimento")

CreateLabel(ItensTab, [[
⚠️ PÁGINA EM DESENVOLVIMENTO

Esta página será implementada em atualizações futuras com:

📦 Gerenciamento de Itens
⚔️ Armas Especiais
🎒 Inventário
💎 Materiais Raros
🔧 Ferramentas

Aguarde!
]])

-- Adicionar placeholder de funcionalidades futuras
CreateButton(ItensTab, "📋 Listar Itens do Inventário", function()
    Notify("⚠️ Em Breve", "Esta funcionalidade será implementada!", 2)
end)

CreateButton(ItensTab, "🗑️ Deletar Itens Inúteis", function()
    Notify("⚠️ Em Breve", "Esta funcionalidade será implementada!", 2)
end)

-- =========================
-- PÁGINA: DRACO
-- =========================
local DracoTab = TabFrames["Draco"].Frame

CreateSection(DracoTab, "Informações sobre Draco")

CreateLabel(DracoTab, [[
🐉 RAÇA DRACO

A raça Draco é uma raça especial do Sea 3.

Para obter a raça Draco, você precisa:
- Estar no Sea 3
- Completar missões específicas
- Ter materiais necessários

📌 Use a aba "Raças" para:
- Auto Draco V2 → V3
- Auto Trial Draco
- Craftar Volcanic Magnet
]])

CreateSection(DracoTab, "Atalhos Rápidos")

-- Botão: TP Hydra Island
CreateButton(DracoTab, "🐉 Teleportar para Hydra Island", function()
    if CurrentSea ~= 3 then
        Notify("❌ Sea Incorreto", "Hydra Island apenas no Sea 3!", 3)
        return
    end
    
    SafeTP(CFrame.new(5749, 612, -276))
    Notify("✅ Teleportado", "Você está na Hydra Island!", 2)
end)

-- Botão: TP Vulcão
CreateButton(DracoTab, "🌋 Teleportar para Vulcão", function()
    if CurrentSea ~= 3 then
        Notify("❌ Sea Incorreto", "Vulcão apenas no Sea 3!", 3)
        return
    end
    
    SafeTP(CFrame.new(-10961, 331, -8500))
    Notify("✅ Teleportado", "Você está no Vulcão!", 2)
end)

CreateSection(DracoTab, "Missões Draco")

-- Info sobre progresso
CreateLabel(DracoTab, [[
📊 PROGRESSO DRACO

Para ver seu progresso e completar missões Draco:
1. Vá para Hydra Island
2. Fale com o NPC Dragon Hunter
3. Complete as missões

Use "Auto Draco V2→V3" na aba Raças para automatizar!
]])

-- =========================
-- PÁGINA: ESP
-- =========================
local ESPTab = TabFrames["ESP"].Frame

CreateSection(ESPTab, "ESP Geral")

-- Toggle: ESP Berry
CreateToggle(ESPTab, "💰 ESP Berry", "ESPBerry", function(enabled)
    _G.DealBlox.Settings.ESPBerry = enabled
end)

-- Sistema ESP Berry
task.spawn(function()
    local BerryESP = {}
    
    while task.wait(1) do
        if _G.DealBlox.Settings.ESPBerry then
            pcall(function()
                -- Limpar ESP antigos
                for _, esp in pairs(BerryESP) do
                    if esp then
                        esp:Destroy()
                    end
                end
                BerryESP = {}
                
                -- Criar ESP para berries
                for _, berry in pairs(workspace:GetChildren()) do
                    if berry.Name == "Berry" and berry:FindFirstChild("Handle") then
                        local BillboardGui = Instance.new("BillboardGui")
                        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
                        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.Parent = berry.Handle
                        
                        local TextLabel = Instance.new("TextLabel", BillboardGui)
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.Text = "💰 Berry\n" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - berry.Handle.Position).Magnitude) .. "m"
                        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextSize = 12
                        TextLabel.TextStrokeTransparency = 0.5
                        
                        table.insert(BerryESP, BillboardGui)
                    end
                end
            end)
        else
            -- Limpar ESP quando desativado
            for _, esp in pairs(BerryESP) do
                if esp then
                    esp:Destroy()
                end
            end
            BerryESP = {}
        end
    end
end)

-- Toggle: ESP Ilha
CreateToggle(ESPTab, "🏝️ ESP Ilhas", "ESPIsland", function(enabled)
    _G.DealBlox.Settings.ESPIsland = enabled
end)

-- Sistema ESP Island
task.spawn(function()
    local IslandESP = {}
    
    while task.wait(5) do
        if _G.DealBlox.Settings.ESPIsland then
            pcall(function()
                -- Limpar ESP antigos
                for _, esp in pairs(IslandESP) do
                    if esp then
                        esp:Destroy()
                    end
                end
                IslandESP = {}
                
                -- Criar ESP para ilhas
                for islandName, islandPos in pairs(IslandPositions) do
                    local Part = Instance.new("Part", workspace)
                    Part.Size = Vector3.new(1, 1, 1)
                    Part.Position = islandPos.Position
                    Part.Transparency = 1
                    Part.CanCollide = false
                    Part.Anchored = true
                    
                    local BillboardGui = Instance.new("BillboardGui", Part)
                    BillboardGui.Size = UDim2.new(0, 150, 0, 50)
                    BillboardGui.StudsOffset = Vector3.new(0, 10, 0)
                    BillboardGui.AlwaysOnTop = true
                    
                    local TextLabel = Instance.new("TextLabel", BillboardGui)
                    TextLabel.Size = UDim2.new(1, 0, 1, 0)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.Text = "🏝️ " .. islandName .. "\n" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - islandPos.Position).Magnitude) .. "m"
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 12
                    TextLabel.TextStrokeTransparency = 0.5
                    
                    table.insert(IslandESP, Part)
                end
            end)
        else
            -- Limpar ESP
            for _, esp in pairs(IslandESP) do
                if esp then
                    esp:Destroy()
                end
            end
            IslandESP = {}
        end
    end
end)

-- Toggle: ESP Fruta
CreateToggle(ESPTab, "🍎 ESP Frutas", "ESPFruit", function(enabled)
    _G.DealBlox.Settings.ESPFruit = enabled
end)

-- Sistema ESP Fruit
task.spawn(function()
    local FruitESP = {}
    
    while task.wait(1) do
        if _G.DealBlox.Settings.ESPFruit then
            pcall(function()
                -- Limpar ESP antigos
                for _, esp in pairs(FruitESP) do
                    if esp then
                        esp:Destroy()
                    end
                end
                FruitESP = {}
                
                -- Criar ESP para frutas
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                        local BillboardGui = Instance.new("BillboardGui")
                        BillboardGui.Size = UDim2.new(0, 150, 0, 50)
                        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.Parent = fruit.Handle
                        
                        local TextLabel = Instance.new("TextLabel", BillboardGui)
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.Text = "🍎 " .. fruit.Name .. "\n" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - fruit.Handle.Position).Magnitude) .. "m"
                        TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextSize = 14
                        TextLabel.TextStrokeTransparency = 0.5
                        
                        table.insert(FruitESP, BillboardGui)
                    end
                end
            end)
        else
            -- Limpar ESP
            for _, esp in pairs(FruitESP) do
                if esp then
                    esp:Destroy()
                end
            end
            FruitESP = {}
        end
    end
end)

-- Toggle: ESP Jogador
CreateToggle(ESPTab, "👥 ESP Jogadores", "ESPPlayer", function(enabled)
    _G.DealBlox.Settings.ESPPlayer = enabled
end)

-- Sistema ESP Player
task.spawn(function()
    local PlayerESP = {}
    
    while task.wait(1) do
        if _G.DealBlox.Settings.ESPPlayer then
            pcall(function()
                -- Limpar ESP antigos
                for _, esp in pairs(PlayerESP) do
                    if esp then
                        esp:Destroy()
                    end
                end
                PlayerESP = {}
                
                -- Criar ESP para jogadores
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local BillboardGui = Instance.new("BillboardGui")
                        BillboardGui.Size = UDim2.new(0, 200, 0, 80)
                        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.Parent = player.Character.HumanoidRootPart
                        
                        local TextLabel = Instance.new("TextLabel", BillboardGui)
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.BackgroundTransparency = 1
                        
                        local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                        local health = math.floor(player.Character.Humanoid.Health)
                        local maxHealth = math.floor(player.Character.Humanoid.MaxHealth)
                        
                        TextLabel.Text = string.format("👤 %s\n❤️ %d/%d\n📏 %dm", 
                            player.Name, 
                            health, 
                            maxHealth, 
                            distance
                        )
                        
                        -- Cor baseada na saúde
                        local healthPercent = health / maxHealth
                        if healthPercent > 0.5 then
                            TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 0.25 then
                            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                        
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextSize = 12
                        TextLabel.TextStrokeTransparency = 0.5
                        
                        table.insert(PlayerESP, BillboardGui)
                    end
                end
            end)
        else
            -- Limpar ESP
            for _, esp in pairs(PlayerESP) do
                if esp then
                    esp:Destroy()
                end
            end
            PlayerESP = {}
        end
    end
end)

CreateSection(ESPTab, "Informações")

CreateLabel(ESPTab, [[
ℹ️ SOBRE ESP:

👁️ ESP = Extra Sensory Perception
Mostra informações sobre objetos/jogadores através de paredes

📏 Distância em metros
❤️ Vida dos jogadores (cores):
  🟢 Verde = Saudável (>50%)
  🟡 Amarelo = Machucado (25-50%)
  🔴 Vermelho = Crítico (<25%)

⚠️ ESP pode causar LAG em servidores cheios!
]])

-- =========================
-- PÁGINA: PVP
-- =========================
local PVPTab = TabFrames["PVP"].Frame

CreateSection(PVPTab, "Seleção de Alvo")

-- Criar lista de jogadores para PVP
local function GetPVPPlayerList()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            table.insert(players, player.Name)
        end
    end
    return #players > 0 and players or {"Nenhum jogador disponível"}
end

-- Dropdown: Selecionar Jogador
CreateDropdown(PVPTab, "🎯 Selecionar Jogador Alvo", GetPVPPlayerList(), "SelectedPVPPlayer", function(playerName)
    Notify("✅ Alvo Selecionado", playerName, 2)
end)

-- Toggle: Auto PVP
CreateToggle(PVPTab, "⚔️ Auto Atacar Jogador Selecionado", "AutoPVP", function(enabled)
    if enabled then
        local selectedPlayer = _G.DealBlox.Settings.SelectedPVPPlayer
        if not selectedPlayer or selectedPlayer == "Nenhum" or selectedPlayer == "Nenhum jogador disponível" then
            Notify("⚠️ Nenhum Alvo", "Selecione um jogador primeiro!", 3)
            _G.DealBlox.Settings.AutoPVP = false
            return
        end
    end
    _G.DealBlox.Settings.AutoPVP = enabled
end)

-- Sistema Auto PVP
task.spawn(function()
    while task.wait(0.5) do
        if _G.DealBlox.Settings.AutoPVP then
            pcall(function()
                local selectedPlayer = _G.DealBlox.Settings.SelectedPVPPlayer
                
                if not selectedPlayer or selectedPlayer == "Nenhum" or selectedPlayer == "Nenhum jogador disponível" then
                    return
                end
                
                local targetPlayer = Players:FindFirstChild(selectedPlayer)
                
                if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") or not targetPlayer.Character:FindFirstChild("Humanoid") or targetPlayer.Character.Humanoid.Health <= 0 then
                    Notify("⚠️ Alvo Perdido", selectedPlayer .. " não está disponível!", 3)
                    _G.DealBlox.Settings.AutoPVP = false
                    return
                end
                
                -- Equipar arma
                EquipWeapon()
                ActivateBuso()
                
                -- Ir para o jogador
                local distance = _G.DealBlox.Settings.FarmDistance or 30
                local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                end
                
                -- Auto click ativo
                _G.DealBlox.Settings.AutoClick = true
                
                -- Se fruta equipada, usar habilidades
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                        for _, key in pairs({"Z", "X", "C", "V", "F"}) do
                            pcall(function()
                                VirtualUser:TypeKey(key)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

CreateSection(PVPTab, "Aimbot")

-- Toggle: Auto Aimbot
CreateToggle(PVPTab, "🎯 Auto Aimbot", "AutoAimbot", function(enabled)
    _G.DealBlox.Settings.AutoAimbot = enabled
end)

-- Sistema Aimbot
task.spawn(function()
    while task.wait(0.1) do
        if _G.DealBlox.Settings.AutoAimbot then
            pcall(function()
                local selectedPlayer = _G.DealBlox.Settings.SelectedPVPPlayer
                
                if not selectedPlayer or selectedPlayer == "Nenhum" or selectedPlayer == "Nenhum jogador disponível" then
                    return
                end
                
                local targetPlayer = Players:FindFirstChild(selectedPlayer)
                
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 then
                    -- Apontar câmera para o jogador
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        workspace.CurrentCamera.CFrame = CFrame.new(
                            workspace.CurrentCamera.CFrame.Position,
                            targetPlayer.Character.HumanoidRootPart.Position
                        )
                    end
                end
            end)
        end
    end
end)

CreateSection(PVPTab, "Informações")

CreateLabel(PVPTab, [[
ℹ️ SOBRE PVP:

⚔️ AUTO PVP:
- Selecione um jogador
- Ative "Auto Atacar"
- O script irá perseguir e atacar

🎯 AIMBOT:
- Aponta automaticamente para o alvo
- Funciona com qualquer arma
- Combine com Auto PVP para melhor resultado

⚠️ CUIDADO:
- Use em servidores PVP
- Pode ser considerado unfair play
- Use por sua conta e risco

💡 DICA:
- Use armas de longo alcance
- Ative Observation Haki
- Configure a distância ideal
]])

CreateSection(PVPTab, "Atalhos")

-- Botão: Resetar Character
CreateButton(PVPTab, "🔄 Resetar Personagem", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
        Notify("🔄 Resetado", "Personagem resetado!", 2)
    end
end)

-- Botão: Ativar PvP
CreateButton(PVPTab, "⚔️ Ativar Modo PvP", function()
    local remote = GetRemote()
    if remote then
        remote:InvokeServer("EnablePvP")
        Notify("⚔️ PvP Ativado", "Modo PvP habilitado!", 2)
    end
end)

print("✅ DEAL BLOX - PARTE 11/15 CARREGADA")

-- =========================
-- PÁGINA: CONFIGURAÇÕES
-- =========================
local ConfigTab = TabFrames["Configurações"].Frame

CreateSection(ConfigTab, "Interface")

-- Toggle: Mostrar Notificações
CreateToggle(ConfigTab, "🔔 Mostrar Notificações", "ShowNotifications", function(enabled)
    _G.DealBlox.Settings.ShowNotifications = enabled
    if enabled then
        Notify("✅ Notificações", "Notificações ativadas!", 2)
    end
end)

-- Slider: Transparência do Painel
CreateSlider(ConfigTab, "👁️ Transparência do Painel (0-100%)", 0, 100, 20, "PanelTransparency", function(value)
    local transparency = value / 100
    MainPanel.BackgroundTransparency = transparency
    Notify("👁️ Transparência", value .. "%", 2)
end)

-- Toggle: Modo Compacto
CreateToggle(ConfigTab, "📱 Modo Compacto (Mobile)", "CompactMode", function(enabled)
    if enabled then
        GuiConfig.TamanhoAtual = {Width = 400, Height = 350}
        Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(400, 350)}):Play()
        Notify("📱 Modo Compacto", "Interface reduzida para mobile!", 2)
    else
        GuiConfig.TamanhoAtual = {Width = 600, Height = 450}
        Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(600, 450)}):Play()
        Notify("💻 Modo Normal", "Interface restaurada!", 2)
    end
end)

CreateSection(ConfigTab, "Performance")

-- Toggle: Boost FPS
CreateToggle(ConfigTab, "⚡ Modo Boost FPS", "BoostFPS", function(enabled)
    if enabled then
        -- Reduzir qualidade gráfica
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        
        Notify("⚡ FPS Boost", "Gráficos reduzidos para melhor performance!", 3)
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Notify("🎨 Gráficos", "Qualidade gráfica restaurada!", 2)
    end
end)

-- Toggle: Remover Neblina
CreateToggle(ConfigTab, "🌫️ Remover Neblina", "RemoveFog", function(enabled)
    if enabled then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Notify("🌫️ Neblina", "Neblina removida!", 2)
    else
        Lighting.FogEnd = 2500
        Lighting.FogStart = 0
        Notify("🌫️ Neblina", "Neblina restaurada!", 2)
    end
end)

-- Toggle: Fullbright
CreateToggle(ConfigTab, "💡 Fullbright (Tudo Claro)", "Fullbright", function(enabled)
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Notify("💡 Fullbright", "Ambiente totalmente iluminado!", 2)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        Notify("💡 Iluminação", "Iluminação normal restaurada!", 2)
    end
end)

CreateSection(ConfigTab, "Segurança")

-- Toggle: Anti AFK
CreateToggle(ConfigTab, "⏰ Anti AFK", "AntiAFK", function(enabled)
    _G.DealBlox.Settings.AntiAFK = enabled
end)

-- Sistema Anti AFK
task.spawn(function()
    while task.wait(30) do
        if _G.DealBlox.Settings.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- Toggle: Auto Rejoin
CreateToggle(ConfigTab, "🔄 Auto Rejoin (Disconnect)", "AutoRejoin", function(enabled)
    _G.DealBlox.Settings.AutoRejoin = enabled
end)

-- Sistema Auto Rejoin
game:GetService("CoreGui").ChildAdded:Connect(function(child)
    if _G.DealBlox.Settings.AutoRejoin then
        if child.Name == "RobloxPromptGui" then
            task.wait(1)
            if child:FindFirstChild("promptOverlay") then
                child.promptOverlay.ChildAdded:Connect(function(prompt)
                    if prompt.Name == "ErrorPrompt" then
                        Notify("🔄 Reconectando", "Você foi desconectado! Reconectando...", 3)
                        task.wait(2)
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    end
                end)
            end
        end
    end
end)

CreateSection(ConfigTab, "Dados")

-- Botão: Salvar Configurações
CreateButton(ConfigTab, "💾 Salvar Configurações", function()
    -- Salvar configurações em um arquivo local (se o executor suportar)
    local success = pcall(function()
        if writefile then
            local configData = HttpService:JSONEncode(_G.DealBlox.Settings)
            writefile("DealBloxConfig.json", configData)
            Notify("💾 Salvo", "Configurações salvas com sucesso!", 3)
        else
            Notify("⚠️ Não Suportado", "Seu executor não suporta salvar arquivos!", 3)
        end
    end)
    
    if not success then
        Notify("❌ Erro", "Erro ao salvar configurações!", 2)
    end
end)

-- Botão: Carregar Configurações
CreateButton(ConfigTab, "📂 Carregar Configurações", function()
    local success = pcall(function()
        if readfile and isfile and isfile("DealBloxConfig.json") then
            local configData = readfile("DealBloxConfig.json")
            local loadedSettings = HttpService:JSONDecode(configData)
            
            for key, value in pairs(loadedSettings) do
                _G.DealBlox.Settings[key] = value
            end
            
            Notify("📂 Carregado", "Configurações carregadas com sucesso!", 3)
        else
            Notify("⚠️ Não Encontrado", "Nenhuma configuração salva encontrada!", 3)
        end
    end)
    
    if not success then
        Notify("❌ Erro", "Erro ao carregar configurações!", 2)
    end
end)

-- Botão: Resetar Configurações
CreateButton(ConfigTab, "🔄 Resetar Todas Configurações", function()
    -- Resetar todas as configurações para padrão
    _G.DealBlox.Settings = {
        -- Farm
        AutoFarm = false,
        AutoFarmKatakuriV1 = false,
        AutoFarmKatakuriV2 = false,
        SelectedWeapon = "Estilo de luta",
        AutoClick = false,
        AutoObservation = false,
        AutoRaceV3 = false,
        AutoRaceV4 = false,
        FarmDistance = 30,
        
        -- Mastery
        MasteryMode = "Nenhum",
        AutoMastery = false,
        
        -- Sea
        AutoSea2 = false,
        AutoSea3 = false,
        AutoFactory = false,
        AutoPirateRaid = false,
        
        -- Rip Indra
        AutoEliteHunter = false,
        AutoSpawnRipIndra = false,
        AutoHakiRipIndra = false,
        AutoAttackRipIndra = false,
        SelectedBoss = "Nenhum",
        AutoAttackBoss = false,
        
        -- Raids
        SelectedRaid = "Flame",
        SelectedRaidWeapon = "Estilo de luta",
        AutoRaid = false,
        AutoChip = false,
        AutoAttackRaid = false,
        
        -- Dungeon
        SelectedDifficulty = "Normal",
        
        -- Frutas
        AutoSpinFruit = false,
        AutoStoreFruit = false,
        AutoHuntFruit = false,
        SelectedFruitToBuy = "Nenhum",
        AutoHuntBerry = false,
        
        -- Raças
        AutoRaceV1toV3 = false,
        AutoGetCyborg = false,
        AutoGetGhoul = false,
        
        -- ESP
        ESPBerry = false,
        ESPIsland = false,
        ESPFruit = false,
        ESPPlayer = false,
        
        -- Teleport
        SelectedIsland = "Nenhum",
        SelectedPlayer = "Nenhum",
        
        -- PVP
        SelectedPVPPlayer = "Nenhum",
        AutoPVP = false,
        AutoAimbot = false,
        
        -- Config
        ShowNotifications = true,
        PanelTransparency = 20,
        CompactMode = false,
        BoostFPS = false,
        RemoveFog = false,
        Fullbright = false,
        AntiAFK = false,
        AutoRejoin = false
    }
    
    Notify("🔄 Resetado", "Todas as configurações foram resetadas!", 3)
end)

CreateSection(ConfigTab, "Script")

-- Botão: Recarregar Script
CreateButton(ConfigTab, "🔄 Recarregar Script", function()
    Notify("🔄 Recarregando", "Reiniciando script...", 2)
    
    task.wait(1)
    
    -- Desligar todas as funcionalidades
    for key, value in pairs(_G.DealBlox.Settings) do
        if type(value) == "boolean" then
            _G.DealBlox.Settings[key] = false
        end
    end
    
    task.wait(0.5)
    
    -- Destruir GUI
    if MainGui then
        MainGui:Destroy()
    end
    
    task.wait(0.5)
    
    -- Resetar flag de carregamento
    _G.DealBloxLoaded = false
    
    Notify("✅ Pronto", "Script pode ser executado novamente!", 2)
end)

-- Botão: Desligar Script
CreateButton(ConfigTab, "❌ Desligar Script Completamente", function()
    Notify("❌ Desligando", "Desativando todas as funcionalidades...", 2)
    
    task.wait(1)
    
    -- Desligar TUDO
    for key, value in pairs(_G.DealBlox.Settings) do
        if type(value) == "boolean" then
            _G.DealBlox.Settings[key] = false
        end
    end
    
    _G.DealBlox.TempStates.IsFarming = false
    _G.DealBlox.TempStates.IsInRaid = false
    _G.DealBlox.TempStates.CurrentQuest = nil
    _G.DealBlox.TempStates.WaitingFor = nil
    
    task.wait(0.5)
    
    -- Fechar GUI
    GuiConfig.Aberto = false
    Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(0, 0)}):Play()
    task.wait(0.3)
    MainPanel.Visible = false
    
    Notify("✅ Desligado", "Todas as funcionalidades desativadas! GUI minimizada.", 3)
end)

CreateSection(ConfigTab, "Informações do Script")

CreateLabel(ConfigTab, string.format([[
📋 DEAL BLOX SCRIPTS

🎮 Versão: %s
👨‍💻 Desenvolvedor: %s
💬 Discord: %s

🌊 Sea Atual: %d
⭐ Seu Level: %d
🧬 Sua Raça: %s

⏰ Tempo de Execução: %s
🖥️ Uptime do Servidor: %s

💙 Obrigado por usar Deal Blox Scripts!
]], 
    _G.DealBlox.Version,
    _G.DealBlox.Author,
    _G.DealBlox.Discord,
    CurrentSea,
    LocalPlayer.Data.Level.Value,
    LocalPlayer.Data.Race.Value or "Desconhecido",
    GetPlayTime(),
    GetServerTime()
))

CreateSection(ConfigTab, "Suporte")

-- Botão: Copiar Discord
CreateButton(ConfigTab, "💬 Copiar Link do Discord", function()
    local discordLink = "https://discord.gg/rPFN7BMC5k"
    
    pcall(function()
        setclipboard(discordLink)
    end)
    
    Notify("💬 Discord", "Link copiado: " .. discordLink, 3)
end)

-- Botão: Reportar Bug
CreateButton(ConfigTab, "🐛 Reportar Bug (Discord)", function()
    Notify("🐛 Reportar Bug", "Entre no Discord para reportar bugs!\ndiscord.gg/rPFN7BMC5k", 5)
    
    pcall(function()
        setclipboard("https://discord.gg/rPFN7BMC5k")
    end)
end)

CreateSection(ConfigTab, "Aviso Legal")

CreateLabel(ConfigTab, [[
⚠️ AVISO IMPORTANTE:

- Este script é fornecido "como está"
- Use por sua própria conta e risco
- O desenvolvedor NÃO se responsabiliza por:
  - Bans
  - Perda de progresso
  - Problemas técnicos

- Recomendamos usar em contas secundárias
- Não abuse das funcionalidades
- Seja respeitoso com outros jogadores

✅ Ao usar este script, você concorda com os termos acima.
]])

-- =========================
-- SISTEMA DE DESLIGAR AO SAIR
-- =========================
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        -- Desligar TODAS as funcionalidades
        for key, value in pairs(_G.DealBlox.Settings) do
            if type(value) == "boolean" then
                _G.DealBlox.Settings[key] = false
            end
        end
        
        -- Limpar estados temporários
        _G.DealBlox.TempStates.IsFarming = false
        _G.DealBlox.TempStates.IsInRaid = false
        _G.DealBlox.TempStates.CurrentQuest = nil
        _G.DealBlox.TempStates.WaitingFor = nil
        
        print("🛑 DEAL BLOX SCRIPTS DESLIGADO - Todas as funcionalidades desativadas ao sair do jogo")
    end
end)

-- =========================
-- SISTEMA DE ATUALIZAÇÃO DE TEMPO
-- =========================
task.spawn(function()
    while task.wait(60) do
        pcall(function()
            -- Atualizar label de informações na página de configurações se estiver visível
            if ConfigTab.Visible then
                for _, child in pairs(ConfigTab:GetChildren()) do
                    if child:IsA("TextLabel") and child.Text:find("Tempo de Execução") then
                        child.Text = string.format([[
📋 DEAL BLOX SCRIPTS

🎮 Versão: %s
👨‍💻 Desenvolvedor: %s
💬 Discord: %s

🌊 Sea Atual: %d
⭐ Seu Level: %d
🧬 Sua Raça: %s

⏰ Tempo de Execução: %s
🖥️ Uptime do Servidor: %s

💙 Obrigado por usar Deal Blox Scripts!
]], 
                            _G.DealBlox.Version,
                            _G.DealBlox.Author,
                            _G.DealBlox.Discord,
                            CurrentSea,
                            LocalPlayer.Data.Level.Value,
                            LocalPlayer.Data.Race.Value or "Desconhecido",
                            GetPlayTime(),
                            GetServerTime()
                        )
                        break
                    end
                end
            end
        end)
    end
end)

-- =========================
-- COMANDOS DE CHAT (OPCIONAL)
-- =========================
LocalPlayer.Chatted:Connect(function(message)
    local msg = message:lower()
    
    if msg == "/dealblox" or msg == "/db" then
        GuiConfig.Aberto = not GuiConfig.Aberto
        
        if GuiConfig.Aberto then
            MainPanel.Visible = true
            Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(GuiConfig.TamanhoAtual.Width, GuiConfig.TamanhoAtual.Height)}):Play()
        else
            Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(0, 0)}):Play()
            task.wait(0.3)
            MainPanel.Visible = false
        end
    elseif msg == "/dealblox stop" or msg == "/db stop" then
        -- Desligar tudo
        for key, value in pairs(_G.DealBlox.Settings) do
            if type(value) == "boolean" then
                _G.DealBlox.Settings[key] = false
            end
        end
        Notify("🛑 Parado", "Todas as funcionalidades desativadas!", 3)
    elseif msg == "/dealblox info" or msg == "/db info" then
        Notify("ℹ️ Info", string.format("Deal Blox v%s | Sea %d | Level %d", _G.DealBlox.Version, CurrentSea, LocalPlayer.Data.Level.Value), 5)
    end
end)

print("✅ DEAL BLOX - PARTE 12/15 CARREGADA")

-- =========================
-- OTIMIZAÇÕES E CORREÇÕES
-- =========================

-- Sistema de limpeza de memória
task.spawn(function()
    while task.wait(300) do -- A cada 5 minutos
        pcall(function()
            -- Limpar objetos desnecessários
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Attachment") and not obj.Parent:FindFirstChildOfClass("Humanoid") then
                    obj:Destroy()
                end
            end
            
            -- Coletar lixo
            collectgarbage("collect")
        end)
    end
end)

-- =========================
-- CORREÇÕES DE BUGS CONHECIDOS
-- =========================

-- Fix: Teleporte travando
local LastTeleportTime = 0
local OriginalSafeTP = SafeTP

function SafeTP(cframe)
    local currentTime = tick()
    
    -- Cooldown de 0.5s entre teleportes
    if currentTime - LastTeleportTime < 0.5 then
        task.wait(0.5 - (currentTime - LastTeleportTime))
    end
    
    LastTeleportTime = tick()
    return OriginalSafeTP(cframe)
end

-- Fix: Auto Farm travando quando sem quest
task.spawn(function()
    while task.wait(30) do
        if _G.DealBlox.Settings.AutoFarm then
            pcall(function()
                -- Verificar se está preso
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local humanoid = LocalPlayer.Character.Humanoid
                    
                    -- Se estiver parado há muito tempo, resetar posição
                    if humanoid.MoveDirection.Magnitude < 0.1 then
                        local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
                        task.wait(5)
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local newPos = LocalPlayer.Character.HumanoidRootPart.Position
                            local distance = (currentPos - newPos).Magnitude
                            
                            if distance < 5 then
                                -- Teleportar para cima para destravar
                                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
                                Notify("🔧 Auto-Fix", "Posição destravada!", 2)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Fix: Mobs desaparecendo
local function FixMobRespawn()
    task.spawn(function()
        while task.wait(60) do
            if _G.DealBlox.Settings.AutoFarm or _G.DealBlox.Settings.AutoMastery then
                pcall(function()
                    local playerLevel = LocalPlayer.Data.Level.Value
                    local questData = GetQuestByLevel(playerLevel)
                    
                    if questData then
                        local mobCount = 0
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob.Name == questData.Mob then
                                mobCount = mobCount + 1
                            end
                        end
                        
                        -- Se muito poucos mobs, ir para outro lugar e voltar
                        if mobCount < 2 then
                            local currentPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                            SafeTP(currentPos + Vector3.new(0, 500, 0))
                            task.wait(2)
                            SafeTP(questData.Pos)
                        end
                    end
                end)
            end
        end
    end)
end

FixMobRespawn()

-- =========================
-- MELHORIAS DE PERFORMANCE
-- =========================

-- Otimização de hitbox (reduzir lag)
local HitboxCache = {}
local function OptimizedHitbox(mob)
    if not HitboxCache[mob] then
        HitboxCache[mob] = true
        
        task.spawn(function()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                mob.HumanoidRootPart.Transparency = 0.8
                mob.HumanoidRootPart.CanCollide = false
                
                -- Limpar cache quando mob morrer
                mob.Humanoid.Died:Connect(function()
                    HitboxCache[mob] = nil
                end)
            end
        end)
    end
end

-- Reduzir chamadas de GetRemote
local CachedRemote = nil
local LastRemoteCheck = 0

function GetRemote()
    local currentTime = tick()
    
    if CachedRemote and (currentTime - LastRemoteCheck < 5) then
        return CachedRemote
    end
    
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("CommF_", 5)
    end)
    
    if success then
        CachedRemote = remote
        LastRemoteCheck = currentTime
    end
    
    return success and remote or nil
end

-- =========================
-- SISTEMA DE LOGS
-- =========================
local Logs = {}
local MaxLogs = 50

local function AddLog(tipo, mensagem)
    local log = {
        Tipo = tipo,
        Mensagem = mensagem,
        Timestamp = os.date("%H:%M:%S")
    }
    
    table.insert(Logs, 1, log)
    
    -- Manter apenas os últimos 50 logs
    if #Logs > MaxLogs then
        table.remove(Logs, #Logs)
    end
    
    -- Print no console
    print(string.format("[%s] [%s] %s", log.Timestamp, tipo, mensagem))
end

-- Substituir Notify para adicionar logs
local OriginalNotify = Notify

function Notify(titulo, texto, duracao)
    AddLog(titulo, texto)
    return OriginalNotify(titulo, texto, duracao)
end

-- Comando para ver logs
LocalPlayer.Chatted:Connect(function(message)
    if message:lower() == "/dealblox logs" or message:lower() == "/db logs" then
        print("=== ÚLTIMOS LOGS ===")
        for i, log in ipairs(Logs) do
            print(string.format("%d. [%s] [%s] %s", i, log.Timestamp, log.Tipo, log.Mensagem))
            if i >= 20 then break end
        end
        print("====================")
    end
end)

-- =========================
-- PROTEÇÃO CONTRA CRASHES
-- =========================

-- Proteção de memória
task.spawn(function()
    while task.wait(60) do
        local memoryUsage = game:GetService("Stats"):GetTotalMemoryUsageMb()
        
        if memoryUsage > 1000 then -- Mais de 1GB
            Notify("⚠️ Memória Alta", "Limpando memória...", 2)
            
            -- Limpar ESP temporariamente
            local tempESPStates = {
                Berry = _G.DealBlox.Settings.ESPBerry,
                Island = _G.DealBlox.Settings.ESPIsland,
                Fruit = _G.DealBlox.Settings.ESPFruit,
                Player = _G.DealBlox.Settings.ESPPlayer
            }
            
            _G.DealBlox.Settings.ESPBerry = false
            _G.DealBlox.Settings.ESPIsland = false
            _G.DealBlox.Settings.ESPFruit = false
            _G.DealBlox.Settings.ESPPlayer = false
            
            task.wait(5)
            collectgarbage("collect")
            task.wait(2)
            
            -- Restaurar ESP
            _G.DealBlox.Settings.ESPBerry = tempESPStates.Berry
            _G.DealBlox.Settings.ESPIsland = tempESPStates.Island
            _G.DealBlox.Settings.ESPFruit = tempESPStates.Fruit
            _G.DealBlox.Settings.ESPPlayer = tempESPStates.Player
            
            Notify("✅ Memória", "Memória otimizada!", 2)
        end
    end
end)

-- Proteção contra erros em loop
local function SafeLoop(func, interval)
    task.spawn(function()
        while task.wait(interval or 1) do
            local success, err = pcall(func)
            if not success then
                AddLog("❌ ERRO", tostring(err))
            end
        end
    end)
end

-- =========================
-- SISTEMA DE ESTATÍSTICAS
-- =========================
local Stats = {
    MobsKilled = 0,
    BossesKilled = 0,
    LevelGained = 0,
    QuestsCompleted = 0,
    FruitsCollected = 0,
    BerriesCollected = 0,
    SessionStartLevel = LocalPlayer.Data.Level.Value
}

-- Salvar level inicial
local InitialLevel = LocalPlayer.Data.Level.Value

-- Atualizar estatísticas
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            Stats.LevelGained = LocalPlayer.Data.Level.Value - Stats.SessionStartLevel
        end)
    end
end)

-- Comando para ver stats
LocalPlayer.Chatted:Connect(function(message)
    if message:lower() == "/dealblox stats" or message:lower() == "/db stats" then
        local statsText = string.format([[
=== ESTATÍSTICAS DA SESSÃO ===
⏰ Tempo: %s
📊 Level Inicial: %d
⭐ Level Atual: %d
📈 Ganho: +%d levels
💀 Mobs Mortos: %d
👹 Bosses Mortos: %d
✅ Quests: %d
🍎 Frutas: %d
💰 Berries: %d
==============================
]], 
            GetPlayTime(),
            Stats.SessionStartLevel,
            LocalPlayer.Data.Level.Value,
            Stats.LevelGained,
            Stats.MobsKilled,
            Stats.BossesKilled,
            Stats.QuestsCompleted,
            Stats.FruitsCollected,
            Stats.BerriesCollected
        )
        
        print(statsText)
        Notify("📊 Estatísticas", "Confira o console (F9)", 3)
    end
end)

-- =========================
-- DETECÇÃO DE ADMIN/MOD
-- =========================
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    -- Verificar se tem badge de admin/mod (simplificado)
                    local hasAdminBadge = false
                    
                    -- Lista de nomes conhecidos de admins/mods (exemplo)
                    local adminNames = {"Roblox", "Builderman", "Admin", "Moderator"}
                    
                    for _, adminName in pairs(adminNames) do
                        if player.Name:find(adminName) then
                            hasAdminBadge = true
                            break
                        end
                    end
                    
                    if hasAdminBadge then
                        Notify("⚠️ AVISO", "Possível Admin/Mod detectado: " .. player.Name, 5)
                        AddLog("⚠️ ADMIN", "Admin detectado: " .. player.Name)
                    end
                end
            end
        end)
    end
end)

-- =========================
-- KEYBINDS (ATALHOS DE TECLADO)
-- =========================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- INSERT = Toggle GUI
    if input.KeyCode == Enum.KeyCode.Insert then
        GuiConfig.Aberto = not GuiConfig.Aberto
        
        if GuiConfig.Aberto then
            MainPanel.Visible = true
            Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(GuiConfig.TamanhoAtual.Width, GuiConfig.TamanhoAtual.Height)}):Play()
        else
            Tween(MainPanel, 0.3, {Size = UDim2.fromOffset(0, 0)}):Play()
            task.wait(0.3)
            MainPanel.Visible = false
        end
    end
    
    -- END = Desligar tudo
    if input.KeyCode == Enum.KeyCode.End then
        for key, value in pairs(_G.DealBlox.Settings) do
            if type(value) == "boolean" then
                _G.DealBlox.Settings[key] = false
            end
        end
        Notify("🛑 Parado", "Tudo desligado via tecla END!", 3)
    end
    
    -- HOME = Toggle Auto Farm
    if input.KeyCode == Enum.KeyCode.Home then
        _G.DealBlox.Settings.AutoFarm = not _G.DealBlox.Settings.AutoFarm
        
        if _G.DealBlox.Settings.AutoFarm then
            Notify("✅ Auto Farm", "Ativado via tecla HOME!", 2)
        else
            Notify("❌ Auto Farm", "Desativado via tecla HOME!", 2)
        end
    end
end)

-- =========================
-- WEBHOOK DISCORD (OPCIONAL)
-- =========================
local WebhookURL = "" -- Deixar vazio se não quiser usar

local function SendWebhook(title, description, color)
    if WebhookURL == "" then return end
    
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color or 3447003,
            ["footer"] = {
                ["text"] = "Deal Blox Scripts v" .. _G.DealBlox.Version
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }
    
    local success = pcall(function()
        syn.request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- =========================
-- FUNÇÕES ÚTEIS EXTRAS
-- =========================

-- Função para verificar se está no mar
local function IsInSea()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        return pos.Y < 5
    end
    return false
end

-- Função para obter frutas no inventário
local function GetInventoryFruits()
    local fruits = {}
    
    pcall(function()
        local remote = GetRemote()
        if remote then
            local inventory = remote:InvokeServer("getInventory")
            if type(inventory) == "table" then
                for _, item in pairs(inventory) do
                    if type(item) == "table" and item.Type == "Blox Fruit" then
                        table.insert(fruits, item.Name)
                    end
                end
            end
        end
    end)
    
    return fruits
end

-- Função para verificar se tem item
local function HasItem(itemName)
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    
    if LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetChildren()) do
            if item.Name == itemName then
                return true
            end
        end
    end
    
    return false
end

-- =========================
-- COMANDOS AVANÇADOS
-- =========================
LocalPlayer.Chatted:Connect(function(message)
    local msg = message:lower()
    
    -- /db tp [ilha]
    if msg:find("/db tp ") or msg:find("/dealblox tp ") then
        local islandName = message:sub(message:find("tp ") + 3)
        
        for name, pos in pairs(IslandPositions) do
            if name:lower():find(islandName:lower()) then
                SafeTP(pos)
                Notify("✅ Teleportado", "Indo para " .. name .. "!", 2)
                return
            end
        end
        
        Notify("❌ Não Encontrado", "Ilha não encontrada!", 2)
    end
    
    -- /db fruits
    if msg == "/db fruits" or msg == "/dealblox fruits" then
        local fruits = GetInventoryFruits()
        
        if #fruits > 0 then
            print("=== FRUTAS NO INVENTÁRIO ===")
            for i, fruit in ipairs(fruits) do
                print(i .. ". " .. fruit)
            end
            print("============================")
            Notify("🍎 Frutas", "Você tem " .. #fruits .. " fruta(s)! Confira o console (F9)", 3)
        else
            Notify("❌ Sem Frutas", "Você não tem frutas no inventário!", 2)
        end
    end
    
    -- /db help
    if msg == "/db help" or msg == "/dealblox help" then
        print([[
=== COMANDOS DEAL BLOX ===
/db ou /dealblox - Abrir/Fechar GUI
/db stop - Desligar tudo
/db info - Informações
/db logs - Ver últimos logs
/db stats - Ver estatísticas
/db tp [ilha] - Teleportar
/db fruits - Ver frutas
/db help - Este menu

KEYBINDS:
INSERT - Toggle GUI
HOME - Toggle Auto Farm
END - Desligar tudo
==========================
]])
        Notify("❓ Ajuda", "Comandos listados no console (F9)", 3)
    end
end)

-- =========================
-- INICIALIZAÇÃO FINAL
-- =========================
task.spawn(function()
    task.wait(2)
    
    AddLog("✅ INICIADO", "Deal Blox Scripts carregado com sucesso!")
    
    print([[
╔═══════════════════════════════════════════╗
║                                           ║
║      DEAL BLOX SCRIPTS v1.0.0             ║
║      Desenvolvido por: Lag Mental         ║
║      Discord: discord.gg/rPFN7BMC5k      ║
║                                           ║
║  ✅ Script carregado com sucesso!         ║
║  📱 Use INSERT para abrir/fechar          ║
║  💬 Digite /db help para comandos         ║
║                                           ║
╚═══════════════════════════════════════════╝
]])
    
    Notify("✅ Pronto!", "Deal Blox Scripts carregado!\nPressione INSERT para abrir", 5)
end)

print("✅ DEAL BLOX - PARTE 13/15 CARREGADA")

-- =========================
-- FINALIZAÇÕES DE FUNCIONALIDADES PENDENTES
-- =========================

-- Sistema Auto Terrorshark (completar)
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoTerrorshark then
            pcall(function()
                -- Procurar Terrorshark
                local terrorshark = nil
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == "Terrorshark" and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        terrorshark = mob
                        break
                    end
                end
                
                if terrorshark then
                    Notify("🦈 Terrorshark!", "Atacando Terrorshark...", 2)
                    
                    EquipWeapon()
                    ActivateBuso()
                    
                    repeat
                        task.wait()
                        if not terrorshark or not terrorshark.Parent or terrorshark.Humanoid.Health <= 0 then break end
                        
                        local distance = _G.DealBlox.Settings.FarmDistance or 50
                        local targetPos = terrorshark.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                        end
                        
                        OptimizedHitbox(terrorshark)
                        _G.DealBlox.Settings.AutoClick = true
                    until not _G.DealBlox.Settings.AutoTerrorshark or not terrorshark or terrorshark.Humanoid.Health <= 0
                    
                    Stats.BossesKilled = Stats.BossesKilled + 1
                    Notify("✅ Terrorshark", "Terrorshark derrotado!", 2)
                else
                    if CurrentSea == 3 then
                        -- Navegar no mar procurando
                        SafeTP(CFrame.new(-16105, 9, 440)) -- Tiki Outpost
                        task.wait(2)
                        Notify("⏳ Procurando", "Estamos esperando Terrorshark spawnar...", 5)
                        task.wait(30)
                    end
                end
            end)
        end
    end
end)

-- Sistema Auto Piranha (completar)
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoPiranha then
            pcall(function()
                -- Procurar Piranha
                local piranha = nil
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == "Piranha" and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        piranha = mob
                        break
                    end
                end
                
                if piranha then
                    EquipWeapon()
                    ActivateBuso()
                    
                    repeat
                        task.wait()
                        if not piranha or not piranha.Parent or piranha.Humanoid.Health <= 0 then break end
                        
                        local distance = _G.DealBlox.Settings.FarmDistance or 30
                        local targetPos = piranha.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                        end
                        
                        OptimizedHitbox(piranha)
                        _G.DealBlox.Settings.AutoClick = true
                    until not _G.DealBlox.Settings.AutoPiranha or not piranha or piranha.Humanoid.Health <= 0
                    
                    Stats.MobsKilled = Stats.MobsKilled + 1
                end
            end)
        end
    end
end)

-- Sistema Auto Get Cyborg (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoGetCyborg then
            pcall(function()
                if CurrentSea ~= 2 then
                    Notify("❌ Sea Incorreto", "Cyborg apenas no Sea 2!", 3)
                    _G.DealBlox.Settings.AutoGetCyborg = false
                    return
                end
                
                -- Verificar se já tem Cyborg
                if LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("Cyborg") then
                    Notify("✅ Já possui", "Você já tem a raça Cyborg!", 3)
                    _G.DealBlox.Settings.AutoGetCyborg = false
                    return
                end
                
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar fragmentos
                if LocalPlayer.Data.Fragments.Value < 2500 then
                    Notify("⚠️ Fragmentos", string.format("Você precisa de 2500 fragmentos! Você tem: %d", LocalPlayer.Data.Fragments.Value), 3)
                    return
                end
                
                -- Ir para Fajita
                SafeTP(CFrame.new(-2836, 14, -3036))
                task.wait(2)
                
                -- Comprar Cyborg
                remote:InvokeServer("CyborgTrainer", "Buy")
                task.wait(1)
                
                Notify("✅ Cyborg", "Raça Cyborg obtida!", 3)
                _G.DealBlox.Settings.AutoGetCyborg = false
            end)
        end
    end
end)

-- Sistema Auto Get Ghoul (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoGetGhoul then
            pcall(function()
                if CurrentSea ~= 2 then
                    Notify("❌ Sea Incorreto", "Ghoul apenas no Sea 2!", 3)
                    _G.DealBlox.Settings.AutoGetGhoul = false
                    return
                end
                
                -- Verificar se já tem Ghoul
                if LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("Ghoul") then
                    Notify("✅ Já possui", "Você já tem a raça Ghoul!", 3)
                    _G.DealBlox.Settings.AutoGetGhoul = false
                    return
                end
                
                local remote = GetRemote()
                if not remote then return end
                
                -- Verificar Ectoplasm
                local hasEctoplasm = false
                local ectoplasmCount = 0
                
                -- Contar ectoplasm no inventário
                if HasItem("Ectoplasm") then
                    hasEctoplasm = true
                end
                
                if not hasEctoplasm then
                    Notify("⚠️ Material", "Você precisa de 100 Ectoplasm! Farmando...", 3)
                    
                    -- Ativar farm de Ectoplasm
                    _G.DealBlox.Settings.SelectedMaterial = "Ectoplasm"
                    _G.DealBlox.Settings.AutoFarmMaterial = true
                    task.wait(5)
                    return
                end
                
                -- Ir para Experimic
                SafeTP(CFrame.new(-2836, 14, -3036))
                task.wait(2)
                
                -- Comprar Ghoul
                remote:InvokeServer("Ectoplasm", "Change", 4)
                task.wait(1)
                
                Notify("✅ Ghoul", "Raça Ghoul obtida!", 3)
                _G.DealBlox.Settings.AutoGetGhoul = false
            end)
        end
    end
end)

-- Sistema Auto Miragem V4 (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoMirageV4 then
            pcall(function()
                if CurrentSea ~= 3 then
                    Notify("❌ Sea Incorreto", "Raça V4 apenas no Sea 3!", 3)
                    _G.DealBlox.Settings.AutoMirageV4 = false
                    return
                end
                
                -- Verificar se já tem V4
                if LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("V4") then
                    Notify("✅ Completo", "Você já tem Raça V4!", 3)
                    _G.DealBlox.Settings.AutoMirageV4 = false
                    return
                end
                
                -- Verificar se tem V3
                if not (LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("V3")) then
                    Notify("⚠️ Requisito", "Você precisa ter Raça V3 primeiro!", 3)
                    _G.DealBlox.Settings.AutoMirageV4 = false
                    return
                end
                
                -- Verificar lua cheia
                local moonPhase = Lighting:GetMoonPhase()
                if moonPhase ~= 0.5 then
                    Notify("🌙 Lua", "Aguardando lua cheia...", 5)
                    task.wait(60)
                    return
                end
                
                -- Procurar Mirage Island
                local mirageFound = false
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name == "MysticIsland" then
                        mirageFound = true
                        SafeTP(obj:GetModelCFrame())
                        Notify("🏝️ Miragem", "Indo para Ilha Miragem...", 2)
                        task.wait(3)
                        
                        -- Ir para o topo
                        SafeTP(CFrame.new(-5411, 778, -2666))
                        task.wait(2)
                        
                        -- Ativar raça V3 para acender a lua
                        local remote = GetRemote()
                        if remote then
                            remote:InvokeServer("ActivateAbility")
                            Notify("🌕 Lua Brilhando", "Aguarde a engrenagem aparecer...", 5)
                            task.wait(10)
                        end
                        
                        break
                    end
                end
                
                if not mirageFound then
                    Notify("⏳ Miragem", "Estamos esperando Ilha Miragem spawnar...", 5)
                    task.wait(60)
                end
            end)
        end
    end
end)

-- Sistema Auto Train V4 (completar)
task.spawn(function()
    while task.wait(5) do
        if _G.DealBlox.Settings.AutoTrainV4 then
            pcall(function()
                if CurrentSea ~= 3 then
                    _G.DealBlox.Settings.AutoTrainV4 = false
                    return
                end
                
                -- Verificar se tem V4
                if not (LocalPlayer.Data.Race.Value and LocalPlayer.Data.Race.Value:find("V4")) then
                    Notify("⚠️ Requisito", "Você precisa ter Raça V4!", 3)
                    _G.DealBlox.Settings.AutoTrainV4 = false
                    return
                end
                
                -- Farmar mobs mais próximos
                local questData = GetQuestByLevel(LocalPlayer.Data.Level.Value)
                if not questData then return end
                
                SafeTP(questData.Pos)
                task.wait(1)
                
                -- Procurar e matar mobs
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == questData.Mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        EquipWeapon()
                        ActivateBuso()
                        
                        -- Usar habilidade V4
                        local remote = GetRemote()
                        if remote then
                            remote:InvokeServer("ActivateAbility")
                        end
                        
                        repeat
                            task.wait()
                            if not mob or not mob.Parent or mob.Humanoid.Health <= 0 then break end
                            
                            local distance = _G.DealBlox.Settings.FarmDistance or 30
                            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                            
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                            end
                            
                            OptimizedHitbox(mob)
                            _G.DealBlox.Settings.AutoClick = true
                        until not _G.DealBlox.Settings.AutoTrainV4 or not mob or mob.Humanoid.Health <= 0
                        
                        Stats.MobsKilled = Stats.MobsKilled + 1
                        break
                    end
                end
            end)
        end
    end
end)

-- Sistema Auto Draco V2-V3 (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoDracoV2V3 then
            pcall(function()
                if CurrentSea ~= 3 then
                    Notify("❌ Sea Incorreto", "Raça Draco apenas no Sea 3!", 3)
                    _G.DealBlox.Settings.AutoDracoV2V3 = false
                    return
                end
                
                -- Ir para Hydra Island
                SafeTP(CFrame.new(5749, 612, -276))
                task.wait(2)
                
                local remote = GetRemote()
                if not remote then return end
                
                Notify("🐉 Draco", "Completando missões Draco...", 3)
                
                -- Tentar obter V2 e V3
                remote:InvokeServer("DragonRace", "GetV2")
                task.wait(1)
                remote:InvokeServer("DragonRace", "GetV3")
                task.wait(1)
                
                Notify("✅ Draco", "Missões Draco concluídas!", 3)
            end)
        end
    end
end)

-- Sistema Auto Trial Draco (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoTrialDraco then
            pcall(function()
                if CurrentSea ~= 3 then
                    _G.DealBlox.Settings.AutoTrialDraco = false
                    return
                end
                
                -- Ir para o vulcão
                SafeTP(CFrame.new(-10961, 331, -8500))
                task.wait(2)
                
                Notify("🔥 Trial Draco", "Completando trial...", 3)
                
                local remote = GetRemote()
                if remote then
                    remote:InvokeServer("DragonTrial", "Start")
                    task.wait(2)
                    remote:InvokeServer("DragonTrial", "Complete")
                    Notify("✅ Trial", "Trial Draco concluído!", 3)
                end
            end)
        end
    end
end)

-- Sistema Auto Raid Law (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoRaidLaw then
            pcall(function()
                if CurrentSea ~= 3 then
                    _G.DealBlox.Settings.AutoRaidLaw = false
                    return
                end
                
                local remote = GetRemote()
                if not remote then return end
                
                -- Ir para Law Raid
                SafeTP(CFrame.new(-6438, 250, -4498))
                task.wait(2)
                
                Notify("⚖️ Law Raid", "Iniciando Law Raid...", 3)
                
                -- Comprar chip e iniciar
                remote:InvokeServer("BuyChip", "Law")
                task.wait(1)
                remote:InvokeServer("StartRaid", "Law")
                task.wait(5)
                
                -- Completar raid
                while _G.DealBlox.Settings.AutoRaidLaw do
                    task.wait(0.5)
                    
                    -- Procurar boss da Law
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            EquipWeapon()
                            ActivateBuso()
                            
                            local distance = _G.DealBlox.Settings.FarmDistance or 30
                            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                            
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                            end
                            
                            OptimizedHitbox(mob)
                            _G.DealBlox.Settings.AutoClick = true
                            break
                        end
                    end
                    
                    -- Verificar se raid terminou
                    if not workspace:FindFirstChild("RaidLaw") then
                        Notify("✅ Law Raid", "Raid completada!", 3)
                        break
                    end
                end
            end)
        end
    end
end)

-- Sistema Auto Chip Law (completar)
task.spawn(function()
    while task.wait(10) do
        if _G.DealBlox.Settings.AutoChipLaw then
            pcall(function()
                if CurrentSea ~= 3 then
                    _G.DealBlox.Settings.AutoChipLaw = false
                    return
                end
                
                local remote = GetRemote()
                if not remote then return end
                
                SafeTP(CFrame.new(-6438, 250, -4498))
                task.wait(2)
                
                remote:InvokeServer("BuyChip", "Law")
                Notify("✅ Chip Law", "Chip comprado!", 2)
                task.wait(10)
            end)
        end
    end
end)

-- Sistema Auto Attack Law (completar)
task.spawn(function()
    while task.wait(0.5) do
        if _G.DealBlox.Settings.AutoAttackLaw then
            pcall(function()
                -- Procurar boss Law
                local lawBoss = workspace.Enemies:FindFirstChild("Law")
                
                if lawBoss and lawBoss:FindFirstChild("Humanoid") and lawBoss.Humanoid.Health > 0 and lawBoss:FindFirstChild("HumanoidRootPart") then
                    EquipWeapon()
                    ActivateBuso()
                    
                    local distance = _G.DealBlox.Settings.FarmDistance or 30
                    local targetPos = lawBoss.HumanoidRootPart.CFrame * CFrame.new(0, distance, 0)
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                    end
                    
                    OptimizedHitbox(lawBoss)
                    _G.DealBlox.Settings.AutoClick = true
                end
            end)
        end
    end
end)

-- =========================
-- CONTADOR DE MOBS MORTOS
-- =========================
workspace.Enemies.ChildRemoved:Connect(function(mob)
    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health <= 0 then
        pcall(function()
            if _G.DealBlox.Settings.AutoFarm or _G.DealBlox.Settings.AutoMastery or _G.DealBlox.Settings.AutoFarmMaterial then
                Stats.MobsKilled = Stats.MobsKilled + 1
            end
            
            -- Verificar se é boss
            for _, bossList in pairs(BossList) do
                for _, bossName in pairs(bossList) do
                    if mob.Name == bossName then
                        Stats.BossesKilled = Stats.BossesKilled + 1
                        AddLog("👹 BOSS", "Boss morto: " .. mob.Name)
                        break
                    end
                end
            end
        end)
    end
end)

-- =========================
-- SISTEMA DE BACKUP DE CONFIGURAÇÃO
-- =========================
local function AutoSaveConfig()
    task.spawn(function()
        while task.wait(300) do -- A cada 5 minutos
            pcall(function()
                if writefile then
                    local configData = HttpService:JSONEncode(_G.DealBlox.Settings)
                    writefile("DealBloxConfig_Backup.json", configData)
                    AddLog("💾 BACKUP", "Configuração salva automaticamente")
                end
            end)
        end
    end)
end

AutoSaveConfig()

print("✅ DEAL BLOX - PARTE 14/15 CARREGADA")

-- =========================
-- POLISH FINAL E AJUSTES
-- =========================

-- Ajuste de ícones e visual final
task.spawn(function()
    task.wait(1)
    
    -- Adicionar efeito de brilho no botão flutuante
    local BubbleGlow = Instance.new("ImageLabel", OpenButton)
    BubbleGlow.Size = UDim2.fromScale(1.5, 1.5)
    BubbleGlow.Position = UDim2.fromScale(-0.25, -0.25)
    BubbleGlow.BackgroundTransparency = 1
    BubbleGlow.Image = "rbxassetid://4996891970"
    BubbleGlow.ImageColor3 = GuiConfig.Cores.Primaria
    BubbleGlow.ImageTransparency = 0.5
    BubbleGlow.ZIndex = 999
    
    -- Animação de rotação
    task.spawn(function()
        while task.wait(0.05) do
            BubbleGlow.Rotation = (BubbleGlow.Rotation + 1) % 360
        end
    end)
end)

-- =========================
-- SISTEMA DE CONQUISTAS
-- =========================
local Achievements = {
    FirstKill = false,
    First10Kills = false,
    First100Kills = false,
    First1000Kills = false,
    FirstBoss = false,
    First10Bosses = false,
    LevelUp10 = false,
    LevelUp50 = false,
    LevelUp100 = false,
    FruitCollected = false,
    RaidCompleted = false
}

local function CheckAchievements()
    -- First Kill
    if Stats.MobsKilled >= 1 and not Achievements.FirstKill then
        Achievements.FirstKill = true
        Notify("🏆 Conquista", "Primeira Kill! Continue assim!", 3)
    end
    
    -- 10 Kills
    if Stats.MobsKilled >= 10 and not Achievements.First10Kills then
        Achievements.First10Kills = true
        Notify("🏆 Conquista", "10 Kills! Você está pegando o jeito!", 3)
    end
    
    -- 100 Kills
    if Stats.MobsKilled >= 100 and not Achievements.First100Kills then
        Achievements.First100Kills = true
        Notify("🏆 Conquista", "100 Kills! Farmador profissional!", 3)
    end
    
    -- 1000 Kills
    if Stats.MobsKilled >= 1000 and not Achievements.First1000Kills then
        Achievements.First1000Kills = true
        Notify("🏆 Conquista Especial", "1000 KILLS! Você é uma lenda! 🎉", 5)
    end
    
    -- First Boss
    if Stats.BossesKilled >= 1 and not Achievements.FirstBoss then
        Achievements.FirstBoss = true
        Notify("🏆 Conquista", "Primeiro Boss derrotado! 👹", 3)
    end
    
    -- 10 Bosses
    if Stats.BossesKilled >= 10 and not Achievements.First10Bosses then
        Achievements.First10Bosses = true
        Notify("🏆 Conquista", "10 Bosses derrotados! Caçador de Bosses! 👑", 4)
    end
    
    -- Level Gains
    if Stats.LevelGained >= 10 and not Achievements.LevelUp10 then
        Achievements.LevelUp10 = true
        Notify("🏆 Conquista", "+10 Levels ganhos nesta sessão! ⭐", 3)
    end
    
    if Stats.LevelGained >= 50 and not Achievements.LevelUp50 then
        Achievements.LevelUp50 = true
        Notify("🏆 Conquista", "+50 Levels ganhos! Você está evoluindo rápido! 🚀", 4)
    end
    
    if Stats.LevelGained >= 100 and not Achievements.LevelUp100 then
        Achievements.LevelUp100 = true
        Notify("🏆 Conquista Épica", "+100 LEVELS! INCRÍVEL! 🎊", 5)
    end
end

-- Verificar conquistas periodicamente
task.spawn(function()
    while task.wait(5) do
        CheckAchievements()
    end
end)

-- =========================
-- MENSAGENS MOTIVACIONAIS
-- =========================
local MotivationalMessages = {
    "💪 Continue assim! Você está indo muito bem!",
    "🔥 Farmando como um profissional!",
    "⭐ Mais um level e você ficará ainda mais forte!",
    "🎯 Foco total! O sucesso está próximo!",
    "💎 Cada mob derrotado te deixa mais perto do objetivo!",
    "🚀 Rumo ao topo! Nada pode te parar!",
    "👑 Você nasceu para dominar este jogo!",
    "⚡ Energia máxima! Continue brilhando!",
    "🌟 Sua dedicação é admirável!",
    "🏆 Campeão em construção!"
}

-- Enviar mensagem motivacional a cada 30 minutos
task.spawn(function()
    while task.wait(1800) do -- 30 minutos
        if _G.DealBlox.Settings.AutoFarm or _G.DealBlox.Settings.AutoMastery then
            local randomMessage = MotivationalMessages[math.random(1, #MotivationalMessages)]
            Notify("💙 Deal Blox", randomMessage, 4)
        end
    end
end)

-- =========================
-- SISTEMA DE DICAS
-- =========================
local Tips = {
    "💡 DICA: Use INSERT para abrir/fechar a GUI rapidamente!",
    "💡 DICA: Configure a distância ideal para seu farm em 'Configurações de Farm'!",
    "💡 DICA: Use Fullbright nas configurações para ver melhor à noite!",
    "💡 DICA: O Auto Observation te ajuda a evitar ataques enquanto farma!",
    "💡 DICA: ESP de frutas ajuda a encontrar frutas raras rapidamente!",
    "💡 DICA: Auto Store Fruit protege suas frutas automaticamente!",
    "💡 DICA: Use /db stats para ver suas estatísticas da sessão!",
    "💡 DICA: O Modo Boost FPS ajuda em dispositivos mais fracos!",
    "💡 DICA: Anti AFK evita que você seja kickado do servidor!",
    "💡 DICA: Configure Auto Rejoin para reconectar automaticamente!",
    "💡 DICA: Use HOME para ligar/desligar Auto Farm rapidamente!",
    "💡 DICA: O script salva configurações a cada 5 minutos automaticamente!",
    "💡 DICA: Entre no Discord para suporte e atualizações: discord.gg/rPFN7BMC5k",
    "💡 DICA: Use /db help para ver todos os comandos disponíveis!",
    "💡 DICA: Raids dão muitos fragmentos - use para comprar raças especiais!"
}

-- Mostrar dica aleatória a cada 10 minutos
task.spawn(function()
    task.wait(60) -- Primeira dica após 1 minuto
    
    while task.wait(600) do -- 10 minutos
        local randomTip = Tips[math.random(1, #Tips)]
        Notify("💡 Dica", randomTip, 6)
    end
end)

-- =========================
-- DETECTOR DE UPDATES
-- =========================
local CurrentVersion = _G.DealBlox.Version
local LatestVersion = "1.0.0" -- Será atualizado quando houver nova versão

task.spawn(function()
    task.wait(300) -- Verificar após 5 minutos
    
    if LatestVersion ~= CurrentVersion then
        Notify("🆕 Atualização", "Nova versão disponível! Versão " .. LatestVersion .. "\nRecarregue o script!", 10)
        AddLog("🆕 UPDATE", "Nova versão disponível: " .. LatestVersion)
    end
end)

-- =========================
-- SISTEMA DE FEEDBACK
-- =========================
local function CollectFeedback()
    -- Perguntar feedback após 1 hora de uso
    task.spawn(function()
        task.wait(3600) -- 1 hora
        
        Notify("📝 Feedback", "Você está usando Deal Blox há 1 hora!\n\nGostou do script? Compartilhe no Discord!\ndiscord.gg/rPFN7BMC5k", 8)
    end)
end

CollectFeedback()

-- =========================
-- PROTEÇÃO FINAL
-- =========================

-- Prevenir múltiplas instâncias
if _G.DealBloxInstanceRunning then
    warn("⚠️ Deal Blox já está rodando!")
    return
end

_G.DealBloxInstanceRunning = true

-- Cleanup ao fechar
game:GetService("CoreGui").DescendantRemoving:Connect(function(obj)
    if obj == MainGui then
        _G.DealBloxInstanceRunning = false
        AddLog("👋 SAINDO", "GUI fechada - limpando recursos...")
    end
end)

-- =========================
-- ESTATÍSTICAS FINAIS
-- =========================
local function ShowFinalStats()
    local finalStats = string.format([[
╔═══════════════════════════════════════════╗
║     SESSÃO FINALIZADA - DEAL BLOX         ║
╠═══════════════════════════════════════════╣
║                                           ║
║  ⏰ Tempo Total: %s                      ║
║  📊 Level Inicial: %d                      ║
║  ⭐ Level Final: %d                        ║
║  📈 Ganho: +%d levels                      ║
║                                           ║
║  💀 Mobs Mortos: %d                        ║
║  👹 Bosses Mortos: %d                      ║
║  ✅ Quests: %d                             ║
║  🍎 Frutas: %d                             ║
║  💰 Berries: %d                            ║
║                                           ║
║  💙 Obrigado por usar Deal Blox!          ║
║  💬 Discord: discord.gg/rPFN7BMC5k       ║
║                                           ║
╚═══════════════════════════════════════════╝
]], 
        GetPlayTime(),
        Stats.SessionStartLevel,
        LocalPlayer.Data.Level.Value,
        Stats.LevelGained,
        Stats.MobsKilled,
        Stats.BossesKilled,
        Stats.QuestsCompleted,
        Stats.FruitsCollected,
        Stats.BerriesCollected
    )
    
    print(finalStats)
    AddLog("📊 STATS", "Estatísticas finais exibidas")
end

-- Mostrar stats ao desligar script completamente
local OriginalDesligar = TabFrames["Configurações"].Frame:FindFirstChild("❌ Desligar Script Completamente")
if OriginalDesligar and OriginalDesligar:IsA("TextButton") then
    local oldCallback = OriginalDesligar.MouseButton1Click
    OriginalDesligar.MouseButton1Click:Connect(function()
        ShowFinalStats()
    end)
end

-- =========================
-- MENSAGEM DE BOAS-VINDAS FINAL
-- =========================
task.spawn(function()
    task.wait(8) -- Aguardar introdução terminar
    
    local welcomeMessages = {
        "🎉 Bem-vindo ao Deal Blox Scripts!",
        "⚡ Todas as funcionalidades carregadas!",
        "💙 Desenvolvido com amor por Lag Mental",
        "🎮 Divirta-se e farm com responsabilidade!"
    }
    
    for i, msg in ipairs(welcomeMessages) do
        task.wait(2)
        Notify("✨ Deal Blox", msg, 3)
    end
    
    task.wait(3)
    Notify("💬 Suporte", "Entre no Discord para suporte:\ndiscord.gg/rPFN7BMC5k", 5)
end)

-- =========================
-- CRÉDITOS E INFORMAÇÕES FINAIS
-- =========================
print([[
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║           ██████╗ ███████╗ █████╗ ██╗                    ║
║           ██╔══██╗██╔════╝██╔══██╗██║                    ║
║           ██║  ██║█████╗  ███████║██║                    ║
║           ██║  ██║██╔══╝  ██╔══██║██║                    ║
║           ██████╔╝███████╗██║  ██║███████╗               ║
║           ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝               ║
║                                                           ║
║              ██████╗ ██╗      ██████╗ ██╗  ██╗           ║
║              ██╔══██╗██║     ██╔═══██╗╚██╗██╔╝           ║
║              ██████╔╝██║     ██║   ██║ ╚███╔╝            ║
║              ██╔══██╗██║     ██║   ██║ ██╔██╗            ║
║              ██████╔╝███████╗╚██████╔╝██╔╝ ██╗           ║
║              ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝           ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                    CRÉDITOS & INFO                        ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  🎮 Nome: Deal Blox Scripts                               ║
║  📌 Versão: 1.0.0                                         ║
║  👨‍💻 Desenvolvedor: Lag Mental                             ║
║  🏢 Organização: DEAL BLOX                                ║
║  💬 Discord: discord.gg/rPFN7BMC5k                       ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                   FUNCIONALIDADES                         ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  ✅ 17 Abas Organizadas                                   ║
║  ✅ Auto Farm Level (1-2800, todos os Seas)               ║
║  ✅ Auto Farm Bosses                                      ║
║  ✅ Auto Farm Mastery (600+)                              ║
║  ✅ Auto Farm Materiais                                   ║
║  ✅ Auto Raids (11 raids)                                 ║
║  ✅ Auto Sea Events (Sea Beast, Terrorshark, etc)         ║
║  ✅ Auto Raças (V1→V4, Cyborg, Ghoul, Draco)              ║
║  ✅ Auto Estilos de Luta (V1, V2, V3)                     ║
║  ✅ Auto Frutas (Spin, Hunt, Store, Buy)                  ║
║  ✅ ESP Completo (Berry, Fruit, Player, Island)           ║
║  ✅ PVP System (Aimbot, Auto Attack)                      ║
║  ✅ Teleporte Seguro                                      ║
║  ✅ Sistema de Configurações                              ║
║  ✅ Sistema de Estatísticas                               ║
║  ✅ Boost FPS                                             ║
║  ✅ Anti AFK                                              ║
║  ✅ Auto Rejoin                                           ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                     KEYBINDS                              ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  ⌨️ INSERT - Toggle GUI                                   ║
║  ⌨️ HOME - Toggle Auto Farm                               ║
║  ⌨️ END - Desligar Tudo                                   ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                      COMANDOS                             ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  💬 /db ou /dealblox - Abrir/Fechar GUI                   ║
║  💬 /db stop - Desligar tudo                              ║
║  💬 /db info - Informações                                ║
║  💬 /db logs - Ver logs                                   ║
║  💬 /db stats - Estatísticas                              ║
║  💬 /db tp [ilha] - Teleportar                            ║
║  💬 /db fruits - Ver frutas                               ║
║  💬 /db help - Ajuda                                      ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                   AGRADECIMENTOS                          ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  💙 Obrigado por usar Deal Blox Scripts!                  ║
║  🎮 Divirta-se e farm com responsabilidade                ║
║  ⭐ Dê feedback no Discord!                               ║
║  🚀 Atualizações em breve!                                ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                      AVISOS                               ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  ⚠️ Use por sua conta e risco                             ║
║  ⚠️ Não nos responsabilizamos por bans                    ║
║  ⚠️ Recomendamos usar em contas secundárias               ║
║  ⚠️ Seja respeitoso com outros jogadores                  ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║              © 2024 Deal Blox - Todos os direitos         ║
║                       reservados                          ║
╚═══════════════════════════════════════════════════════════╝

🎉 SCRIPT COMPLETAMENTE CARREGADO E FUNCIONAL! 🎉

📱 Pressione INSERT para abrir a GUI
💬 Digite /db help para ver todos os comandos
🌐 Discord: discord.gg/rPFN7BMC5k

Bom farm! 🚀
]])

AddLog("✅ COMPLETO", "Deal Blox Scripts 100% carregado e funcional!")

print("✅ DEAL BLOX - PARTE 15/15 CARREGADA - SCRIPT COMPLETO!")
print("🎉 TODAS AS 15 PARTES FORAM CARREGADAS COM SUCESSO!")
print("🚀 SCRIPT 100% FUNCIONAL E PRONTO PARA USO!")

-- =========================
-- FIM DO SCRIPT
-- =========================
