-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "DYHUB | Expedition Antarctica",
   Icon = 104487529937663,
   LoadingTitle = "DYHUB Loaded! - Expedition Antarctica",
   LoadingSubtitle = "Join our dsc.gg/dyhub",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ExpeditionAntarcticaConfig",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- UI Tabs
local MainTab = Window:CreateTab("🏔️ Main", nil)
local MiscTab = Window:CreateTab("🔧 Misc", nil)
local Section = MainTab:CreateSection("Movement")
local MiscSection = MiscTab:CreateSection("Utilities")

-- === CONFIGURABLE STATS === --
local CurrentSpeed = 16
local CurrentJump = 50
local AutoFarmActive = false
local NoclipActive = false
local FogRemoved = false

-- === CHECKPOINT DETECTION FUNCTION === --
local function waitForCheckpoint(maxWaitTime)
    local startTime = tick()
    local player = game.Players.LocalPlayer
    
    while tick() - startTime < (maxWaitTime or 5) do
        -- Check for common checkpoint indicators
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local checkpoint = leaderstats:FindFirstChild("Checkpoint") or leaderstats:FindFirstChild("Stage")
            if checkpoint then
                print("Current checkpoint: " .. tostring(checkpoint.Value))
            end
        end
        
        -- Check for checkpoint parts in workspace
        for _, obj in pairs(workspace:GetChildren()) do
            if string.find(string.lower(obj.Name), "checkpoint") or 
               string.find(string.lower(obj.Name), "camp") then
                local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                if distance < 50 then
                    print("Near checkpoint: " .. obj.Name)
                end
            end
        end
        
        wait(0.1)
    end
end

-- === IMPROVED TELEPORT FUNCTION === --
local function teleportToCheckpoint(name, cframe)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Teleport slightly above the checkpoint
        local adjustedCFrame = cframe + Vector3.new(0, 5, 0)
        char.HumanoidRootPart.CFrame = adjustedCFrame
        
        -- Wait a moment then move to exact position
        wait(0.5)
        char.HumanoidRootPart.CFrame = cframe
        
        -- Wait for checkpoint detection
        print("Teleported to " .. name .. ", checking for checkpoint...")
        waitForCheckpoint(3)
        
        -- Try walking a bit to trigger checkpoint
        wait(0.5)
        char.Humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
        wait(1)
        char.Humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(-5, 0, 0))
    end
end

-- === UPDATED TELEPORT COORDINATES === --
local Camps = {
    ["Camp 1"] = CFrame.new(-4236.6, 0, 723.6),
    ["Camp 2"] = CFrame.new(1789.7, 0, -137),
    ["Camp 3"] = CFrame.new(5892.1, 0, -20.3),
    ["Camp 4"] = CFrame.new(8992.2, 0, 102.6),
    ["South Pole"] = CFrame.new(11001.9, 0, 103)
}

-- === AUTO CHECKPOINT FARM === --
MainTab:CreateToggle({
    Name = "🤖 Auto Checkpoint Farm",
    CurrentValue = false,
    Flag = "AutoCheckpoint",
    Callback = function(Value)
        AutoFarmActive = Value
        if Value then
            spawn(function()
                while AutoFarmActive do
                    for name, cframe in pairs(Camps) do
                        if not AutoFarmActive then break end
                        print("Auto farming: " .. name)
                        teleportToCheckpoint(name, cframe)
                        wait(2) -- Wait between checkpoints
                    end
                    if AutoFarmActive then
                        wait(5) -- Wait before repeating cycle
                    end
                end
            end)
        end
    end
})

-- === MANUAL TELEPORT BUTTONS === --
for name, cframe in pairs(Camps) do
    MainTab:CreateButton({
        Name = "🚩 Teleport to " .. name,
        Callback = function()
            teleportToCheckpoint(name, cframe)
        end
    })
end

