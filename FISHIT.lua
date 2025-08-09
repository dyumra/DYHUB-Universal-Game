local function safeRequireRemote(path)
    -- path: table path from ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Packages = ReplicatedStorage:WaitForChild("Packages")
    local Index = Packages:WaitForChild("_Index")
    local sleitnet = Index:WaitForChild("sleitnick_net@0.2.0")
    local net = sleitnet:WaitForChild("net")
    return net:FindFirstChild(path) or error("Remote not found: ".. tostring(path))
end

local function fire(remote, ...)
    if remote and remote.FireServer then
        return remote:FireServer(...)
    end
    -- if it's an RF (RemoteFunction) use InvokeServer
    if remote and remote.InvokeServer then
        return remote:InvokeServer(...)
    end
end

local function invoke(remote, ...)
    if remote and remote.InvokeServer then
        return remote:InvokeServer(...)
    end
    if remote and remote.FireServer then
        return remote:FireServer(...)
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ///////////////////
-- // Library / UI  //
-- ///////////////////

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Library-DYHUB/refs/heads/main/DYHUB02-LIB"))()

local mainWindow = Library:CreateMain({
    ToggleUI = "M",
    Name = "DYHUB | Fish It!",
    WindowIcon = "star",
    Theme = {
        Surface = Color3.fromRGB(40, 35, 38),         -- ดำอมแดงเข้ม
        AccentSecondary = Color3.fromRGB(220, 80, 90), -- แดงสดอมชมพู
        Shadow = Color3.fromRGB(15, 5, 10),           -- เงาดำลึก
        Text = Color3.fromRGB(230, 200, 200),         -- ขาวอมชมพู
        Border = Color3.fromRGB(70, 20, 25),          -- ขอบแดงเข้ม
        Accent = Color3.fromRGB(190, 50, 60),         -- แดงเข้มมน
        Warning = Color3.fromRGB(255, 100, 90),       -- แดงอมส้ม
        TextSecondary = Color3.fromRGB(150, 100, 105),-- ตัวหนังสือรองชมพูเข้ม
        Success = Color3.fromRGB(180, 80, 90),        -- แดงหม่น
        SurfaceVariant = Color3.fromRGB(45, 38, 42),  -- พื้นผิวแดงดำ
        NavBackground = Color3.fromRGB(30, 25, 28),   -- แถบนำทางดำอมแดง
        Background = Color3.fromRGB(20, 15, 18),      -- พื้นหลังดำเข้มอมแดง
        Error = Color3.fromRGB(255, 70, 70),          -- แดงแจ่ม
        Secondary = Color3.fromRGB(35, 28, 32)        -- สีรองแดงดำ
    },
    title = "DYHUB | Fish It!"
})

-- Tabs
local farmingTab = Library:CreateTab("Farming", "fish")
local buyTab = Library:CreateTab("Shop", "shopping-cart")
local playerTab = Library:CreateTab("Player", "user")
local modifiersTab = Library:CreateTab("Modifiers", "sparkles")
local extrasTab = Library:CreateTab("Extras", "star")

Library:CreateSection({ parent = farmingTab, text = "Farming Controls" })
Library:CreateSection({ parent = buyTab, text = "Buy Items" })
Library:CreateSection({ parent = playerTab, text = "Player & Feature" })
Library:CreateSection({ parent = modifiersTab, text = "Modifiers & Enchants" })
Library:CreateSection({ parent = extrasTab, text = "Misc" })

-- //////////////////////
-- // Fishing Remotes   //
-- //////////////////////

local netRoot = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RF_ChargeFishingRod = netRoot:WaitForChild("RF/ChargeFishingRod")
local RF_RequestFishingMinigameStarted = netRoot:WaitForChild("RF/RequestFishingMinigameStarted")
local RE_FishingCompleted = netRoot:WaitForChild("RE/FishingCompleted")
local RE_EquipToolFromHotbar = netRoot:WaitForChild("RE/EquipToolFromHotbar")
local RE_UnequipToolFromHotbar = netRoot:WaitForChild("RE/UnequipToolFromHotbar")
-- other remotes used later dynamically (RF/PurchaseBait, RF/PurchaseFishingRod, RF/SellAllItems, RF/SpawnBoat etc.)

-- Safe wrappers with notifications
local function notifySuccess(title, message)
    Library:CreateNotify({ title = title or "Success", description = message or "" })
end
local function notifyWarn(title, message)
    Library:CreateNotify({ type = "Warning", title = title or "Notice", description = message or "" })
