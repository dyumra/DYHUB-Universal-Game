-- pre-view

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DYHUB | Wizard West",
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
MainTab:CreateToggle({
   Name = "Anti-AFK",
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

MainTab:CreateToggle({
   Name = "Auto Safe (HP Below %)",
   CurrentValue = false,
   Flag = "AutoSafe",
   Callback = function(v)
      _G.AutoSafeEnabled = v
   end
})
MainTab:CreateSlider({
   Name = "Safe Trigger %",
   Range = {10, 90},
   Increment = 5,
   CurrentValue = 50,
   Flag = "SafeTrigger",
   Callback = function(v) _G.SafeTrigger = v end
})

-- ===================================
-- 🔹 VISUALS
-- ===================================
VisualsTab:CreateToggle({Name="Player ESP",CurrentValue=false,Flag="ESP",Callback=function(v) _G.ESP=v end})
VisualsTab:CreateToggle({Name="Skeleton ESP",CurrentValue=false,Flag="SkeletonESP",Callback=function(v) _G.SkeletonESP=v end})
VisualsTab:CreateToggle({Name="Item ESP",CurrentValue=false,Flag="ItemESP",Callback=function(v) _G.ItemESP=v end})
VisualsTab:CreateToggle({Name="Team Color ESP",CurrentValue=false,Flag="TeamESP",Callback=function(v) _G.TeamESP=v end})

-- ===================================
-- 🔹 CHARACTER
-- ===================================
CharacterTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end
})
CharacterTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower=v end
})
CharacterTab:CreateToggle({Name="Fly Mode",CurrentValue=false,Flag="Fly",Callback=function(v) _G.Fly=v end})
CharacterTab:CreateSlider({Name="Fly Speed",Range={10,200},Increment=10,CurrentValue=50,Flag="FlySpeed",Callback=function(v) _G.FlySpeed=v end})
CharacterTab:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="InfJump",Callback=function(v) _G.InfJump=v end})
CharacterTab:CreateToggle({Name="Noclip",CurrentValue=false,Flag="Noclip",Callback=function(v) _G.Noclip=v end})
CharacterTab:CreateToggle({Name="No Fall Damage",CurrentValue=false,Flag="NoFall",Callback=function(v) _G.NoFall=v end})

-- ===================================
-- 🔹 WORLD
-- ===================================
WorldTab:CreateToggle({Name="Full Bright",CurrentValue=false,Flag="Bright",Callback=function(v) _G.FullBright=v end})
WorldTab:CreateToggle({Name="No Fog",CurrentValue=false,Flag="NoFog",Callback=function(v) _G.NoFog=v end})

-- ===================================
-- 🔹 TELEPORT
-- ===================================
local SafeZonePos = Vector3.new(0,222,0)
TeleportTab:CreateButton({
   Name = "Teleport to Safe Zone",
   Callback = function()
      local hrp=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then hrp.CFrame=CFrame.new(SafeZonePos) end
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
MiscTab:CreateToggle({Name="FPS Unlocker",CurrentValue=false,Flag="FPSUnlock",Callback=function(v) if v and setfpscap then setfpscap(1000) else if setfpscap then setfpscap(60) end end end})
