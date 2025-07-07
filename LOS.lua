if not workspace:FindFirstChild("DYHUB PART") then
    local _0 = Instance.new("Part")
    _0.Name = "DYHUB PART"
    _0.Parent = workspace
    _0.Anchored = true
    _0.Transparency = 0
    _0.Size = Vector3.new(30, -0.5, 30)
    _0.Position = Vector3.new(-543.452, 2873.2, 324.647)
end

getgenv()["_1"] = true
spawn(function()
    while _1 and task.wait() do
        pcall(function()
            local _2 = {"Red Orb", "Blue Orb", "Yellow Orb", "Purple Orb", "Gem"}
            local _3 = {"City", "Desert", "Magma City", "Snow City", "Space", "Legends Highway"}
            for _4 = 1, #_2 do
                for _5 = 1, #_3 do
                    local _6 = {
                        [1] = "collectOrb",
                        [2] = _2[_4],
                        [3] = _3[_5]
                    }
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(_6))
                end
            end
        end)
    end
end)

getgenv()["_7"] = true
spawn(function()
    while _7 and task.wait() do
        pcall(function()
            local _8 = {"City", "Desert", "Magma City", "Snow City", "Space", "Legends Highway"}
            for _9 = 1, #_8 do
                local _10 = {
                    [1] = "collectOrb",
                    [2] = "Gem",
                    [3] = _8[_9]
                }
                game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(_10))
            end
        end)
    end
end)

getgenv()["_11"] = true
spawn(function()
    while _11 and task.wait(0.3) do
        pcall(function()
            local _12 = game.Players.LocalPlayer.Character
            if _12 and _12:FindFirstChild("HumanoidRootPart") then
                _12.HumanoidRootPart.CFrame = CFrame.new(-547.52026, 2893.19995, 327.647003)
            end
        end)
    end
end)

spawn(function()
    while _11 and task.wait() do
        pcall(function()
            local _13 = game:GetService("Workspace"):FindFirstChild("Hoops")
            local _14 = game.Players.LocalPlayer.Character
            if _13 and _14 and _14:FindFirstChild("HumanoidRootPart") then
                for _, _15 in pairs(_13:GetChildren()) do
                    _15.CFrame = _14.HumanoidRootPart.CFrame
                    wait(0.3)
                end
            end
        end)
    end
end)

getgenv()["_16"] = true
spawn(function()
    while _16 and task.wait() do
        pcall(function()
            game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
        end)
    end
end)
