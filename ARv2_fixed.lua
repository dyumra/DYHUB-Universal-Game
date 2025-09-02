-- HI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local cashInputValue = ""
local spinInputValue = ""
local autoInfiniteCash = false
local autoInfiniteSpin = false
local espEnabled = false
local espUpdateConnection
local espOptions = { ShowName=false, ShowHealth=false, ShowDistance=false, ShowMorph=false, ShowClass=false, ShowAura=false, HighlightColor=Color3.fromRGB(0,255,0), Rainbow=false }
local ESPNormal = "Red"
local antiAfkEnabled = false
local antiAdminEnabled = false 
local fakeBypassEnabled = false
local maxPlayers = 1
local allowFriend = true
local nightmareMode = false
local selectedGamepass = "All"
local morphInputValue = false
local classInputValue = false
local auraInputValue = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Loading"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- กล่องหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 120)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.05
MainFrame.Parent = ScreenGui

-- มุมโค้งมน
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- เงา
local Shadow = Instance.new("ImageLabel")
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5028857084"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
Shadow.Parent = MainFrame

-- ข้อความ Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "DYHUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0.8
Title.Parent = MainFrame

-- ข้อความ Loading
local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1, -20, 0, 30)
LoadingLabel.Position = UDim2.new(0, 10, 0, 50)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Loading..."
LoadingLabel.Font = Enum.Font.Gotham
LoadingLabel.TextSize = 20
LoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingLabel.Parent = MainFrame

-- Progress Bar พื้นหลัง
local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(1, -40, 0, 12)
ProgressBarBg.Position = UDim2.new(0, 20, 1, -30)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ProgressBarBg.BorderSizePixel = 0
ProgressBarBg.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = ProgressBarBg

-- Progress Bar ขยับได้
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBarBg

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = ProgressBar

-- Animation
spawn(function()
	while true do
		for i = 0, 1, 0.01 do
			ProgressBar.Size = UDim2.new(i, 0, 1, 0)
			wait(0.03)
		end
		wait(0.5)
		ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	end
end)

-- ====== โหลด WindUI แบบ Async ======
task.spawn(function()
    local success, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)

    if not success or not WindUI then
        LoadingLabel.Text = "Failed to load WindUI!"
        task.wait(3)
        LoadingLabel.Text = "Change your executor!"
        task.wait(2)
        ScreenGui:Destroy()
        return
    end

    -- ลบ Loading UI
    ScreenGui:Destroy()

    -- สร้างหน้าต่างหลัก
    local Window = WindUI:CreateWindow({
        Title = "DYHUB - Anime Rails (Lobby)",
        IconThemed = true,
        Icon = "star",
        Author = "Version: 5.2.6 | dsc.gg/dyhub",
        Size = UDim2.fromOffset(500, 300),
        Transparent = true,
        Theme = "Dark",
    })

    Window:EditOpenButton({
        Title = "DYHUB - Open",
        Icon = "monitor",
        CornerRadius = UDim.new(0, 6),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromRGB(30, 30, 30),
            Color3.fromRGB(255, 255, 255)
        ),
        Draggable = true,
    })

    -- Tabs with Icons (ต้องอยู่ในนี้)
    local InfoTab = Window:Tab({ Title = "Info", Icon = "info" })
    local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" }) 
    local CashTab = Window:Tab({ Title = "Cash", Icon = "dollar-sign" }) 
    local PartyTab = Window:Tab({ Title = "Auto Join", Icon = "handshake" }) 
    local GUI = Window:Tab({ Title = "Equip", Icon = "flame" }) 
    local GamepassTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" }) 
    local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" }) 
    local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" }) 

    Window:SelectTab(1)

    InfoTab:Section({ Title = "Read before using this script", Icon = "info" })
    InfoTab:Section({ Title = "This script is still under development." })
    InfoTab:Section({ Title = "If there are any bugs or issues" })
    InfoTab:Section({ Title = "you can report them to us on Discord" })

    InfoTab:Button({
        Title = "DYHUB - Discord! (Copy Link)",
        Callback = function()
            setclipboard("https://dsc.gg/dyhub")
        end
    })

    InfoTab:Section({ Title = "inf money & spin, if rejoin u will be reset.", Icon = "triangle-alert" })
    InfoTab:Section({ Title = "We appreciate your choice to use our script.", Icon = "heart" })
end)

-- ====== Main Tab ======
local player = LocalPlayer
local data = player:WaitForChild("Data")
local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ChangeValue")

