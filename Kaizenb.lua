local NEVERLOSE = loadstring(game:HttpGet("https://you.whimper.xyz/sources/ronix/ui.lua"))()

NEVERLOSE:Theme("nightly")
local Window = NEVERLOSE:AddWindow("DYHUB", "Text")

-- Tabs and Sections
local MainTab = Window:AddTab("Main", "home")
local CharactersTab = Window:AddTab("Characters", "locked")
local GodModeTab = Window:AddTab("God Mode", "earth")
local SettingsTab = Window:AddTab("Settings", "folder")

-- Character sections
local GojoSection = CharactersTab:AddSection("Gojo", "left")
local YujiSection = CharactersTab:AddSection("Yuji", "left")
local LuffySection = CharactersTab:AddSection("Luffy", "left")
local GokuSection = CharactersTab:AddSection("Goku", "left")
local YutaSection = CharactersTab:AddSection("Yuta", "left")

-- God Mode section
local GodModeSection = GodModeTab:AddSection("Auto Abilities", "left")

-- Settings section
local LoopSettings = SettingsTab:AddSection("Loop Settings", "left")
local cooldown = 0.5 -- Default cooldown
LoopSettings:AddSlider("Loop Cooldown (seconds)", 0.1, 5, 0.5, 0.1, function(value)
    cooldown = value
end)

-- Function to create attack buttons with loop options
local function createAttackButtons(section, character, attacks)
    for _, attack in pairs(attacks) do
        local loopConnection = nil
        
        -- Regular attack button
        section:AddButton(attack, function()
            local args = {attack}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild(character):FireServer(unpack(args))
        end)
        
        -- Loop toggle for the attack
        section:AddToggle("Loop "..attack, false, function(state)
            if state then
                loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    local args = {attack}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild(character):FireServer(unpack(args))
                    wait(cooldown)
                end)
            else
                if loopConnection then
                    loopConnection:Disconnect()
                    loopConnection = nil
                end
            end
        end)
    end
end

-- Gojo attacks
createAttackButtons(GojoSection, "Gojo", {
    "Blue", "Red", "Barrage", "Hora",
    "BackHand", "MaxRed", "HollowPurpleBig", "Domain"
})

-- Yuji attacks
createAttackButtons(YujiSection, "Yuji", {
    "Brother", "Divergent", "Black", "Manji",
    "Cleave", "FireArrow", "Dismantle", "Domain"
})

-- Luffy attacks
createAttackButtons(LuffySection, "Luffy", {
    "Axe", "Bazooka", "Gatling", "Bullet",
    "JetPistol", "JetBazooka", "JetGat", "RedHawk"
})

-- Goku attacks
createAttackButtons(GokuSection, "Goku", {
    "KiBarrage", "Kamehameha", "DragonCombo", "FrenzyKicks",
    "QuickCombo", "SuperKamehameha", "UltraSense", "GodlyCombo"
})

-- Yuta attacks
createAttackButtons(YutaSection, "Yuta", {
    "Slashes", "Strike", "Rampage", "Heal",
    "Shine", "BlackFlash", "GroundBreak", "PureLove"
})

-- God Mode toggles
local healLoop
local ultraSenseLoop

GodModeSection:AddToggle("Auto Heal (God Mode)", false, function(state)
    if state then
        healLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local args = {"Heal"}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Yuta"):FireServer(unpack(args))
            wait(0.01)
        end)
    else
        if healLoop then
            healLoop:Disconnect()
            healLoop = nil
        end
    end
end)

GodModeSection:AddToggle("Ultra Sense (God Mode)", false, function(state)
    if state then
        ultraSenseLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local args = {"UltraSense"}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Goku"):FireServer(unpack(args))
            wait(0.01)
        end)
    else
        if ultraSenseLoop then
            ultraSenseLoop:Disconnect()
            ultraSenseLoop = nil
        end
    end
end)

-- Main section with example elements
local MainSection = MainTab:AddSection("Home", "left")

MainSection:AddButton("Anti-Cheat", function()
    print("Anti Cheat Enabled!")
end)

MainSection:AddToggle("Detected Admin", false, function(state)
    if state then
        print("Anti-Admin Enabled!")
    end
end)

MainSection:AddDropdown("Feature", {"No-Cooldown", "No-Ragdoll", "Reducing-Lag"}, function(selection)
    print("Selected:", selection)
end)
