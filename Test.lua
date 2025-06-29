-- === DYHUB | ARSENAL FULL REWORK (with Save/Load Config + Silent Aim + Triggerbot) ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local configFileName = "DYHUB_Arsenal_Config.txt"
local configData = {}

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = txt,
            Duration = 2
        })
    end)
end

notify("✅ DYHUB Loaded")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | Arsenal"
gui.ResetOnSpawn = false

-- MAIN FRAME
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- HEADER
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "DYHUB | Arsenal"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 5)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

-- SIDEBAR
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 150, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -150, 1, -30)
contentFrame.Position = UDim2.new(0, 150, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local listLayout = Instance.new("UIListLayout", sidebar)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local pages, buttons = {}, {}
local function createPage(name)
    local page = Instance.new("Frame", contentFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false

    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)

    table.insert(pages, page)
    table.insert(buttons, btn)
    return page
end

local aimbotPage = createPage("Aimbot"); aimbotPage.Visible = true
local espPage = createPage("ESP")
local fovPage = createPage("FOV")

-- STATE
local Aimbot, Smooth, Wall, SafeMode, WhoLock, ESP, ShowName, SilentAim, Triggerbot = false,false,false,false,false,false,false,false,false
local TargetPart, parts, partIdx = "Head", {"Head","UpperTorso","Torso"}, 1
local CurrentTarget = nil
local highlights, names = {}, {}
local fovCircle, FOV_Size, FOV_Color = nil, 100, Color3.fromRGB(255,255,255)

-- BUTTON GENERATOR
local function createBtn(parent, text, posY)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 220, 0, 30)
    b.Position = UDim2.new(0, 20, 0, posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

-- Aimbot Page
local posY = 20
local btnAimbot = createBtn(aimbotPage,"Aimbot: OFF",posY)
btnAimbot.MouseButton1Click:Connect(function() 
    Aimbot = not Aimbot 
    btnAimbot.Text = "Aimbot: " .. (Aimbot and "ON" or "OFF") 
    notify(btnAimbot.Text) 
end)

posY += 40
local btnSmooth = createBtn(aimbotPage,"Smooth: OFF",posY)
btnSmooth.MouseButton1Click:Connect(function() 
    Smooth = not Smooth
    btnSmooth.Text = "Smooth: " .. (Smooth and "ON" or "OFF")
    notify(btnSmooth.Text) 
end)

posY += 40
local btnWall = createBtn(aimbotPage,"Wall: OFF",posY)
btnWall.MouseButton1Click:Connect(function() 
    Wall = not Wall
    btnWall.Text = "Wall: " .. (Wall and "ON" or "OFF")
    notify(btnWall.Text) 
end)

posY += 40
local btnSafe = createBtn(aimbotPage,"Safe Mode: OFF",posY)
btnSafe.MouseButton1Click:Connect(function() 
    SafeMode = not SafeMode
    btnSafe.Text = "Safe Mode: " .. (SafeMode and "ON" or "OFF")
    notify(btnSafe.Text) 
end)

posY += 40
local btnWho = createBtn(aimbotPage,"Who Lock: OFF",posY)
btnWho.MouseButton1Click:Connect(function() 
    WhoLock = not WhoLock
    btnWho.Text = "Who Lock: " .. (WhoLock and "ON" or "OFF")
    notify(btnWho.Text) 
end)

posY += 40
local btnSilent = createBtn(aimbotPage,"Silent Aim: OFF", posY)
btnSilent.MouseButton1Click:Connect(function()
    SilentAim = not SilentAim
    btnSilent.Text = "Silent Aim: " .. (SilentAim and "ON" or "OFF")
    notify(btnSilent.Text)
end)

posY += 40
local btnTrigger = createBtn(aimbotPage,"Triggerbot: OFF", posY)
btnTrigger.MouseButton1Click:Connect(function()
    Triggerbot = not Triggerbot
    btnTrigger.Text = "Triggerbot: " .. (Triggerbot and "ON" or "OFF")
    notify(btnTrigger.Text)
end)

posY += 40
local btnTarget = createBtn(aimbotPage,"Target: Head",posY)
btnTarget.MouseButton1Click:Connect(function() 
    partIdx = partIdx % #parts + 1
    TargetPart = parts[partIdx]
    btnTarget.Text = "Target: " .. TargetPart
    notify(btnTarget.Text)
end)

posY += 40
local btnSaveConfig = createBtn(aimbotPage,"Save Config",posY)
btnSaveConfig.MouseButton1Click:Connect(function()
    saveConfig()
end)

posY += 40
local btnLoadConfig = createBtn(aimbotPage,"Load Config",posY)
btnLoadConfig.MouseButton1Click:Connect(function()
    loadConfig()
end)

-- ESP Page
local posY2 = 20
local btnESP = createBtn(espPage,"ESP: OFF",posY2)
btnESP.MouseButton1Click:Connect(function() 
    ESP = not ESP
    btnESP.Text = "ESP: " .. (ESP and "ON" or "OFF")
    notify(btnESP.Text) 
end)

posY2 += 40
local btnShowName = createBtn(espPage,"Show Name/HP: OFF",posY2)
btnShowName.MouseButton1Click:Connect(function() 
    ShowName = not ShowName
    btnShowName.Text = "Show Name/HP: " .. (ShowName and "ON" or "OFF")
    notify(btnShowName.Text) 
end)

-- FOV Page
local posY3 = 20
local Drawing = Drawing or getgenv().Drawing
if Drawing then 
    fovCircle = Drawing.new("Circle") 
    fovCircle.Transparency = 0.5 
    fovCircle.Thickness = 2 
    fovCircle.Radius = FOV_Size 
    fovCircle.Color = FOV_Color 
    fovCircle.Filled = false 
end

local plusBtn = createBtn(fovPage,"FOV +",posY3)
plusBtn.MouseButton1Click:Connect(function() 
    FOV_Size += 10
    if fovCircle then fovCircle.Radius = FOV_Size end
    notify("FOV Size: "..FOV_Size) 
end)

posY3 += 40
local minusBtn = createBtn(fovPage,"FOV -",posY3)
minusBtn.MouseButton1Click:Connect(function() 
    FOV_Size = math.max(10, FOV_Size - 10)
    if fovCircle then fovCircle.Radius = FOV_Size end
    notify("FOV Size: "..FOV_Size) 
end)

posY3 += 40
local colorBox = Instance.new("TextBox", fovPage)
colorBox.Size = UDim2.new(0, 220, 0, 30)
colorBox.Position = UDim2.new(0, 20, 0, posY3)
colorBox.PlaceholderText = "FOV Color (red,blue,green,white,rainbow)"
colorBox.Text = ""
colorBox.Font = Enum.Font.Gotham
colorBox.TextColor3 = Color3.new(1,1,1)
colorBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0, 5)

