local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DYHUB | The Strongest Battleground (dsc.gg/dyhub)",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "DYHUB | dsc.gg/dyhub",
   LoadingSubtitle = "Powered by DYHUB TEAM",
   ShowText = "gurt yo", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Dark Blue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = ud, -- Create a custom folder for your hub/game
      FileName = "DYHUBTSB"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- Create Tabs
local MiscTab = Window:CreateTab("Misc", 4483362458)
local LocalTab = Window:CreateTab("Local", 4483362458)
local EspTab = Window:CreateTab("Esp", 4483362458)
local DummyTab = Window:CreateTab("Dummy", 4483362458)
local TechTab = Window:CreateTab("Tech", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local AutoBlockTab = Window:CreateTab("Auto Block", 4483362458)
local AdminTab = Window:CreateTab("Admin", 4483362458)

-- Misc Tab
MiscTab:CreateButton({
   Name = "M1 Reach",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/M1%20Reach%20Rework"))()
   end,
})

MiscTab:CreateButton({
   Name = "Aimbot",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Aimlock%20By%20YQANTG"))()
   end,
})

MiscTab:CreateButton({
   Name = "FaceLock",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/Tsb/FACELOCK"))()
   end,
})

MiscTab:CreateButton({
   Name = "Block Aimlock",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Block%20Aimlock"))()
   end,
})

MiscTab:CreateButton({
   Name = "Orbit",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Orbit%20by%20YQANTG"))()
   end,
})

MiscTab:CreateButton({
   Name = "Fake Dash ( Q )",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Fake%20Dash%20Q"))()
   end,
})

MiscTab:CreateButton({
   Name = "No Slide Dash EndLag",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/No-endlag-side-dash/refs/heads/main/No%20endlag%20side%20dash"))()
   end,
})

MiscTab:CreateButton({
   Name = "Keyboard",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Delta-Scripts/refs/heads/main/MobileKeyboard.txt"))()
   end,
})

-- Local Tab
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local auraOn = false
local auraHighlight = nil
local auraParticles = {}
local auraColorTime = 0
local auraLoop = nil

local function enableAura()
   -- Animation
   local anim = Instance.new("Animation")
   anim.AnimationId = "rbxassetid://114586157428274"
   local track = humanoid:LoadAnimation(anim)
   track:Play()

   -- Highlight
   auraHighlight = Instance.new("Highlight")
   auraHighlight.Adornee = char
   auraHighlight.FillTransparency = 1
   auraHighlight.OutlineTransparency = 0
   auraHighlight.OutlineColor = Color3.fromRGB(255, 0, 255)
   auraHighlight.Parent = char

   -- Particles
   for _, partName in pairs({"UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
      local part = char:FindFirstChild(partName)
      if part then
         local att = Instance.new("Attachment", part)
         local particle = Instance.new("ParticleEmitter", att)
         particle.Name = "DarkAura"
         particle.Rate = 30
         particle.Lifetime = NumberRange.new(1.2, 2)
         particle.Speed = NumberRange.new(2, 5)
         particle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 0) })
         particle.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
         particle.Color = ColorSequence.new(Color3.fromRGB(15, 15, 15))
         particle.Rotation = NumberRange.new(0, 360)
         particle.RotSpeed = NumberRange.new(-90, 90)
         particle.SpreadAngle = Vector2.new(180, 180)
         particle.ZOffset = -1
         table.insert(auraParticles, particle)
      end
   end

   -- Rainbow Highlight
   auraLoop = game:GetService("RunService").RenderStepped:Connect(function(dt)
      if auraOn and auraHighlight then
         auraColorTime += dt * 0.25
         local r = math.sin(auraColorTime) * 127 + 128
         local g = math.sin(auraColorTime + 2) * 127 + 128
         local b = math.sin(auraColorTime + 4) * 127 + 128
         auraHighlight.OutlineColor = Color3.fromRGB(r, g, b)
      end
   end)
end

local function disableAura()
   if auraHighlight then
      auraHighlight:Destroy()
      auraHighlight = nil
   end
   for _, p in pairs(auraParticles) do
      if p then p:Destroy() end
   end
   auraParticles = {}

   if auraLoop then
      auraLoop:Disconnect()
      auraLoop = nil
   end
end

LocalTab:CreateToggle({
   Name = "Aura ( Client )",
   CurrentValue = false,
   Flag = "AuraToggle",
   Callback = function(Value)
      auraOn = Value
      if Value then
         enableAura()
      else
         disableAura()
      end
   end,
})

-- Invisible Block
local blockEnabled = false
local targetAnimationId = "rbxassetid://10470389827"
local blockConnection = nil
local blockLoop = nil

local function blockAnimation(humanoid)
   for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
      if track.Animation and track.Animation.AnimationId == targetAnimationId then
         track:Stop()
         track:Destroy()
      end
   end
end

local function enableBlock()
   local char = player.Character or player.CharacterAdded:Wait()
   local humanoid = char:WaitForChild("Humanoid")

   blockLoop = task.spawn(function()
      while blockEnabled and humanoid and humanoid.Parent do
         blockAnimation(humanoid)
         task.wait(0.05)
      end
   end)

   blockConnection = humanoid.AnimationPlayed:Connect(function(track)
      if track.Animation and track.Animation.AnimationId == targetAnimationId then
         track:Stop()
         track:Destroy()
      end
   end)
end

local function disableBlock()
   if blockConnection then
      blockConnection:Disconnect()
      blockConnection = nil
   end
   if blockLoop then
      task.cancel(blockLoop)
      blockLoop = nil
   end
end

LocalTab:CreateToggle({
   Name = "Invisible Block",
   CurrentValue = false,
   Flag = "InvisibleBlockToggle",
   Callback = function(Value)
      blockEnabled = Value
      if Value then
         enableBlock()
         player.CharacterAdded:Connect(function()
            if blockEnabled then
               task.wait(1)
               enableBlock()
            end
         end)
      else
         disableBlock()
      end
   end,
})

-- No Stun
local function enableNoStun()
   _G.StunBypass = game:GetService("RunService").RenderStepped:Connect(function()
      local char = game.Players.LocalPlayer.Character
      if char then
         if char:FindFirstChild("Stunned") then
            char.Stunned:Destroy()
         end
         local hum = char:FindFirstChild("Humanoid")
         if hum then
            hum.PlatformStand = false
            if hum.WalkSpeed == 0 then
               hum.WalkSpeed = 16
            end
         end
      end
   end)
end

local function disableNoStun()
   if _G.StunBypass then
      _G.StunBypass:Disconnect()
      _G.StunBypass = nil
   end
end

LocalTab:CreateToggle({
   Name = "No Stun",
   CurrentValue = false,
   Flag = "NoStunToggle",
   Callback = function(Value)
      if Value then
         enableNoStun()
      else
         disableNoStun()
      end
   end,
})

-- No Slowed
local function enableNoSlowed()
   _G.NoSlowLoop = game:GetService("RunService").RenderStepped:Connect(function()
      local char = game.Players.LocalPlayer.Character
      if char then
         local hum = char:FindFirstChild("Humanoid")
         if hum then
            if hum.WalkSpeed < 20 then
               hum.WalkSpeed = 20
            end
            hum.PlatformStand = false
         end
      end
   end)
end

local function disableNoSlowed()
   if _G.NoSlowLoop then
      _G.NoSlowLoop:Disconnect()
      _G.NoSlowLoop = nil
   end
end

