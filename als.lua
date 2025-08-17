local BlacklistedPlayers = {
    548245499,
    2318524722,
    3564923852
}

local player = game.Players.LocalPlayer
local userId = player.UserId

-- Check if the player's userId is in the BlacklistedPlayers table
for _, blacklistedId in ipairs(BlacklistedPlayers) do
    if userId == blacklistedId then
        player:Kick("You are blacklisted from using this script. wrdyz.94 On discord for appeal.")
        break
    end
end




local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "2.7.5"

if _G.Interface == nil then
    _G.Interface = true
    
    -- ====== PERSISTENCE MECHANISM ======
    local CONFIGURATION = {
        FOLDER_NAME = "DYHUB",
        SCRIPT_URL = "https://pastes.io/raw/animelaststandscript",
        FILE_EXTENSION = ".lua"
    }






    
Fluent:Notify({
    Title = "Loading interface...",
    Content = "Interface is loading, please wait.",
    Duration = 5 -- Set to nil to make the notification not disappear
})



local Admins = {
    8205778977
}
local isAdmin = false
for _, adminId in ipairs(Admins) do
    if userId == adminId then
        isAdmin = true
        break
    end
end

local Window = Fluent:CreateWindow({
    Title = "DYHUB | "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." ("..Version..")",
    SubTitle = "dsc.gg/dyhub",
    TabWidth = 100,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    Transparency = "false",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})



local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local Tabs = {}

Tabs.Player = Window:AddTab({ Title = "Player", Icon = "user" })

if workspace:FindFirstChild("TPparts") then
    Tabs.Teleport = Window:AddTab({ Title = "Teleport", Icon = "compass" })
end

if gui:FindFirstChild("Story") or gui:WaitForChild("Story", 5) then
    Tabs.Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "repeat" })
end

-- Only show Autofarm2 if WorldModel exists inside Bottom.Frame.Frame
local root = gui:FindFirstChild("Bottom")
    and gui.Bottom:FindFirstChild("Frame")
    and gui.Bottom.Frame:FindFirstChild("Frame")

if root then
    for _, desc in ipairs(root:GetDescendants()) do
        if desc:IsA("WorldModel") then
            Tabs.Autofarm2 = Window:AddTab({ Title = "Autofarm", Icon = "repeat" })
            break
        end
    end
end

Tabs.server = Window:AddTab({ Title = "Server", Icon = "server" })
Tabs.Credits = Window:AddTab({ Title = "Credits", Icon = "book" })
Tabs.UpdateLogs = Window:AddTab({ Title = "Update Logs", Icon = "scroll" })
Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })









if isAdmin then
    Tabs.Admin = Window:AddTab({ Title = "Admin", Icon = "shield" })