colorBox.FocusLost:Connect(function(enter)
    if not enter then return end
    local v = colorBox.Text:lower()
    if v == "red" then 
        FOV_Color = Color3.fromRGB(255,0,0)
    elseif v == "blue" then 
        FOV_Color = Color3.fromRGB(0,0,255)
    elseif v == "green" then 
        FOV_Color = Color3.fromRGB(0,255,0)
    elseif v == "white" then 
        FOV_Color = Color3.fromRGB(255,255,255)
    elseif v == "rainbow" then 
        -- handle rainbow in render step
    else 
        FOV_Color = Color3.fromRGB(255,255,255) 
    end
    if fovCircle then fovCircle.Color = FOV_Color end
    notify("FOV Color: "..v)
end)

-- MINIMIZE/CLOSE
minimizeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
closeBtn.MouseButton1Click:Connect(function() 
    gui:Destroy() 
    if fovCircle then fovCircle:Remove() end 
end)

-- VALIDATION & HELPERS
local function valid(p)
    return p 
        and p.Character 
        and p.Character:FindFirstChild(TargetPart) 
        and p.Character:FindFirstChild("Humanoid") 
        and p.Character.Humanoid.Health > 0
end

local function isBehind(p)
    local origin = Camera.CFrame.Position
    local direction = (p.Character[TargetPart].Position - origin).Unit * 500
    local ray = Ray.new(origin, direction)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character}, false, true)
    return hit and not p.Character:IsAncestorOf(hit)