LocalTab:CreateToggle({
   Name = "No Slowed",
   CurrentValue = false,
   Flag = "NoSlowedToggle",
   Callback = function(Value)
      if Value then
         enableNoSlowed()
      else
         disableNoSlowed()
      end
   end,
})

-- ESP Tab
local espEnabled = false
local espConnections = {}
local espLabels = {}

local function createNameESP(target)
   if target == player then return end
   if espLabels[target] then return end

   local head = target:FindFirstChild("Head")
   if not head then return end

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "NameESP"
   billboard.Size = UDim2.new(0, 100, 0, 20)
   billboard.StudsOffset = Vector3.new(0, 2.2, 0)
   billboard.AlwaysOnTop = true
   billboard.Adornee = head
   billboard.Parent = head

   local nameLabel = Instance.new("TextLabel")
   nameLabel.Size = UDim2.new(1, 0, 1, 0)
   nameLabel.BackgroundTransparency = 1
   nameLabel.Text = target.Name
   nameLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
   nameLabel.TextStrokeTransparency = 0.4
   nameLabel.TextScaled = true
   nameLabel.Font = Enum.Font.GothamBold
   nameLabel.Parent = billboard

   espLabels[target] = billboard
end

local function enableESP()
   for _, p in ipairs(game.Players:GetPlayers()) do
      if p.Character then
         createNameESP(p.Character)
      end
   end

   table.insert(espConnections, game.Players.PlayerAdded:Connect(function(p)
      p.CharacterAdded:Connect(function(char)
         repeat task.wait() until char:FindFirstChild("Head")
         createNameESP(char)
      end)
   end))

   for _, p in ipairs(game.Players:GetPlayers()) do
      if p ~= player then
         table.insert(espConnections, p.CharacterAdded:Connect(function(char)
            repeat task.wait() until char:FindFirstChild("Head")
            createNameESP(char)
         end))
      end
   end
end

local function disableESP()
   for _, gui in pairs(espLabels) do
      if gui then gui:Destroy() end
   end
   espLabels = {}

   for _, conn in ipairs(espConnections) do
      if conn then conn:Disconnect() end
   end
   espConnections = {}
end

EspTab:CreateToggle({
   Name = "ESP Name",
   CurrentValue = false,
   Flag = "ESPNameToggle",
   Callback = function(Value)
      espEnabled = Value
      if Value then
         enableESP()
      else
         disableESP()
      end
   end,
})

-- Highlight ESP
local highlightEnabled = false
local highlightConnections = {}
local highlightList = {}

local function createHighlightForCharacter(char, plr)
   if plr == player then return end
   if highlightList[plr] then return end

   local highlight = Instance.new("Highlight")
   highlight.Name = "PlayerHighlight"
   highlight.Adornee = char
   highlight.FillTransparency = 1
   highlight.OutlineTransparency = 0
   highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
   highlight.Parent = char

   highlightList[plr] = highlight
end

local function enableHighlight()
   for _, plr in ipairs(game.Players:GetPlayers()) do
      if plr.Character then
         createHighlightForCharacter(plr.Character, plr)
      end
   end

   table.insert(highlightConnections, game.Players.PlayerAdded:Connect(function(p)
      table.insert(highlightConnections, p.CharacterAdded:Connect(function(char)
         repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
         createHighlightForCharacter(char, p)
      end))
   end))

   for _, p in ipairs(game.Players:GetPlayers()) do
      if p ~= player then
         table.insert(highlightConnections, p.CharacterAdded:Connect(function(char)
            repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
            createHighlightForCharacter(char, p)
         end))
      end
   end
end

local function disableHighlight()
   for _, hl in pairs(highlightList) do
      if hl then hl:Destroy() end
   end
   highlightList = {}

   for _, conn in ipairs(highlightConnections) do
      if conn then conn:Disconnect() end
   end
   highlightConnections = {}
end

EspTab:CreateToggle({
   Name = "Highlight",
   CurrentValue = false,
   Flag = "HighlightToggle",
   Callback = function(Value)
      highlightEnabled = Value
      if Value then
         enableHighlight()
      else
         disableHighlight()
      end
   end,
})

-- Box ESP
local boxEnabled = false
local boxList = {}
local boxConnections = {}

local function createBox(plr)
   if plr == player then return end
   if boxList[plr] then return end
   if not plr.Character then return end

   local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   local box = Instance.new("BoxHandleAdornment")
   box.Name = "PurpleBox"
   box.Adornee = hrp
   box.AlwaysOnTop = true
   box.ZIndex = 5
   box.Size = Vector3.new(2, 2, 1)
   box.Color3 = Color3.fromRGB(170, 0, 255)
   box.Transparency = 0.3
   box.Parent = hrp

   boxList[plr] = box
end

local function enableBoxes()
   for _, p in pairs(game.Players:GetPlayers()) do
      if p.Character then
         createBox(p)
      end
   end

   table.insert(boxConnections, game.Players.PlayerAdded:Connect(function(p)
      table.insert(boxConnections, p.CharacterAdded:Connect(function(char)
         repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
         createBox(p)
      end))
   end))

   for _, p in ipairs(game.Players:GetPlayers()) do
      if p ~= player then
         table.insert(boxConnections, p.CharacterAdded:Connect(function(char)
            repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
            createBox(p)
         end))
      end
   end
end

local function disableBoxes()
   for _, box in pairs(boxList) do
      if box then box:Destroy() end
   end
   boxList = {}

   for _, conn in ipairs(boxConnections) do
      if conn then conn:Disconnect() end
   end
   boxConnections = {}
end

EspTab:CreateToggle({
   Name = "Show HRP",
   CurrentValue = false,
   Flag = "ShowHRPToggle",
   Callback = function(Value)
      boxEnabled = Value
      if Value then
         enableBoxes()
      else
         disableBoxes()
      end
   end,
})

-- Show Count
local guiConnection
local playerCountLabel

local function createPlayerCountGUI()
   local screenGui = Instance.new("ScreenGui")
   screenGui.Name = "PlayerCountGui"
   screenGui.ResetOnSpawn = false
   screenGui.IgnoreGuiInset = true
   screenGui.Parent = player:WaitForChild("PlayerGui")

   playerCountLabel = Instance.new("TextLabel")
   playerCountLabel.Size = UDim2.new(0, 220, 0, 50)
   playerCountLabel.Position = UDim2.new(0.5, -100, 0, 50)
   playerCountLabel.BackgroundTransparency = 1
   playerCountLabel.TextColor3 = Color3.new(1, 1, 1)
   playerCountLabel.TextStrokeTransparency = 0.2
   playerCountLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
   playerCountLabel.TextScaled = true
   playerCountLabel.Font = Enum.Font.GothamBlack
   playerCountLabel.TextTransparency = 1
   playerCountLabel.Text = "Players: " .. #game.Players:GetPlayers()
   playerCountLabel.Parent = screenGui

   local tween = TweenService:Create(playerCountLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
      TextTransparency = 0
   })
   tween:Play()

   guiConnection = RunService.RenderStepped:Connect(function()
      if playerCountLabel then
         playerCountLabel.Text = "Players: " .. #game.Players:GetPlayers()
      end
   end)
end

local function removePlayerCountGUI()
   if guiConnection then
      guiConnection:Disconnect()
      guiConnection = nil
   end
   if playerCountLabel then
      playerCountLabel:Destroy()
      playerCountLabel = nil
   end
   local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("PlayerCountGui")
   if gui then
      gui:Destroy()
   end