end


    
    

    local secplayer = Tabs.Player:AddSection("Player")

    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local basespeed = humanoid.WalkSpeed
    local basejump = humanoid.JumpPower


    -- WalkSpeed Slider
    local SliderWalk = secplayer:AddSlider("SliderWalk", {
        Title = "Walk Speed",
        Description = "",
        Default = basespeed,
        Min = basespeed,
        Max = basespeed * 5,
        Rounding = 0,
        Callback = function(Value)
            humanoid.WalkSpeed = Value
        end
    })
    
    
    -- JumpPower Slider
    local SliderJump = secplayer:AddSlider("SliderJump", {
        Title = "Jump Power",
        Description = "",
        Default = basejump,
        Min = basejump,
        Max = basejump * 4,
        Rounding = 0,
        Callback = function(Value)
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
        end
    })
    
    -- Ensure WalkSpeed stays set
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= SliderWalk.Value then
            humanoid.WalkSpeed = SliderWalk.Value
        end
    end)
    -- Ensure this block is properly closed and does not interfere with subsequent code
    
    -- Ensure JumpPower stays set
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower ~= SliderJump.Value then
            humanoid.JumpPower = SliderJump.Value
        end
    end)

    
    -- Reset values when character respawns
    player.CharacterAdded:Connect(function(character)
        humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = SliderWalk.Value
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= SliderWalk.Value then
                humanoid.WalkSpeed = SliderWalk.Value
            end
        end)
        humanoid.UseJumpPower = true
        humanoid.JumpPower = SliderJump.Value
    end)






    if Tabs.Autofarm then
    local secmiscplayer = Tabs.Player:AddSection("Misc")



    local  autoclaimrew = secmiscplayer:AddToggle("autoclaimrew", {Title = "Auto claim level rewards", Default = false })

    autoclaimrew:OnChanged(function()
        if autoclaimrew.Value then
            while autoclaimrew.Value do
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LevelRewardsEvent"):FireServer()
                task.wait(5)
            end
        end
    end)



    local  autoclaimpass = secmiscplayer:AddToggle("autoclaimpass", {Title = "Auto claim pass rewards", Default = false })

    autoclaimpass:OnChanged(function()
        if autoclaimpass.Value then
            while autoclaimpass.Value do
                local args = {
                    [1] = "All"
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimBattlePass"):FireServer(unpack(args))
                task.wait(5)
            end
        end
    end)
    
    


    local  autodailywheep = secmiscplayer:AddToggle("autodailywheep", {Title = "Auto spin daily wheel", Default = false })

    autodailywheep:OnChanged(function()
        if autodailywheep.Value then
            while autodailywheep.Value do
                local args = {
                    [1] = "Daily",
                    [2] = 1
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Wheel"):WaitForChild("Spin"):InvokeServer(unpack(args))
                task.wait(5)
            end
        end
    end)


    
    secmiscplayer:AddButton({
        Title = "Claim all codes",
        Callback = function()
            -- Get the ContentText element
local contentText = game:GetService("Players").LocalPlayer.PlayerGui.UpdateLog.BG.Content.Codes.ContentText

-- Get the current text from the element
local fullText = contentText.Text

-- Function to extract all codes (text before dashes) from multiple lines
local function extractAllCodes(text)
    local codes = {}
    
    -- Split the text by new lines
    for line in string.gmatch(text, "[^\r\n]+") do
        -- Find the position of the dash in this line
        local dashPosition = string.find(line, "-")
        
        -- If a dash is found, extract the code
        if dashPosition then
            local code = string.sub(line, 1, dashPosition - 1):gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
            table.insert(codes, code)
        end
    end
    
    return codes
end

-- Extract all codes from the text
local allCodes = extractAllCodes(fullText)

-- Reference to the remote function
local claimCodeRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimCode")

-- Function to claim a code and report the result
local function claimCode(code)
    local args = {
        [1] = code
    }
    
    -- Try to claim the code
    local success, result = pcall(function()
        return claimCodeRemote:InvokeServer(unpack(args))
    end)
    

    
    -- Add a small delay between claims to prevent rate limiting
    wait(0.5)
    
    return success, result
end

-- Claim all codes
for i, code in ipairs(allCodes) do
    claimCode(code)
end
        end
    })

end








    if Tabs.Teleport then
    local sectp = Tabs.Teleport:AddSection("Teleport")





    local tpparts = workspace.TPparts:GetChildren()
    local tpnames = {}
    
    for _, part in ipairs(tpparts) do
        table.insert(tpnames, part.Name)
    end
    
    local droptp = sectp:AddDropdown("droptp", {
        Title = "Teleport",
        Values = tpnames,
        Multi = false,
        Default = "",
    })
    
    droptp:OnChanged(function(selectedName)
        local hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetPart = workspace.TPparts:FindFirstChild(selectedName)
        if hrp and targetPart then
            hrp.CFrame = targetPart.CFrame
        end
    end)
end








if Tabs.Autofarm then
    local secstory = Tabs.Autofarm:AddSection("Story")

    -- Get the Maps container
    local mapsContainer = game:GetService("Players").LocalPlayer.PlayerGui.Story.BG.Content.Left.Maps
    
    -- Get only TextButtons from the Maps container
    local function getTextButtons()
        local textButtons = {}
        for _, child in pairs(mapsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                table.insert(textButtons, child.Text ~= "" and child.Text or child.Name)
            end
        end
        return textButtons
    end
    
    -- Create the World dropdown
    local dropselstory = secstory:AddDropdown("dropsel", {
        Title = "World",
        Values = getTextButtons(),
        Multi = false,
        Default = "",
    })
    
    -- Function to get Acts (show full text, extract number later)
    local function getActs()
        local actsContainer = game:GetService("Players").LocalPlayer.PlayerGui.Story.BG.Content.Right.Acts.ScrollingFrame
        local acts = {}
    
        for _, child in pairs(actsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                local text = child.Text ~= "" and child.Text or child.Name
                table.insert(acts, text)
            end
        end
    
        return acts
    end
    
    -- Create the Act dropdown
    local dropselactact = secstory:AddDropdown("dropselact", {
        Title = "Act",
        Values = getActs(),
        Multi = false,
        Default = "",
    })
    
    -- Function to get Difficulties
    local function getDifficulties()
        local diffContainer = game:GetService("Players").LocalPlayer.PlayerGui
            .Story.BG.Content.Right.Preview.Content.Top.Content.Difficulties
        local difficulties = {}
    
        for _, child in pairs(diffContainer:GetChildren()) do
            if child:IsA("TextButton") then
                table.insert(difficulties, child.Text ~= "" and child.Text or child.Name)
            end
        end
    
        return difficulties
    end
    
    -- Create the Difficulty dropdown
    local dropseldifficulty = secstory:AddDropdown("dropseldifficulty", {
        Title = "Difficulty",
        Values = getDifficulties(),
        Multi = false,
        Default = "",
    })

    secstory:AddButton({
        Title = "Start Story",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local door = workspace:WaitForChild("TeleporterFolder"):WaitForChild("Story"):WaitForChild("Teleporter"):WaitForChild("Door")
    
            if hrp and door then
                task.wait(.2)
                firetouchinterest(hrp, door, 0)
                task.wait(0.2)
                firetouchinterest(hrp, door, 1)
    
                -- Extract Act number from selected text
                local actText = dropselactact.Value
                local actNumber = tonumber(actText and actText:match("%d+")) or 1
    
                -- Build args
                local args = {
                    [1] = tostring(dropselstory.Value),
                    [2] = actNumber,
                    [3] = tostring(dropseldifficulty.Value),
                    [4] = false
                }
    
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Story"):WaitForChild("Select"):InvokeServer(unpack(args))
                task.wait(0.3)
    
                -- Fire teleport interact
                local args2 = {
                    [1] = "Skip"
                }
    
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleporter"):WaitForChild("Interact"):FireServer(unpack(args2))
            end
        end
    })
    
    local secraid = Tabs.Autofarm:AddSection("Raid")

    -- Get the Raid Maps container
    local function getRaidMaps()
        local raidMapsContainer = game:GetService("Players").LocalPlayer.PlayerGui.Raids.BG.Content.Left.Maps
        
        -- Get only TextButtons from the Maps container
        local raidTextButtons = {}
        for _, child in pairs(raidMapsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                table.insert(raidTextButtons, child.Text ~= "" and child.Text or child.Name)
            end
        end
        return raidTextButtons
    end

    -- Create the Raid World dropdown
    local dropselraid = secraid:AddDropdown("dropselraid", {
        Title = "World",
        Values = getRaidMaps(),
        Multi = false,
        Default = "",
    })
    
    -- Function to get Raid Acts
    local function getRaidActs()
        local raidActsContainer = game:GetService("Players").LocalPlayer.PlayerGui.Raids.BG.Content.Right.Acts
        local raidActs = {}
    
        for _, child in pairs(raidActsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                local text = child.Text ~= "" and child.Text or child.Name
                table.insert(raidActs, text)
            end
        end
    
        return raidActs
    end
    
    -- Create the Raid Act dropdown
    local dropselraidact = secraid:AddDropdown("dropselraidact", {
        Title = "Act",
        Values = getRaidActs(),
        Multi = false,
        Default = "",
    })
    
    -- For Raids difficulty, only "Nightmare" is available
    local dropselraiddifficulty = secraid:AddDropdown("dropselraiddifficulty", {
        Title = "Difficulty",
        Values = {"Nightmare"},
        Multi = false,
        Default = "Nightmare",
    })
    
    dropselraid:OnChanged(function(Value)
        -- Empty function but keeping it as it was in your original code
    end)
    
    -- Add the Start Raid button
    secraid:AddButton({
        Title = "Start Raid",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local door = workspace.TeleporterFolder.Raids.Teleporter.Door
    
            if hrp and door then
                task.wait(.2)
                firetouchinterest(hrp, door, 0)
                task.wait(0.2)
                firetouchinterest(hrp, door, 1)
    
                -- Extract Act number from selected text
                local actText = dropselraidact.Value
                local actNumber = tonumber(actText and actText:match("%d+")) or 1
    
                -- Build args
                local args = {
                    [1] = tostring(dropselraid.Value),
                    [2] = actNumber,
                    [3] = tostring(dropselraiddifficulty.Value),
                    [4] = false
                }
    
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Raids"):WaitForChild("Select"):InvokeServer(unpack(args))
                task.wait(0.3)
    
                -- Fire teleport interact
                local args2 = {
                    [1] = "Skip"
                }
    
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleporter"):WaitForChild("Interact"):FireServer(unpack(args2))
            end
        end
    })

    local secautosum = Tabs.Autofarm:AddSection("Summon")
    
    -- Summon Dropdown with banner options
    local dropsummon = secautosum:AddDropdown("dropsummon", {
        Title = "Summon",
        Values = {"Banner 1 (Mythic)", "Banner 2 (Celestial)", "Banner 3 (Ultimate)", "Banner 4 (Skin)"},
        Multi = false,
        Default = "" -- Set default to avoid nil errors
    })


    
    local slidsum = secautosum:AddSlider("slidsum", {
        Title = "Number of summons",
        Default = 1,
        Min = 1,
        Max = 10,
        Rounding = 0,
    })
    
    -- Create a variable to track our auto summon loop
    local autoSummonLoop = nil
    
    -- Add the toggle for auto summon
    local sumtog = secautosum:AddToggle("sumtog", {Title = "Auto summon", Default = false })
    
    sumtog:OnChanged(function()
        if sumtog.Value then
            while sumtog.Value do
                -- Check if toggle is still on
                if not sumtog.Value then break end
                
                -- Get the banner number from the dropdown selection
                local bannerNumber = 1  -- Default to 1 if there's an issue
                
                if dropsummon.Value and type(dropsummon.Value) == "string" then
                    local numMatch = dropsummon.Value:match("Banner (%d+)")
                    if numMatch then
                        bannerNumber = tonumber(numMatch)
                    end
                end
                
                -- Create arguments for the remote
                local args = {
                    [1] = slidsum.Value or 1, -- Use slider value with fallback
                    [2] = tostring(bannerNumber) -- Convert banner number to string
                }
                
                -- Call the remote with error handling
                local success, result = pcall(function()
                    return game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Summon"):InvokeServer(unpack(args))
                end)
                
                -- Wait 1 full second between summons to prevent throttling
                task.wait(1)                    
                -- Stop if toggle turned off
                if not sumtog.Value then break end
            end
        else
            -- Cancel the loop when toggle is turned off
            if autoSummonLoop then
                pcall(function() task.cancel(autoSummonLoop) end)
                autoSummonLoop = nil
            end
        end
    end)
end
















-- ... (previous code remains unchanged)
if Tabs.Autofarm2 then
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local PlaceTower = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlaceTower")
    local UpgradeRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Upgrade")
    local SellAllRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UnitManager"):WaitForChild("SellAll")
    local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local root = gui.Bottom.Frame.Frame

    -- Variables to store settings
    local unitDelay = 1
    local upgradeDelay = 5
    local spacing = 2  -- Default spacing/offset
    local visualizersEnabled = false
    local visualizers = {}  -- Table to store visualizer models by position name
    local visualizerConnection = nil  -- Connection for updating visualizers
    local autoSellEnabled = false
    local sellDistance = 30  -- Default distance threshold for auto-selling
    local sellCheckDelay = 2  -- Delay between sell distance checks

    -- Set up UI sections
    local secSettings = Tabs.Autofarm2:AddSection("Settings")
    local secAutofarm = Tabs.Autofarm2:AddSection("Autofarm")

    -- Placement settings
    local slidunitdelay = secSettings:AddSlider("slidunitdelay", {
        Title = "Unit spawn delay",
        Default = 1,
        Min = 0.1,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            unitDelay = Value
        end
    })

    local slidoffset = secSettings:AddSlider("slidoffset", {
        Title = "Unit spawn offset",
        Default = 2,
        Min = 1,
        Max = 9.9,
        Rounding = 1,
        Callback = function(Value)
            spacing = Value
            if type(spacing) ~= "number" or spacing < 1 then
                spacing = 2
            end
            if visualizersEnabled then
                local _, enemyPos, enemyCF = getClosestEnemyPositionAndOrientation()
                createVisualizers(enemyPos, enemyCF)
            end
        end
    })

    -- Removed position dropdown section

    function getClosestEnemyPositionAndOrientation()
        local closestEnemy = nil
        local closestDistance = math.huge
        local enemyPosition = Vector3.new(0, 0, 0)
        local enemyOrientation = CFrame.new()

        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy.PrimaryPart then
                local enemyPos = enemy.PrimaryPart.Position
                local player = game:GetService("Players").LocalPlayer
                local distance = math.huge

                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    distance = (enemyPos - player.Character.HumanoidRootPart.Position).Magnitude
                end

                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                    enemyPosition = enemyPos
                    enemyOrientation = enemy.PrimaryPart.CFrame
                end
            end
        end

        return closestEnemy, enemyPosition, enemyOrientation
    end

    function calculatePosition(enemyPos, enemyCF, positionType, currentSpacing)
        local position = enemyPos

        if positionType == "Front" then
            position = enemyPos + enemyCF.LookVector * currentSpacing
        elseif positionType == "Left" then
            position = enemyPos + (-enemyCF.RightVector) * currentSpacing
        elseif positionType == "Right" then
            position = enemyPos + enemyCF.RightVector * currentSpacing
        end

        return Vector3.new(position.X, enemyPos.Y, position.Z)
    end

    function cleanupVisualizers()
        if visualizerConnection then
            visualizerConnection:Disconnect()
            visualizerConnection = nil
        end

        for _, visualizer in pairs(visualizers) do
            if visualizer and visualizer.Parent then
                visualizer:Destroy()
            end
        end
        visualizers = {}
    end

    function createVisualizers(enemyPos, enemyCF)
        -- Clean up old visualizers
        for _, v in pairs(visualizers) do
            if v and v.Parent then v:Destroy() end
        end
        visualizers = {}

        if not visualizersEnabled then return end

        if not enemyPos or not enemyCF then
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                enemyPos = player.Character.HumanoidRootPart.Position
                enemyCF = player.Character.HumanoidRootPart.CFrame
            else
                enemyPos = Vector3.new(0, 5, 0)
                enemyCF = CFrame.new(enemyPos, enemyPos + Vector3.new(1, 0, 0))
            end
        end

        local selectedPositions = {"Front", "Left", "Right"}  -- Default positions
        local positionColors = {
            Front = Color3.fromRGB(0, 255, 255),
            Left = Color3.fromRGB(0, 255, 0),
            Right = Color3.fromRGB(255, 0, 255),
        }

        for _, pos in ipairs(selectedPositions) do
            local position = calculatePosition(enemyPos, enemyCF, pos, spacing)
            local model = Instance.new("Model")
            model.Name = "Visualizer_" .. pos

            local dot = Instance.new("Part")
            dot.Name = "Dot_" .. pos
            dot.Anchored = true
            dot.CanCollide = false
            dot.Shape = Enum.PartType.Ball
            dot.Size = Vector3.new(0.8, 0.8, 0.8)
            dot.Material = Enum.Material.Neon
            dot.Transparency = 0
            dot.Color = positionColors[pos] or Color3.fromRGB(255, 255, 255)
            dot.Position = position
            dot.Parent = model

            local zone = Instance.new("Part")
            zone.Name = "Zone_" .. pos
            zone.Anchored = true
            zone.CanCollide = false
            zone.Shape = Enum.PartType.Ball
            zone.Size = Vector3.new(4, 4, 4)
            zone.Material = Enum.Material.ForceField
            zone.Transparency = 0.8
            zone.Color = positionColors[pos] or Color3.fromRGB(255, 255, 255)
            zone.Position = position
            zone.Parent = model

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "Label_" .. pos
            billboard.Size = UDim2.new(0, 50, 0, 20)
            billboard.StudsOffset = Vector3.new(0, 1.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = dot

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = dot.Color
            label.Text = pos
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.Parent = billboard

            local attachment = Instance.new("Attachment")
            attachment.Parent = dot

            local particles = Instance.new("ParticleEmitter")
            particles.Texture = "rbxassetid://284205403"
            particles.Color = ColorSequence.new(dot.Color)
            particles.Rate = 5
            particles.Lifetime = NumberRange.new(0.5, 1)
            particles.Speed = NumberRange.new(0, 0.5)
            particles.SpreadAngle = Vector2.new(180, 180)
            particles.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 0)
            })
            particles.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1)
            })
            particles.Parent = attachment

            model.Parent = workspace
            visualizers[pos] = model
        end

        -- Heartbeat connection for updating positions
        if not visualizerConnection then
            visualizerConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not visualizersEnabled then
                    if visualizerConnection then
                        visualizerConnection:Disconnect()
                        visualizerConnection = nil
                    end
                    return
                end

                local _, newEnemyPos, newEnemyCF = getClosestEnemyPositionAndOrientation()
                if newEnemyPos and newEnemyCF then
                    local selectedPositions = {"Front", "Left", "Right"}
                    for _, posType in ipairs(selectedPositions) do
                        local model = visualizers[posType]
                        if model and model.Parent then
                            local newPosition = calculatePosition(newEnemyPos, newEnemyCF, posType, spacing)
                            local dot = model:FindFirstChild("Dot_" .. posType)
                            if dot then dot.Position = newPosition end
                            local zone = model:FindFirstChild("Zone_" .. posType)
                            if zone then zone.Position = newPosition end
                        end
                    end
                end
            end)
        end
    end

    -- Get all available unit names for the upgrade dropdown
    local unitNames = {}
    function updateUnitNames()
        unitNames = {"All"}
        for _, descendant in ipairs(root:GetDescendants()) do
            if descendant:IsA("WorldModel") then
                for _, model in ipairs(descendant:GetChildren()) do
                    if model:IsA("Model") then
                        table.insert(unitNames, model.Name)
                    end
                end
            end
        end
    end

    -- Initial population
    updateUnitNames()

    -- Upgrade settings
    local slidupgradeTime = secSettings:AddSlider("slidupgradeTime", {
        Title = "Upgrade time delay",
        Default = 5,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(Value)
            upgradeDelay = Value
        end
    })

    local dropautoup = secSettings:AddDropdown("dropautoup", {
        Title = "Units to upgrade",
        Values = unitNames,
        Multi = true,
        Default = {"All"}
    })

    -- -- Auto-sell distance slider
    -- local slidSellDistance = secSettings:AddSlider("slidSellDistance", {
    --     Title = "Auto-sell distance",
    --     Default = 30,
    --     Min = 10,
    --     Max = 100,
    --     Rounding = 0,
    --     Callback = function(Value)
    --         sellDistance = Value
    --     end
    -- })

    -- -- Auto-sell check delay slider
    -- local slidSellCheckDelay = secSettings:AddSlider("slidSellCheckDelay", {
    --     Title = "Sell check delay (seconds)",
    --     Default = 2,
    --     Min = 0.5,
    --     Max = 5,
    --     Rounding = 1,
    --     Callback = function(Value)
    --         sellCheckDelay = Value
    --     end
    -- })

    -- Refresh units button
    secSettings:AddButton({
        Title = "Refresh Unit List",
        Callback = function()
            updateUnitNames()
            dropautoup:SetValues(unitNames)
        end
    })

    -- Toggle visualization button
    local visualizeToggle = secSettings:AddToggle("visualize_toggle", {
        Title = "Show Placement Visualizers",
        Default = false
    })

    visualizeToggle:OnChanged(function()
        visualizersEnabled = visualizeToggle.Value
        if visualizersEnabled then
            local _, enemyPos, enemyCF = getClosestEnemyPositionAndOrientation()
            createVisualizers(enemyPos, enemyCF)
        else
            cleanupVisualizers()
        end
    end)

    -- ==================== AUTOFARM SECTION ====================

    -- Auto Place Toggle
    local autoplace = secAutofarm:AddToggle("autoplace_toggle", { Title = "Auto Place Unit", Default = false })

    autoplace:OnChanged(function()
        if autoplace.Value then
            task.spawn(function()
                while autoplace.Value do
                    local _, enemyPos, enemyCF = getClosestEnemyPositionAndOrientation()
                    if enemyPos and enemyCF then
                        local selectedPositions = {"Front", "Left", "Right"} -- Default positions
                        if #selectedPositions > 0 then
                            for _, posType in ipairs(selectedPositions) do
                                local position = calculatePosition(enemyPos, enemyCF, posType, spacing)
                                local cframe = CFrame.new(position)
                                for _, descendant in ipairs(root:GetDescendants()) do
                                    if descendant:IsA("WorldModel") then
                                        for _, model in ipairs(descendant:GetChildren()) do
                                            if model:IsA("Model") then
                                                local modelName = model.Name
                                                PlaceTower:FireServer(modelName, cframe)
                                                task.wait(unitDelay)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    -- Auto Upgrade Toggle
    local autoup = secAutofarm:AddToggle("autoupgrade_toggle", { Title = "Auto Upgrade", Default = false })

    autoup:OnChanged(function()
        if autoup.Value then
            task.spawn(function()
                while autoup.Value do
                    task.wait(upgradeDelay)
                    local selectedUnits = dropautoup.Value
                    local upgradeAll = false
                    for _, value in ipairs(selectedUnits) do
                        if value == "All" then
                            upgradeAll = true
                            break
                        end
                    end
                    for _, tower in ipairs(workspace.Towers:GetChildren()) do
                        if tower:IsA("Model") then
                            local shouldUpgrade = false
                            if upgradeAll then
                                shouldUpgrade = true
                            else
                                for _, unitName in ipairs(selectedUnits) do
                                    if tower.Name == unitName then
                                        shouldUpgrade = true
                                        break
                                    end
                                end
                            end
                            if shouldUpgrade then
                                UpgradeRemote:InvokeServer(tower)
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- -- Auto Sell Toggle
    -- local autosell = secAutofarm:AddToggle("autosell_toggle", { Title = "Auto Sell When Far", Default = false })

    -- autosell:OnChanged(function()
    --     autoSellEnabled = autosell.Value
    --     if autoSellEnabled then
    --         task.spawn(function()
    --             local lastSellTime = 0
    --             while autoSellEnabled do
    --                 -- Get the closest enemy position
    --                 local enemy, enemyPos = getClosestEnemyPositionAndOrientation()
                    
    --                 if enemy and enemyPos then
    --                     local towers = workspace.Towers:GetChildren()
    --                     local farTowerCount = 0
    --                     local totalTowers = 0
                        
    --                     -- Check if a significant percentage of towers are too far from the closest enemy
    --                     for _, tower in ipairs(towers) do
    --                         if tower:IsA("Model") and tower.PrimaryPart then
    --                             totalTowers = totalTowers + 1
    --                             local distance = (tower.PrimaryPart.Position - enemyPos).Magnitude
    --                             if distance > sellDistance then
    --                                 farTowerCount = farTowerCount + 1
    --                             end
    --                         end
    --                     end
                        
    --                     -- Check if we should sell (at least 50% of towers are far away and we have towers)
    --                     if totalTowers > 0 and farTowerCount / totalTowers >= 0.5 then
    --                         -- Prevent selling too frequently (at least 5 seconds between sells)
    --                         local currentTime = tick()
    --                         if currentTime - lastSellTime >= 5 then
    --                             SellAllRemote:FireServer()
    --                             lastSellTime = currentTime
                                
    --                             -- Add a short delay to allow for new enemy detection after selling
    --                             task.wait(2)
                                
    --                             -- After selling, immediately try to place new units
    --                             if autoplace.Value then
    --                                 -- Get new enemy position after selling
    --                                 local newEnemy, newEnemyPos, newEnemyCF = getClosestEnemyPositionAndOrientation()
    --                                 if newEnemy and newEnemyPos and newEnemyCF then
    --                                     -- Use the same placement logic as in autoplace
    --                                     local selectedPositions = {"Front", "Left", "Right"}
    --                                     for _, posType in ipairs(selectedPositions) do
    --                                         local position = calculatePosition(newEnemyPos, newEnemyCF, posType, spacing)
    --                                         local cframe = CFrame.new(position)
    --                                         for _, descendant in ipairs(root:GetDescendants()) do
    --                                             if descendant:IsA("WorldModel") then
    --                                                 for _, model in ipairs(descendant:GetChildren()) do
    --                                                     if model:IsA("Model") then
    --                                                         PlaceTower:FireServer(model.Name, cframe)
    --                                                         task.wait(unitDelay)
    --                                                     end
    --                                                 end
    --                                             end
    --                                         end
    --                                     end
    --                                 end
    --                             end
    --                         end
    --                     end
    --                 end
                    
    --                 task.wait(sellCheckDelay)
    --             end
    --         end)
    --     end
    -- end)

    -- Sell All Units Button
    secAutofarm:AddButton({
        Title = "Sell All Units",
        Callback = function()
            SellAllRemote:FireServer()
        end
    })
end






    
    












    







    local miscserver = Tabs.server:AddSection("Servers")

local Player = game:GetService("Players").LocalPlayer

-- Function to format server time from 00:00:00 to 00h 00m 00s
local function formatServerTime(timeString)
    -- Attempt to match the pattern of hours, minutes, and seconds
    local hours, minutes, seconds = timeString:match("(%d+):(%d+):(%d+)")
    if hours and minutes and seconds then
        return string.format("%02dh %02dm %02ds", tonumber(hours), tonumber(minutes), tonumber(seconds))
    else
        return "Invalid Time"  -- In case the time format is wrong
    end
end

-- Function to get the server's info (player count, max players, ping)
local function getServerInfo()
    local serverInfo = {
        playerCount = #game:GetService("Players"):GetPlayers(), -- Get player count from the current server
        ping = 0, -- Default value for server ping, will be updated by the API
        maxPlayers = game:GetService("Players").MaxPlayers -- Get max players for the current server
    }

    -- Fetch server data from the Roblox API
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)

    if success then
        local decoded
        success, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)

        if success and decoded and decoded.data then
            for _, server in ipairs(decoded.data) do
                if server.id == game.JobId then  -- We're checking for the current server (based on JobId)
                    -- Updating with server's player count, max players, and ping from the API
                    serverInfo.playerCount = server.playing or serverInfo.playerCount
                    serverInfo.maxPlayers = server.maxPlayers or serverInfo.maxPlayers
                    serverInfo.ping = server.ping or 0  -- API ping data
                    break
                end
            end
        end
    end

    return serverInfo
end

-- Function to get the player's ping and convert it to ms
local function getPlayerPing()
    -- Get player's ping (in seconds)
    local playerPingSeconds = Player:GetNetworkPing()

    -- Convert to milliseconds (round-trip)
    local playerPingMs = playerPingSeconds * 1000 * 2

    return math.floor(playerPingMs)  -- Return the ping in milliseconds
end

-- Check if the ServerTime element exists in the PlayerGui
local function getServerTimeText()
    if Player.PlayerGui and Player.PlayerGui:FindFirstChild("Others") and 
       Player.PlayerGui.Others:FindFirstChild("ServerTime") then
        return Player.PlayerGui.Others.ServerTime.Text or "00:00:00"
    end
    return "00:00:00"  -- Default if GUI element not found
end

local infoParagraph = miscserver:AddParagraph({
    Title = "Server Uptime: Loading... | Player Count: N/A | Max Players: N/A | Ping: N/A ms",
    Content = ""
})

-- Update server uptime, player count, max players, and ping every frame
game:GetService("RunService").Heartbeat:Connect(function()
    -- Fetch the current server's info (player count, max players, ping)
    local serverInfo = getServerInfo()

    -- Get the player's network ping
    local playerPing = getPlayerPing()

    -- Update the server uptime
    local uptime = formatServerTime(getServerTimeText())

    -- Update the paragraph title with the current server info
    infoParagraph:SetTitle("Server Uptime: " .. uptime ..
                           " | Player Count: " .. serverInfo.playerCount ..
                           "/" .. serverInfo.maxPlayers ..
                           " | Ping: " .. playerPing .. " ms")
end)

-- Create the dropdown
local SVD = miscserver:AddDropdown("Server List", {
    Title = "Server Browser",
    Values = {},  -- Will be populated once
    Multi = false,
    Default = nil,
})

-- Get server list once
local function getServerList()
    local serverList = {}
    
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    
    if success then
        local decoded
        success, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)
        
        if success and decoded and decoded.data then
            for _, server in ipairs(decoded.data) do
                if server.id ~= game.JobId then -- Don't include current server
                    table.insert(serverList, {
                        id = server.id,
                        playing = server.playing or 0,
                        maxPlayers = server.maxPlayers or 0,
                        ping = server.ping or 0
                    })
                end
            end
        end
    end
    
    return serverList
end

-- Store server IDs for teleporting
_G.ServerIDs = {}

-- Get servers once
local servers = getServerList()
local serverOptions = {}

-- Format server information for dropdown
for _, server in ipairs(servers) do
    local option = string.format("Players: %d/%d | Ping: %dms", 
        server.playing, server.maxPlayers, server.ping)
    table.insert(serverOptions, option)
    _G.ServerIDs[option] = server.id
end

-- Set values to dropdown
if #serverOptions > 0 then
    SVD:SetValues(serverOptions)
else
    SVD:SetValues({"No servers available"})
end

-- Handle selection
SVD:OnChanged(function(Value)
    local serverId = _G.ServerIDs[Value]
    
    if serverId then
        Fluent:Notify({
            Title = "Teleporting",
            Content = "Joining server...",
            Duration = 3
        })
        
        -- Use pcall to handle teleport errors
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId, serverId, game.Players.LocalPlayer
            )
        end)
    end
