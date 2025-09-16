-- pre-2.37-fixed

repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer
local GetReadyRemote = ReplicatedStorage:WaitForChild("GetReadyRemote")
local SkipHelicopterRemote = ReplicatedStorage:WaitForChild("SkipHelicopter")
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

local autoFarmActive = false
local autoReadyActive = false
local MasteryAutoFarmActive = false
local autoSkipHelicopterActive = false
local flushAuraActive = false
local espActive = false

local MMovementMode = "Teleport"

local espActiveEnemies = false
local espActivePlayers = false
local espShowName = true
local espShowHealth = true
local espShowDistance = false
local espMode = "Highlight"

getgenv().HitboxEnabled = false
getgenv().HitboxSize = 20
getgenv().HitboxShow = false

local movementMode = "Teleport"
local CharacterMode = "Used"
local ActionMode = "Default"

local visitedNPCs = {}
local pressCount = {}
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function createBillboard(model, humanoid)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DYHUB_ESP_Billboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = workspace

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    local function updateText()
        local parts = {}
        if espShowName then table.insert(parts, model.Name or "NPC") end
        if humanoid and humanoid.Health and humanoid.MaxHealth and espShowHealth then
            table.insert(parts, math.floor(humanoid.Health).." / "..math.floor(humanoid.MaxHealth))
        end
        if espShowDistance then
            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            table.insert(parts, "Dist: "..math.floor(dist))
        end
        textLabel.Text = table.concat(parts, "\n")
    end

    updateText()

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if humanoid and humanoid.Health <= 0 then
            billboard:Destroy()
            if conn then
                conn:Disconnect()
                conn = nil
            end
        else
            updateText()
        end
    end)

    table.insert(espObjects, billboard)
end

local function applyESPToModel(model)
    if espMode == "Highlight" then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = workspace
        table.insert(espObjects, highlight)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            createBillboard(model, humanoid)
        end
    elseif espMode == "BoxHandle" then
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 2)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.Parent = workspace.Terrain
        table.insert(espObjects, box)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            createBillboard(model, humanoid)
        end
    end
end

local function updateESPmodel()
    clearESP()
    if not espActive then return end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        applyESPToModel(char)
    end

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    applyESPToModel(npc)
                end
            end
        end
    end
end

-- แยกฟังก์ชัน update ESP
function updateESPPlayers()
    clearESP()
    if not espActivePlayers then return end
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            createBillboard(char, humanoid)
        end
    end
end

function updateESPEnemies()
    clearESP()
    if not espActiveEnemies then return end
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    createBillboard(npc, humanoid)
                end
            end
        end
    end
end

-- Loop อัปเดต ESP
task.spawn(function()
    while true do
        if espActiveEnemies or espActivePlayers then
            pcall(updateESPmodel)
            pcall(updateESPPlayers)
            pcall(updateESPEnemies)
        else
            clearESP()
        end
        task.wait(1)
    end
end)

local function isVisited(npc)
    for _, v in ipairs(visitedNPCs) do
        if v == npc then return true end
    end
    return false
end

local function addVisited(npc)
    table.insert(visitedNPCs, npc)
end

local function removeVisited(npc)
    for i, v in ipairs(visitedNPCs) do
        if v == npc then
            table.remove(visitedNPCs, i)
            break
        end
    end
    pressCount[npc] = nil
end

