-- test2

repeat task.wait() until game:IsLoaded()

local function destroyObjectCache(parent)
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == "ObjectCache" then
            obj:Destroy()
        else
            destroyObjectCache(obj)
        end
    end
end

destroyObjectCache(workspace.Terrain)

local WindUI
repeat
    task.wait(0.1)
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    if success then
        WindUI = result
    end
until WindUI

local Window = WindUI:CreateWindow({
    Title = "DYHUB | Hunty Zombie",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 1.0.0",
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
Window:SelectTab(1)

-- ================= MainTab =================
MainTab:Section({ Title = "Feature Farm", Icon = "sword" })

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")

local autoFarmEnabled = false
local waitTime = 1.5 -- เวลารอแต่ละตัว

-- ฟังก์ชันส่งเหตุการณ์รัวๆ
local function fireByteNet()
    local argsList = {
        buffer.fromstring("\b\004\000"),
        buffer.fromstring("\b\003\000"),
        buffer.fromstring("\b\005\000"),
        buffer.fromstring("\b\006\000")
    }
    spawn(function()
        while autoFarmEnabled do
            for _, args in ipairs(argsList) do
                ByteNetReliable:FireServer(args)
            end
            task.wait(0.1) -- ส่งรัวๆ
        end
    end)
end

-- ฟังก์ชันเริ่มออโต้ฟาร์ม
function startAutoFarm()
    autoFarmEnabled = true
    fireByteNet() -- เริ่มส่งเหตุการณ์รัวๆ

    spawn(function()
        while autoFarmEnabled do
            for _, zombie in ipairs(workspace.Entities.Zombie:GetChildren()) do
                if not autoFarmEnabled then break end
                if zombie:FindFirstChild("HumanoidRootPart") then
                    -- วาร์ปไปบนหัวมัน
                    HumanoidRootPart.CFrame = zombie.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(waitTime)
                end
            end
        end
    end)
end

-- ฟังก์ชันหยุดออโต้ฟาร์ม
function stopAutoFarm()
    autoFarmEnabled = false
end

-- ================= MainTab =================
MainTab:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        if value then startAutoFarm() else stopAutoFarm() end
    end
})
