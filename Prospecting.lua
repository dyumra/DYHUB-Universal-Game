-- =========================
local version = "3.8.3"
-- =========================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Character
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local character = getCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function getHumanoidRootPart()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

-- UI Load
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Prospecting | Free Version",
    Folder = "DYHUB_Prospecting",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30,30,30), Color3.fromRGB(255,255,255)),
    Draggable = true,
})

-- Tabs
local Tabs = {}
Tabs.Info = Window:Tab({ Title = "Information", Icon = "info", Desc = "DYHUB" })
Tabs.MainDivider = Window:Divider()
Tabs.Main = Window:Tab({ Title = "Main", Icon = "rocket", Desc = "DYHUB" })
Tabs.PlayerTab = Window:Tab({ Title = "Player", Icon = "user", Desc = "DYHUB" })
Tabs.Auto = Window:Tab({ Title = "Auto", Icon = "wrench", Desc = "DYHUB" })
Tabs.Farm = Window:Tab({ Title = "Farm", Icon = "badge-dollar-sign", Desc = "DYHUB" })
Tabs.MpDivider = Window:Divider()
Tabs.Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart", Desc = "DYHUB" })
Tabs.Code = Window:Tab({ Title = "Code", Icon = "bird", Desc = "DYHUB" })
Window:SelectTab(1)

-- Player Gui
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local function getStatsText()
    local stats = playerGui:WaitForChild("ToolUI"):WaitForChild("FillingPan"):WaitForChild("FillText")
    return stats.Text
end

local function getStats()
    local text = getStatsText()
    local current, max = text:match("([%d%.]+)/([%d%.]+)")
    current = tonumber(current) or 0
    max = tonumber(max) or 0
    return math.floor(current), max
end

local function getStatsRaw()
    local text = getStatsText()
    local current, max = text:match("([%d%.]+)/([%d%.]+)")
    current = tonumber(current) or 0
    max = tonumber(max) or 0
    return current, max
end

-- Find Pan
local function findPan()
    local character = getCharacter()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:match("Pan$") then
            return tool
        end
    end
    return nil
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shakeRunning = false
local digRunning = false

-- Tab: Main
Tabs.Auto:Section({ Title = "Feature Auto", Icon = "flame" })