end

EspTab:CreateToggle({
   Name = "Show Count",
   CurrentValue = false,
   Flag = "ShowCountToggle",
   Callback = function(Value)
      if Value then
         createPlayerCountGUI()
      else
         removePlayerCountGUI()
      end
   end,
})

-- Dummy Tab
local npcHighlights = {}
local npcConnections = {}
local highlightEnabled = false

local function highlightNPC(model)
   if npcHighlights[model] then return end
   local highlight = Instance.new("Highlight")
   highlight.Adornee = model
   highlight.FillTransparency = 1
   highlight.OutlineTransparency = 0
   highlight.OutlineColor = Color3.fromRGB(170, 0, 255)
   highlight.Parent = model
   npcHighlights[model] = highlight
end

local function enableNPCHighlights()
   local liveFolder = workspace:FindFirstChild("Live")
   if not liveFolder then return end

   for _, model in pairs(liveFolder:GetChildren()) do
      if model:IsA("Model") and model.Name == "Weakest Dummy" then
         highlightNPC(model)
      end
   end

   table.insert(npcConnections, liveFolder.ChildAdded:Connect(function(child)
      if child:IsA("Model") and child.Name == "Weakest Dummy" then
         task.wait(0.2)
         highlightNPC(child)
      end
   end))
end

local function disableNPCHighlights()
   for _, h in pairs(npcHighlights) do
      if h then h:Destroy() end
   end
   npcHighlights = {}

   for _, conn in pairs(npcConnections) do
      if conn then conn:Disconnect() end
   end
   npcConnections = {}
end

DummyTab:CreateToggle({
   Name = "Highlight",
   CurrentValue = false,
   Flag = "DummyHighlightToggle",
   Callback = function(Value)
      highlightEnabled = Value
      if Value then
         enableNPCHighlights()
      else
         disableNPCHighlights()
      end
   end,
})

-- Show Name NPC
local npcNameTags = {}
local npcNameConnections = {}
local showNames = false

local function addNameTag(npc)
   if npcNameTags[npc] then return end

   local hrp = npc:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "NameTag"
   billboard.Size = UDim2.new(0, 100, 0, 25)
   billboard.Adornee = hrp
   billboard.AlwaysOnTop = true
   billboard.StudsOffset = Vector3.new(0, 3.5, 0)
   billboard.Parent = npc

   local textLabel = Instance.new("TextLabel")
   textLabel.Size = UDim2.new(1, 0, 1, 0)
   textLabel.BackgroundTransparency = 1
   textLabel.Text = npc.Name
   textLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
   textLabel.TextStrokeTransparency = 0.2
   textLabel.TextScaled = true
   textLabel.Font = Enum.Font.GothamBold
   textLabel.Parent = billboard

   npcNameTags[npc] = billboard
end

local function enableNPCNames()
   local live = workspace:FindFirstChild("Live")
   if not live then return end

   for _, npc in pairs(live:GetChildren()) do
      if npc:IsA("Model") and npc.Name == "Weakest Dummy" then
         addNameTag(npc)
      end
   end

   table.insert(npcNameConnections, live.ChildAdded:Connect(function(npc)
      if npc:IsA("Model") and npc.Name == "Weakest Dummy" then
         task.wait(0.2)
         addNameTag(npc)
      end
   end))
end

local function disableNPCNames()
   for _, tag in pairs(npcNameTags) do
      if tag then tag:Destroy() end
   end
   npcNameTags = {}

   for _, conn in ipairs(npcNameConnections) do
      if conn then conn:Disconnect() end
   end
   npcNameConnections = {}
end

DummyTab:CreateToggle({
   Name = "Show Name",
   CurrentValue = false,
   Flag = "ShowNameToggle",
   Callback = function(Value)
      showNames = Value
      if Value then
         enableNPCNames()
      else
         disableNPCNames()
      end
   end,
})

-- Orbit Dummy
local orbitConnection
local orbitOn = false
local orbitRadius = 5
local orbitSpeed = 2
local angle = 0

local function getClosestDummy()
   local live = workspace:FindFirstChild("Live")
   if not live then return nil end

   local myChar = player.Character
   if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
   local myPos = myChar.HumanoidRootPart.Position

   local closest
   local shortest = math.huge

   for _, npc in pairs(live:GetChildren()) do
      if npc:IsA("Model") and npc.Name == "Weakest Dummy" and npc:FindFirstChild("HumanoidRootPart") then
         local dist = (npc.HumanoidRootPart.Position - myPos).Magnitude
         if dist < shortest then
            shortest = dist
            closest = npc
         end
      end
   end

   return closest
end

local function startOrbit()
   angle = 0
   orbitConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
      local myChar = player.Character
      if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
      local myHRP = myChar.HumanoidRootPart

      local npc = getClosestDummy()
      if not npc or not npc:FindFirstChild("HumanoidRootPart") then return end

      local center = npc.HumanoidRootPart.Position
      angle += dt * orbitSpeed

      local offset = Vector3.new(
         math.cos(angle) * orbitRadius,
         0,
         math.sin(angle) * orbitRadius
      )

      local goalPos = center + offset
      local currentRot = myHRP.CFrame - myHRP.Position
      myHRP.CFrame = CFrame.new(goalPos) * currentRot
   end)
end

local function stopOrbit()
   if orbitConnection then
      orbitConnection:Disconnect()
      orbitConnection = nil
   end
end

DummyTab:CreateToggle({
   Name = "Orbit",
   CurrentValue = false,
   Flag = "OrbitToggle",
   Callback = function(Value)
      orbitOn = Value
      if Value then
         startOrbit()
      else
         stopOrbit()
      end
   end,
})

-- Tween NPC
DummyTab:CreateButton({
   Name = "Tween",
   Callback = function()
      local myChar = player.Character
      if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
      local myHRP = myChar.HumanoidRootPart

      local npc = getClosestDummy()
      if npc and npc:FindFirstChild("HumanoidRootPart") then
         local targetPos = npc.HumanoidRootPart.Position
         local finalPos = Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z)

         local currentRot = myHRP.CFrame - myHRP.Position
         local goalCFrame = CFrame.new(finalPos) * currentRot

         local tween = game:GetService("TweenService"):Create(myHRP, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
            CFrame = goalCFrame
         })
         tween:Play()
      end
   end,
})

-- Teleport to NPC
DummyTab:CreateButton({
   Name = "Teleport",
   Callback = function()
      local myChar = player.Character
      if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
      local myHRP = myChar.HumanoidRootPart

      local npc = getClosestDummy()
      if npc and npc:FindFirstChild("HumanoidRootPart") then
         local targetPos = npc.HumanoidRootPart.Position
         local newPos = Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z)

         local currentRot = myHRP.CFrame - myHRP.Position
         myHRP.CFrame = CFrame.new(newPos) * currentRot
      end
   end,
})

-- Tech Tab
TechTab:CreateButton({
   Name = "M1 Reset",
   Callback = function()
      getgenv().keybinds = {
         m1reset = Enum.KeyCode.R,
         emotedash = Enum.KeyCode.T,
         rotation = Enum.KeyCode.H
      }
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/M1-Reset-And-Emote-Dash-TSB-OLD-/refs/heads/main/M1R%26ED%20TSB"))()
   end,
})

TechTab:CreateButton({
   Name = "Auto Kyoto",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Auto%20kyoto%20ma%20hoa"))()
   end,
})

