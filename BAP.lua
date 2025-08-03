repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Build A Plane",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB TEAM - Join us at dsc.gg/dyhub",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - Build A Plane",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
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

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local PlayerTab = Window:Tab({ Title = "Plane", Icon = "plane" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })

local baseSpeed = 50
local boostedSeats = {}
local boostLoopActive = false
local autoStartRunning = false
-- 100k
local autoFarmRunning = false
-- inf
local autoFarmRunning2 = false
-- 500k
local autoFarmRunning3 = false

PlayerTab:Input({
    Title = "Set Base Speed Boost",
    Placeholder = "Enter base speed (0-2000)",
    Icon = "sliders",
    Callback = function(text)
        local number = tonumber(text)
        if number and number > 0 and number <= 2000 then
            baseSpeed = number
        else
            warn("[DYHUB] Invalid base speed value. Please enter a number between 1 and 2000.")
        end
    end
})

PlayerTab:Toggle({
    Title = "Boost Speed",
    Icon = "wind",
    Default = false,
    Callback = function(state)
        boostLoopActive = state

        if state then
            task.spawn(function()
                while boostLoopActive do
                    local char = LocalPlayer.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
                        local seat = humanoid.SeatPart
                        if not boostedSeats[seat] then
                            boostedSeats[seat] = seat.MaxSpeed or baseSpeed
                            seat.MaxSpeed = baseSpeed
                        end
                    end
                    task.wait(5)
                end
            end)
        else
            -- รีเซ็ต MaxSpeed ของ VehicleSeat ที่บูสต์แล้ว
            for seat, speed in pairs(boostedSeats) do
                if seat and seat:IsA("VehicleSeat") then
                    seat.MaxSpeed = speed
                end
            end
            boostedSeats = {}
        end
    end
})

MainTab:Toggle({
    Title = "Auto Start (Just Start)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoStartRunning = state
        if state then
            task.spawn(function()
                while autoStartRunning do
                    local launch = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                    launch:FireServer()
                    task.wait(3)
                end
            end)
        else
            print("[DYHUB] Auto Start stopped.")
        end
    end
})

MainTab:Toggle({
    Title = "Auto Farm (1sec - 100K)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoFarmRunning = state
        if state then
            print("[DYHUB] Auto Farm started.")
            task.spawn(function()
                local LaunchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return")
                local player = Players.LocalPlayer

                while autoFarmRunning do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")

                    while autoFarmRunning and (not character or not humanoid or humanoid.Health <= 0 or not hrp) do
                        task.wait(0.5)
                        character = player.Character
                        humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        hrp = character and character:FindFirstChild("HumanoidRootPart")
                    end

                    if not autoFarmRunning then break end

                    -- ยิง Launch
                    LaunchRemote:FireServer()
                    task.wait(1.5)

                    -- สร้าง Part ขนาดใหญ่ให้ชน
                    local part = Instance.new("Part")
                    part.Name = "AutoFarmTarget"
                    part.Size = Vector3.new(1000, 1000, 1000) -- ใหญ่มาก
                    part.Anchored = true
                    part.CanCollide = true
                    part.Material = Enum.Material.Neon
                    part.BrickColor = BrickColor.new("Bright red")
                    part.Transparency = 0.2
                    part.CFrame = CFrame.new(9e6, 9e6, 9e6)
                    part.Parent = workspace

                    -- วาร์ปไปด้านบนของ part
                    if hrp then
                        hrp.CFrame = CFrame.new(9e6, 9e6 + 100, 9e6)
                    end

                    task.wait(1.5)

                    -- ยิง Return
                    ReturnRemote:FireServer()

                    task.wait(4)

                    -- ลบ Part ถ้าไม่ต้องการให้ค้าง
                    if workspace:FindFirstChild("AutoFarmTarget") then
                        workspace.AutoFarmTarget:Destroy()
                    end
                end
            end)
        else
            print("[DYHUB] Auto Farm stopped.")
        end
    end
})