local function keepModifyProximityPrompts()
    spawn(function()
        while true do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.HoldDuration ~= 0 then
                        obj.HoldDuration = 0
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end
keepModifyProximityPrompts()

local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC, closestPrompt = nil, nil

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                for _, prompt in pairs(npc:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" then
                        if (pressCount[npc] or 0) < 3 then
                            local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                            if dist < lastDist then
                                closestNPC, closestPrompt = npc, prompt
                                lastDist = dist
                            end
                        end
                    end
                end
            end
        end
    end

    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoidNoProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local hasProximity = false
                        for _, child in pairs(npc:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                hasProximity = true
                                break
                            end
                        end
                        if not hasProximity then
                            local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                            if dist < lastDist then
                                closestNPC = npc
                                lastDist = dist
                            end
                        end
                    end
                end
            end
        end
    end

    return closestNPC
end

local function findNextNPCWithHumanoidNoProximity2(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                        if dist < lastDist then
                            closestNPC = npc
                            lastDist = dist
                        end
                    end
                end
            end
        end
    end

    return closestNPC
end

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPos)}

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

local function teleportToTarget(targetPos, duration)
    if movementMode == "CFrame" then
        smoothTeleportTo(targetPos, duration or 0.5)
    else
        instantTeleportTo(targetPos)
    end
end

local RunService = game:GetService("RunService")
local supportPart
local partConnection

local function createSupportPart(character)
    -- ลบของเก่าถ้ามี
    if supportPart then
        supportPart:Destroy()
        supportPart = nil
    end
    if partConnection then
        partConnection:Disconnect()
        partConnection = nil
    end

    supportPart = Instance.new("Part")
    supportPart.Size = Vector3.new(5, 1, 5) -- ขนาดแผ่น
    supportPart.Anchored = true
    supportPart.CanCollide = true
    supportPart.Transparency = 0.9 -- โปร่งใสหน่อย
    supportPart.Name = "AutoFarmSupport"
    supportPart.Parent = workspace

    -- อัปเดตตำแหน่งตลอดเวลา
    partConnection = RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            -- วางแผ่นใต้เท้า (พอดีกับพื้น)
            supportPart.Position = hrp.Position - Vector3.new(
                0,
                (hrp.Size.Y/1 + supportPart.Size.Y/1),
                0
            )
        end
    end)
end

local function removeSupportPart()
    if partConnection then
        partConnection:Disconnect()
        partConnection = nil
    end
    if supportPart then
        supportPart:Destroy()
        supportPart = nil
    end
end


-- ฟังก์ชันหลัก (เพิ่มระบบสร้าง part เข้าไป)
local function attackHumanoidNoProximity(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local character = game.Players.LocalPlayer.Character

    if humanoid and hrp and humanoid.Health > 0 then
        createSupportPart(character) -- เริ่มสร้างแผ่นรอง
        while humanoid.Health > 0 and autoFarmActive do
            teleportToTarget(hrp.Position + Vector3.new(0, 1, 0), 0.5)
            LMBRemote:FireServer()
            task.wait(0.1)
        end
        removeSupportPart() -- หยุดเมื่อฟังก์ชันหยุด
        removeVisited(npc)
    end
end

-- ฟังก์ชันเปิด/ปิด Mastery AutoFarm
local function toggleMasteryAutoFarm(state)
    MasteryAutoFarmActive = state
    if not MasteryAutoFarmActive then
        removeSupportPart() -- ลบ SupportPart ถ้า AutoFarm ถูกปิด
    else
        MasteryAutoFarm()
    end
end

-- ฟังก์ชัน Mastery AutoFarm
function MasteryAutoFarm()
    task.spawn(function()
        while MasteryAutoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- หา NPC ใกล้ที่สุดใน workspace.Living
                    local npc = findNextNPCWithHumanoid(1000, hrp)
                    if npc then
                        if not isVisited(npc) then
                            addVisited(npc)
                        end
                        attackHumanoid(npc)
                    else
                        -- ถ้าไม่เจอ NPC รีเซ็ตตัวแปร
                        visitedNPCs = {}
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- ฟังก์ชันต่อย NPC
function attackHumanoid(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local character = LocalPlayer.Character

    if humanoid and hrp and humanoid.Health > 0 then
        createSupportPart(character) -- สร้างแผ่นรองใต้เท้า
        while humanoid.Health > 0 and MasteryAutoFarmActive do
            teleportToTarget(hrp.Position + Vector3.new(0, 3, 0), 0.5)
            LMBRemote:FireServer() -- ต่อย NPC
            task.wait(0.1)
        end
        removeSupportPart() -- ลบแผ่นรอง
        removeVisited(npc)
    end
end

-- ฟังก์ชันหาตัว NPC ใกล้ที่สุดใน workspace.Living
function findNextNPCWithHumanoid(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                        if dist < lastDist then
                            closestNPC = npc
                            lastDist = dist
                        end
                    end
                end
            end
        end
    end

    return closestNPC
end


local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc, prompt = findNextNPCWithFlushProximity(1000, hrp)
                    if npc and prompt and prompt.Parent then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local targetPos = prompt.Parent.Position + Vector3.new(0, 3, 0)
                            teleportToTarget(targetPos, 0.5)
                            while (pressCount[npc] or 0) < 3 do
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                                pressCount[npc] = (pressCount[npc] or 0) + 1
                                task.wait(0.15)
                            end
                            addVisited(npc)
                        else
                            removeVisited(npc)
                        end
                    else
                        local npc2 = findNextNPCWithHumanoidNoProximity(1000, hrp)
                        if npc2 then
                            if not isVisited(npc2) then
                                addVisited(npc2)
                            end
                            attackHumanoidNoProximity(npc2)
                        else
                            visitedNPCs = {}
                            pressCount = {}
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

local function flushAura()
    task.spawn(function()
        while flushAuraActive do
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local nearbyParts = workspace:GetPartBoundsInRadius(hrp.Position, 100, nil)

                for _, part in pairs(nearbyParts) do
                    local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.ActionText == "Flush" then
                        pcall(function()
                            prompt:InputHoldBegin()
                            task.wait(0.05)
                            prompt:InputHoldEnd()
                        end)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end


local function sendReady(value)
    GetReadyRemote:FireServer("1", value)
end

local function startAutoReady()
    task.spawn(function()
        sendReady(true)
        while autoReadyActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                sendReady(true)
            end
            task.wait(1)
        end
        sendReady(false)
    end)
end

local function startAutoSkipHelicopter()
    task.spawn(function()
        while autoSkipHelicopterActive do
            pcall(function()
                SkipHelicopterRemote:FireServer()
            end)
            task.wait(1)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoFarmActive then startAutoFarm() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
    if flushAuraActive then flushAura() end
end)

WindUI:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b", 
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa",
})

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#ffffff",
    Button = "#e4e4e7",
    Icon = "#52525b",
})

WindUI:AddTheme({
    Name = "Gray",
    Accent = "#374151",
    Dialog = "#374151",
    Outline = "#d1d5db", 
    Text = "#f9fafb",
    Placeholder = "#9ca3af",
    Background = "#1f2937",
    Button = "#4b5563",
    Icon = "#d1d5db",
})

WindUI:AddTheme({
    Name = "Blue",
    Accent = "#1e40af",
    Dialog = "#1e3a8a",
    Outline = "#93c5fd", 
    Text = "#f0f9ff",
    Placeholder = "#60a5fa",
    Background = "#1e293b",
    Button = "#3b82f6",
    Icon = "#93c5fd",
})

WindUI:AddTheme({
    Name = "Green",
    Accent = "#059669",
    Dialog = "#047857",
    Outline = "#6ee7b7", 
    Text = "#ecfdf5",
    Placeholder = "#34d399",
    Background = "#064e3b",
    Button = "#10b981",
    Icon = "#6ee7b7",
})

WindUI:AddTheme({
    Name = "Purple",
    Accent = "#7c3aed",
    Dialog = "#6d28d9",
    Outline = "#c4b5fd", 
    Text = "#faf5ff",
    Placeholder = "#a78bfa",
    Background = "#581c87",
    Button = "#8b5cf6",
    Icon = "#c4b5fd",
})

WindUI:SetNotificationLower(true)

local themes = {"Dark", "Light", "Gray", "Blue", "Green", "Purple"}
local currentThemeIndex = 1

local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "ST : Blockade Battlefront | Free Version",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Dark",
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "Theme Changed",
                Content = "Switched to " .. newTheme .. " theme!",
                Duration = 2,
                Icon = "palette"
            })
            print("Switched to " .. newTheme .. " theme")
        end,
    },
    
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local InfoTab = Window:Tab({ Title = "Info", Icon = "info" })
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local HitboxTab = Window:Tab({ Title = "Hitbox", Icon = "package" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "sword" })
local MasteryTab = Window:Tab({ Title = "Mastery", Icon = "award" })
local CodesTab = Window:Tab({ Title = "Codes", Icon = "bird" })
local GameTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })

