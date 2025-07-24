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
    Icon = "terminal",
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
                while autoFarmRunning do
                    local launchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
                    launchRemote:FireServer()
                    task.wait(3)

                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChildOfClass("Humanoid") then break end

                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
                        local seat = humanoid.SeatPart
                        local dir = seat.CFrame.LookVector
                        local targetPos = seat.CFrame + dir * 10000000

                        seat.CFrame = targetPos
                        if char.PrimaryPart then
                            char:SetPrimaryPartCFrame(targetPos)
                        end
                    end
                end
            end)
        end
    end
})

MainTab:Button({
    Title = "Infinite Money",
    Icon = "badge-dollar-sign",
    Callback = function()
        local launchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch")
        launchRemote:FireServer()
        task.wait(3)

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChildOfClass("Humanoid") then return end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
            local seat = humanoid.SeatPart
            local dir = seat.CFrame.LookVector
            local targetPos = seat.CFrame + dir * 50000000 -- ลดระยะลงเพื่อความปลอดภัย

            if char.PrimaryPart then
                char:SetPrimaryPartCFrame(targetPos)
            end
        end

        -- รีเทเลพอร์ตกลับไปยัง instance เดิมหลังจาก 3 วินาที
        task.delay(8, function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end
})


local ShopList = {
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
    "All"
}

-- Dropdown สำหรับดู index ทั้งหมด
ShopTab:Dropdown({
    Title = "Select Shop",
    Multi = true,
    Values = ShopList,
    Callback = function(value)
        print("[DYHUB] Selected Shop:", value)
    end,
})

ShopTab:Toggle({
    Title = "Buy (Select)",
    Icon = "badge-dollar-sign",
    Callback = function(state)
        if state then
            local shopRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock")
            -- ซื้อของทีละชิ้นเพื่อป้องกันบัค
            task.spawn(function()
                for _, itemName in ipairs(ShopList) do
                    shopRemote:FireServer(itemName)
                    task.wait(0.1)
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
                        task.wait(2)
                        LocalPlayer:LoadCharacter()
                    end
                    task.wait(1)
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
