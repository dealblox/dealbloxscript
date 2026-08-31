--==================================================
-- DEAL BLOX V2
-- Base de testes
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

while not Player do
    task.wait()
    Player = Players.LocalPlayer
end

--==================================================
-- EVITAR EXECUÇÃO DUPLICADA
--==================================================

if getgenv and getgenv().DealBloxV2Loaded then
    warn("[DEAL BLOX] O script já está aberto.")
    return
end

if getgenv then
    getgenv().DealBloxV2Loaded = true
end

--==================================================
-- DEBUG
--==================================================

local function Log(text)
    print("[DEAL BLOX] " .. tostring(text))
end

local function Error(text)
    warn("[DEAL BLOX] " .. tostring(text))
end

local function SafeCall(name, callback)
    local success, result = xpcall(callback, debug.traceback)

    if not success then
        Error("Erro em " .. name)
        Error(result)
    end

    return success, result
end

Log("Inicializando...")

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "DealBloxV2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

local parentSuccess = pcall(function()
    Gui.Parent = game:GetService("CoreGui")
end)

if not parentSuccess or not Gui.Parent then
    Gui.Parent = Player:WaitForChild("PlayerGui")
end

--==================================================
-- BOTÃO DB
--==================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenButton"
OpenButton.Parent = Gui

OpenButton.Size = UDim2.fromOffset(60, 60)
OpenButton.Position = UDim2.new(0, 20, 0.5, -30)

OpenButton.BackgroundColor3 = Color3.fromRGB(35, 95, 180)
OpenButton.BorderSizePixel = 0

OpenButton.Text = "DB"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBold

OpenButton.Active = true

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

--==================================================
-- PAINEL
--==================================================

local Main = Instance.new("Frame")

Main.Name = "Main"
Main.Parent = Gui

Main.Size = UDim2.fromOffset(600, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)

Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0

Main.Visible = false
Main.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

--==================================================
-- TOPBAR
--==================================================

local TopBar = Instance.new("Frame")

TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 50)

TopBar.BackgroundColor3 = Color3.fromRGB(35, 95, 180)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")

Title.Parent = TopBar
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)

Title.BackgroundTransparency = 1

Title.Text = "DEAL BLOX V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- FECHAR
--==================================================

local Close = Instance.new("TextButton")

Close.Parent = TopBar

Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -42, 0.5, -16)

Close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold

Close.BorderSizePixel = 0

Instance.new("UICorner", Close).CornerRadius =
    UDim.new(0, 7)

--==================================================
-- CONTEÚDO
--==================================================

local Text = Instance.new("TextLabel")

Text.Parent = Main

Text.Position = UDim2.fromOffset(20, 70)
Text.Size = UDim2.new(1, -40, 0, 100)

Text.BackgroundTransparency = 1

Text.Text =
    "Deal Blox V2 carregado!\n\n" ..
    "Jogador: " .. Player.Name .. "\n" ..
    "Primeiro teste da nova base."

Text.TextColor3 = Color3.new(1, 1, 1)
Text.Font = Enum.Font.Gotham
Text.TextSize = 16

Text.TextWrapped = true
Text.TextXAlignment = Enum.TextXAlignment.Left
Text.TextYAlignment = Enum.TextYAlignment.Top

--==================================================
-- ABRIR / FECHAR
--==================================================

local opened = false
local debounce = false

local function SetOpen(state)

    if debounce then
        return
    end

    debounce = true
    opened = state

    if opened then

        Main.Visible = true
        Main.Size = UDim2.fromOffset(0, 0)

        local tween = TweenService:Create(
            Main,
            TweenInfo.new(
                0.25,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.fromOffset(600, 400)
            }
        )

        tween:Play()

    else

        local tween = TweenService:Create(
            Main,
            TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            ),
            {
                Size = UDim2.fromOffset(0, 0)
            }
        )

        tween:Play()
        tween.Completed:Wait()

        Main.Visible = false
    end

    debounce = false
end

OpenButton.Activated:Connect(function()

    SafeCall("OpenButton", function()
        SetOpen(not opened)
    end)

end)

Close.Activated:Connect(function()

    SafeCall("CloseButton", function()
        SetOpen(false)
    end)

end)

--==================================================
-- FINAL
--==================================================

Log("GUI criada.")
Log("Deal Blox V2 carregado com sucesso.")