TechTab:CreateButton({
   Name = "Loop Dash",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Loop%20Dash%20Rework%20Script%20Real"))()
   end,
})

TechTab:CreateButton({
   Name = "Lethal Dash",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Lethal%20Dash%20Script"))()
   end,
})

TechTab:CreateButton({
   Name = "Oreo Dash",
   Callback = function()
      loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\75\105\101\116\98\97\47\75\105\101\116\98\97\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\79\114\101\111\37\50\48\84\101\99\104\37\50\48\83\99\114\105\112\116\34\41\41\40\41")()
   end,
})

TechTab:CreateButton({
   Name = "Tornado Dash",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Idk%20lolololol"))()
   end,
})

TechTab:CreateButton({
   Name = "Supa Dash",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Supa%20tech%20script"))()
   end,
})

TechTab:CreateButton({
   Name = "BackDash ( MB )",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/BackDash%20Tech"))()
   end,
})

TechTab:CreateButton({
   Name = "BackDash ( PC )",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/BackDash%20For%20Pc"))()
   end,
})

-- Admin Tab
AdminTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

AdminTab:CreateButton({
   Name = "Nameless",
   Callback = function()
      loadstring(game:HttpGet("https://github.com/FilteringEnabled/NamelessAdmin/blob/main/Source?raw=true"))()
   end,
})

-- Auto Tab
local cooldown = false
local animationConnection
local animationId = "rbxassetid://13294471966"
local delayBeforeRemote = 0.23

local function useRemote()
   local args = {
      [1] = {
         ["Dash"] = Enum.KeyCode.W,
         ["Key"] = Enum.KeyCode.Q,
         ["Goal"] = "KeyPress"
      }
   }
   local char = player.Character
   if char and char:FindFirstChild("Communicate") then
      char.Communicate:FireServer(unpack(args))
   end
end

local function stepBack()
   local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
   if hrp then
      hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
   end
end

local function bindAnimationDetection()
   local char = player.Character or player.CharacterAdded:Wait()
   local humanoid = char:WaitForChild("Humanoid")

   animationConnection = humanoid.AnimationPlayed:Connect(function(track)
      if track.Animation and track.Animation.AnimationId == animationId and not cooldown then
         cooldown = true
         task.delay(delayBeforeRemote, function()
            stepBack()
            useRemote()
         end)
         task.delay(5, function()
            cooldown = false
         end)
      end
   end)
end

AutoTab:CreateToggle({
   Name = "Auto Twisted",
   CurrentValue = false,
   Flag = "AutoTwistedToggle",
   Callback = function(Value)
      if Value then
         bindAnimationDetection()
         player.CharacterAdded:Connect(function()
            task.wait(1)
            bindAnimationDetection()
         end)
      else
         if animationConnection then
            animationConnection:Disconnect()
            animationConnection = nil
         end
      end
   end,
})

-- Instant Twisted
local TweenService = game:GetService("TweenService")
local cam = workspace.CurrentCamera
local debounce = false
local animConnection
local charConnection

local function swipeAndDash()
   print("✅ Swipe + Dash Triggered")

   local args = {
      [1] = {
         ["Dash"] = Enum.KeyCode.W,
         ["Key"] = Enum.KeyCode.Q,
         ["Goal"] = "KeyPress"
      }
   }
   local char = player.Character
   if char and char:FindFirstChild("Communicate") then
      char.Communicate:FireServer(unpack(args))
   end

   local startCFrame = cam.CFrame
   local leftCFrame = startCFrame * CFrame.Angles(40, math.rad(-90), 180)

   cam.CameraType = Enum.CameraType.Scriptable
   local tween1 = TweenService:Create(cam, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {CFrame = leftCFrame})
   tween1:Play()
   tween1.Completed:Wait()

   wait(0.00001)
   local tween2 = TweenService:Create(cam, TweenInfo.new(0.001, Enum.EasingStyle.Sine), {CFrame = startCFrame})
   tween2:Play()
   tween2.Completed:Wait()

   wait(0.1)
   local angledCFrame = startCFrame * CFrame.Angles(math.rad(-6), math.rad(20), 0)
   local tween3 = TweenService:Create(cam, TweenInfo.new(0.0001, Enum.EasingStyle.Sine), {CFrame = angledCFrame})
   tween3:Play()
   tween3.Completed:Wait()

   cam.CameraType = Enum.CameraType.Custom
end

local function bindAnimator(animator)
   animConnection = animator.AnimationPlayed:Connect(function(track)
      if track.Animation and track.Animation.AnimationId == animationId and not debounce then
         debounce = true
         print("🎬 Phát hiện animation:", animationId)

         local char = player.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         if hrp then
            local back = hrp.CFrame.LookVector * -1
            hrp.CFrame = hrp.CFrame + back
         end

         task.delay(0.25, function()
            swipeAndDash()
            wait(5)
            debounce = false
         end)
      end
   end)
end

local function monitorCharacter()
   local char = player.Character or player.CharacterAdded:Wait()
   local humanoid = char:WaitForChild("Humanoid")
   local animator = humanoid:FindFirstChildOfClass("Animator")

   if animator then
      bindAnimator(animator)
   else
      humanoid.ChildAdded:Connect(function(child)
         if child:IsA("Animator") then
            bindAnimator(child)
         end
      end)
   end
end

AutoTab:CreateToggle({
   Name = "Instant Twisted",
   CurrentValue = false,
   Flag = "InstantTwistedToggle",
   Callback = function(Value)
      if Value then
         monitorCharacter()
         charConnection = player.CharacterAdded:Connect(monitorCharacter)
      else
         if animConnection then
            animConnection:Disconnect()
            animConnection = nil
         end
         if charConnection then
            charConnection:Disconnect()
            charConnection = nil
         end
      end
   end,
})

-- Auto Supa
local targetAnimationId = "rbxassetid://12296113986"
local rotating = false
local animConnection = nil
local charConnection = nil

local function holdJump()
   local char = player.Character
   local humanoid = char and char:FindFirstChild("Humanoid")
   if humanoid then
      humanoid.Jump = true
   end
end

local function releaseJump()
   local char = player.Character
   local humanoid = char and char:FindFirstChild("Humanoid")
   if humanoid then
      humanoid.Jump = false
   end
end

local function rotateBack()
   local char = player.Character
   local root = char and char:FindFirstChild("HumanoidRootPart")
   if not root then return end

   local currentCFrame = root.CFrame
   local lookVector = -currentCFrame.LookVector
   local newLook = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + lookVector)

   root.CFrame = newLook
   cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + lookVector)
end

local function sendRemote()
   local char = player.Character
   local remote = char and char:FindFirstChild("Communicate")
   if remote then
      local args = {
         [1] = {
            ["Dash"] = Enum.KeyCode.W,
            ["Key"] = Enum.KeyCode.Q,
            ["Goal"] = "KeyPress"
         }
      }
      remote:FireServer(unpack(args))
   end
end

local function bindHumanoid(humanoid)
   animConnection = humanoid.AnimationPlayed:Connect(function(track)
      if track.Animation and track.Animation.AnimationId == targetAnimationId and not rotating then
         rotating = true
         holdJump()

         task.delay(2, function()
            sendRemote()
            task.delay(0.26, function()
               rotateBack()
               releaseJump()
               rotating = false
            end)
         end)
      end
   end)
end

local function setupMonitor()
   local char = player.Character or player.CharacterAdded:Wait()
   local humanoid = char:WaitForChild("Humanoid")
   bindHumanoid(humanoid)