-- === COORDINATE CHECKER === --
MainTab:CreateButton({
    Name = "📍 Get Current Coordinates",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local cframe = player.Character.HumanoidRootPart.CFrame
            
            -- Format coordinates
            local posStr = string.format("Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            local cframeStr = string.format("CFrame.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
            
            -- Print to console
            print("=== CURRENT COORDINATES ===")
            print(posStr)
            print("CFrame: " .. cframeStr)
            print("Full CFrame: " .. tostring(cframe))
            print("============================")
            
            -- Show notification
            Rayfield:Notify({
                Title = "Coordinates Copied",
                Content = "Check console for full coordinates",
                Duration = 5
            })
            
            -- Try to copy to clipboard if possible
            if setclipboard then
                setclipboard(cframeStr)
                Rayfield:Notify({
                    Title = "Copied to Clipboard",
                    Content = cframeStr,
                    Duration = 3
                })
            end
        end
    end
})

-- === SPEED AND JUMP CONTROLS === --
Section:CreateSlider({
    Name = "🏃 Walk Speed",
    Range = {1, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        CurrentSpeed = Value
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
        
        -- Update for future spawns
        if player.Character then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

Section:CreateSlider({
    Name = "🦘 Jump Power", 
    Range = {1, 300},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        CurrentJump = Value
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end
        
        -- Update for future spawns
        if player.Character then
            player.Character.Humanoid.JumpPower = Value
        end
    end
})

-- Quick Speed Presets
Section:CreateButton({
    Name = "⚡ Speed: Normal (16)",
    Callback = function()
        CurrentSpeed = 16
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
})

Section:CreateButton({
    Name = "🚀 Speed: Fast (50)",
    Callback = function()
        CurrentSpeed = 50
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        end
    end
})

Section:CreateButton({
    Name = "💨 Speed: Super Fast (100)",
    Callback = function()
        CurrentSpeed = 100
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 100
        end
    end
})

-- Quick Jump Presets
Section:CreateButton({
    Name = "🦘 Jump: Normal (50)",
    Callback = function()
        CurrentJump = 50
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
    end
})

Section:CreateButton({
    Name = "🚁 Jump: High (120)",
    Callback = function()
        CurrentJump = 120
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 120
        end
    end
})

Section:CreateButton({
    Name = "🌙 Jump: Moon Jump (200)",
    Callback = function()
        CurrentJump = 200
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 200
        end
    end
})

-- === COORDINATE SAVER === --
local SavedCoordinates = {}

MainTab:CreateTextBox({
    Name = "💾 Save Current Position",
    PlaceholderText = "Enter name for this position",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Text ~= "" then
            local pos = player.Character.HumanoidRootPart.Position
            local cframe = CFrame.new(pos.X, pos.Y, pos.Z)
            SavedCoordinates[Text] = cframe
            
            print("Saved position '" .. Text .. "': " .. string.format("CFrame.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
            
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Saved as: " .. Text,
                Duration = 3
            })
        end
    end
})

-- === TELEPORT TO SAVED COORDINATES === --
MainTab:CreateDropdown({
    Name = "🎯 Teleport to Saved Position",
    Options = {},
    CurrentOption = "",
    Flag = "SavedPositions",
    Callback = function(Option)
        if SavedCoordinates[Option] then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = SavedCoordinates[Option]
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Moved to: " .. Option,
                    Duration = 2
                })
            end
        end
    end
})

-- === COORDINATE TOOLS SECTION === --
local CoordSection = MainTab:CreateSection("📍 Coordinate Tools")

-- === CHECKPOINT INFO === --
MainTab:CreateButton({
    Name = "ℹ️ Check Current Checkpoint",
    Callback = function()
        local player = game.Players.LocalPlayer
        local leaderstats = player:FindFirstChild("leaderstats")
        
        if leaderstats then
            for _, stat in pairs(leaderstats:GetChildren()) do
                if string.find(string.lower(stat.Name), "checkpoint") or 
                   string.find(string.lower(stat.Name), "stage") or
                   string.find(string.lower(stat.Name), "camp") then
                    Rayfield:Notify({
                        Title = "Checkpoint Info",
                        Content = stat.Name .. ": " .. tostring(stat.Value),
                        Duration = 5
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "No Leaderstats",
                Content = "Cannot find checkpoint information",
                Duration = 3
            })
        end
    end
})

-- === ADDITIONAL UTILITIES === --
MiscTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        NoclipActive = Value
        local player = game.Players.LocalPlayer
        
        if Value then
            -- Enable noclip
            spawn(function()
                while NoclipActive do
                    if player.Character then
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        else
            -- Disable noclip
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "🌫️ Remove/Toggle Fog",
    Callback = function()
        local lighting = game:GetService("Lighting")
        
        if not FogRemoved then
            -- Remove fog
            lighting.FogEnd = 100000
            lighting.FogStart = 0
            FogRemoved = true
            Rayfield:Notify({
                Title = "Fog Removed",
                Content = "Visibility improved!",
                Duration = 2
            })
        else
            -- Restore fog (default Antarctic settings)
            lighting.FogEnd = 500
            lighting.FogStart = 0
            FogRemoved = false
            Rayfield:Notify({
                Title = "Fog Restored", 
                Content = "Default visibility restored",
                Duration = 2
            })
        end
    end
})

MiscTab:CreateButton({
    Name = "🔄 Reset Character",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
})

-- Auto-apply speed and jump when character spawns  
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CurrentSpeed
        char.Humanoid.JumpPower = CurrentJump
    end
end)

-- Apply to current character if exists
local player = game.Players.LocalPlayer
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = CurrentSpeed
    player.Character.Humanoid.JumpPower = CurrentJump
end
