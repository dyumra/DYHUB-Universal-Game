-- =====================
local Development = "DYHUB | Wizard West (V3.9.2)"
-- =====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = Development,
   LoadingTitle = "Wizard West Loaded",
   LoadingSubtitle = "Made by DYHUB™",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "DYHUB_Wizard_West_Config"
   },
})

Rayfield:Notify({
   Title = "DYHUB Loaded",
   Content = "Enjoy your power!",
   Duration = 5,
   Image = 104487529937663,
   Actions = {
      Okay = {Name = "Let's Go!", Callback = function() end},
   },
})

-- Tabs
local MainTab      = Window:CreateTab("Main", "rocket")
local VisualsTab   = Window:CreateTab("Visuals", "eye")
local CharacterTab = Window:CreateTab("Character", "person-standing")
local WorldTab     = Window:CreateTab("World", "sun")
local TeleportTab  = Window:CreateTab("Teleports", "map-pinned")
local MiscTab      = Window:CreateTab("Misc", "settings")

-- ===================================
-- 🔹 MAIN
-- ===================================
_G.AutoSafeEnabled = false
_G.SafeTrigger = 50

MainTab:CreateButton({
   Name = "Camlock (V3)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/Camlock.lua"))()
   end
})

MainTab:CreateButton({
   Name = "No ProximityPrompt",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/nodelay.lua"))()
   end
})

MainTab:CreateToggle({
   Name = "Auto Safe (HP Below %)",
   CurrentValue = false,
   Flag = "AutoSafe",
   Callback = function(v) _G.AutoSafeEnabled = v end
})

MainTab:CreateSlider({
   Name = "Safe Trigger %",
   Range = {10, 90},
   Increment = 5,
   CurrentValue = 50,
   Flag = "SafeTrigger",
   Callback = function(v) _G.SafeTrigger = v end
})

local safeZone = Instance.new("Part")
safeZone.Name = "SafeZone_Part_DYHUB"
safeZone.Anchored = true
safeZone.CanCollide = true
safeZone.Size = Vector3.new(50, 1, 50)
safeZone.Position = Vector3.new(0, 221.5, 0)
safeZone.Color = Color3.fromRGB(0, 255, 0)
safeZone.Transparency = 0.85
safeZone.Parent = workspace

task.spawn(function()
   while task.wait(1) do
      if _G.AutoSafeEnabled then
         local lp = game.Players.LocalPlayer
         if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            local hp = hum.Health / hum.MaxHealth * 100
            if hp <= _G.SafeTrigger then
               local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
               if hrp then
                  hrp.CFrame = CFrame.new(0, 222.5, 0)
               end
            end
         end
      end
   end
end)

-- ===================================
-- 🔹 VISUALS (ESP)
-- ===================================
local function createESP(obj)
    if obj:FindFirstChild("Highlight") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "Highlight"
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = obj

    if not obj:FindFirstChild("ESPGui") then
        local hrp = obj:FindFirstChild("HumanoidRootPart")
        local hum = obj:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPGui"
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 80, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextStrokeTransparency = 0
            text.TextScaled = true
            text.Font = Enum.Font.SourceSansBold
            text.Parent = billboard

            billboard.Parent = obj

            task.spawn(function()
                while billboard.Parent do
                    local nameText = obj.Name or "NPC"
                    local hpText = hum.Health and math.floor(hum.Health) or 0
                    local distText = hrp.Position and math.floor((hrp.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
                    text.Text = string.format("%s\n[%d HP]\n[%d Dist]", nameText, hpText, distText)
                    task.wait(0.1)
                end
            end)
        end
    end
end

local function removeESP(obj)
    if obj:FindFirstChild("Highlight") then obj.Highlight:Destroy() end
    if obj:FindFirstChild("ESPGui") then obj.ESPGui:Destroy() end
end

VisualsTab:CreateToggle({
    Name="Player ESP",
    CurrentValue=false,
    Flag="ESP",
    Callback=function(v)
        _G.ESP=v
        task.spawn(function()
            while _G.ESP do task.wait(1)
                for _,plr in ipairs(game.Players:GetPlayers()) do
                    if plr~=game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        createESP(plr.Character)
                    end
                end
            end
            if not _G.ESP then
                for _,plr in ipairs(game.Players:GetPlayers()) do
                    if plr.Character then removeESP(plr.Character) end
                end
            end
        end)
    end
})

VisualsTab:CreateToggle({
    Name="Bandit ESP",
    CurrentValue=false,
    Flag="BESP",
    Callback=function(v)
        _G.BESP=v
        task.spawn(function()
            while _G.BESP do task.wait(1)
                for _,npc in ipairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                        if not game.Players:GetPlayerFromCharacter(npc) then createESP(npc) end
                    end
                end
            end
            if not _G.BESP then
                for _,npc in ipairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc:FindFirstChild("Highlight") then
                        if not game.Players:GetPlayerFromCharacter(npc) then removeESP(npc) end
                    end
                end
            end
        end)
    end
})

-- ===================================
-- 🔹 CHARACTER
-- ===================================
CharacterTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 150},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(v) 
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v 
   end
})
CharacterTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(v) 
      game.Players.LocalPlayer.Character.Humanoid.JumpPower=v 
   end
})