end

AutoTab:CreateToggle({
   Name = "Auto Supa",
   CurrentValue = false,
   Flag = "AutoSupaToggle",
   Callback = function(Value)
      if Value then
         setupMonitor()
         charConnection = player.CharacterAdded:Connect(setupMonitor)
      else
         if animConnection then animConnection:Disconnect() animConnection = nil end
         if charConnection then charConnection:Disconnect() charConnection = nil end
      end
   end,
})

-- Flowing + Grasp
local animationId = "rbxassetid://12273188754"
local toggleConnection = nil
local systemEnabled = false

AutoTab:CreateToggle({
   Name = "Flowing + Grasp",
   CurrentValue = false,
   Flag = "FlowingGraspToggle",
   Callback = function(Value)
      systemEnabled = Value

      if toggleConnection then
         toggleConnection:Disconnect()
         toggleConnection = nil
      end

      if not systemEnabled then return end

      local isTweening = false
      local lastPlaying = false

      toggleConnection = game:GetService("RunService").RenderStepped:Connect(function()
         local char = player.Character
         if not char then return end

         local humanoid = char:FindFirstChild("Humanoid")
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if not humanoid or not hrp then return end

         local isPlaying = false
         for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId == animationId then
               isPlaying = true
               break
            end
         end

         if isPlaying and not isTweening and not lastPlaying then
            isTweening = true
            lastPlaying = true

            task.delay(1.8, function()
               local forwardCFrame = hrp.CFrame + hrp.CFrame.LookVector * 24
               local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
               local tween = TweenService:Create(hrp, tweenInfo, {CFrame = forwardCFrame})
               tween:Play()
               tween.Completed:Wait()

               local tool = player.Backpack:FindFirstChild("Hunter's Grasp")
               local remote = char:FindFirstChild("Communicate")
               if tool and remote then
                  local args = {
                     [1] = {
                        ["Tool"] = tool,
                        ["Goal"] = "Console Move"
                     }
                  }
                  remote:FireServer(unpack(args))
               end

               isTweening = false
            end)
         elseif not isPlaying then
            lastPlaying = false
         end
      end)
   end,
})

-- Upper + Grasp
local animationId = "rbxassetid://10503381238"
local TWEEN_HEIGHT_OFFSET = Vector3.new(0, 8, 0)
local systemEnabled = false
local toggleConnection = nil

AutoTab:CreateToggle({
   Name = "Upper + Grasp",
   CurrentValue = false,
   Flag = "UpperGraspToggle",
   Callback = function(Value)
      systemEnabled = Value

      if toggleConnection then
         toggleConnection:Disconnect()
         toggleConnection = nil
      end

      if not systemEnabled then return end

      local isTweening = false
      local lastPlaying = false
      local cooldown = false

      toggleConnection = game:GetService("RunService").RenderStepped:Connect(function()
         local character = player.Character
         local hrp = character and character:FindFirstChild("HumanoidRootPart")
         local humanoid = character and character:FindFirstChild("Humanoid")
         if not character or not hrp or not humanoid then return end

         local isPlaying = false
         for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId == animationId then
               isPlaying = true
               break
            end
         end

         if isPlaying and not isTweening and not lastPlaying and not cooldown then
            isTweening = true
            lastPlaying = true
            cooldown = true

            task.delay(0.18, function()
               local target = nil
               local shortestDist = 7
               local live = workspace:FindFirstChild("Live")
               if live then
                  for _, model in ipairs(live:GetChildren()) do
                     if model:IsA("Model") and model ~= character then
                        local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
                        if torso then
                           local dist = (hrp.Position - torso.Position).Magnitude
                           if dist <= shortestDist then
                              shortestDist = dist
                              target = torso
                           end
                        end
                     end
                  end
               end

               if target then
                  local targetPos = target.Position + TWEEN_HEIGHT_OFFSET
                  local tween = TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                  tween:Play()
                  tween.Completed:Wait()
               end

               local tool = player.Backpack:FindFirstChild("Hunter's Grasp")
               local remote = character:FindFirstChild("Communicate")
               if tool and remote then
                  local args = {
                     [1] = {
                        ["Tool"] = tool,
                        ["Goal"] = "Console Move"
                     }
                  }
                  remote:FireServer(unpack(args))
               end

               isTweening = false

               task.delay(15, function()
                  cooldown = false
               end)
            end)
         elseif not isPlaying then
            lastPlaying = false
         end
      end)
   end,
})

-- Server Tab
ServerTab:CreateButton({
   Name = "Anti Lag",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Antilag%20script"))()
   end,
})

ServerTab:CreateButton({
   Name = "Rejoin",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      local player = game.Players.LocalPlayer

      local screenGui = Instance.new("ScreenGui")
      screenGui.Name = "RejoinGui"
      screenGui.Parent = player:WaitForChild("PlayerGui")

      local label = Instance.new("TextLabel")
      label.Size = UDim2.new(0.3, 0, 0.2, 0)
      label.Position = UDim2.new(0.35, 0, 0.4, 0)
      label.TextScaled = true
      label.BackgroundTransparency = 1
      label.TextColor3 = Color3.new(1, 1, 1)
      label.Font = Enum.Font.GothamBold
      label.Text = ""
      label.Parent = screenGui

      for i = 5, 1, -1 do
         label.Text = "Rejoining in " .. i .. "..."
         task.wait(1)
      end

      screenGui:Destroy()
      TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
   end,
})

ServerTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      local HttpService = game:GetService("HttpService")
      local player = game.Players.LocalPlayer
      local placeId = game.PlaceId

      local screenGui = Instance.new("ScreenGui")
      screenGui.Name = "ServerHopGui"
      screenGui.Parent = player:WaitForChild("PlayerGui")

      local label = Instance.new("TextLabel")
      label.Size = UDim2.new(0.3, 0, 0.2, 0)
      label.Position = UDim2.new(0.35, 0, 0.4, 0)
      label.TextScaled = true
      label.BackgroundTransparency = 1
      label.TextColor3 = Color3.new(1, 1, 1)
      label.Font = Enum.Font.GothamBold
      label.Text = ""
      label.Parent = screenGui

      for i = 5, 1, -1 do
         label.Text = "Hopping in " .. i .. "..."
         task.wait(1)
      end

      screenGui:Destroy()

      local function getRandomServer()
         local servers = {}
         local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
         end)

         if success and response and response.data then
            for _, server in pairs(response.data) do
               if server.playing < server.maxPlayers and server.id ~= game.JobId then
                  table.insert(servers, server.id)
               end
            end
         end

         return #servers > 0 and servers[math.random(1, #servers)] or nil
      end

      local target = getRandomServer()
      if target then
         TeleportService:TeleportToPlaceInstance(placeId, target, player)
      else
         warn("⚠️ Không tìm được server khác.")
      end
   end,
})

