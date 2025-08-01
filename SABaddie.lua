repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- โหลด WindUI
local WindUI = nil
local success, errorMessage = pcall(function()
    local scriptContent = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    if scriptContent and scriptContent ~= "" then
        WindUI = loadstring(scriptContent)()
    else
        error("Failed to retrieve WindUI script content.")
    end
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. (errorMessage or "Unknown error"))
    StarterGui:SetCore("SendNotification", {
        Title = "DYHUB Error",
        Text = "The script does not support your executor!",
        Duration = 10,
        Button1 = "OK"
    })
    return
end

-- Popup Confirm
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Steal A Baddie",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

-- สร้างหน้าต่างหลัก
local Window = WindUI:CreateWindow({
    Title = "DYHUB - Steal A Baddie (Beta)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- สร้าง Tabs
local Tabs = {
    GameTab = Window:Tab({ Title = "Main", Icon = "rocket" }),
    FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "crown" }),
    PlayerTab = Window:Tab({ Title = "Player", Icon = "user" }),
    ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" }),
    TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
}

-- ======= GameTab (Steal) =======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local fakeClone = nil
local isInvisible = false
local originalCameraSubject = nil
local originalFakePos = nil

Tabs.GameTab:Toggle({
    Title = "Invisible (Clone)",
    Default = false,
    Callback = function(state)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not character or not humanoid or not rootPart then return end

        if state and not isInvisible then
            isInvisible = true

            -- บันทึกตำแหน่งปัจจุบันก่อนย้ายขึ้น
            originalFakePos = rootPart.CFrame

            -- ย้ายตัวจริงให้ลอยขึ้น
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 50, 0)

            -- Clone ตัวปลอม
            fakeClone = character:Clone()
            fakeClone.Name = "FakeClone"
            fakeClone.Parent = Workspace

            -- ลบ scripts ใน clone
            for _, desc in pairs(fakeClone:GetDescendants()) do
                if desc:IsA("Script") or desc:IsA("LocalScript") then
                    desc:Destroy()
                end
            end

            -- ยึดตำแหน่งตัวปลอมให้อยู่กับที่
            local fakeHRP = fakeClone:FindFirstChild("HumanoidRootPart")
            local fakeHumanoid = fakeClone:FindFirstChildOfClass("Humanoid")
            if fakeHRP then
                fakeHRP.Anchored = true
            end
            if fakeHumanoid then
                fakeHumanoid.DisplayName = "[Clone]"
                fakeHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                fakeHumanoid.NameDisplayDistance = 0
            end

            -- กล้องตามร่างปลอม
            originalCameraSubject = Workspace.CurrentCamera.CameraSubject
            Workspace.CurrentCamera.CameraSubject = fakeHumanoid

        elseif not state and isInvisible then
            isInvisible = false

            -- เอาตัวจริงกลับมาตำแหน่งร่างปลอม
            if fakeClone and fakeClone:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = fakeClone.HumanoidRootPart.CFrame
                rootPart.CFrame = targetCFrame + Vector3.new(0, 2, 0) -- ยืนเหนือร่างปลอมเล็กน้อย
            elseif originalFakePos then
                rootPart.CFrame = originalFakePos -- fallback
            end

            -- กล้องกลับมาหาตัวจริง
            if originalCameraSubject then
                Workspace.CurrentCamera.CameraSubject = originalCameraSubject
            end

            -- ลบร่างปลอม
            if fakeClone and fakeClone.Parent then
                fakeClone:Destroy()
            end
        end
    end
})

Tabs.GameTab:Button({
    Title = "Steal (No Hold)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/nodelay.lua"))()
    end
})

-- ======= PlayerTab (Speed, Jump, Fly, Noclip) =======
getgenv().speedEnabled = false
getgenv().speedValue = 20
Tabs.PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = { Min = 16, Max = 600, Default = 20 },
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50
Tabs.PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 16 end
    end
})
Tabs.PlayerTab:Slider({
    Title = "Set Jump Value",
    Value = { Min = 10, Max = 600, Default = 50 },
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

Tabs.PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Dly"))()
    end
})

local noclipConnection
_G.Noclip = false
Tabs.PlayerTab:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char and _G.Noclip then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- ======= FarmTab (Auto Collect Money) =======
_G.AutoCollectMoney = false
Tabs.FarmTab:Toggle({
    Title = "Auto Collect (Money)",
    Default = false,
    Callback = function(state)
        local RS = ReplicatedStorage
        local ClaimCash = RS:WaitForChild("src"):WaitForChild("Modules"):WaitForChild("KnitClient")
            :WaitForChild("Services"):WaitForChild("BaseService"):WaitForChild("RE"):WaitForChild("ClaimCash")

        _G.AutoCollectMoney = state
        if state then
            task.spawn(function()
                while _G.AutoCollectMoney do
                    for i = 1, 20 do
                        pcall(function()
                            ClaimCash:FireServer(i)
                        end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- ======= ESP Tab =======
local ESPEnabled = false
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPFolder:FindFirstChild(player.Name) then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- สีเขียว
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1) -- สีขาว
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    local function attachESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = player.Character
            billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    attachESP()
    player.CharacterAdded:Connect(function()
        task.wait(1)
        attachESP()
    end)

    highlight.Parent = ESPFolder
    billboard.Parent = ESPFolder
end

local function removeESP(player)
    local h = ESPFolder:FindFirstChild(player.Name)
    local b = ESPFolder:FindFirstChild(player.Name .. "_ESPLabel")
    if h then h:Destroy() end
    if b then b:Destroy() end
end

local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end
    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)
end

local function disableESP()
    ESPFolder:ClearAllChildren()
end

Tabs.ESPTab:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        if state then
            enableESP()
        else
            disableESP()
        end
    end
})

-- ======= Teleport Tab =======
local savedCFrame = nil

-- เซฟตำแหน่งจุดแรก หลังโหลดเสร็จ
task.delay(2, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

Tabs.TeleportTab:Button({
    Title = "Teleport to Home",
    Callback = function()
        if savedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport",
                Text = "Spawn point not saved or character missing!",
                Duration = 5
            })
        end
    end
})

