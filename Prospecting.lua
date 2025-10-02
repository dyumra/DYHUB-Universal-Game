-- =========================
local version = "3.9.6"
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

-- Character functions
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

-- Player GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local function getStatsText()
    return playerGui:WaitForChild("ToolUI"):WaitForChild("FillingPan"):WaitForChild("FillText").Text
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

-- Find Pan (Character + BackpackTwo)
local function findPanAll()
    local character = getCharacter()
    local backpack = LocalPlayer:FindFirstChild("BackpackTwo")
    
    -- ตรวจสอบใน Character ก่อน
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:match("Pan$") then
            return tool
        end
    end

    -- ตรวจสอบใน BackpackTwo
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:match("Pan$") then
                return tool
            end
        end
    end

    return nil
end

-- WindUI
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local FreeVersion = "Free Version"
local PremiumVersion = "Premium Version"

local function checkVersion(playerName)
    local url = "https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua"

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        return FreeVersion
    end

    local premiumData
    local func, err = loadstring(response)
    if func then
        premiumData = func()
    else
        return FreeVersion
    end

    if premiumData[playerName] then
        return PremiumVersion
    else
        return FreeVersion
    end
end

local player = Players.LocalPlayer
local userversion = checkVersion(player.Name)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Prospecting | " .. userversion,
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
pcall(function() Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") }) end)
Window:EditOpenButton({ Title = "DYHUB - Open", Icon = "monitor", CornerRadius = UDim.new(0,6), StrokeThickness = 2, Color = ColorSequence.new(Color3.fromRGB(30,30,30), Color3.fromRGB(255,255,255)), Draggable = true })

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

-- Variables
local shakeRunning, digRunning, AutoFarm3Running, autoEquipRunning = false, false, false, false
local DigInputValue, ShakeInputValue, SellInputValue
local TweenSpeed = 2
local selectedLegitMode = "Tween"

-- Helper Tween function
local function tweenTo(hrp, targetCF, time)
    local tween = TweenService:Create(hrp, TweenInfo.new(time or TweenSpeed, Enum.EasingStyle.Linear), {CFrame=targetCF})
    tween:Play()
    tween.Completed:Wait()
end

-- Helper Walk Legit function with jump
local function walkToTarget(character, targetPos)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    local lastDistance = (hrp.Position - targetPos.Position).Magnitude
    while (hrp.Position - targetPos.Position).Magnitude > 2 do
        humanoid:MoveTo(targetPos.Position)
        task.wait(0.1)
        local distance = (hrp.Position - targetPos.Position).Magnitude
        if math.abs(distance - lastDistance) < 0.05 then humanoid.Jump = true end
        lastDistance = distance
        if not AutoFarm3Running then break end
    end
end

-- Auto Tab Toggles
Tabs.Auto:Section({ Title = "Feature Auto", Icon = "flame" })

-- Auto Shake
Tabs.Auto:Toggle({
    Title = "Auto Shake",
    Value = false,
    Callback = function(state)
        shakeRunning = state
        if state then
            task.spawn(function()
                while shakeRunning do
                    local rustyPan = findPanAll()
                    if rustyPan then
                        local shakeScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Shake")
                        local panScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Pan")
                        local current,_ = getStatsRaw()
                        if shakeScript and panScript and current>0 then
                            panScript:InvokeServer()
                            task.wait(0.5)
                            repeat
                                current,_=getStatsRaw()
                                if current<=0 then break end
                                panScript:InvokeServer()
                                shakeScript:FireServer()
                                task.wait(0.05)
                            until current<=0
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- Auto Dig
Tabs.Auto:Toggle({
    Title = "Auto Dig",
    Value = false,
    Callback = function(state)
        digRunning = state
        if state then
            task.spawn(function()
                while digRunning do
                    local rustyPan = findPanAll()
                    if rustyPan then
                        local collectScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Collect")
                        local args = {[1]=99}
                        local current,max = getStats()
                        if collectScript and current<max then collectScript:InvokeServer(unpack(args)) end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- Auto Equip Pan
Tabs.Auto:Toggle({
    Title = "Auto Equip Pan",
    Value = false,
    Callback = function(state)
        autoEquipRunning = state
        if state then
            task.spawn(function()
                while autoEquipRunning do
                    local player = game:GetService("Players").LocalPlayer
                    local backpackTwo = player:WaitForChild("BackpackTwo")
                    
                    local panTool
                    for _, tool in ipairs(backpackTwo:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:find("Pan") then
                            panTool = tool
                            break
                        end
                    end
                    
                    if panTool then
                        local args = { panTool }
                        local equipRemote = game:GetService("ReplicatedStorage")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("CustomBackpack")
                                            :WaitForChild("EquipRemote")
                        equipRemote:FireServer(unpack(args))
                    end

                    task.wait(1.5)
                end
            end)
        end
    end
})

-- Main Sell
Tabs.Main:Section({ Title = "Feature Sell", Icon = "badge-dollar-sign" })
local localSellRunning = false

Tabs.Main:Toggle({
    Title = "Sell Sell (Near NPC)",
    Value = false,
    Callback = function(state)
        localSellRunning = state
        if state then
            task.spawn(function()
                local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")
                while localSellRunning do
                    pcall(function()
                        sellRemote:InvokeServer()
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Main:Button({
    Title = "Sell All (Anywhere)",
    Icon = "shopping-cart",
    Callback = function()
        local character = getCharacter()
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local originalCFrame = hrp.CFrame
        local targetCFrame = CFrame.new(-36.475,18.708,32.644)
        tweenTo(hrp, targetCFrame, 2)

        local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")
        sellRemote:InvokeServer()
        task.wait(0.5)

        tweenTo(hrp, originalCFrame, 2)
    end
})

-- Farm Tab
Tabs.Farm:Section({ Title = "Warning: Use this feature on private servers", Icon = "triangle-alert" })
Tabs.Farm:Section({ Title = "Set by you", Icon = "map-pin-plus" })

Tabs.Farm:Input({
    Title = "Tween Speed",
    Placeholder = "Default = 2",
    Callback = function(text)
        local num = tonumber(text)
        if num and num>0 then TweenSpeed=num print("[Tween Speed] set to "..num) else warn("Invalid Tween Speed") end
    end
})

-- Legit Mode Dropdown
Tabs.Farm:Dropdown({
    Title = "Legit Mode",
    Multi = false,
    Values = {"Walk","Tween"},
    Callback = function(value)
        selectedLegitMode = value or "Tween"
        print("[Legit Mode] Selected:", selectedLegitMode)
    end
})

-- Set Positions
Tabs.Farm:Button({Title="Set Dig Position",Icon="pickaxe",Callback=function()
    local hrp = getHumanoidRootPart()
    if hrp then DigInputValue=hrp.CFrame print("[Dig Position] Set to "..tostring(DigInputValue)) end
end})

Tabs.Farm:Button({Title="Set Shake Position",Icon="handshake",Callback=function()
    local hrp = getHumanoidRootPart()
    if hrp then ShakeInputValue=hrp.CFrame print("[Shake Position] Set to "..tostring(ShakeInputValue)) end
end})

Tabs.Farm:Button({Title="Set Sell Position",Icon="shopping-cart",Callback=function()
    local hrp = getHumanoidRootPart()
    if hrp then SellInputValue=hrp.CFrame print("[Sell Position] Set to "..tostring(SellInputValue)) end
end})

-- Auto Farm: Set By You Toggle
Tabs.Farm:Toggle({
    Title = "Auto Farm: Set By You",
    Value = false,
    Callback = function(state)
        AutoFarm3Running = state
        if state then
            task.spawn(function()
                local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")
                local equipRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CustomBackpack"):WaitForChild("EquipRemote")

                while AutoFarm3Running do
                    local player = game:GetService("Players").LocalPlayer
                    local backpackTwo = player:WaitForChild("BackpackTwo")
                    local rustyPan = findPanAll()
                    
                    local panTool
                    for _, tool in ipairs(backpackTwo:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:find("Pan") then
                            panTool = tool
                            break
                        end
                    end
                    
                    if panTool then
                        local args = { panTool }
                        equipRemote:FireServer(unpack(args))
                    end

                    local current,max = getStats()
                    local step = current<=0 and 1 or max<=current and 2 or 1

                    if step==1 and DigInputValue then
                        if selectedLegitMode=="Tween" then
                            tweenTo(getHumanoidRootPart(), DigInputValue, TweenSpeed)
                        else
                            walkToTarget(getCharacter(), DigInputValue)
                        end
                        repeat
                            current,max = getStats()
                            local collectScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Collect")
                            if collectScript then collectScript:InvokeServer(99) end
                            task.wait(0.05)
                        until current>=max
                        step = 2
                    end

                    if step==2 and ShakeInputValue then
                        if selectedLegitMode=="Tween" then
                            tweenTo(getHumanoidRootPart(), ShakeInputValue, TweenSpeed)
                        else
                            walkToTarget(getCharacter(), ShakeInputValue)
                        end
                        local shakeScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Shake")
                        local panScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Pan")
                        if shakeScript and panScript then
                            current,_=getStatsRaw()
                            if current>0 then
                                panScript:InvokeServer()
                                task.wait(0.5)
                                repeat
                                    current,_=getStatsRaw()
                                    if current<=0 then break end
                                    panScript:InvokeServer()
                                    shakeScript:FireServer()
                                    task.wait(0.05)
                                until current<=0
                            end
                        end
                        step = 3
                    end

                    if step==3 and SellInputValue then
                        if selectedLegitMode=="Tween" then
                            tweenTo(getHumanoidRootPart(), SellInputValue, TweenSpeed)
                        else
                            walkToTarget(getCharacter(), SellInputValue)
                        end
                        task.wait(1.5)
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
