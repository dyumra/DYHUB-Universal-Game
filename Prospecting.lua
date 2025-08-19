repeat task.wait() until game:IsLoaded()

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
    Title = "DYHUB - Prospecting (Version: 2.6.7)",
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
Tabs.Auto = Window:Tab({ Title = "Auto", Icon = "wrench", Desc = "DYHUB" })
Tabs.Farm = Window:Tab({ Title = "Farm", Icon = "badge-dollar-sign", Desc = "DYHUB" })

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
Tabs.Auto:Section({ Title = "⚠️ Please Turn-On All", Icon = "badge-dollar-sign" })
Tabs.Auto:Section({ Title = "⚠️ Before used to Auto Farm", Icon = "badge-dollar-sign" })
Tabs.Auto:Section({ Title = "Feature Auto", Icon = "badge-dollar-sign" })

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
    Title = "Sell All",
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

Tabs.Farm:Section({ Title = "⚠️ Warning: Use this feature on private servers", Icon = "badge-dollar-sign" })
Tabs.Farm:Section({ Title = "🌏 Island (1)", Icon = "badge-dollar-sign" })
Tabs.Farm:Section({ Title = "Rubble Creek Sands", Icon = "badge-dollar-sign" })

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

Tabs.Farm:Section({ Title = "Rubble Creek Deposit", Icon = "badge-dollar-sign" })

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

Tabs.Farm:Section({ Title = "Set by you", Icon = "badge-dollar-sign" })

local AutoFarm3Running = false
local DigInputValue, ShakeInputValue, SellInputValue

-- Copy Position Button
Tabs.Farm:Button({
    Title = "Copy Position",
    Icon = "atom",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cfString = string.format("CFrame.new(%s)", tostring(hrp.CFrame))
            setclipboard(cfString) -- คัดลอกไป Clipboard
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

-- Toggle Auto Farm
Tabs.Farm:Toggle({
    Title = "Auto Farm: Set By You",
    Value = false,
    Callback = function(state)
        AutoFarm3Running = state
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

                -- Convert Input to CFrame
                local function parseCFrame(str)
                    local success, result = pcall(function()
                        return loadstring("return "..str)()
                    end)
                    if success and typeof(result) == "CFrame" then
                        return result
                    end
                    return nil
                end

                while AutoFarm2Running do
                    local DigPoint1 = parseCFrame(DigInputValue)
                    local ShakePoint2 = parseCFrame(ShakeInputValue)
                    local sellPoint = parseCFrame(SellInputValue)

                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    local hrp = character.HumanoidRootPart
                    local rustyPan = findPan()
                    if not rustyPan then return end
                    local collectScript = rustyPan:FindFirstChild("Scripts"):FindFirstChild("Collect")
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

                    -- STEP 1
                    if step == 1 and DigPoint1 then
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=DigPoint1}):Play()
                        task.wait(1.6)
                        repeat
                            current, max = getStats()
                            if current >= max then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current >= max
                        step = 2
                    end

                    -- STEP 2
                    if step == 2 and ShakePoint2 then
                        TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame=ShakePoint2}):Play()
                        task.wait(1.6)
                        repeat
                            current, max = getStats()
                            if current <= 0 then break end
                            if collectScript then collectScript:InvokeServer(unpack(args)) end
                            task.wait(0.05)
                        until current <= 0
                        step = 3
                    end

                    -- STEP 3
                    if step == 3 and sellPoint then
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