Window:SelectTab(1)

InfoTab:Section({ Title = "Info", Icon = "info" })
InfoTab:Section({ Title = "This script is still under development." })
InfoTab:Section({ Title = "If there are any bugs or issues" })
InfoTab:Section({ Title = "you can report them to us on Discord" })

InfoTab:Button({
    Title = "DYHUB - Discord!",
    Callback = function()
        setclipboard("https://dsc.gg/dyhub")
    end
})

InfoTab:Section({ Title = "We appreciate your choice to use our script.", Icon = "heart" })

MainTab:Section({ Title = "Feature Farm", Icon = "badge-dollar-sign" })

MainTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value)
        movementMode = value
    end,
})

MainTab:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

MainTab:Toggle({
    Title = "Flush Aura (Upgrade)",
    Default = false,
    Callback = function(value)
        flushAuraActive = value
        if flushAuraActive then
            flushAura()
            task.spawn(function()
                while flushAuraActive do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end,
})

MainTab:Section({ Title = "Feature Play", Icon = "badge-dollar-sign" })

MainTab:Toggle({
    Title = "Auto Ready",
    Default = false,
    Callback = function(value)
        autoReadyActive = value
        if autoReadyActive then
            startAutoReady()
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Skip Helicopter",
    Default = false,
    Callback = function(value)
        autoSkipHelicopterActive = value
        if autoSkipHelicopterActive then
            startAutoSkipHelicopter()
        end
    end,
})

CodesTab:Section({ Title = "Feature Code", Icon = "badge-dollar-sign" })

local redeemCodes = {
    "AstroInvasionBegin",
    "WaveStuckIssue",
    "50KGroup",
    "DarkDriveIssue",
    "Digi",
}

local selectedCodes = {}

CodesTab:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value)
        selectedCodes = value or {}
    end,
})

