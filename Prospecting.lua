repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Player references
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")


-- โหลด WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Prospecting",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

-- สร้าง Window
local Window = WindUI:CreateWindow({
    Folder = "DYHUB Config | Prospecting",
    Author = "DYHUB",
    Title = "DYHUB - Prospecting (Version: 3.61)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    ScrollBarEnabled = true,
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
local Tabs = {}
Tabs.Main = Window:Tab({ Title = "Main", Icon = "rocket", Desc = "DYHUB" })
Tabs.PlayerTab = Window:Tab({ Title = "Player", Icon = "user", Desc = "DYHUB" })
Tabs.Auto = Window:Tab({ Title = "Auto", Icon = "wrench", Desc = "DYHUB" })
Tabs.Farm = Window:Tab({ Title = "Farm", Icon = "badge-dollar-sign", Desc = "DYHUB" })
Tabs.Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart", Desc = "DYHUB" })
Tabs.Code = Window:Tab({ Title = "Code", Icon = "bird", Desc = "DYHUB" })

Window:SelectTab(1)

-- ฟังก์ชันช่วยเหลือ
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ฟังก์ชันหา Pan
local function findPan()
    local character = player.Character
    if not character then return nil end
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:match("Pan$") then
            return tool
        end
    end
    return nil
end

-- Stats
local stats = playerGui:WaitForChild("ToolUI"):WaitForChild("FillingPan"):WaitForChild("FillText")
local function getStats() -- สำหรับ Auto Dig
    local text = stats.Text
    local current, max = text:match("([%d%.]+)/([%d%.]+)")
    current = tonumber(current) or 0
    max = tonumber(max) or 0
    return math.floor(current), max
end
local function getStatsRaw() -- สำหรับ Auto Shake
    local text = stats.Text
    local current, max = text:match("([%d%.]+)/([%d%.]+)")
    current = tonumber(current) or 0
    max = tonumber(max) or 0
    return current, max
end

-- ตัวแปร loop
local shakeRunning = false
local digRunning = false

-- Tab: Main
Tabs.Auto:Section({ Title = "Please Turn-On All", Icon = "triangle-alert" })
Tabs.Auto:Section({ Title = "Before used to Auto Farm", Icon = "triangle-alert" })
Tabs.Auto:Section({ Title = "Feature Auto", Icon = "repeat" })

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

Tabs.Main:Button({
    Title = "Sell All (Near NPC)",
    Icon = "shopping-cart",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")
        sellRemote:InvokeServer()
    end
})


Tabs.Farm:Section({ Title = "Warning: Use this feature on private servers", Icon = "triangle-alert" })
Tabs.Farm:Section({ Title = "Island (1)", Icon = "earth" })
Tabs.Farm:Section({ Title = "Rubble Creek Sands", Icon = "locate" })

local FarmToggleRunning = false

Tabs.Farm:Toggle({
    Title = "Auto Farm: Sands",
    Value = false,
    Callback = function(state)
        FarmToggleRunning = state
        if state then
            task.spawn(function()
                local TweenService = game:GetService("TweenService")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")

                local function findPan()
                    local character = player.Character
                    if not character then return nil end
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:match("Pan$") then
                            return tool
                        end
                    end
                    return nil
                end

                local stats = playerGui:WaitForChild("ToolUI"):WaitForChild("FillingPan"):WaitForChild("FillText")
                local function getStats()
                    local text = stats.Text
                    local current, max = text:match("([%d%.]+)/([%d%.]+)")
                    current = tonumber(current) or 0
                    max = tonumber(max) or 0
                    return current, max
                end

                local farmPoint1 = CFrame.new(-64.6619263, 10.9495306, 26.7822113, 0.156690493, -2.93944777e-06, 0.987647712, -5.75828496e-10, 0.99999994, 3.03590673e-06, -0.987647772, -4.66926934e-07, 0.156690478)
                local farmPoint2 = CFrame.new(-92.9891281, 8.99459934, 28.8235168, 0.447938859, -6.23808864e-06, 0.894064188, 1.53285237e-06, 1, 6.09003746e-06, -0.894064188, -1.41089401e-06, 0.447938859)
                local sellPoint = CFrame.new(-36.4754753, 18.7080574, 32.6440926, -0.241923511, 3.02572585e-06, -0.97029525, 1.24988816e-07, 0.99999994, 3.14679664e-06, 0.97029531, 6.25588257e-07, -0.241923496)

                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = character.HumanoidRootPart
                local rustyPan = findPan()
                if not rustyPan then return end
                local collectScript = rustyPan:FindFirstChild("Scripts"):FindFirstChild("Collect")
                local args = {[1]=99}

                -- เช็ค Step เริ่มต้นตาม FillText
                local current, max = getStats()
                local step
                if current <= 0 then
                    step = 1 -- เริ่ม Step 1
                elseif current >= max then
                    step = 2 -- เริ่ม Step 2
                else
                    step = 1 -- กรณีไม่เต็ม ไม่ว่าง ให้เริ่ม Step 1
                end

                while FarmToggleRunning do
                    if step == 1 then
                        -- STEP 1: Farm Point 1
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=farmPoint1}):Play()
                        task.wait(1.6)
                        repeat
                            current, max = getStats()
                            if current >= max then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current >= max
                        step = 2
                    end

                    if step == 2 then
                        -- STEP 2: Farm Point 2
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=farmPoint2}):Play()
                        task.wait(1.6)
                        repeat
                            current, max = getStats()
                            if current <= 0 then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current <= 0
                        step = 3
                    end

                    if step == 3 then
                        -- STEP 3: Sell Point
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=sellPoint}):Play()
                        task.wait(1.6)
                        sellRemote:InvokeServer()
                        step = 1 -- เริ่ม loop ใหม่จาก Step 1
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