end
local function notifyError(title, message)
    Library:CreateNotify({ type = "Error", title = title or "Error", description = message or "" })
end

-- //////////////////////
-- // Farming Features  //
-- //////////////////////

local autoFishFlag = false
local autoFishThread = nil

local function startAutoFish()
    if autoFishFlag then return end
    autoFishFlag = true
    autoFishThread = task.spawn(function()
        while autoFishFlag do
            -- equip first slot (1)
            pcall(function() RE_EquipToolFromHotbar:FireServer(1) end)
            task.wait(0.2)

            -- charge rod (large number used in original)
            pcall(function() RF_ChargeFishingRod:InvokeServer(9999999999) end)
            task.wait(0.2)

            -- start minigame (original used coordinates -1.238, 0.969)
            pcall(function() RF_RequestFishingMinigameStarted:InvokeServer(-1.238, 0.969) end)
            task.wait(0.5)

            -- complete fishing
            pcall(function() RE_FishingCompleted:FireServer() end)
            task.wait(0.1)
            -- loop quickly; tweak waits above to match server timing
        end
    end)
end

local function stopAutoFish()
    autoFishFlag = false
    autoFishThread = nil
end

Library:CreateToggle({
    default = false,
    parent = farmingTab,
    text = "Auto Fish",
    callback = function(state)
        if state then
            startAutoFish()
            notifySuccess("Auto Fish", "Started.")
        else
            stopAutoFish()
            notifyWarn("Auto Fish", "Stopped.")
        end
    end,
    flag = "AutoFishToggle"
})

Library:CreateButton({
    parent = farmingTab,
    text = "Reset Fish (Unequip)",
    callback = function()
        -- call unequip twice like original did redundantly
        local ok, err = pcall(function()
            RE_UnequipToolFromHotbar:FireServer()
            task.wait(0.1)
            RE_UnequipToolFromHotbar:FireServer()
        end)
        if ok then
            notifySuccess("Reset Fish", "Fish reset (unequipped).")
        else
            notifyError("Reset Fish", "Failed: ".. tostring(err))
        end
    end,
    flag = "ResetFishBtn"
})

Library:CreateButton({
    parent = farmingTab,
    text = "Sell All Fishes Anywhere",
    callback = function()
        -- the original teleported player to a sell CFrame and invoked RF/SellAllItems
        notifyWarn("Selling", "Selling all fishes, please wait.")
        local char = LocalPlayer.Character
        if not char then
            notifyError("Sell All", "No character found.")
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            notifyError("Sell All", "No HumanoidRootPart.")
            return
        end

        -- Save original and teleport to sell position (from original: Vector3(-32,5,2885) etc.)
        local originalCFrame = hrp.CFrame
        local sellPos = CFrame.new(Vector3.new(-32, 5, 2885) + Vector3.new(0,3,0))
        hrp.CFrame = sellPos
        task.wait(0.5)

        -- invoke sell remote
        local sellRemote = netRoot:WaitForChild("RF/SellAllItems")
        pcall(function() sellRemote:InvokeServer() end)

        notifySuccess("Sell All", "All fishes sold.")
        task.wait(1)
        -- return player
        hrp.CFrame = originalCFrame
    end,
    flag = "SellAllBtn"
})

-- //////////////////////
-- // Buy Baits & Rods  //
-- //////////////////////

-- Tables derived from original file (IDs from original calls)
local baitList = {
    -- [label] = id (matches RF/PurchaseBait:InvokeServer(id) in original)
    ["Topwater Bait (100)"] = 10,
    ["Luck Bait (1K)"] = 2,
    ["Midnight Bait (3K)"] = 3,
    ["Chroma Bait (290K)"] = 6,
    ["Dark Mater Bait (630K)"] = 8,
    ["Corrupt Bait (1.15M)"] = 15,
}

local rodList = {
    -- label = id (RF/PurchaseFishingRod)
    ["Lucky Rod (15K)"] = 4,
    ["Midnight Rod (50K)"] = 80,
    ["Steampunk Rod (215K)"] = 6,
    ["Chrome Rod (437K)"] = 7,
    ["Astral Rod (1M)"] = 5,
    -- more from original can be appended similarly
}

local function purchaseBait(id)
    local remote = netRoot:WaitForChild("RF/PurchaseBait")
    local ok, err = pcall(function() remote:InvokeServer(id) end)
    if ok then
        notifySuccess("Purchase Attempted", "Tried to buy bait id: ".. tostring(id))
    else
        notifyError("Purchase Error", tostring(err))
    end
