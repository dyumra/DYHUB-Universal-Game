repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Load UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Main Tab
local MainTab = WindUI:CreateTab({
    Title = "DYHUB - Auto Level",
    Icon = "zap"
})

-- Auto Start Toggle
local autoStartRunning = false

MainTab:Toggle({
    Title = "Infinite level",
    Icon = "badge-dollar-sign",
    Value = false,
    Callback = function(state)
        autoStartRunning = state
        if state then
            print("[DYHUB] Auto Infinite level started.")
            task.spawn(function()
                while autoStartRunning
                    local success, err = pcall(function()
                        local event = ReplicatedStorage:WaitForChild("Events"):FindFirstChild("LevelUp")
                        if event then
                            event:FireServer()
                        else
                            warn("[DYHUB] LevelUp Event not found!")
                        end
                    end)
                    if not success then
                        warn("[DYHUB] Auto Infinite level Error:", err)
                    end
                    task.wait(0.001) -- ปลอดภัยกว่าการยิงถี่เกิน
                end
            end)
        else
            print("[DYHUB] Auto Infinite level stopped.")
        end
    end
})

-- Anti-AFK
task.spawn(function()
    while task.wait(60) do
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        print("[DYHUB] Anti-AFK triggered.")
    end
end)

print("[DYHUB] Loaded successfully!")
