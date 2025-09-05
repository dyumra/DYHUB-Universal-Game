-- ====== loops ======
local loop = getgenv().loop or false

-- ====== settings ======
local tp = getgenv().auto_win
local speed = getgenv().get_speed or 1
local egg = getgenv().buy_egg

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local WinCFrames = {
    CFrame.new(424.787109, 60.8722534, 88.3873444),
    CFrame.new(763.866028, 61.4240227, 88.5375671),
    CFrame.new(1134.97058, 60.943573, 88.5375748),
    CFrame.new(1680.14783, 1.21932316, 88.5375671),
    CFrame.new(2024.87354, 0.637123108, 88.5375748),
    CFrame.new(2372.80029, 0.230704278, 88.5375671),
    CFrame.new(2660.39795, 32.2375412, 88.5375671),
    CFrame.new(3004.53149, 31.3529797, 88.5375671),
    CFrame.new(3264.01733, 1055.25452, 88.5375671),
    CFrame.new(5731.36523, 1055.81897, 88.5375595)
}

local function autoWin(tpIndex)
    local HRP = getHRP()
    if tpIndex and tpIndex > 0 and WinCFrames[tpIndex] then
        HRP.CFrame = WinCFrames[tpIndex]
    else
        for _, cf in ipairs(WinCFrames) do
            HRP.CFrame = cf
            wait(0.1)
        end
    end
end

local function boostSpeed()
    local args = {"WalkingSpeedGain", speed}
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("SpeedBoost"):FireServer(unpack(args))
    end)
end

local function activateEgg()
    local args = {"Obsidian Egg"}
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("ActivateEgg"):FireServer(unpack(args))
    end)
end

-- ====== One round ======
boostSpeed()
autoWin(tp)
for i = 1, egg do
    activateEgg()
    wait(0.1)
end

-- ====== Loop round ======
if loop then
    while true do
        boostSpeed()
        autoWin(tp)
        if egg then
            activateEgg()
        end
        wait(1)
    end
end