end

local function purchaseRod(id)
    local remote = netRoot:WaitForChild("RF/PurchaseFishingRod")
    local ok, err = pcall(function() remote:InvokeServer(id) end)
    if ok then
        notifySuccess("Purchase Attempted", "Tried to buy rod id: ".. tostring(id))
    else
        notifyError("Purchase Error", tostring(err))
    end
end

-- create buy buttons programmatically (keeps script short & readable)
local baitSectionParent = buyTab
for label, id in pairs(baitList) do
    Library:CreateButton({
        parent = baitSectionParent,
        text = label,
        callback = function()
            purchaseBait(id)
        end,
        flag = "BuyBait_".. tostring(id)
    })
end

for label, id in pairs(rodList) do
    Library:CreateButton({
        parent = buyTab,
        text = label,
        callback = function()
            purchaseRod(id)
        end,
        flag = "BuyRod_".. tostring(id)
    })
end

-- //////////////////////
-- // Boat Spawns       //
-- //////////////////////

local boats = {
    ["Speed Boat"] = 5,
    ["Fishing Boat"] = 6,
    ["Mini Yacht"] = 7,
    ["Hyper Boat"] = 8,
    ["Admin Boat"] = 9,
    ["Admin Boat 2"] = 10,
}

for name, id in pairs(boats) do
    Library:CreateButton({
        parent = extrasTab,
        text = name,
        callback = function()
            local spawnRemote = netRoot:WaitForChild("RF/SpawnBoat")
            pcall(function() spawnRemote:InvokeServer(id) end)
            notifySuccess("Boat Spawned", name.." spawned!")
        end,
        flag = "SpawnBoat_".. tostring(id)
    })
end

-- //////////////////////
-- // Modifiers (Auto Enchant Rod)
-- //////////////////////

Library:CreateButton({
    parent = modifiersTab,
    text = "Auto Enchant Rod (Go to Altar then Equip Slot)",
    callback = function()
        -- from original: teleported to coordinates and used RE/EquipToolFromHotbar then RE/ActivateAltar
        notifyWarn("Enchanting", "Process starting, please wait.")
        local char = LocalPlayer.Character
        if not char then notifyError("Enchant", "No character."); return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then notifyError("Enchant", "No HRP."); return end

        -- teleport to enchant position found in original (example)
        local enchantPos = CFrame.new(Vector3.new(3231, -1303, 1402) + Vector3.new(0,5,0))
        hrp.CFrame = enchantPos
        task.wait(1.2)

        -- equip rod slot (example slot 5 used in original)
        local equipRemote = netRoot:WaitForChild("RE/EquipToolFromHotbar")
        local activateRemote = netRoot:WaitForChild("RE/ActivateAltar")

        pcall(function() equipRemote:FireServer(5) end)
        task.wait(0.5)
        pcall(function() activateRemote:FireServer() end)
        notifySuccess("Enchant", "Enchant attempt done.")
    end,
    flag = "AutoEnchantBtn"
})

-- //////////////////////
-- // Extras: Auto Teleport to Event
-- //////////////////////

local autoTeleportEvent = false
Library:CreateToggle({
    default = false,
    parent = extrasTab,
    text = "Auto Teleport to EVENT",
    callback = function(state)
        autoTeleportEvent = state
        if state then
            notifyWarn("Auto Teleport", "Enabled. Will teleport when event appears.")
            task.spawn(function()
                while autoTeleportEvent do
                    -- original script probably watched an event flag or region; this is a placeholder loop
                    -- you can replace the condition with an actual check from the game's event flag (e.g., workspace:FindFirstChild("EventZone"))
                    local eventZone = workspace:FindFirstChild("FishingEventZone") -- placeholder name
                    if eventZone and eventZone:IsA("BasePart") then
                        local hrp = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                        if hrp then
                            hrp.CFrame = eventZone.CFrame + Vector3.new(0,3,0)
                            notifySuccess("Teleported", "Teleported to event.")
                        end
                    end
                    task.wait(2)
                end
            end)
        else
            notifyWarn("Auto Teleport", "Disabled.")
        end
    end,
    flag = "AutoTeleportEvent"
})

-- //////////////////////
-- // Utility / Cleanup //
-- //////////////////////

-- quick function to stop everything (for safety)
Library:CreateButton({
    parent = extrasTab,
    text = "STOP ALL",
    callback = function()
        stopAutoFish()
        autoTeleportEvent = false
        notifyWarn("STOP", "All automated features stopped.")
    end,
    flag = "StopAllBtn"
})

