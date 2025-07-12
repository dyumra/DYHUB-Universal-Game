local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Window = WindUI:CreateWindow({
    Folder = "DYHUB Scripts (Ink Game)",   
    Title = "DYHUB | Ink Game",
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Open DYHUB",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    ESP = Window:Tab({ Title = "ESP", Icon = "eye" }),
    Movement = Window:Tab({ Title = "Movement", Icon = "zap" }),
}

----------------------------------------------------------
-- 🌟 MAIN TAB: AutoWin / Killaura / RedLight Godmode / Dalgona / TugOfWar
----------------------------------------------------------

-- AutoWin (Reveal Glass Bridge)
Tabs.Main:Button({
    Title = "AutoWin: Reveal Glass Bridge",
    Callback = function()
        local glassHolder = workspace:FindFirstChild("GlassBridge") and workspace.GlassBridge:FindFirstChild("GlassHolder")
        if not glassHolder then warn("GlassHolder not found") return end

        for _, tilePair in pairs(glassHolder:GetChildren()) do
            for _, tileModel in pairs(tilePair:GetChildren()) do
                if tileModel:IsA("Model") and tileModel.PrimaryPart then
                    local primaryPart = tileModel.PrimaryPart
                    local isBreakable = primaryPart:GetAttribute("exploitingisevil") == true
                    local targetColor = isBreakable and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)

                    for _, part in pairs(tileModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            TweenService:Create(part, TweenInfo.new(0.5), {Transparency=0.5, Color=targetColor}):Play()
                        end
                    end

                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = targetColor
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0.5
                    highlight.Parent = tileModel
                end
            end
        end
        warn("[DYHUB]: Safe tiles are green, breakable tiles are red!")
    end
})

-- Killaura
local killauraEnabled = false
Tabs.Main:Toggle({
    Title = "Killaura",
    Default = false,
    Callback = function(state)
        killauraEnabled = state
        task.spawn(function()
            while killauraEnabled do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
})

-- Red Light Green Light Godmode
Tabs.Main:Button({
    Title = "Red Light Green Light Godmode",
    Callback = function()
        local statusFolder = workspace:FindFirstChild("StatusFolder")
        if statusFolder then
            for _, status in ipairs(statusFolder:GetChildren()) do
                if status:IsA("BoolValue") then
                    status.Changed:Connect(function()
                        status.Value = false
                    end)
                end
            end
        end
        warn("[DYHUB]: Red Light Godmode enabled!")
    end
})

-- Dalgona Bypass
Tabs.Main:Button({
    Title = "Dalgona Bypass",
    Callback = function()
        local event = ReplicatedStorage:WaitForChild("RemoteEvents"):FindFirstChild("CompleteDalgona")
        if event then
            event:FireServer()
            warn("[DYHUB]: Dalgona completed instantly!")
        end
    end
})

-- Tug Of War Auto Pull
local autoPullEnabled = false
Tabs.Main:Toggle({
    Title = "TugOfWar Auto Pull",
    Default = false,
    Callback = function(state)
        autoPullEnabled = state
        task.spawn(function()
            local event = ReplicatedStorage:WaitForChild("RemoteEvents"):FindFirstChild("TugOfWarPull")
            while autoPullEnabled do
                if event then
                    event:FireServer()
                end
                task.wait(0.1)
            end
        end)
    end
})

----------------------------------------------------------
-- 👁 ESP TAB: Player ESP
----------------------------------------------------------

local espEnabled = false
Tabs.ESP:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0.2
                    highlight.Parent = player.Character
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, highlight in ipairs(player.Character:GetChildren()) do
                        if highlight:IsA("Highlight") then
                            highlight:Destroy()
                        end
                    end
                end
            end
        end
    end
})

----------------------------------------------------------
-- 🏃 MOVEMENT TAB: Fly / Speed / InfiniteJump / Noclip
----------------------------------------------------------

-- Fly
local flyEnabled = false
local flySpeed = 40
Tabs.Movement:Slider({
    Title = "Fly Speed",
    Min = 10, Max = 100, Default = 40,
    Callback = function(val) flySpeed = val end
})
Tabs.Movement:Toggle({
    Title = "Fly",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if state and hrp then
            task.spawn(function()
                while flyEnabled do
                    hrp.Velocity = hrp.CFrame.LookVector * flySpeed
                    task.wait()
                end
            end)
        end
    end
})

-- Speed
local speedEnabled = false
local speedValue = 28
Tabs.Movement:Slider({
    Title = "WalkSpeed",
    Min=16, Max=200, Default=28,
    Callback=function(val) speedValue=val end
})
Tabs.Movement:Toggle({
    Title = "Speed Hack",
    Default = false,
    Callback = function(state)
        speedEnabled = state
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = state and speedValue or 16
        end
    end
})

-- Infinite Jump
local infJumpEnabled = false
Tabs.Movement:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
    end
})
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip
local noclipEnabled = false
Tabs.Movement:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        task.spawn(function()
            while noclipEnabled do
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
                task.wait()
            end
        end)
    end
})