-- Tab: Auto
Tabs.Auto:Toggle({
    Title = "Auto Shake",
    Value = false,
    Callback = function(state)
        shakeRunning = state
        if state then
            task.spawn(function()
                while shakeRunning do
                    local rustyPan = findPan()
                    if rustyPan then
                        local shakeScript = rustyPan:FindFirstChild("Scripts"):FindFirstChild("Shake")
                        local panScript = rustyPan:FindFirstChild("Scripts"):FindFirstChild("Pan")
                        if shakeScript and panScript then
                            local current, _ = getStatsRaw()
                            if current > 0 then
                                panScript:InvokeServer() -- เริ่มรอบแรก
                                task.wait(0.5)
                                shakeScript:FireServer() -- shake ครั้งแรก
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Dig",
    Value = false,
    Callback = function(state)
        digRunning = state
        if state then
            task.spawn(function()
                while digRunning do
                    local rustyPan = findPan()
                    if rustyPan then
                        local collectScript = rustyPan:FindFirstChild("Scripts"):FindFirstChild("Collect")
                        local args = {[1] = 99}
                        if collectScript then
                            local current, max = getStats()
                            if current < max then
                                collectScript:InvokeServer(unpack(args))
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})

Tabs.Main:Section({ Title = "Feature Sell", Icon = "badge-dollar-sign" })

Tabs.Main:Button({
    Title = "Sell All (Anywhere)",
    Icon = "shopping-cart",
    Callback = function()
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = character.HumanoidRootPart
        local TweenService = game:GetService("TweenService")

        -- บันทึกตำแหน่งเดิม
        local originalCFrame = hrp.CFrame

        -- CFrame จุดขาย
        local targetCFrame = CFrame.new(
            -36.4754753, 18.7080574, 32.6440926,
            -0.241923511, 3.02572585e-06, -0.97029525,
            1.24988816e-07, 0.99999994, 3.14679664e-06,
            0.97029531, 6.25588257e-07, -0.241923496
        )

        -- Tween เดินไปยังจุดขาย
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
        local goalTo = {CFrame = targetCFrame}
        local tweenTo = TweenService:Create(hrp, tweenInfo, goalTo)
        tweenTo:Play()
        tweenTo.Completed:Wait()

        -- รัน SellAll Remote
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")
        sellRemote:InvokeServer()

        -- Tween เดินกลับตำแหน่งเดิม
        local goalBack = {CFrame = originalCFrame}
        local tweenBack = TweenService:Create(hrp, tweenInfo, goalBack)
        tweenBack:Play()
        tweenBack.Completed:Wait()
    end
})

-- Tween function
local TweenSpeed = 2
local function tweenTo(hrp, targetCF, time)
    local goal = {CFrame = targetCF}
    local tween = TweenService:Create(hrp, TweenInfo.new(time or TweenSpeed, Enum.EasingStyle.Linear), goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Walk legit function
local function walkToTarget(character, targetPos)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    local lastDistance = (hrp.Position - targetPos.Position).Magnitude
    while (hrp.Position - targetPos.Position).Magnitude > 2 do
        humanoid:MoveTo(targetPos.Position)
        task.wait(0.1)
        local distance = (hrp.Position - targetPos.Position).Magnitude
        if math.abs(distance - lastDistance) < 0.05 then
            humanoid.Jump = true
        end
        lastDistance = distance
        if not AutoFarm3Running then break end
    end
end

-- Auto Farm Variables
local AutoFarm3Running = false
local DigInputValue, ShakeInputValue, SellInputValue
local selectedLegitMode = "Tween"

-- Farm Tab
Tabs.Farm:Section({ Title = "Set by you", Icon = "map-pin-plus" })

Tabs.Farm:Input({
    Title = "Tween Speed",
    Placeholder = "Default = 2",
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            TweenSpeed = num
            print("[Tween Speed] set to "..num)
        else
            warn("Invalid Tween Speed, must be a number > 0")
        end
    end,
})

Tabs.Farm:Dropdown({
    Title = "Legit Mode",
    Multi = false,
    Values = {"Walk","Tween"},
    Callback = function(value)
        selectedLegitMode = value
        print("[Legit Mode] Selected:", selectedLegitMode)
    end,
})

Tabs.Farm:Button({
    Title = "Set Dig Position",
    Icon = "pickaxe",
    Callback = function()
        local hrp = getHumanoidRootPart()
        if hrp then
            DigInputValue = hrp.CFrame
            print("[Dig Position] Set to "..tostring(DigInputValue))
        end
    end,
})

Tabs.Farm:Button({
    Title = "Set Shake Position",
    Icon = "handshake",
    Callback = function()
        local hrp = getHumanoidRootPart()
        if hrp then
            ShakeInputValue = hrp.CFrame
            print("[Shake Position] Set to "..tostring(ShakeInputValue))
        end
    end,
})

Tabs.Farm:Button({
    Title = "Set Sell Position",
    Icon = "shopping-cart",
    Callback = function()
        local hrp = getHumanoidRootPart()
        if hrp then
            SellInputValue = hrp.CFrame
            print("[Sell Position] Set to "..tostring(SellInputValue))
        end
    end,
})

-- Auto Farm Toggle
Tabs.Farm:Toggle({
    Title = "Auto Farm: Set By You",
    Value = false,
    Callback = function(state)
        AutoFarm3Running = state
        if state then
            task.spawn(function()
                local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")
                while AutoFarm3Running do
                    -- Hold Pan
                    local character = getCharacter()
                    local humanoid = getHumanoid()
                    local hrp = getHumanoidRootPart()
                    local rustyPan = findPan()
                    if humanoid and rustyPan then
                        humanoid:EquipTool(rustyPan)
                    end

                    local current, max = getStats()
                    local step = (current <= 0 and 1) or (current >= max and 2) or 1

                    -- STEP 1 : Dig
                    if step == 1 and DigInputValue then
                        if selectedLegitMode == "Tween" then
                            tweenTo(hrp, DigInputValue, TweenSpeed)
                        else
                            walkToTarget(character, DigInputValue)
                        end
                        local collectScript = rustyPan and rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Collect")
                        local args = {[1]=99}
                        repeat
                            current, max = getStats()
                            if current >= max then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current >= max
                        step = 2
                    end

                    -- STEP 2 : Shake
                    if step == 2 and ShakeInputValue then
                        if selectedLegitMode == "Tween" then
                            tweenTo(hrp, ShakeInputValue, TweenSpeed)
                        else
                            walkToTarget(character, ShakeInputValue)
                        end
                        local shakeScript = rustyPan and rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Shake")
                        local panScript = rustyPan and rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Pan")
                        if shakeScript and panScript then
                            if current > 0 then
                                panScript:InvokeServer()
                                task.wait(0.5)
                                repeat
                                    current, _ = getStats()
                                    if current <= 0 then break end
                                    panScript:InvokeServer()
                                    task.wait(0.05)
                                    shakeScript:FireServer()
                                    task.wait(0.05)
                                until current <= 0
                            end
                        end
                        step = 3
                    end

                    -- STEP 3 : Sell
                    if step == 3 and SellInputValue then
                        if selectedLegitMode == "Tween" then
                            tweenTo(hrp, SellInputValue, TweenSpeed)
                        else
                            walkToTarget(character, SellInputValue)
                        end
                        task.wait(1)
                        sellRemote:InvokeServer()
                        task.wait(0.5)
                        step = 1
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Tabs.Code:Section({ Title = "Feature Code", Icon = "bird" })

local redeemCodes = {
    "plants",
    "200KLIKES",
    "collection",
    "coolupdate",
    "hundredmillion",
    "traveler",
    "fossilized",
    "millions",
    "updateone"
}

-- เก็บโค้ดที่ผู้เล่นเลือก
local selectedCodes = {}

-- Dropdown เลือกโค้ด
Tabs.Code:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value)
        selectedCodes = value or {}
        print("Selected Codes:", table.concat(selectedCodes, ", "))
    end,
})

-- ฟังก์ชัน redeem โค้ด 1 ตัว
local function redeemCode(code)
    local success, err = pcall(function()
        local claimEvent = ReplicatedStorage:WaitForChild("Remotes")
                                      :WaitForChild("Misc")
                                      :WaitForChild("ClaimCode")
        claimEvent:FireServer(code)
    end)
    if success then
        print("Redeemed:", code)
    else
        warn("Failed to redeem:", code, err)
    end
end

-- ปุ่ม redeem โค้ดที่เลือก
Tabs.Code:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        if #selectedCodes == 0 then
            warn("No code selected!")
            return
        end
        for _, code in ipairs(selectedCodes) do
            redeemCode(code)
            task.wait(0.5) -- เวลารอ server process
        end
    end,
})

-- ปุ่ม redeem โค้ดทั้งหมด
Tabs.Code:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, code in ipairs(redeemCodes) do
            redeemCode(code)
            task.wait(0.5)
        end
    end,
})