-- //////////////////////
-- // PLAYER //
-- //////////////////////

Library:CreateButton({
    parent = playerTab,
    text = "Redeem Code All",
    callback = function()
        local codes = {
            "LOST",
            "HUNTING",
            "EGGS",
            "FISHING",
            "BIGUPD",
            "LOBSTAH"
        }

        local net = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
            :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
            :WaitForChild("net"):WaitForChild("RF/RedeemCode")

        for _, code in ipairs(codes) do
            local args = {code}
            pcall(function()
                net:InvokeServer(unpack(args))
            end)
            wait(0.5) -- เว้นช่วงถ้าต้องการ
        end
    end,
    flag = "CODEBtn"
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local speedValue = 16
local jumpPowerValue = 50

local speedEnabled = false
local jumpEnabled = false

Library:CreateSlider({
    parent = playerTab,
    text = "Set Base Speed",
    min = 10,
    max = 300,
    default = 16,
    flag = "SpeedBoostSlider",
    callback = function(value)
        speedValue = value
    end
})

Library:CreateToggle({
    parent = playerTab,
    text = "Speed Hack",
    flag = "SpeedBoostToggle",
    default = false,
    callback = function(state)
        speedEnabled = state
        if not state then
            -- ปิด toggle คืนค่า default
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
            notifyWarn("Player", "Speed Boost Disabled")
        else
            notifyWarn("Player", "Speed Boost Enabled")
        end
    end
})

Library:CreateSlider({
    parent = playerTab,
    text = "Set Base JumpPower",
    min = 30,
    max = 300,
    default = 50,
    flag = "JumpPowerSlider",
    callback = function(value)
        jumpPowerValue = value
    end
})

Library:CreateToggle({
    parent = playerTab,
    text = "JumpPower Hack",
    flag = "JumpPowerToggle",
    default = false,
    callback = function(state)
        jumpEnabled = state
        if not state then
            -- ปิด toggle คืนค่า default
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
            notifyWarn("Player", "JumpBoost Disabled")
        else
            notifyWarn("Player", "JumpBoost Enabled")
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local NoclipEnabled = false
local InfJumpEnabled = false

-- Noclip Loop
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled then
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    else
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide == false then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Create Toggles
Library:CreateToggle({
    parent = playerTab,
    text = "Noclip",
    flag = "NoclipToggle",
    default = false,
    callback = function(state)
        NoclipEnabled = state
        notifyWarn("Player", "Noclip Enabled")
    end
})

Library:CreateToggle({
    parent = playerTab,
    text = "Infinite Jump",
    flag = "InfJumpToggle",
    default = false,
    callback = function(state)
        InfJumpEnabled = state
        notifyWarn("Player", "Infinite-Jump Enabled")
    end
})

Library:CreateButton({
    parent = playerTab,
    text = "Fly (Beta)",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Dly"))()
    end,
    flag = "FlyBtn"
})

-- ฟังก์ชันเซ็ตค่า WalkSpeed และ JumpPower ให้ตัวละคร
local function applySettings(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if speedEnabled then
        humanoid.WalkSpeed = speedValue
    else
        humanoid.WalkSpeed = 16
    end

    if jumpEnabled then
        humanoid.JumpPower = jumpPowerValue
    else
        humanoid.JumpPower = 50
    end
end

-- เชื่อมเหตุการณ์เกิดตัวละครใหม่ ให้ตั้งค่าอัตโนมัติ
Player.CharacterAdded:Connect(function(character)
    -- รอให้ humanoid โหลดก่อน
    character:WaitForChild("Humanoid")
    applySettings(character)
end)

-- Loop เช็คสถานะในทุกเฟรมเผื่อค่าโดนเปลี่ยน
RunService.Heartbeat:Connect(function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- ถ้าค่าปัจจุบันไม่ตรงกับที่ตั้งไว้ ให้ตั้งใหม่
            if speedEnabled and humanoid.WalkSpeed ~= speedValue then
                humanoid.WalkSpeed = speedValue
            elseif not speedEnabled and humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
            end

            if jumpEnabled and humanoid.JumpPower ~= jumpPowerValue then
                humanoid.JumpPower = jumpPowerValue
            elseif not jumpEnabled and humanoid.JumpPower ~= 50 then
                humanoid.JumpPower = 50
            end
        end
    end
end)


-- //////////////////////
-- // End Of Script     //
-- //////////////////////

notifySuccess("Loaded", "DYHUB - Clean UI Loaded. Press M to toggle UI.")