ServerTab:CreateButton({
   Name = "Small Server",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      local HttpService = game:GetService("HttpService")
      local player = game.Players.LocalPlayer
      local placeId = game.PlaceId

      local screenGui = Instance.new("ScreenGui")
      screenGui.Name = "SmallServerGui"
      screenGui.Parent = player:WaitForChild("PlayerGui")

      local label = Instance.new("TextLabel")
      label.Size = UDim2.new(0.3, 0, 0.2, 0)
      label.Position = UDim2.new(0.35, 0, 0.4, 0)
      label.TextScaled = true
      label.BackgroundTransparency = 1
      label.TextColor3 = Color3.new(1, 1, 1)
      label.Font = Enum.Font.GothamBold
      label.Text = ""
      label.Parent = screenGui

      for i = 5, 1, -1 do
         label.Text = "Tìm server < 5 người trong " .. i .. "..."
         task.wait(1)
      end

      screenGui:Destroy()

      local function getSmallServer()
         local servers = {}
         local cursor = ""

         for i = 1, 5 do
            local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
            if cursor ~= "" then
               url = url .. "&cursor=" .. cursor
            end

            local success, response = pcall(function()
               return HttpService:JSONDecode(game:HttpGet(url))
            end)

            if success and response and response.data then
               for _, server in pairs(response.data) do
                  if server.playing < 5 and server.id ~= game.JobId then
                     table.insert(servers, server.id)
                  end
               end

               if response.nextPageCursor then
                  cursor = response.nextPageCursor
               else
                  break
               end
            else
               break
            end
         end

         return #servers > 0 and servers[math.random(1, #servers)] or nil
      end

      local target = getSmallServer()
      if target then
         TeleportService:TeleportToPlaceInstance(placeId, target, player)
      else
         warn("⚠️ Không tìm được server < 5 người.")
      end
   end,
})

ServerTab:CreateButton({
   Name = "Exit Server",
   Callback = function()
      local player = game.Players.LocalPlayer

      local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
      gui.ResetOnSpawn = false
      gui.Name = "ExitConfirmGui"

      local frame = Instance.new("Frame", gui)
      frame.Size = UDim2.new(0.5, 0, 0.3, 0)
      frame.Position = UDim2.new(0.25, 0, 0.35, 0)
      frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
      frame.BorderSizePixel = 0
      frame.BackgroundTransparency = 0.1

      local title = Instance.new("TextLabel", frame)
      title.Size = UDim2.new(1, 0, 0.4, 0)
      title.Text = "Do you want to exit server?"
      title.TextColor3 = Color3.new(1, 1, 1)
      title.BackgroundTransparency = 1
      title.TextScaled = true
      title.Font = Enum.Font.GothamBold

      local yesBtn = Instance.new("TextButton", frame)
      yesBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
      yesBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
      yesBtn.Text = "Yes"
      yesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
      yesBtn.TextColor3 = Color3.new(1, 1, 1)
      yesBtn.TextScaled = true
      yesBtn.Font = Enum.Font.GothamBold

      local noBtn = Instance.new("TextButton", frame)
      noBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
      noBtn.Position = UDim2.new(0.5, 0, 0.55, 0)
      noBtn.Text = "No"
      noBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
      noBtn.TextColor3 = Color3.new(1, 1, 1)
      noBtn.TextScaled = true
      noBtn.Font = Enum.Font.GothamBold

      yesBtn.MouseButton1Click:Connect(function()
         player:Kick("Bạn đã thoát khỏi server.")
      end)

      noBtn.MouseButton1Click:Connect(function()
         gui:Destroy()
      end)
   end,
})

ServerTab:CreateButton({
   Name = "Check Ping",
   Callback = function()
      local player = game:GetService("Players").LocalPlayer
      local screenGui = Instance.new("ScreenGui")
      screenGui.Name = "PingDisplay"
      screenGui.ResetOnSpawn = false
      screenGui.Parent = player:WaitForChild("PlayerGui")

      local pingLabel = Instance.new("TextLabel")
      pingLabel.Size = UDim2.new(0, 150, 0, 40)
      pingLabel.Position = UDim2.new(1, -160, 0, 10)
      pingLabel.BackgroundTransparency = 0.4
      pingLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      pingLabel.TextColor3 = Color3.new(1, 1, 1)
      pingLabel.Font = Enum.Font.GothamBold
      pingLabel.TextSize = 20
      pingLabel.Text = "PING: -- ms"
      pingLabel.Parent = screenGui

      while true do
         local ping = math.floor(player:GetNetworkPing() * 1000)
         pingLabel.Text = "PING: " .. ping .. " ms"

         if ping <= 80 then
            pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
         elseif ping <= 150 then
            pingLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
         else
            pingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
         end

         wait(1)
      end
   end,
})

ServerTab:CreateToggle({
   Name = "Anti Kick",
   CurrentValue = false,
   Flag = "AntiKickToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local StarterGui = game:GetService("StarterGui")
      local LocalPlayer = Players.LocalPlayer
      local connections = {}
      
      local function hookKick()
         local mt = getrawmetatable(game)
         local oldNamecall = mt.__namecall
         setreadonly(mt, false)

         mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" and self == LocalPlayer then
               warn("[🚫 AntiKick]: Kick blocked (Namecall)")
               return nil
            end
            return oldNamecall(self, ...)
         end)

         LocalPlayer.Kick = function()
            warn("[🚫 AntiKick]: Kick blocked (Direct)")
            return nil
         end

         setreadonly(mt, true)
      end

      local function hookGui()
         local con = StarterGui.MessageBoxPrompted:Connect(function()
            warn("[🚫 AntiKick]: MessageBox blocked")
         end)
         table.insert(connections, con)
      end

      local function hookExploit()
         for _, v in pairs(getgc(true)) do
            if typeof(v) == "function" and islclosure(v) then
               local info = debug.getinfo(v)
               if info.name and string.lower(info.name):match("kick") then
                  hookfunction(v, function(...)
                     warn("[🚫 AntiKick]: Exploit Kick blocked")
                     return nil
                  end)
               end
            end
         end
      end

      local function enable()
         hookKick()
         hookGui()
         hookExploit()
      end

      local function disable()
         for _, con in ipairs(connections) do
            if typeof(con) == "RBXScriptConnection" then
               pcall(function() con:Disconnect() end)
            end
         end
         table.clear(connections)
      end

      if Value then
         enable()
      else
         disable()
      end
   end,
})

-- Auto Block Tab
AutoBlockTab:CreateButton({
   Name = "Notpaki Block",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/TSB/refs/heads/main/CombatGui"))()
   end,
})


-- Additional Local Tab Features
LocalTab:CreateButton({
   Name = "Goku Miui",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()
   end,
})

-- No Anim Ult
LocalTab:CreateToggle({
   Name = "No Anim Ult",
   CurrentValue = false,
   Flag = "NoAnimUltToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")

      local lp = Players.LocalPlayer
      local character = lp.Character or lp.CharacterAdded:Wait()
      local blockAnimEnabled = Value

      local blockedIds = {
         "12447707844",
         "12342141464",
         "12772543293"
      }

      local function isBlocked(animationId)
         for _, id in pairs(blockedIds) do
            if animationId:find(id) then
               return true
            end
         end
         return false
      end

      if _G.BlockAnimConnection then
         _G.BlockAnimConnection:Disconnect()
         _G.BlockAnimConnection = nil
      end

      if Value then
         _G.BlockAnimConnection = RunService.Stepped:Connect(function()
            if not blockAnimEnabled then return end
            local char = lp.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
               local animator = humanoid:FindFirstChildOfClass("Animator")
               if animator then
                  for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                     local anim = track.Animation
                     if anim and isBlocked(anim.AnimationId) then
                        track:Stop(0)
                        pcall(function() track:Destroy() end)
                        print("🚫 Dừng animation bị chặn: " .. anim.AnimationId)
                     end
                  end
               end
            end
         end)
      end
   end,
})