local function getDataNames()
    local names = {}
    for _, child in ipairs(data:GetChildren()) do
        if child:IsA("BoolValue") then
            table.insert(names, child.Name)
        end
    end
    return names
end

MainTab:Section({ Title = "Dupe All", Icon = "copy" })

MainTab:Button({
    Title = "Dupe All (Fixed)",
    Icon = "atom",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local data = player:WaitForChild("Data") -- เปลี่ยนเป็น path จริงของ data

        for _, name in ipairs(getDataNames()) do
            -- ตรวจสอบว่าปลดล็อกแล้วหรือยัง
            local unlocked = data:FindFirstChild(name) and data[name].Value
            if not unlocked then
                event:FireServer("SetMorphBuy", name, 0)
                task.wait(0.25)
            end
        end

        print("[DYHUB] All Morphs, Classes and Auras unlocked!")
    end,
})

MainTab:Section({ Title = "Dupe Select", Icon = "layers-2" })

-- Morph Dropdown
MainTab:Dropdown({
    Title = "Select Morph",
    Values = getDataNames(),
    Multi = false,
    Callback = function(value)
        morphInputValue = value
    end
})
MainTab:Button({
    Title = "Unlock Morph",
    Icon = "crown",
    Callback = function()
        if morphInputValue ~= "" then
            event:FireServer("SetMorphBuy", morphInputValue, 0)
            print("[DYHUB] Morph unlocked:", morphInputValue)
        end
    end
})

-- Class Dropdown
MainTab:Dropdown({
    Title = "Select Class",
    Values = getDataNames(),
    Multi = false,
    Callback = function(value)
        classInputValue = value
    end
})
MainTab:Button({
    Title = "Unlock Class",
    Icon = "swords",
    Callback = function()
        if classInputValue ~= "" then
            event:FireServer("SetMorphBuy", classInputValue, 0)
            print("[DYHUB] Class unlocked:", classInputValue)
        end
    end
})

-- Aura Dropdown
MainTab:Dropdown({
    Title = "Select Aura",
    Values = getDataNames(),
    Multi = false,
    Callback = function(value)
        auraInputValue = value
    end
})
MainTab:Button({
    Title = "Unlock Aura",
    Icon = "flame",
    Callback = function()
        if auraInputValue ~= "" then
            event:FireServer("SetMorphBuy", auraInputValue, 0)
            print("[DYHUB] Aura unlocked:", auraInputValue)
        end
    end
})

-- ====== Equip Tab ======
local function fireChangeValue(key,value)
    event:FireServer(key,value)
    print("[DYHUB] Sent", key,value)
end

GUI:Section({ Title = "Equip Select", Icon = "shapes" })

GUI:Dropdown({ Title="Select Character", Values=getDataNames(), Multi=false, Callback=function(v) fireChangeValue("SetCurrChar",v) end })
GUI:Dropdown({ Title="Select Class Slot 1", Values=getDataNames(), Multi=false, Callback=function(v) fireChangeValue("SetCurClass",v) end })
GUI:Dropdown({ Title="Select Class Slot 2", Values=getDataNames(), Multi=false, Callback=function(v) fireChangeValue("SetCurClass2",v) end })
GUI:Dropdown({ Title="Select Aura", Values=getDataNames(), Multi=false, Callback=function(v) fireChangeValue("SetCurAura",v) end })

-- ====== Cash Tab ======

CashTab:Section({ Title = "Join Group first!", Icon = "triangle-alert" })
CashTab:Section({ Title = "Dupe Currency", Icon = "circle-dollar-sign" })

CashTab:Input({ Title = "Enter Dupe Cash Amount", Placeholder = "100 ~ 10000", Callback = function(text) cashInputValue = text end })
CashTab:Button({
    Title = "Dupe Cash",
    Icon = "dollar-sign",
    Callback = function()
        local input = tonumber(cashInputValue)
        if input and input >= 100 and input <= 10000 then
            ReplicatedStorage:WaitForChild("CodeEvent"):FireServer("Wins", input, "DYHUB")
            print("[DYHUB] Dupe Cash:", input)
        else
            print("[DYHUB] Invalid amount:", cashInputValue)
        end
    end,
})

CashTab:Input({ Title = "Enter Dupe Spin Amount", Placeholder = "100 ~ 500", Callback = function(text) spinInputValue = text end })
CashTab:Button({
    Title = "Dupe Spin",
    Icon = "dollar-sign",
    Callback = function()
        local input = tonumber(spinInputValue)
        if input and input >= 100 and input <= 500 then
            ReplicatedStorage:WaitForChild("CodeEvent"):FireServer("Wins", input, "DYHUB")
            print("[DYHUB] Dupe Spin:", input)
        else
            print("[DYHUB] Invalid amount:", spinInputValue)
        end
    end,
})