Tabs.Farm:Section({ Title = "Rubble Creek Deposit", Icon = "locate" })

local AutoFarm2Running = false

Tabs.Farm:Toggle({
    Title = "Auto Farm: Deposit",
    Value = false,
    Callback = function(state)
        AutoFarm2Running = state
        if state then
            task.spawn(function()
                local TweenService = game:GetService("TweenService")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")

                local function findPan()
                    local character = player.Character
                    if not character then return nil end
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:match("Pan$") then
                            return tool
                        end
                    end
                    return nil
                end

                local stats = playerGui:WaitForChild("ToolUI"):WaitForChild("FillingPan"):WaitForChild("FillText")
                local function getStats()
                    local text = stats.Text
                    local current, max = text:match("([%d%.]+)/([%d%.]+)")
                    current = tonumber(current) or 0
                    max = tonumber(max) or 0
                    return current, max
                end

                -- Farm Points (เปลี่ยนเฉพาะ Farm Point 1)
                local farmPoint1 = CFrame.new(-125.866165, 12.1797943, 27.3370609, -0.08893352, 0.00163053721, -0.996036291, -6.08532137e-05, 0.999998689, 0.00164240401, 0.996037543, 0.000206681507, -0.088933304)
                local farmPoint2 = CFrame.new(-92.9891281, 8.99459934, 28.8235168, 0.447938859, -6.23808864e-06, 0.894064188, 1.53285237e-06, 1, 6.09003746e-06, -0.894064188, -1.41089401e-06, 0.447938859)
                local sellPoint = CFrame.new(-36.4754753, 18.7080574, 32.6440926, -0.241923511, 3.02572585e-06, -0.97029525, 1.24988816e-07, 0.99999994, 3.14679664e-06, 0.97029531, 6.25588257e-07, -0.241923496)

                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = character.HumanoidRootPart
                local rustyPan = findPan()
                if not rustyPan then return end
                local collectScript = rustyPan:FindFirstChild("Scripts"):FindFirstChild("Collect")
                local args = {[1]=99}

                -- เช็ค Step เริ่มต้นตาม FillText
                local current, max = getStats()
                local step
                if current <= 0 then
                    step = 1
                elseif current >= max then
                    step = 2
                else
                    step = 1
                end

                while AutoFarm2Running do
                    if step == 1 then
                        -- STEP 1: Farm Point 1
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=farmPoint1}):Play()
                        task.wait(1.6)
                        repeat
                            current, max = getStats()
                            if current >= max then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current >= max
                        step = 2
                    end

                    if step == 2 then
                        -- STEP 2: Farm Point 2
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=farmPoint2}):Play()
                        task.wait(1.6)
                        repeat
                            current, max = getStats()
                            if current <= 0 then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current <= 0
                        step = 3
                    end

                    if step == 3 then
                        -- STEP 3: Sell Point
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=sellPoint}):Play()
                        task.wait(1.6)
                        sellRemote:InvokeServer()
                        step = 1
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

Tabs.Farm:Section({ Title = "Set by you", Icon = "map-pin-plus" })

local AutoFarm3Running = false
local DigInputValue, ShakeInputValue, SellInputValue
local TweenSpeed = 2 -- default

