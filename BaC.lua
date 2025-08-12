repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Build A Car",
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
    Title = "DYHUB - Build A Car (Beta)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(500, 300),
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
local PlayerTab = Window:Tab({ Title = "Mod", Icon = "car" })
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
    Placeholder = "Enter base speed (0-200)",
    Icon = "sliders",
    Callback = function(text)
        local number = tonumber(text)
        if number and number > 0 and number <= 200 then
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

PlayerTab:Toggle({
    Title = "Infinite Fuel (Coming Soon)",
    Icon = "fuel",
    Default = false,
    Callback = function(state)
        autoStartRunning = state
        if state then
            task.spawn(function()
                while autoStartRunning do
                    local launch = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DYHUB"):WaitForChild("Fuel")
                    launch:FireServer()
                    task.wait(10)
                end
            end)
        else
            print("[DYHUB] Coming Soon")
        end
    end
})

MainTab:Toggle({
    Title = "Auto Start (AFK)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoStartRunning = state
        if state then
            task.spawn(function()
                while autoStartRunning do
                    local LaunchRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_spawn")
                
                    LaunchRemote:InvokeServer()
                    task.wait(3)
                end
            end)
        else
            print("[DYHUB] Auto Start stopped.")
        end
    end
})

MainTab:Toggle({
    Title = "Infinite Money (Max)",
    Icon = "infinity",
    Default = false,
    Callback = function(state)
        autoFarmRunning2 = state
        if state then
            print("[DYHUB] Auto Farm started.")
            task.spawn(function()
                local LaunchRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_spawn")
                local ReturnRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_stop")
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
                    LaunchRemote:InvokeServer()
                    task.wait(1.5)

                    -- วาร์ป
                    if hrp then
                        hrp.CFrame = CFrame.new(9e12, 999, 0)
                    end

                    task.wait(3)

                    if hrp then
                        hrp.CFrame = CFrame.new(0, 999, 10000)
                    end

                    task.wait(1.5)

                    -- ยิง Return
                    ReturnRemote:InvokeServer()

                    task.wait(3)
                end
            end)
        else
            print("[DYHUB] Auto Farm stopped.")
        end
    end
})

-- ====== Auto Buy ======
local ShopList = {
    "All",
    "Stab",
    "Block",
    "Wheel",
    "Gas Tank",
    "Small Engine",
    "Good Wheel",
    "Big Gas Tank",
    "Medium Engine",
    "Efficient Gas Tank",
    "Big Wheel",
    "Super Gas Tank",
    "Great Engine",
    "V10 Engine",
    "Glass Panel",
    "Carbon Fiber Block",
    "Carbon Fiber Slab",
    "Heavy Block"
}

local selectedShops = {}
local buyingActive = false
local shopRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("merchant_purchase")

-- Dropdown เลือกไอเทม
ShopTab:Dropdown({
    Title = "Select Shop",
    Multi = true,
    Values = ShopList,
    Callback = function(value)
        selectedShops = value or {}
        print("[DYHUB] Selected Shop:", table.concat(selectedShops, ", "))
    end,
})

-- ปุ่ม Toggle ซื้ออัตโนมัติ
ShopTab:Toggle({
    Title = "Buy (Select)",
    Icon = "badge-dollar-sign",
    Callback = function(state)
        buyingActive = state
        if state then
            print("[DYHUB] Buying selected shop items started.")
            task.spawn(function()
                while buyingActive do
                    local itemsToBuy = {}

                    -- ถ้าเลือก All ให้ซื้อทุกอย่างยกเว้น "All"
                    if selectedShops and table.find(selectedShops, "All") then
                        for i = 2, #ShopList do
                            table.insert(itemsToBuy, ShopList[i])
                        end
                    else
                        itemsToBuy = selectedShops
                    end

                    -- วนซื้อทีละไอเทม
                    for _, itemName in ipairs(itemsToBuy) do
                        if itemName and itemName ~= "All" then
                            shopRemote:InvokeServer(itemName) 
                            
                            task.wait(0.05)
                        end
                    end

                    task.wait(0.05)
                end
            end)
        else
            print("[DYHUB] Buying stopped.")
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