CashTab:Section({ Title = "You will got reset!, if rejoin.", Icon = "triangle-alert" })
CashTab:Section({ Title = "Dupe Infinite", Icon = "infinity" })

CashTab:Toggle({
    Title = "Infinite Dupe Cash",
    Default = false,
    Icon = "infinity",
    Callback = function(enabled)
        autoInfiniteCash = enabled
        if enabled then
            task.spawn(function()
                local totalAmount, perFire = 999000000, 999999
                local times = math.floor(totalAmount / perFire)
                while autoInfiniteCash do
                    for i = 1, times do
                        if not autoInfiniteCash then break end
                        ReplicatedStorage:WaitForChild("CodeEvent"):FireServer("Wins", perFire, "DYHUB")
                        task.wait(0.1)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

CashTab:Toggle({
    Title = "Infinite Dupe Spin",
    Default = false,
    Icon = "infinity",
    Callback = function(enabled)
        autoInfiniteSpin = enabled
        if enabled then
            task.spawn(function()
                local totalAmount, perFire = 100, 999999
                local times = math.floor(totalAmount / perFire)
                while autoInfiniteSpin do
                    for i = 1, times do
                        if not autoInfiniteSpin then break end
                        ReplicatedStorage:WaitForChild("CodeEvent"):FireServer("Wins", perFire, "DYHUB")
                        task.wait(0.1)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- ====== Player ESP Tab ======

local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local gui = head:FindFirstChild("DYESP") or Instance.new("BillboardGui")
            gui.Name, gui.Size, gui.StudsOffset, gui.AlwaysOnTop, gui.Parent = "DYESP", UDim2.new(0,200,0,100), Vector3.new(0,2.5,0), true, head
            for _, child in ipairs(gui:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
            local y=0
            local function addLine(text)
                local label = Instance.new("TextLabel")
                label.Size, label.Position, label.BackgroundTransparency = UDim2.new(1,0,0,20), UDim2.new(0,0,0,y), 1
                label.TextColor3 = espOptions.Rainbow and Color3.fromHSV((tick()%5)/5,1,1) or espOptions.HighlightColor
                label.TextStrokeTransparency, label.TextScaled, label.Font, label.Text = 0, true, Enum.Font.SourceSansBold, text
                label.Parent = gui
                y = y + 20
            end
            if espOptions.ShowName then addLine(target.Name) end
            if espOptions.ShowHealth and target.Character:FindFirstChild("Humanoid") then addLine("HP: "..math.floor(target.Character.Humanoid.Health)) end
            if espOptions.ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                addLine("Dist: "..math.floor(dist))
            end
            local d = target:FindFirstChild("Data")
            if d then
                if espOptions.ShowMorph and d:FindFirstChild("CurrChar") then addLine("Morph: "..d.CurrChar.Value) end
                if espOptions.ShowClass and d:FindFirstChild("CurrClass") then addLine("Class: "..d.CurrClass.Value) end
                if espOptions.ShowAura and d:FindFirstChild("CurrSelect") then addLine("Aura: "..d.CurrSelect.Value) end
            end
        end
    end
end

local function clearESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local gui = p.Character.Head:FindFirstChild("DYESP")
            if gui then gui:Destroy() end
        end
    end
end

local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        updateESP()
        espUpdateConnection = RunService.Heartbeat:Connect(updateESP)
    else
        clearESP()
        if espUpdateConnection then espUpdateConnection:Disconnect() espUpdateConnection=nil end
    end
end

PlayerTab:Section({ Title = "Featrue ESP", Icon = "eye" })

PlayerTab:Toggle({ Title="Enable ESP", Value=false, Callback=toggleESP })
PlayerTab:Dropdown({
    Title="ESP Color", Default="Green",
    Values={"Red","Green","Blue","Yellow","Purple","Cyan","White","Black","Rainbow"},
    Default = ESPNormal,  
    Multi = false, 
    Callback=function(value)
        espOptions.Rainbow = (value=="Rainbow")
        local colors = {Red=Color3.fromRGB(255,0,0), Green=Color3.fromRGB(0,255,0), Blue=Color3.fromRGB(0,0,255),
            Yellow=Color3.fromRGB(255,255,0), Purple=Color3.fromRGB(128,0,128), Cyan=Color3.fromRGB(0,255,255),
            White=Color3.fromRGB(255,255,255), Black=Color3.fromRGB(0,0,0)}
        if not espOptions.Rainbow then espOptions.HighlightColor = colors[value] or Color3.fromRGB(0,255,0) end
    end
})

PlayerTab:Section({ Title = "ESP Settings", Icon = "settings" })

PlayerTab:Toggle({ Title="Show Player Name", Value=false, Callback=function(s) espOptions.ShowName=s end })
PlayerTab:Toggle({ Title="Show Health", Value=false, Callback=function(s) espOptions.ShowHealth=s end })
PlayerTab:Toggle({ Title="Show Distance", Value=false, Callback=function(s) espOptions.ShowDistance=s end })
PlayerTab:Toggle({ Title="Show Morph", Value=false, Callback=function(s) espOptions.ShowMorph=s end })
PlayerTab:Toggle({ Title="Show Class", Value=false, Callback=function(s) espOptions.ShowClass=s end })
PlayerTab:Toggle({ Title="Show Aura", Value=false, Callback=function(s) espOptions.ShowAura=s end })

-- ====== Misc Tab ======
MiscTab:Section({ Title = "Feature Safe", Icon = "shield" })

MiscTab:Toggle({
    Title="Bypass Anti-Cheat (V2)",
    Value=true,
    Callback=function(state)
        fakeBypassEnabled=state
        if state then print("[DYHUB] Bypass Anti-Cheat Enabled") end
    end
})

MiscTab:Toggle({
    Title="Anti AFK",
    Value=false,
    Callback=function(state)
        antiAfkEnabled=state
        if state then
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(60)
                end
            end)
            print("[DYHUB] Anti AFK enabled")
        else
            print("[DYHUB] Anti AFK disabled")
        end
    end
})

MiscTab:Toggle({
    Title="Anti Admin (Auto Hop)",
    Value=false,
    Callback=function(state)
        antiAdminEnabled=state
        if state then
            task.spawn(function()
                while antiAdminEnabled do
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Name=="Roblox123" then
                            TeleportService:Teleport(game.PlaceId, LocalPlayer)
                            return
                        end
                    end
                    task.wait(15)
                end
            end)
        end
    end
})

-- ====== Auto Join Tab ======

PartyTab:Section({ Title = "Feature Join", Icon = "user" })

PartyTab:Input({ Title="Max Players", Placeholder="Enter 1 ~ 8", Callback=function(txt)
    local n=tonumber(txt)
    if n and n>=1 and n<=8 then maxPlayers=n else warn("[DYHUB] Invalid Max Players") end
end})
PartyTab:Toggle({ Title="Allow Friend Join", Default=true, Callback=function(s) allowFriend=s end })
PartyTab:Toggle({ Title="Nightmare Mode", Default=false, Callback=function(s) nightmareMode=s end })
PartyTab:Button({ Title="Auto Join", Callback=function()
    ReplicatedStorage:WaitForChild("ApplyTP"):FireServer(allowFriend,maxPlayers,nightmareMode)
    print("[DYHUB] Auto Join sent:",allowFriend,maxPlayers,nightmareMode)
end })

-- ====== Gamepass Tab ======
GamepassTab:Section({ Title = "Feature Gamepass", Icon = "moon-star" })

GamepassTab:Dropdown({
    Title = "Select Gamepass",
    Values = { "All", "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" },
    Multi = false,
    Callback = function(selected)
        selectedGamepass = selected
        print("[DYHUB] Selected Gamepass:", selectedGamepass)
    end,
})

GamepassTab:Button({
    Title = "Enter Unlock",
    Icon = "check",
    Callback = function()
        local data = player:FindFirstChild("Data")
        if not data then warn("[DYHUB] Data not found!") return end
        local gamepasses = selectedGamepass == "All" and { "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" } or { selectedGamepass }
        for _, gpName in ipairs(gamepasses) do
            local gp = data:FindFirstChild(gpName)
            if gp then
                gp.Value = true
                print("[DYHUB] Unlocked Gamepass:", gpName)
            else
                warn("[DYHUB] Gamepass not found:", gpName)
            end
        end
        if selectedGamepass == "Emote" or selectedGamepass == "All" then
            local emotes = player:FindFirstChild("PlayerGui"):FindFirstChild("HUD")
            if emotes and emotes:FindFirstChild("Emotes") then
                emotes.Emotes.Visible = true
            end
        end
    end,
})

print("[DYHUB] Script loaded successfully!")
