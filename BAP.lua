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
    Title = "Open DYHUB",
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
local autoFarmRunning = false

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
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")

                local LaunchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return")

                local player = Players.LocalPlayer

                while autoFarmRunning do
                    local character = player.Character or player.CharacterAdded:Wait()

                    LaunchRemote:FireServer()
                    task.wait(1)

                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(1000000e9, 1000000e9, 1000000e9)
                    end

                    task.wait(1)

                    ReturnRemote:FireServer()
                    task.wait(3)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "Auto Farm (1sec - 500K)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoFarmRunning = state
        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")

                local LaunchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return")

                local player = Players.LocalPlayer

                while autoFarmRunning do
                    local character = player.Character or player.CharacterAdded:Wait()

                    LaunchRemote:FireServer()
                    task.wait(1)

                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(5000000e9, 5000000e9, 5000000e9)
                    end

                    task.wait(1)

                    ReturnRemote:FireServer()
                    task.wait(3)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "Infinite Money (AFK)",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoFarmRunning = state
        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")

                local LaunchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return")

                local player = Players.LocalPlayer

                while autoFarmRunning do
                    local character = player.Character or player.CharacterAdded:Wait()

                    LaunchRemote:FireServer()
                    task.wait(1)

                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(9000000000e9, 90000000000e9, 9000000000e9)
                    end

                    task.wait(1)

                    ReturnRemote:FireServer()
                    task.wait(3)
                end
            end)
        end
    end
})

local ShopList = {
    "All",
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

local selectedItems = {} -- ไอเทมที่เลือกจาก dropdown
local autoBuyRunning = false

-- Dropdown เลือกหลายอัน
ShopTab:Dropdown({
    Title = "Select Shop",
    Multi = true,
    Values = ShopList,
    Callback = function(values)
        selectedItems = values
        print("[DYHUB] Selected Shop Items:", table.concat(values, ", "))
    end,
})

-- Toggle เริ่ม Auto Buy
ShopTab:Toggle({
    Title = "Auto Buy (Select)",
    Icon = "badge-dollar-sign",
    Callback = function(state)
        autoBuyRunning = state
        if state then
            local shopRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock")
            task.spawn(function()
                while autoBuyRunning do
                    local itemsToBuy = {}

                    -- ถ้าเลือก All → ซื้อทุกอย่าง (ยกเว้น All เอง)
                    if table.find(selectedItems, "All") then
                        for _, item in ipairs(ShopList) do
                            if item ~= "All" then
                                table.insert(itemsToBuy, item)
                            end
                        end
                    else
                        itemsToBuy = selectedItems
                    end

                    for _, itemName in ipairs(itemsToBuy) do
                        if not autoBuyRunning then break end
                        shopRemote:FireServer(itemName)
                        task.wait(0.1)
                    end
                    task.wait(1)
                end
            end)
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
                        task.wait(0.2)
                        LocalPlayer:LoadCharacter()
                    end
                    task.wait(0.2)
                end
            end)
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
            -- ถ้าปิด อาจจะต้องรีเซ็ตคุณภาพกราฟิก (ถ้าต้องการ)
        end
    end
})