-- Copy Position (ปัดเศษเป็นจำนวนเต็ม)
Tabs.Farm:Button({
    Title = "Copy Position",
    Icon = "atom",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            local cfString = string.format("%d,%d,%d", math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))
            setclipboard(cfString)
            print("[Copied] "..cfString)
        else
            warn("HumanoidRootPart not found!")
        end
    end,
})

-- Input Dig
Tabs.Farm:Input({
    Title = "Dig Position",
    Placeholder = "Put your CFrame here",
    Callback = function(text)
        DigInputValue = text
    end,
})

-- Input Shake
Tabs.Farm:Input({
    Title = "Shake Position",
    Placeholder = "Put your CFrame here",
    Callback = function(text)
        ShakeInputValue = text
    end,
})

-- Input Sell
Tabs.Farm:Input({
    Title = "Sell Position",
    Placeholder = "Put your CFrame here",
    Callback = function(text)
        SellInputValue = text
    end,
})

-- Input Tween Speed
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

-- ✅ parseCFrame รองรับ x,y,z / x,y,z,rx,ry,rz / x,y,z,r00,...,r22
local function parseCFrame(str)
    if not str or str == "" then return nil end
    str = str:gsub("%s+", "")
    local parts = {}
    for num in str:gmatch("[%-%.%d]+") do
        table.insert(parts, tonumber(num))
    end

    if #parts == 3 then
        return CFrame.new(parts[1], parts[2], parts[3])
    elseif #parts == 6 then
        return CFrame.new(parts[1], parts[2], parts[3], parts[4], parts[5], parts[6])
    elseif #parts == 12 then
        return CFrame.new(parts[1], parts[2], parts[3],
                         parts[4], parts[5], parts[6],
                         parts[7], parts[8], parts[9],
                         parts[10], parts[11], parts[12])
    else
        warn("[parseCFrame] Invalid format! Use 'x,y,z' or 'x,y,z,rx,ry,rz' or 'x,y,z,r00,...,r22'")
        return nil
    end
end

-- ฟังก์ชัน Tween Smooth
local TweenService = game:GetService("TweenService")
local function tweenTo(hrp, targetCF, time)
    local goal = {CFrame = targetCF}
    local tween = TweenService:Create(hrp, TweenInfo.new(time or TweenSpeed, Enum.EasingStyle.Linear), goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Auto Farm Toggle
Tabs.Farm:Toggle({
    Title = "Auto Farm: Set By You",
    Value = false,
    Callback = function(state)
        AutoFarm3Running = state
        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local sellRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("SellAll")

                local function findPan()
                    local character = player.Character
                    if not character then return nil end
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:match("Pan$") then
                            return tool
                        end
                    end
                    return nil
                end

                local stats = playerGui:WaitForChild("ToolUI"):WaitForChild("FillingPan"):WaitForChild("FillText")
                local function getStats()
                    local text = stats.Text
                    local current, max = text:match("([%d%.]+)/([%d%.]+)")
                    current = tonumber(current) or 0
                    max = tonumber(max) or 0
                    return current, max
                end

                while AutoFarm3Running do
                    local DigPoint1 = parseCFrame(DigInputValue)
                    local ShakePoint2 = parseCFrame(ShakeInputValue)
                    local sellPoint = parseCFrame(SellInputValue)

                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then break end
                    local hrp = character.HumanoidRootPart
                    local rustyPan = findPan()
                    if not rustyPan then break end
                    local collectScript = rustyPan:FindFirstChild("Scripts") and rustyPan.Scripts:FindFirstChild("Collect")
                    local args = {[1]=99}

                    local current, max = getStats()
                    local step
                    if current <= 0 then
                        step = 1
                    elseif current >= max then
                        step = 2
                    else
                        step = 1
                    end

                    -- STEP 1 : Dig
                    if step == 1 and DigPoint1 then
                        tweenTo(hrp, DigPoint1, TweenSpeed)
                        repeat
                            current, max = getStats()
                            if current >= max then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current >= max
                        step = 2
                    end

                    -- STEP 2 : Shake
                    if step == 2 and ShakePoint2 then
                        tweenTo(hrp, ShakePoint2, TweenSpeed)
                        repeat
                            current, max = getStats()
                            if current <= 0 then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current <= 0
                        step = 3
                    end

                    -- STEP 3 : Sell
                    if step == 3 and sellPoint then
                        tweenTo(hrp, sellPoint, TweenSpeed)
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

-- ประกาศ Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- สร้าง Section ใน GUI
Tabs.Code:Section({ Title = "Feature Code", Icon = "bird" })

-- รายการโค้ดที่สามารถ redeem
local redeemCodes = {
    "traveler",
    "fossilized",
    "sorrytwo",
    "millions",
    "updateone",
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