CodesTab:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        for _, codeKey in ipairs(selectedCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

CodesTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, codeKey in ipairs(redeemCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

EspTab:Section({ Title = "Feature Esp", Icon = "badge-dollar-sign" })

EspTab:Dropdown({
    Title = "ESP Mode",
    Values = {"Highlight", "BoxHandle"},
    Default = espMode,
    Multi = false,
    Callback = function(value)
        espMode = value
        if espActiveEnemies or espActivePlayers then
            updateESPmodel()
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- Toggle ESP Enemies
EspTab:Toggle({
    Title = "ESP (Enemies)",
    Default = false,
    Callback = function(value)
        espActiveEnemies = value
        if espActiveEnemies then
            updateESPmodel()
            updateESPEnemies()
        else
            clearESP()
        end
    end,
})

-- Toggle ESP Players
EspTab:Toggle({
    Title = "ESP (Players)",
    Default = false,
    Callback = function(value)
        espActivePlayers = value
        if espActivePlayers then
            updateESPmodel()
            updateESPPlayers()
        else
            clearESP()
        end
    end,
})

EspTab:Section({ Title = "Esp Setting", Icon = "badge-dollar-sign" })

-- Toggle ESP Name
EspTab:Toggle({
    Title = "ESP Name",
    Default = true,
    Callback = function(value)
        espShowName = value
        if espActiveEnemies or espActivePlayers then
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- Toggle ESP Health
EspTab:Toggle({
    Title = "ESP Health",
    Default = true,
    Callback = function(value)
        espShowHealth = value
        if espActiveEnemies or espActivePlayers then
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- Toggle ESP Distance
EspTab:Toggle({
    Title = "ESP Distance",
    Default = false,
    Callback = function(value)
        espShowDistance = value
        if espActiveEnemies or espActivePlayers then
            updateESPPlayers()
            updateESPEnemies()
        end
    end,
})

-- 🌌 DYHUB - Hitbox System
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🧩 ฟังก์ชันปรับ Hitbox
local function applyHitboxToNPC(npc)
    if not npc:IsA("Model") then return end
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")

    if humanoid and hrp then
        local existing = hrp:FindFirstChild("DYHUB_Hitbox")
        if getgenv().HitboxEnabled then
            if not existing then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "DYHUB_Hitbox"
                box.Adornee = hrp
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                box.Transparency = getgenv().HitboxShow and 0.5 or 1
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Parent = hrp
            else
                existing.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                existing.Transparency = getgenv().HitboxShow and 0.5 or 1
            end
        else
            if existing then existing:Destroy() end
        end
    end
end

-- 🔍 Scan NPC
local function scanNPCs()
    print("[DYHUB] Scan Loading...")
    task.wait(0.5)
    for i = 1, 3 do
        print("[DYHUB] Scan Loading... ["..i.."]")
        task.wait(0.3)
    end
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) then
                    applyHitboxToNPC(npc)
                end
            end
        end
    end
end

-- 🔄 Loop update
task.spawn(function()
    while task.wait(1) do
        if getgenv().HitboxEnabled then
            if workspace:FindFirstChild("Living") then
                for _, npc in pairs(workspace.Living:GetChildren()) do
                    if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                        if not Players:GetPlayerFromCharacter(npc) then
                            applyHitboxToNPC(npc)
                        end
                    end
                end
            end
        end
    end
end)

HitboxTab:Section({ Title = "⚠️ Beta Version: Bugs or Etc", Icon = "badge-dollar-sign" })
HitboxTab:Section({ Title = "Feature Hitbox", Icon = "badge-dollar-sign" })

HitboxTab:Button({ 
    Title = "Scan Humanoid",  
    Callback = function()
        scanNPCs()
    end,
})

HitboxTab:Slider({
    Title = "Set Size Hitbox", 
    Value = {Min = 16, Max = 100, Default = 20}, 
    Step = 1,
    Callback = function(val)
        getgenv().HitboxSize = val
    end,
})

HitboxTab:Toggle({
    Title = "Enable Hitbox", 
    Default = false,
    Callback = function(value)
        getgenv().HitboxEnabled = value
    end,
})

HitboxTab:Toggle({
    Title = "Show Hitbox (Transparency)", 
    Default = false,
    Callback = function(value)
        getgenv().HitboxShow = value
    end,
})


QuestTab:Section({ Title = "Feature Quest", Icon = "badge-dollar-sign" })

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

QuestTab:Button({
    Title = "Open Menu (Quest Clock-Man)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestClockManUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

QuestTab:Button({
    Title = "Open Menu (Quest)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

QuestTab:Section({ Title = "Start Auto Quest", Icon = "badge-dollar-sign" })

QuestTab:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

QuestTab:Section({ Title = "Setting Auto Quest", Icon = "badge-dollar-sign" })

QuestTab:Toggle({
    Title = "Auto Quest Collect (Beta)",
    Default = false,
    Callback = function(value)
        autoFarm1Active = value
        print("[DYHUB] Collect Quest: " .. tostring(value))
    end,
})

QuestTab:Toggle({
    Title = "Auto Quest Skip (Need Robux)",
    Default = false,
    Callback = function(value)
        autoFarm2Active = value
        print("[DYHUB] Skip Quest: " .. tostring(value))
    end,
})

MasteryTab:Section({ Title = "Feature Mastery", Icon = "badge-dollar-sign" })

MasteryTab:Dropdown({
    Title = "Action Speed",
    Values = {"Default", "Slow", "Faster", "Flash (Lag)"},
    Default = ActionMode,
    Multi = false,
    Callback = function(value)
        ActionMode = value
    end,
})

MasteryTab:Dropdown({
    Title = "Character List",
    Values = {"Small", "Large", "Support (Not Good)", "Titan"},
    Default = CharacterMode,
    Multi = false,
    Callback = function(value)
        CharacterMode = value
    end,
})

MasteryTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "Soon"},
    Default = MMovementMode,
    Multi = false,
    Callback = function(value)
        MMovementMode = value
    end,
})


MasteryTab:Toggle({
    Title = "Auto Mastery (ATK+Flush) (Beta)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

MasteryTab:Toggle({
    Title = "Auto Mastery (No Flush) (Beta)",
    Default = false,
    Callback = function(value)
        toggleMasteryAutoFarm(value)
    end,
})

GameTab:Section({ Title = "Feature Gamepass", Icon = "badge-dollar-sign" })
GameTab:Section({ Title = "Unlock gamepass for real!", Icon = "badge-dollar-sign" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Gamepasst = {
    "LuckyBoost",
    "RareLuckyBoost",
    "LegendaryLuckyBoost",
    "All"
}

local Gamepassts = {}

GameTab:Dropdown({
    Title = "Select Gamepass",
    Multi = true,
    Values = Gamepasst,
    Callback = function(value)
        Gamepassts = value or {}
    end,
})

GameTab:Button({
    Title = "Unlock Selected Gamepass",
    Callback = function()
        local gachaData = player:FindFirstChild("GachaData")
        if not gachaData then
            gachaData = Instance.new("Folder")
            gachaData.Name = "GachaData"
            gachaData.Parent = player
        end

        local toUnlock = {}

        for _, v in ipairs(Gamepassts) do
            if v == "All" then
                toUnlock = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost"}
                break
            else
                table.insert(toUnlock, v)
            end
        end

        for _, gamepassName in ipairs(toUnlock) do
            pcall(function()
                local boolValue = gachaData:FindFirstChild(gamepassName)
                if not boolValue then
                    boolValue = Instance.new("BoolValue")
                    boolValue.Name = gamepassName
                    boolValue.Parent = gachaData
                end
                boolValue.Value = true
                task.wait(0.2)
            end)
        end
    end,
})

PlayerTab:Section({ Title = "Feature Player", Icon = "badge-dollar-sign" })

PlayerTab:Button({
    Title = "Open Menu (Helicopter)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("003-A")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

-- Player Tab Vars
getgenv().speedEnabled = false
getgenv().speedValue = 20

PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = {Min = 16, Max = 600, Default = 20},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50

PlayerTab:Slider({
    Title = "Set Jump Value",
    Value = {Min = 10, Max = 600, Default = 50},
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end
})

local noclipConnection

PlayerTab:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
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
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

PlayerTab:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local uis = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer
        local infJumpConnection

        if state then
            infJumpConnection = uis.JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            getgenv().infJumpConnection = infJumpConnection
        else
            if getgenv().infJumpConnection then
                getgenv().infJumpConnection:Disconnect()
                getgenv().infJumpConnection = nil
            end
        end
    end
})

PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})

MiscTab:Section({ Title = "Feature Visual", Icon = "badge-dollar-sign" })

-- Misc Tab Vars for Lighting Effects
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogStart = Lighting.FogStart
local oldFogEnd = Lighting.FogEnd
local oldFogColor = Lighting.FogColor

local fullBrightConnection
local noFogConnection

MiscTab:Toggle({
    Title = "FullBright",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 5
            Lighting.ClockTime = 14

            fullBrightConnection = RunService.RenderStepped:Connect(function()
                if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
                if Lighting.Brightness ~= 10 then Lighting.Brightness = 10 end
                if Lighting.Ambient ~= Color3.new(1,1,1) then Lighting.Ambient = Color3.new(1,1,1) end
            end)
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            Lighting.Ambient = oldAmbient
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e10
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)

            noFogConnection = RunService.RenderStepped:Connect(function()
                if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end
                if Lighting.FogEnd ~= 1e10 then Lighting.FogEnd = 1e10 end
                if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then Lighting.FogColor = Color3.fromRGB(255, 255, 255) end
            end)
        else
            if noFogConnection then
                noFogConnection:Disconnect()
                noFogConnection = nil
            end
            Lighting.FogStart = oldFogStart
            Lighting.FogEnd = oldFogEnd
            Lighting.FogColor = oldFogColor
        end
    end
})

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name = "VibrantEffect"
vibrantEffect.Saturation = 1
vibrantEffect.Contrast = 0.4
vibrantEffect.Brightness = 0.05
vibrantEffect.Enabled = false
vibrantEffect.Parent = Lighting

MiscTab:Toggle({
    Title = "Vibrant Colors",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            vibrantEffect.Enabled = true
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            vibrantEffect.Enabled = false
        end
    end
})

MiscTab:Section({ Title = "Feature Boost", Icon = "badge-dollar-sign" })

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
                msText.Text = "Ew Wifi Ping: " .. ping .. " ms"
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)

MiscTab:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

MiscTab:Toggle({
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

MiscTab:Button({
    Title = "FPS Boost (Fixed)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("[Boost] FPS Boost Applied")
    end
})

print("[DYHUB] DYHUB - Loaded! (Console Show)")