MainTab:Toggle({
    Title = "Auto Farm (1sec - 10MILLION)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoFarmRunning3 = state
        if state then
            print("[DYHUB] Auto Farm started.")
            task.spawn(function()
                local LaunchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return")
                local player = Players.LocalPlayer

                while autoFarmRunning3 do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")

                    -- รอจนกว่า character จะเกิดและพร้อม (ถ้าเล่นไปตาย จะรอจนเกิดใหม่)
                    while autoFarmRunning3 and (not character or not humanoid or humanoid.Health <= 0 or not hrp) do
                        task.wait(0.5)
                        character = player.Character
                        humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        hrp = character and character:FindFirstChild("HumanoidRootPart")
                    end

                    if not autoFarmRunning3 then break end

                    -- ยิง Launch
                    LaunchRemote:FireServer()
                    task.wait(1.5)

                    -- วาร์ป
                    if hrp then
                        hrp.CFrame = CFrame.new(7e8, 7e8, 7e8)
                    end

                    task.wait(1.5)

                    -- ยิง Return
                    ReturnRemote:FireServer()

                    task.wait(4)
                end
            end)
        else
            print("[DYHUB] Auto Farm stopped.")
        end
    end
})

MainTab:Toggle({
    Title = "Infinite Money (Fix Lag)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoFarmRunning2 = state
        if state then
            print("[DYHUB] Auto Farm started.")
            task.spawn(function()
                local LaunchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return")
                local player = Players.LocalPlayer

                while autoFarmRunning2 do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")

                    -- รอจนกว่า character จะเกิดและพร้อม (ถ้าเล่นไปตาย จะรอจนเกิดใหม่)
                    while autoFarmRunning2 and (not character or not humanoid or humanoid.Health <= 0 or not hrp) do
                        task.wait(0.5)
                        character = player.Character
                        humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        hrp = character and character:FindFirstChild("HumanoidRootPart")
                    end

                    if not autoFarmRunning2 then break end

                    -- ยิง Launch
                    LaunchRemote:FireServer()
                    task.wait(1.5)

                    -- วาร์ป
                    if hrp then
                        hrp.CFrame = CFrame.new(9e12, 9e12, 9e12)
                    end

                    task.wait(1.5)

                    -- ยิง Return
                    ReturnRemote:FireServer()

                    task.wait(4)
                end
            end)
        else
            print("[DYHUB] Auto Farm stopped.")
        end
    end
})

local ShopList = {
    "All",       -- เพิ่ม "All" เป็นตัวแรก
    "block_1",
    "seat_1",
    "fuel_1",
    "fuel_2",
    "fuel_3",
    "wing_1",
    "wing_2",
    "propeller_1",
    "propeller_2",
    "missile_1",
    "shield",
    "boost_1",
    "balloon"
}

local selectedShops = {}

ShopTab:Dropdown({
    Title = "Select Shop",
    Multi = true,
    Values = ShopList,
    Callback = function(value)
        selectedShops = value or {}
        print("[DYHUB] Selected Shop:", table.concat(selectedShops, ", "))
    end,
})

ShopTab:Toggle({
    Title = "Buy (Select)",
    Icon = "badge-dollar-sign",
    Callback = function(state)
        local shopRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock")
        if state then
            print("[DYHUB] Buying selected shop items started.")
            task.spawn(function()
                while true do
                    if not state then
                        print("[DYHUB] Buying selected shop items stopped.")
                        break
                    end

                    local itemsToBuy = {}

                    -- ถ้าเลือก All ให้ซื้อทุกอย่างยกเว้น "All" เอง
                    if selectedShops and table.find(selectedShops, "All") then
                        for i = 2, #ShopList do
                            table.insert(itemsToBuy, ShopList[i])
                        end
                    else
                        itemsToBuy = selectedShops
                    end

                    for _, itemName in ipairs(itemsToBuy) do
                        if itemName and itemName ~= "All" then
                            shopRemote:FireServer(itemName)
                            task.wait(0.1)
                        end
                    end

                    task.wait(0.5)
                end
            end)
        else
            print("[DYHUB] Buy (Select) toggle disabled.")
        end
    end
})

MiscTab:Toggle({
    Title = "Auto Respawn",
    Icon = "repeat",
    Default = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    local char = LocalPlayer.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        task.wait(2)
                        LocalPlayer:LoadCharacter()
                    end
                    task.wait(1)
                end
            end)
        else
            print("[DYHUB] Auto Respawn disabled.")
        end
    end
})

MiscTab:Toggle({
    Title = "Anti-AFK",
    Icon = "activity",
    Default = true,
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    if not LocalPlayer then return end
                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(60)
                end
            end)
        else
            print("[DYHUB] Anti-AFK disabled.")
        end
    end
})

MiscTab:Toggle({
    Title = "FPS Boost",
    Icon = "cpu",
    Default = false,
    Callback = function(state)
        if state then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                end
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            print("[DYHUB] FPS Boost disabled. (by rhy)")
        end
    end
})