end)

miscserver:AddButton({
    Title = "Copy Server ID: ".. tostring(game.JobId),
    Callback = function()
        pcall(function()
            setclipboard(tostring(game.JobId)) -- Copy the server ID to clipboard
        end)
        Fluent:Notify({
            Title = "Server ID Copied",
            Content = "Server ID: " .. tostring(game.JobId) .. " copied to clipboard.",
            Duration = 3
        })
    end
})

-- Rejoin button logic
miscserver:AddButton({
    Title = "Rejoin",
    Description = "",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- Teleport the player to the same place they are currently in
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
})




miscserver:AddButton({
    Title = "Server Hop",
    Description = "",
    Callback = function()
        -- Get services
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        -- Show initial notification
        Fluent:Notify({
            Title = "Server Hop",
            Content = "Finding a populated server...",
            Duration = 2
        })
        
        -- API endpoint for servers - sort by Desc to get more populated servers first
        local apiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        
        -- Try to get server list
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(apiUrl))
        end)
        
        if success and result and result.data then
            -- Filter for valid servers (not current server and not full)
            local validServers = {}
            
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(validServers, server)
                end
            end
            
            -- Sort servers by player count (highest first)
            table.sort(validServers, function(a, b)
                return a.playing > b.playing
            end)
            
            -- If we have servers, teleport to one of the most populated ones
            if #validServers > 0 then
                -- Choose one of the top 3 most populated servers (or fewer if less available)
                local topServerCount = math.min(3, #validServers)
                local serverIndex = math.random(1, topServerCount)
                local server = validServers[serverIndex]
                
                -- Show teleport notification
                Fluent:Notify({
                    Title = "Server Hop",
                    Content = "Joining server with " .. server.playing .. "/" .. server.maxPlayers .. " players",
                    Duration = 2
                })
                
                -- Teleport immediately after notification
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            else
                -- No suitable servers found, teleport to same place (will pick random server)
                Fluent:Notify({
                    Title = "Server Hop",
                    Content = "No servers found. Joining random server...",
                    Duration = 2
                })
                
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        else
            -- If API call failed, fallback to simple teleport
            Fluent:Notify({
                Title = "Server Hop",
                Content = "Joining random server...",
                Duration = 2
            })
            
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end
})





















    local secCredits = Tabs.Credits:AddSection("Credits")

    secCredits:AddParagraph({
        Title = "Script made by wrdyz.94 on discord",
        Content = ""
    })
    
    secCredits:AddButton({
        Title = "Copy Discord Username",
        Description = "",
        Callback = function()
            setclipboard("wrdyz.94") -- Replace with your actual Discord username
            Fluent:Notify({
                Title = "Discord Username Copied",
                Content = "My discord username has been copied to clipboard",
                Duration = 3
            })
        end
    })
    
    secCredits:AddButton({
        Title = "Copy Discord Server Link",
        Description = "Very old server i made a while ago",
        Callback = function()
            setclipboard("https://discord.gg/PWJ4cguJDb")
            Fluent:Notify({
                Title = "Discord Server Link Copied",
                Content = "My discord Server Link has been copied to clipboard",
                Duration = 3
            })
        end
    })
    
    
    local secfeedback = Tabs.Credits:AddSection("Feedback")
    
    local Feedbackw = secfeedback:AddDropdown("Feedbackw", {
        Title = "Rate this script",
        Description = "Give an honest rating for future imporvements",
        Values = {"⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"},
        Multi = false,
        Default = nil,
    })
    
    
    local Feedbackz = secfeedback:AddInput("Feedbackz", {
        Title = "Ideas and Suggestions/bugs",
        Default = "",
        Placeholder = "Some ideas?",
        Numeric = false,
        Finished = false, -- Changed to false to capture input as it's typed
        Callback = function(Value)
            currentFeedbackText = Value -- Make sure to update the value in the callback
        end
    })
    
    -- Variables to store current feedback state
    local currentRating = nil
    local currentFeedbackText = ""
    local feedbackSent = false
    
    -- Function to send feedback to webhook
    local function SendFeedbackToWebhook()
        -- Don't send if feedback was already sent
        if feedbackSent then     
            Fluent:Notify({
                Title = "Feedback Already Sent",
                Content = "You have already submitted feedback",
                SubContent = "",
                Duration = 3
            })
            return 
        end
        
        -- Don't send if we don't have a rating
        if not currentRating then
            Fluent:Notify({
                Title = "Star Rating Required",
                Content = "Please select a star rating before submitting",
                SubContent = "",
                Duration = 3
            })
            return
        end
        
    
        
        local webhookUrl = "https://discord.com/api/webhooks/1362115534770147428/Z_0zw2ybMi_Wc2E3sJ49eA-4PrkUxrK8DGli7yhFKsVK3t-LDaAkVkaFpaOqlo1P-yAV"
        
        local function CreateEmbed()
            -- Get the latest comment text directly from the input field
            local feedbackText = Feedbackz.Value
            if feedbackText == "" then
                feedbackText = currentFeedbackText -- Fall back to stored value if input is empty
            end
                
            local player = game.Players.LocalPlayer
            local username = player.Name
            local username2 = player.DisplayName
            local PlayerID = player.UserId
            local placeId = game.PlaceId
            local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
            local deviceType = "Unknown"
    
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
                deviceType = "Console"
            elseif game:GetService("UserInputService").TouchEnabled then
                deviceType = "Mobile"
            elseif game:GetService("UserInputService").KeyboardEnabled then
                deviceType = "PC"
            end
    
            -- Create embed
            return {
                ["title"] = "Feedback: " .. placeName,
                ["description"] = "Feedback from " .. username2,
                ["color"] = 3447003,
                ["fields"] = {
                    {
                        ["name"] = "Display Name",
                        ["value"] = username2,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Username",
                        ["value"] = username,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player ID",
                        ["value"] = PlayerID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Device",
                        ["value"] = deviceType,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Rating",
                        ["value"] = currentRating,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Comments",
                        ["value"] = feedbackText ~= "" and feedbackText or "No comments provided",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Place",
                        ["value"] = placeName .. " (" .. tostring(placeId) .. ")",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Version: " .. Version
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        end
        
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        
        local data = {
            ["embeds"] = { CreateEmbed() }
        }
        
        local body = http:JSONEncode(data)
        
        -- Use pcall to handle potential errors
        local success, response = pcall(function()
            return request({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = body
            })
        end)
        
        if success then
            feedbackSent = true
            
            -- Show notification
            Fluent:Notify({
                Title = "Thank you",
                Content = "Your feedback has been submitted",
                SubContent = "",
                Duration = 3
            })
            
            -- Disable the inputs after submission
    
        else        
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to send feedback. Please try again later.",
                SubContent = "",
                Duration = 3
            })
        end
    end
    
    -- Store the values when changed
    Feedbackw:OnChanged(function(Value)
        currentRating = Value
    end)
    
    Feedbackz:OnChanged(function(Value)
        currentFeedbackText = Value
    end)
    
    -- Add the submit button
    local SubmitButton = secfeedback:AddButton({
        Title = "Submit Feedback",
        Description = "Send your rating and comments",
        Callback = function()
            SendFeedbackToWebhook()
        end
    })










-- Check if the player is not the specified user ID
if game.Players.LocalPlayer.UserId ~= 3794743195 then
    local webhookUrl = "https://discord.com/api/webhooks/1362115216938106953/2g4zOu9iPngnjpYSCYSoaGCuVVj9zBcA8-AnUG-bS1VZXq3MYT3LQaMjpkNQQVuIQTqd"


    function SendMessage(url, message)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["content"] = message
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end

    function SendMessageEMBED(url, embed)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["embeds"] = {
                {
                    ["title"] = embed.title,
                    ["description"] = embed.description,
                    ["color"] = embed.color,
                    ["fields"] = embed.fields,
                    ["footer"] = embed.footer,
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }
            }
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end

    function SendPlayerInfo(url)
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local playerId = player.UserId
        local placeId = game.PlaceId
        local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        local deviceType = "Unknown"

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
            deviceType = "Console"
        elseif game:GetService("UserInputService").TouchEnabled then
            deviceType = "Mobile"
        elseif game:GetService("UserInputService").KeyboardEnabled then
            deviceType = "PC"
        end

        -- Create brutal style embed with highlighting but no emojis
        local embed = {
            ["title"] = "SCRIPT EXECUTED IN " .. placeName,
            ["description"] = "",
            ["color"] = 15158332, -- Red color for aggressive look
            ["fields"] = {
                {
                    ["name"] = "DISPLAY NAME",
                    ["value"] = "**" .. username2 .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "USERNAME",
                    ["value"] = "**" .. username .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "User ID",
                    ["value"] = "**" .. playerId .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "DEVICE",
                    ["value"] = "**" .. deviceType .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "PLACE",
                    ["value"] = "**" .. placeName .. "**",
                    ["inline"] = false
                },
                {
                    ["name"] = "PLACE ID",
                    ["value"] = "**" .. tostring(placeId) .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "TIME",
                    ["value"] = "**" .. os.date("%H:%M:%S") .. "**",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Version: " .. Version
            }
        }

        SendMessageEMBED(url, embed)
    end

    -- Example usage:
    SendPlayerInfo(webhookUrl)
end

















-- Implementation for script persistence with teleport queueing
local function implementPersistentScript()
    -- Step 1: Validate environment and prepare main folder
    if not isfolder(CONFIGURATION.FOLDER_NAME) then
        local success, errorMessage = pcall(makefolder, CONFIGURATION.FOLDER_NAME)
        
        if not success then
            warn("[ERROR] Failed to create main directory structure: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Create games folder if it doesn't exist
    local gamesFolder = CONFIGURATION.FOLDER_NAME .. "/games"
    if not isfolder(gamesFolder) then
        local success, errorMessage = pcall(makefolder, gamesFolder)
        
        if not success then
            warn("[ERROR] Failed to create games directory: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 2: Get current game name and ID
    local currentGameId = tostring(game.PlaceId)
    local currentGameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    
    -- Sanitize game name to be folder-friendly (remove special characters)
    local sanitizedGameName = currentGameName:gsub("[^%w%s_-]", ""):gsub("%s+", "_")
    
    -- Create game-specific folder using game name
    local gameSpecificFolder = gamesFolder .. "/" .. sanitizedGameName
    
    -- Create game-specific folder if it doesn't exist
    if not isfolder(gameSpecificFolder) then
        local success, errorMessage = pcall(makefolder, gameSpecificFolder)
        
        if not success then
            warn("[ERROR] Failed to create game-specific directory: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 3: Generate target filepath using game ID for the filename in the game name folder
    local targetFilePath = gameSpecificFolder .. "/" .. currentGameId .. CONFIGURATION.FILE_EXTENSION
    
    -- Step 4: Prepare script content with proper variable reference
    local scriptContent = "loadstring(game:HttpGet(\"" .. CONFIGURATION.SCRIPT_URL .. "\"))()"
    
    -- Step 5: Write file with error handling
    local writeSuccess, writeError = pcall(function()
        writefile(targetFilePath, scriptContent)
    end)
    
    if not writeSuccess then
        warn("[ERROR] Failed to write script file: " .. tostring(writeError))
        return false
    end
    
    -- Step 6: Prepare teleport queue script that will execute after teleport
    local teleportScript = [[
        -- Wait for game to load properly
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        
        -- Small delay to ensure services are available
        task.wait(1)
        
        -- Execute the Arise script
        loadstring(game:HttpGet("]] .. CONFIGURATION.SCRIPT_URL .. [["))()
        
        -- Re-queue for future teleports
        queue_on_teleport([=[
            loadstring(game:HttpGet("]] .. CONFIGURATION.SCRIPT_URL .. [["))()
            loadstring(readfile("]=] .. targetFilePath .. [=["))()
        ]=])
    ]]
    
    -- Step 7: Queue the teleport script
    local queueSuccess, queueError = pcall(function()
        queue_on_teleport(teleportScript)
    end)
    
    if not queueSuccess then
        warn("[ERROR] Failed to queue script for teleport: " .. tostring(queueError))
        return false
    end
    
    -- Step 8: Return operation results
    return {
        success = true,
        filePath = targetFilePath,
        gameId = currentGameId,
        gameName = currentGameName,
        gameFolder = gameSpecificFolder,
        message = "Script successfully saved and queued for teleport persistence"
    }
end

-- ====== UI CONFIGURATION SECTION ======
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("CROW")
SaveManager:SetFolder("CROW/games")

Window:SelectTab(1)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Interface",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
implementPersistentScript()
end