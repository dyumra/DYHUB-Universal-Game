local start = getgenv().auto_farm or false

local DELAY_BEFORE_WARP = getgenv().delay_teleport or 0.1
local OFFSET_ABOVE = 1
local ESCAPE_DISTANCE = getgenv().escape_distance or 50
local MONSTER_RADIUS = getgenv().monster_radius or 20

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function getChar()
    local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return c, c:WaitForChild("Humanoid", 10), c:WaitForChild("HumanoidRootPart", 10)
end

local function isAlive(hum)
    return hum and hum.Health > 0
end

local function getItemCF(item)
    if item:IsA("BasePart") then
        return item.CFrame
    elseif item:IsA("Tool") and item:FindFirstChild("Handle") then
        return item.Handle.CFrame
    elseif item:IsA("Model") then
        if item.PrimaryPart then
            return item.PrimaryPart.CFrame
        end
        local p = item:FindFirstChildWhichIsA("BasePart", true)
        return p and p.CFrame or nil
    end
    return nil
end

-- unequip ก่อนถือใหม่
local function resetTools()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if char and backpack then
        -- ย้าย tools กลับไป backpack (unequip)
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = backpack
            end
        end
        task.wait(0.05)
        -- equip ใหม่
        for _,tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = char
            end
        end
    end
end

-- หามอนสเตอร์ที่ใกล้ที่สุด
local function getNearestMonster(hrp)
    local monsters = workspace:FindFirstChild("Monsters")
    if not monsters then return nil end

    local closest, dist = nil, math.huge
    for _,mob in ipairs(monsters:GetChildren()) do
        local root = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 then
            local d = (root.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                closest = root
            end
        end
    end
    return closest, dist
end

-- smooth move function
local function smoothMove(hrp, targetPos)
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {CFrame = CFrame.new(targetPos)}
    )
    tween:Play()
    tween.Completed:Wait()
end

task.spawn(function()
    while start do
        local char, hum, hrp = getChar()
        if not (char and hum and hrp and isAlive(hum)) then
            task.wait(0.5)
            continue
        end

        -- เช็กมอนสเตอร์
        local nearest, dist = getNearestMonster(hrp)
        if nearest and dist < MONSTER_RADIUS then
            -- หนีออกห่าง
            local direction = (hrp.Position - nearest.Position).Unit
            local newPos = hrp.Position + direction * ESCAPE_DISTANCE
            smoothMove(hrp, newPos + Vector3.new(0, OFFSET_ABOVE, 0))
            task.wait(0.3)
            continue
        end

        local container = workspace:FindFirstChild("RewardDrops")
        if not container then
            task.wait(0.5)
            continue
        end

        for _,obj in ipairs(container:GetChildren()) do
            if not start then break end
            if not (char and hum and hrp and isAlive(hum)) then break end

            resetTools() -- เลิกถือก่อนแล้วค่อยถือใหม่
            task.wait(DELAY_BEFORE_WARP)

            local cf = getItemCF(obj)
            if cf then
                pcall(function()
                    hrp.CFrame = cf + Vector3.new(0, OFFSET_ABOVE, 0)
                end)
                task.wait(0.08)
            end
        end

        RunService.Heartbeat:Wait()
    end
end)