-- Infinite Jump
local infJumpConn
CharacterTab:CreateToggle({
   Name="Infinite Jump",
   CurrentValue=false,
   Flag="InfJump",
   Callback=function(v)
      _G.InfJump=v
      if v then
         infJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump and game.Players.LocalPlayer.Character then
               game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
         end)
      else
         if infJumpConn then infJumpConn:Disconnect() infJumpConn=nil end
      end
   end
})

-- Noclip
local noclipLoop
CharacterTab:CreateToggle({
   Name="No Clip",
   CurrentValue=false,
   Flag="Noclip",
   Callback=function(v)
      _G.Noclip=v
      if v then
         noclipLoop = game:GetService("RunService").Stepped:Connect(function()
            if _G.Noclip and game.Players.LocalPlayer.Character then
               for _,part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                  if part:IsA("BasePart") and part.CanCollide then
                     part.CanCollide = false
                  end
               end
            end
         end)
      else
         if noclipLoop then noclipLoop:Disconnect() noclipLoop=nil end
      end
   end
})

-- ===================================
-- 🔹 WORLD
-- ===================================
local Lighting = game:GetService("Lighting")
local brightLoop
WorldTab:CreateToggle({
   Name="Full Bright",
   CurrentValue=false,
   Flag="Bright",
   Callback=function(v)
      _G.FullBright=v
      if v then
         if brightLoop then brightLoop:Disconnect() end
         brightLoop = game:GetService("RunService").RenderStepped:Connect(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1e6
            Lighting.GlobalShadows = false
         end)
      else
         if brightLoop then brightLoop:Disconnect() brightLoop=nil end
      end
   end
})
WorldTab:CreateToggle({
   Name="No Fog",
   CurrentValue=false,
   Flag="NoFog",
   Callback=function(v)
      _G.NoFog=v
      if v then
         Lighting.FogEnd=1e6
      else
         Lighting.FogEnd=1000
      end
   end
})

-- ===================================
-- 🔹 TELEPORT
-- ===================================
local SafeZonePos = Vector3.new(0,222,0)

local safeZone1 = Instance.new("Part")
safeZone1.Name = "SafeZone_Part"
safeZone1.Anchored = true
safeZone1.CanCollide = true
safeZone1.Size = Vector3.new(50, 1, 50)
safeZone1.Position = SafeZonePos - Vector3.new(0, 0.5, 0)
safeZone1.Color = Color3.fromRGB(0, 255, 0)
safeZone1.Transparency = 0.85
safeZone1.Parent = workspace

TeleportTab:CreateButton({
   Name = "Teleport to Safe Zone",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then hrp.CFrame = CFrame.new(SafeZonePos) end
   end
})

TeleportTab:CreateButton({
   Name = "Save Position",
   Callback = function()
      local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then _G.SavedPos=hrp.CFrame end
   end
})
TeleportTab:CreateButton({
   Name = "Teleport to Saved Position",
   Callback = function()
      local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp and _G.SavedPos then hrp.CFrame=_G.SavedPos end
   end
})

-- ===================================
-- 🔹 MISC
-- ===================================

MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
   end
})
MiscTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local Http=game:GetService("HttpService")
      local TPS=game:GetService("TeleportService")
      local Api="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
      local data=game:HttpGet(Api)
      local servers=Http:JSONDecode(data).data
      for _,s in pairs(servers) do
         if s.playing < s.maxPlayers then
            TPS:TeleportToPlaceInstance(game.PlaceId,s.id,game.Players.LocalPlayer)
            break
         end
      end
   end
})
MiscTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(v)
      if v then
         local vu = game:GetService("VirtualUser")
         game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         end)
      end
   end
})
MiscTab:CreateToggle({
   Name="FPS Unlocker",
   CurrentValue=false,
   Flag="FPSUnlock",
   Callback=function(v) 
      if v and setfpscap then 
         setfpscap(1000) 
      else 
         if setfpscap then setfpscap(60) end 
      end 
   end
})