Tabs.Shop:Section({ Title = "Feature Buy: Totem", Icon = "heart" })

local autoBuyStrength = false
local autoBuyLuck = false

Tabs.Shop:Toggle({
    Title = "Auto Buy: Strength Totem",
    Value = false,
    Callback = function(state)
        local autoBuyStrength = state
        task.spawn(function()
            while autoBuyStrength do
                local args = {
                    workspace:WaitForChild("Purchasable"):WaitForChild("RiverTown"):WaitForChild("Strength Totem"):WaitForChild("ShopItem"),
                    1
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Shop:Toggle({
    Title = "Auto Buy: Luck Totem",
    Value = false,
    Callback = function(state)
        local autoBuyLuck = state
        task.spawn(function()
            while autoBuyLuck do
                local args = {
                    workspace:WaitForChild("Purchasable"):WaitForChild("RiverTown"):WaitForChild("Luck Totem"):WaitForChild("ShopItem"),
                    1
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Shop:Section({ Title = "Feature Buy: Pan", Icon = "circle" })

-- รายการ Pan พร้อมรายละเอียด
local PanList = {
    {
        Name = "Plastic Pan",
        Price = 500,
        Luck = 1.5,
        Capacity = 10,
        ShakeSTR = 0.4,
        ShakeSPD = "80%",
        Passive = "None",
        Description = "A lightweight pan made from wear-resistant plastic."
    },
    {
        Name = "Metal Pan",
        Price = 12000,
        Luck = 2,
        Capacity = 20,
        ShakeSTR = 0.5,
        ShakeSPD = "80%",
        Passive = "None",
        Description = "A large and heavy metal pan made from sheet metal."
    },
    {
        Name = "Silver Pan",
        Price = 55000,
        Luck = 4,
        Capacity = 30,
        ShakeSTR = 0.8,
        ShakeSPD = "90%",
        Passive = "None",
        Description = "A shining silver pan."
    },
}

-- สร้างข้อความสำหรับ Dropdown แสดงชื่อ + ราคา
local PanNamesDisplay = {}
for _, pan in ipairs(PanList) do
    table.insert(PanNamesDisplay, pan.Name.." ($"..pan.Price..")")
end

local selectedPan = nil

-- Dropdown เลือก Pan
Tabs.Shop:Dropdown({
    Title = "Select Pan",
    Multi = false,
    Values = PanNamesDisplay,
    Callback = function(value)
        local name = value:match("^(.-) %(")
        for _, pan in ipairs(PanList) do
            if pan.Name == name then
                selectedPan = pan
                break
            end
        end
    end,
})

-- ปุ่ม Buy Pan
Tabs.Shop:Button({
    Title = "Buy Selected Pan",
    Callback = function()
        if selectedPan then
            local success, err = pcall(function()
                local item = workspace:WaitForChild("Purchasable")
                                    :WaitForChild("StarterTown")
                                    :WaitForChild(selectedPan.Name)
                                    :WaitForChild("ShopItem")
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("Shop")
                    :WaitForChild("BuyItem")
                    :InvokeServer(item)
            end)
            if success then
                print("Bought: "..selectedPan.Name.." ($"..selectedPan.Price..")")
            else
                warn("Failed to buy "..selectedPan.Name..": "..tostring(err))
            end
        else
            warn("No Pan selected!")
        end
    end,
})


Tabs.Shop:Section({ Title = "Feature Buy: Shovel", Icon = "shovel" })

-- รายการ Shovel พร้อมราคา
local ShovelList = {
    {Name = "Iron Shovel", Price = 3000},
    {Name = "Steel Shovel", Price = 25000},
    {Name = "Silver Shovel", Price = 75000},
    {Name = "Reinforced Shovel", Price = 135000},
}

-- สร้างข้อความสำหรับ Dropdown ให้แสดงชื่อ + ราคา
local ShovelNamesDisplay = {}
for _, shovel in ipairs(ShovelList) do
    table.insert(ShovelNamesDisplay, shovel.Name.." ("..shovel.Price..")")
end

local selectedList = {}

-- Dropdown เลือก Shovel
Tabs.Shop:Dropdown({
    Title = "Select Shovel",
    Multi = false,
    Values = ShovelNamesDisplay, -- แสดงชื่อ + ราคา
    Callback = function(value)
        selectedList = {}
        for _, v in ipairs(value) do
            -- แปลงกลับเป็นชื่อ Shovel ล้วน ๆ สำหรับซื้อ
            local name = v:match("^(.-) %(")
            if name then table.insert(selectedList, name) end
        end
    end,
})

-- ปุ่มซื้อ Shovel ที่เลือก
Tabs.Shop:Button({
    Title = "Buy Selected Shovel",
    Callback = function()
        for _, shovelName in ipairs(selectedList) do
            local success, err = pcall(function()
                -- หา ShopItem ใน Workspace ตามชื่อ Shovel
                local item = workspace:WaitForChild("Purchasable")
                                    :WaitForChild("StarterTown")
                                    :WaitForChild(shovelName)
                                    :WaitForChild("ShopItem")
                -- ซื้อผ่าน Remote
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("Shop")
                    :WaitForChild("BuyItem")
                    :InvokeServer(item)
                task.wait(0.2)
            end)
            if success then
                print("Bought: "..shovelName)
            else
                warn("Failed to buy "..shovelName..": "..tostring(err))
            end
        end
    end,
})

Tabs.PlayerTab:Section({ Title = "Feature Player", Icon = "user" })

-- Player Tab Vars
getgenv().speedEnabled = false
getgenv().speedValue = 20

Tabs.PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = {Min = 16, Max = 50, Default = 20},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

Tabs.PlayerTab:Toggle({
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

Tabs.PlayerTab:Slider({
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

Tabs.PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end
})

Tabs.PlayerTab:Section({ Title = "Feature Visual", Icon = "flame" })

local noclipConnection

Tabs.PlayerTab:Toggle({
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

Tabs.PlayerTab:Toggle({
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

Tabs.PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})

Info = Tabs.Info

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

-- Define the Request function that mimics ui.Creator.Request
ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
    -- Try different HTTP methods
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            -- Method 1: Use RequestAsync if available
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            -- Method 2: Fallback to GetAsync
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)
    
    if success then
        return result
    else
        error("HTTP Request failed: " .. tostring(result))
    end
end

-- Remove this line completely: Info = InfoTab
-- The Info variable is already correctly set above

local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Info:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    
                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
        print("Discord API Error:", result) -- Debug print
    end
end

LoadDiscordInfo()

Info:Divider()
Info:Section({ 
    Title = "DYHUB Information",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

local Owner = Info:Paragraph({
    Title = "Main Owner",
    Desc = "@dyumraisgoodguy#8888",
    Image = "rbxassetid://119789418015420",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
})

local Social = Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://guns.lol/DYHUB")
                print("Copied social media link to clipboard!")
            end,
        }
    }
})

local Discord = Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/jWNDPNMmyB")
                print("Copied discord link to clipboard!")
            end,
        }
    }
})