end

local function getClosest()
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and valid(p) and p.Team ~= player.Team then
            if not Wall and isBehind(p) then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist and mag <= FOV_Size then -- within FOV
                    dist, best = mag, p
                end
            end
        end
    end
    return best
end

-- SAVE/LOAD CONFIG
function saveConfig()
    configData.Aimbot = Aimbot
    configData.Smooth = Smooth
    configData.Wall = Wall
    configData.SafeMode = SafeMode
    configData.WhoLock = WhoLock
    configData.ESP = ESP
    configData.ShowName = ShowName
    configData.SilentAim = SilentAim
    configData.Triggerbot = Triggerbot
    configData.TargetPart = TargetPart
    configData.FOV_Size = FOV_Size
    configData.FOV_Color = {FOV_Color.R * 255, FOV_Color.G * 255, FOV_Color.B * 255}
    
    local json = HttpService:JSONEncode(configData)
    writefile(configFileName, json)
    notify("Config saved!")
end

function loadConfig()
    if isfile(configFileName) then
        local json = readfile(configFileName)
        local data = HttpService:JSONDecode(json)
        if data then
            Aimbot = data.Aimbot or false
            Smooth = data.Smooth or false
            Wall = data.Wall or false
            SafeMode = data.SafeMode or false
            WhoLock = data.WhoLock or false
            ESP = data.ESP or false
            ShowName = data.ShowName or false
            SilentAim = data.SilentAim or false
            Triggerbot = data.Triggerbot or false
            TargetPart = data.TargetPart or "Head"
            FOV_Size = data.FOV_Size or 100
            local c = data.FOV_Color or {255,255,255}
            FOV_Color = Color3.fromRGB(c[1], c[2], c[3])
            
            btnAimbot.Text = "Aimbot: " .. (Aimbot and "ON" or "OFF")
            btnSmooth.Text = "Smooth: " .. (Smooth and "ON" or "OFF")
            btnWall.Text = "Wall: " .. (Wall and "ON" or "OFF")
            btnSafe.Text = "Safe Mode: " .. (SafeMode and "ON" or "OFF")
            btnWho.Text = "Who Lock: " .. (WhoLock and "ON" or "OFF")
            btnESP.Text = "ESP: " .. (ESP and "ON" or "OFF")
            btnShowName.Text = "Show Name/HP: " .. (ShowName and "ON" or "OFF")
            btnSilent.Text = "Silent Aim: " .. (SilentAim and "ON" or "OFF")
            btnTrigger.Text = "Triggerbot: " .. (Triggerbot and "ON" or "OFF")
            btnTarget.Text = "Target: " .. TargetPart
            
            if fovCircle then
                fovCircle.Radius = FOV_Size
                fovCircle.Color = FOV_Color
            end
            
            notify("Config loaded!")
        else
            notify("Failed to parse config.")
        end
    else
        notify("No config file found.")
    end
end

-- LOAD CONFIG AT START
loadConfig()

-- RAINBOW COLOR HELPER
local function getRainbowColor(tick)
    local frequency = 2
    local red = math.floor(math.sin(frequency * tick + 0) * 127 + 128)
    local green = math.floor(math.sin(frequency * tick + 2) * 127 + 128)
    local blue = math.floor(math.sin(frequency * tick + 4) * 127 + 128)
    return Color3.fromRGB(red, green, blue)
end