-- Face Camera Y
LocalTab:CreateToggle({
   Name = "Face Camera Y",
   CurrentValue = false,
   Flag = "FaceCameraYToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local Workspace = game:GetService("Workspace")

      local lp = Players.LocalPlayer
      local cam = Workspace.CurrentCamera

      if _G.FaceCamConnection then
         _G.FaceCamConnection:Disconnect()
         _G.FaceCamConnection = nil
      end

      if Value then
         _G.FaceCamConnection = RunService.RenderStepped:Connect(function()
            local char = lp.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local camLook = cam.CFrame.LookVector
            local lookDir = Vector3.new(camLook.X, 0, camLook.Z).Unit

            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)
         end)
      end
   end,
})

-- Additional Auto Tab Features
AutoTab:CreateToggle({
   Name = "Slide + M1",
   CurrentValue = false,
   Flag = "SlideM1Toggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer

      local targetIDs = {
         ["10480796021"] = true,
         ["10480793962"] = true,
      }

      if _G.SlideM1Connection then
         _G.SlideM1Connection:Disconnect()
         _G.SlideM1Connection = nil
      end

      if not Value then
         if _G.SlideM1AnimConnection then _G.SlideM1AnimConnection:Disconnect() _G.SlideM1AnimConnection = nil end
         if _G.SlideM1CharConnection then _G.SlideM1CharConnection:Disconnect() _G.SlideM1CharConnection = nil end
         return
      end

      local function setupForCharacter(char)
         local humanoid = char:WaitForChild("Humanoid", 3)
         local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
         local remote = char:FindFirstChild("Communicate")

         if not humanoid or not animator or not remote then return end

         local cooldown = false

         if _G.SlideM1AnimConnection then _G.SlideM1AnimConnection:Disconnect() end

         _G.SlideM1AnimConnection = animator.AnimationPlayed:Connect(function(track)
            if not Value then return end
            local id = track.Animation.AnimationId:match("%d+")
            if id and targetIDs[id] and not cooldown then
               cooldown = true

               remote:FireServer({
                  ["Mobile"] = true,
                  ["Goal"] = "LeftClick"
               })

               remote:FireServer({
                  ["Goal"] = "LeftClickRelease",
                  ["Mobile"] = true
               })

               task.delay(1.5, function()
                  cooldown = false
               end)
            end
         end)
      end

      if LocalPlayer.Character then
         setupForCharacter(LocalPlayer.Character)
      end

      if _G.SlideM1CharConnection then _G.SlideM1CharConnection:Disconnect() end
      _G.SlideM1CharConnection = LocalPlayer.CharacterAdded:Connect(function(char)
         task.wait(1)
         if Value then
            setupForCharacter(char)
         end
      end)
   end,
})

-- Auto Surf
AutoTab:CreateToggle({
   Name = "Auto Surf",
   CurrentValue = false,
   Flag = "AutoSurfToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local TweenService = game:GetService("TweenService")
      local RunService = game:GetService("RunService")
      local LocalPlayer = Players.LocalPlayer

      local TARGET_ANIM_ID = "rbxassetid://12309835105"
      local active = Value
      local isTweening = false
      local animConnection, charConnection

      if not active then
         isTweening = false
         if charConnection then charConnection:Disconnect() charConnection = nil end
         if animConnection then animConnection:Disconnect() animConnection = nil end
         return
      end

      local function getCharacter()
         return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
      end

      local function isTargetAnimPlaying()
         local char = getCharacter()
         local humanoid = char:FindFirstChildOfClass("Humanoid")
         if not humanoid then return false end

         for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId == TARGET_ANIM_ID then
               return true
            end
         end
         return false
      end

      local function tweenForward()
         local char = getCharacter()
         local root = char:FindFirstChild("HumanoidRootPart")
         if not root then return end

         root.Anchored = false
         local forward = root.CFrame.LookVector.Unit
         local targetCFrame = root.CFrame + (forward * 50)

         local tweenInfo = TweenInfo.new(0.78, Enum.EasingStyle.Linear)
         local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
         tween:Play()
         tween.Completed:Wait()
      end

      RunService.RenderStepped:Connect(function()
         if not active then return end
         if isTweening then return end
         if isTargetAnimPlaying() then
            isTweening = true
            task.wait(0.6)
            tweenForward()
            task.wait(1.5)
            isTweening = false
         end
      end)

      if LocalPlayer.Character then
         getCharacter()
      end
      if charConnection then charConnection:Disconnect() end
      charConnection = LocalPlayer.CharacterAdded:Connect(function()
         task.wait(1)
         if active then
            getCharacter()
         end
      end)
   end,
})

-- True DownSlam
AutoTab:CreateToggle({
   Name = "True DownSlam",
   CurrentValue = false,
   Flag = "TrueDownSlamToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local Workspace = game:GetService("Workspace")

      local LocalPlayer = Players.LocalPlayer
      local Camera = Workspace.CurrentCamera

      local LIFT_IDS = {
         ["rbxassetid://13532600125"] = true,
         ["rbxassetid://10469630950"] = true,
         ["rbxassetid://13296577783"] = true,
         ["rbxassetid://13370310513"] = true,
         ["rbxassetid://15240216931"] = true,
         ["rbxassetid://16515520431"] = true,
         ["rbxassetid://17889461810"] = true,
      }

      local JUMP_IDS = {
         ["rbxassetid://13532604085"] = true,
         ["rbxassetid://10469639222"] = true,
         ["rbxassetid://13295919399"] = true,
         ["rbxassetid://13378751717"] = true,
         ["rbxassetid://15240176873"] = true,
         ["rbxassetid://16515448089"] = true,
         ["rbxassetid://17889471098"] = true,
      }

      local isEnabled = Value
      local lastUsed = {}

      local function waitForCharacter()
         local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
         local humanoid = char:WaitForChild("Humanoid")
         local hrp = char:WaitForChild("HumanoidRootPart")
         char.PrimaryPart = hrp
         return char, humanoid
      end

      local Character, Humanoid = waitForCharacter()

      local function liftCharacter()
         if not Character or not Character.PrimaryPart then return end
         local originalSubject = Camera.CameraSubject
         Camera.CameraSubject = nil

         local startCFrame = Character:GetPivot()
         local targetCFrame = startCFrame + Vector3.new(0, 7, 0)
         local steps, duration = 10, 0.1
         for i = 1, steps do
            local alpha = i / steps
            Character:PivotTo(startCFrame:Lerp(targetCFrame, alpha))
            task.wait(duration / steps)
         end

         Camera.CameraSubject = originalSubject
      end

      RunService.RenderStepped:Connect(function()
         if not isEnabled then return end

         if LocalPlayer.Character ~= Character then
            Character, Humanoid = waitForCharacter()
         end

         for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local animId = tostring(track.Animation.AnimationId)
            local now = tick()

            if LIFT_IDS[animId] and (not lastUsed[animId] or now - lastUsed[animId] > 0.5) then
               lastUsed[animId] = now
               task.delay(0.15, liftCharacter)

            elseif JUMP_IDS[animId] and (not lastUsed[animId] or now - lastUsed[animId] > 0.5) then
               lastUsed[animId] = now
               task.delay(0.15, function()
                  Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
               end)
            end
         end
      end)
   end,
})

-- Whirlwind Dunk
AutoTab:CreateToggle({
   Name = "Whirlwind Dunk",
   CurrentValue = false,
   Flag = "WhirlwindDunkToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local lp = Players.LocalPlayer

      local TARGET_ANIM_ID = "rbxassetid://12296113986"
      local isTeleporting = false
      local lastTrack = nil

      if _G.TeleportAnimConnection then
         _G.TeleportAnimConnection:Disconnect()
         _G.TeleportAnimConnection = nil
      end

      if Value then
         _G.TeleportAnimConnection = RunService.RenderStepped:Connect(function()
            local character = lp.Character
            if not character or isTeleporting then return end

            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root then return end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
               if track.Animation and track.Animation.AnimationId == TARGET_ANIM_ID then
                  if lastTrack == track then return end
                  lastTrack = track

                  isTeleporting = true
                  task.delay(1.3, function()
                     if root and root.Parent then
                        root.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                     end
                     isTeleporting = false
                  end)
                  break
               end
            end

            if lastTrack and not lastTrack.IsPlaying then
               lastTrack = nil
            end
         end)
      end
   end,
})

-- Esp Character
local toolEspMap = {
   ["Flowing Water"] = {"Garou", Color3.fromRGB(0, 170, 255)},
   ["Crushed Rock"] = {"Garou", Color3.fromRGB(0, 170, 255)},
   ["Normal Punch"] = {"Saitama", Color3.fromRGB(139, 69, 19)},
   ["Serious Punch"] = {"Saitama", Color3.fromRGB(139, 69, 19)},
   ["Binding Cloth"] = {"Monster Form", Color3.fromRGB(255, 0, 0)},
   ["Beatdown"] = {"Brutal Demon", Color3.fromRGB(255, 255, 255)},
   ["Death Blow"] = {"Brutal Demon", Color3.fromRGB(255, 255, 255)},
   ["Blitz Shot"] = {"Cyborg", Color3.fromRGB(255, 140, 0)},
   ["Flamewave Cannon"] = {"Cyborg", Color3.fromRGB(255, 140, 0)},
   ["Explosive Shuriken"] = {"Sonic", Color3.fromRGB(255, 105, 180)},
   ["Carnage"] = {"Sonic", Color3.fromRGB(255, 105, 180)},
   ["Atmos Cleave"] = {"Blade Master", Color3.fromRGB(255, 255, 0)},
   ["Atomic Slash"] = {"Blade Master", Color3.fromRGB(255, 255, 0)},
   ["Crushing Pull"] = {"Tatsumaki", Color3.fromRGB(0, 255, 0)},
   ["Psychic Ricochet"] = {"Tatsumaki", Color3.fromRGB(0, 255, 0)},
   ["Bullet Barrage"] = {"Martial Artist", Color3.fromRGB(128, 0, 128)},
   ["Earth Splitting Strike"] = {"Martial Artist", Color3.fromRGB(128, 0, 128)},
}

local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "DynamicESP"

local espEnabled = false

local function getEspData(player)
   local backpack = player:FindFirstChildOfClass("Backpack")
   if not backpack then return "Tech Prodigy", Color3.fromRGB(200, 200, 200) end

   for toolName, data in pairs(toolEspMap) do
      if backpack:FindFirstChild(toolName) then
         return data[1], data[2]
      end
   end
   return "Tech Prodigy", Color3.fromRGB(200, 200, 200)
end

local function createESP(player, labelText, color)
   local char = player.Character
   if not char or not char:FindFirstChild("Head") then return end
   if espFolder:FindFirstChild(player.Name) then return end

   local billboard = Instance.new("BillboardGui")
   billboard.Name = player.Name
   billboard.Adornee = char.Head
   billboard.Size = UDim2.new(0, 100, 0, 20)
   billboard.StudsOffset = Vector3.new(3.5, 0.5, 0)
   billboard.AlwaysOnTop = true
   billboard.Parent = espFolder

   local label = Instance.new("TextLabel", billboard)
   label.Size = UDim2.new(1, 0, 1, 0)
   label.BackgroundTransparency = 1
   label.Text = labelText
   label.TextColor3 = color
   label.Font = Enum.Font.GothamBold
   label.TextScaled = false
   label.TextSize = 12
   label.TextStrokeTransparency = 0.6
   label.TextTransparency = 1

   TweenService:Create(label, TweenInfo.new(0.3), {
      TextTransparency = 0,
      TextStrokeTransparency = 0.3
   }):Play()
end

local function clearAllESP()
   for _, v in ipairs(espFolder:GetChildren()) do
      v:Destroy()
   end
end

local function updateESPForPlayer(player)
   if player == game.Players.LocalPlayer then return end
   if not player.Character or not player.Character:FindFirstChild("Head") then return end
   local labelText, color = getEspData(player)
   createESP(player, labelText, color)
end

local function refreshAll()
   clearAllESP()
   for _, p in ipairs(game.Players:GetPlayers()) do
      updateESPForPlayer(p)
   end
end

EspTab:CreateToggle({
   Name = "Esp Character",
   CurrentValue = false,
   Flag = "EspCharacterToggle",
   Callback = function(Value)
      espEnabled = Value

      if espEnabled then
         refreshAll()

         for _, player in pairs(game.Players:GetPlayers()) do
            player.CharacterAdded:Connect(function()
               if espEnabled then
                  task.wait(1)
                  updateESPForPlayer(player)
               end
            end)
         end

         game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
               if espEnabled then
                  task.wait(1)
                  updateESPForPlayer(player)
               end
            end)
         end)

         task.spawn(function()
            while espEnabled do
               refreshAll()
               task.wait(2)
            end
         end)
      else
         clearAllESP()
      end
   end,
})

-- No Anim Ult
local teleportEnabled = false
local teleporting = false
local oldPos = nil
local oldSubject = nil

LocalTab:CreateToggle({
   Name = "No Anim Ult",
   CurrentValue = false,
   Flag = "NoAnimUltToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")

      local lp = Players.LocalPlayer
      local character = lp.Character or lp.CharacterAdded:Wait()
      local blockAnimEnabled = Value

      local blockedIds = {
         "12447707844",
         "12342141464",
         "12772543293"
      }

      local function isBlocked(animationId)
         for _, id in pairs(blockedIds) do
            if animationId:find(id) then
               return true
            end
         end
         return false
      end

      if _G.BlockAnimConnection then
         _G.BlockAnimConnection:Disconnect()
         _G.BlockAnimConnection = nil
      end

      if Value then
         _G.BlockAnimConnection = RunService.Stepped:Connect(function()
            if not blockAnimEnabled then return end
            local char = lp.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
               local animator = humanoid:FindFirstChildOfClass("Animator")
               if animator then
                  for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                     local anim = track.Animation
                     if anim and isBlocked(anim.AnimationId) then
                        track:Stop(0)
                        pcall(function() track:Destroy() end)
                        print("🚫 Dừng animation bị chặn: " .. anim.AnimationId)
                     end
                  end
               end
            end
         end)
      end
   end,
})

-- Face Camera Y
LocalTab:CreateToggle({
   Name = "Face Camera Y",
   CurrentValue = false,
   Flag = "FaceCameraYToggle",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local Workspace = game:GetService("Workspace")

      local lp = Players.LocalPlayer
      local cam = Workspace.CurrentCamera

      if _G.FaceCamConnection then
         _G.FaceCamConnection:Disconnect()
         _G.FaceCamConnection = nil
      end

      if Value then
         _G.FaceCamConnection = RunService.RenderStepped:Connect(function()
            local char = lp.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local camLook = cam.CFrame.LookVector
            local lookDir = Vector3.new(camLook.X, 0, camLook.Z).Unit

            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)
         end)
      end
   end,
})

Window:Show()