-- Hook example for Silent Aim (ยิงกระสุนไปเป้าหมายโดยตรง)
-- ต้องแก้ให้ตรงกับ RemoteEvent / Function ในเกม Arsenal จริง ๆ
-- ตัวอย่างนี้สมมุติว่ามี RemoteEvent ชื่อ "ShootEvent" ที่ส่งเป้าหมาย (TargetPosition)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shootEvent = ReplicatedStorage:WaitForChild("ShootEvent", 10) -- เปลี่ยนชื่อตามเกมจริง

if shootEvent and shootEvent:IsA("RemoteEvent") then
    local oldFireServer = shootEvent.FireServer
    shootEvent.FireServer = function(self, ...)
        if SilentAim and CurrentTarget and valid(CurrentTarget) then
            local args = {...}
            -- สมมุติ args[1] คือตำแหน่งเป้าหมาย Vector3 ที่จะยิง
            args[1] = CurrentTarget.Character[TargetPart].Position
            return oldFireServer(self, unpack(args))
        else
            return oldFireServer(self, ...)
        end
    end
end

-- Triggerbot: ยิงอัตโนมัติเมื่อเป้าหมายอยู่ใน FOV และ Mouse.Target เป็นเป้าหมาย
RunService.RenderStepped:Connect(function()
    if Triggerbot and Aimbot and CurrentTarget and valid(CurrentTarget) then
        local mouseTarget = Mouse.Target
        if mouseTarget and CurrentTarget.Character and CurrentTarget.Character:IsAncestorOf(mouseTarget) then
            -- กดคลิกเมาส์ซ้ายอัตโนมัติ (ใช้ VirtualInput)
            -- Roblox ไม่อนุญาตให้กดเมาส์โดยตรง ต้องใช้ไลบรารีเสริม (เช่น VirtualUser) ถ้าใช้บน Studio ให้ลองแบบนี้:
            pcall(function()
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            end)
        end
    end
end)

-- UPDATE LOOP
local tickCount = 0
RunService.RenderStepped:Connect(function(delta)
    tickCount += delta
    if fovCircle then 
        fovCircle.Visible = Aimbot
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = FOV_Size
        if colorBox.Text:lower() == "rainbow" then
            fovCircle.Color = getRainbowColor(tickCount * 5)
        else
            fovCircle.Color = FOV_Color
        end
    end

    if Aimbot then
        if not valid(CurrentTarget) then 
            CurrentTarget = getClosest() 
        end
        if SafeMode and CurrentTarget then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and valid(p) and p.Team ~= player.Team then
                    local dist = (p.Character[TargetPart].Position - player.Character.PrimaryPart.Position).Magnitude
                    if dist <= 8 and p ~= CurrentTarget then
                        CurrentTarget = p
                        break
                    end
                end
            end
        end
        if CurrentTarget and valid(CurrentTarget) then
            local goal = CFrame.new(Camera.CFrame.Position, CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame = Smooth and Camera.CFrame:Lerp(goal, 0.2) or goal
        end
    else
        CurrentTarget = nil
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            if ESP and valid(p) and p.Team ~= player.Team then
                if not highlights[p] then
                    local h = Instance.new("Highlight")
                    h.Adornee = p.Character
                    h.FillTransparency = 0.5
                    h.FillColor = Color3.new(1, 1, 1)
                    h.Parent = p.Character
                    highlights[p] = h
                end
                if ShowName then
                    if not names[p] then
                        local bb = Instance.new("BillboardGui", p.Character)
                        bb.Adornee = p.Character:FindFirstChild("Head")
                        bb.Size = UDim2.new(0, 150, 0, 50)
                        bb.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = Color3.new(1, 1, 1)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextScaled = true
                        names[p] = bb
                    end
                    local lbl = names[p]:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        lbl.Text = p.DisplayName .. " | HP:" .. math.floor(p.Character.Humanoid.Health)
                    end
                elseif names[p] then
                    names[p]:Destroy()
                    names[p] = nil
                end
            else
                if highlights[p] then
                    highlights[p]:Destroy()
                    highlights[p] = nil
                end
                if names[p] then
                    names[p]:Destroy()
                    names[p] = nil
                end
            end
        end
    end
end)
