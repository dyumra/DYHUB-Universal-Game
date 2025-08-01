local Players = game:GetService('Players')
local Player = Players.LocalPlayer
local ContextActionService = game:GetService('ContextActionService')
local Phantom = false


local function BlockMovement(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end

local UserInputService = cloneref(game:GetService('UserInputService'))

local ContentProvider = cloneref(game:GetService('ContentProvider'))

local TweenService = cloneref(game:GetService('TweenService'))

local HttpService = cloneref(game:GetService('HttpService'))

local TextService = cloneref(game:GetService('TextService'))

local RunService = cloneref(game:GetService('RunService'))

local Lighting = cloneref(game:GetService('Lighting'))

local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))

local Debris = cloneref(game:GetService('Debris'))


local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Tornado_Time = tick()

local UserInputService = game:GetService('UserInputService')
local Last_Input = UserInputService:GetLastInputType()

local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')

local Vector2_Mouse_Location = nil
local Grab_Parry = nil

local Remotes = {}

local Parry_Key = nil

local Speed_Divisor_Multiplier = 1.1

local LobbyAP_Speed_Divisor_Multiplier = 1.1

local firstParryFired = false

local ParryThreshold = 2.5

local firstParryType = 'F_Key'

local Previous_Positions = {}

local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualInputService = game:GetService("VirtualInputManager")


local GuiService = game:GetService('GuiService')

local function performFirstPress(parryType)
    if parryType == 'F_Key' then
        VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    elseif parryType == 'Left_Click' then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    elseif parryType == 'Navigation' then
        local button = Players.LocalPlayer.PlayerGui.Hotbar.Block
        updateNavigation(button)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        updateNavigation(nil)
    end
end

if not LPH_OBFUSCATED then
    function LPH_JIT(Function) return Function end
    function LPH_JIT_MAX(Function) return Function end
    function LPH_NO_VIRTUALIZE(Function) return Function end
end

local PropertyChangeOrder = {}

local HashOne
local HashTwo
local HashThree

LPH_NO_VIRTUALIZE(function()
    for Index, Value in next, getgc() do
        if rawequal(typeof(Value), "function") and islclosure(Value) and getrenv().debug.info(Value, "s"):find("SwordsController") then
            if rawequal(getrenv().debug.info(Value, "l"), 276) then
                HashOne = getconstant(Value, 62)
                HashTwo = getconstant(Value, 64)
                HashThree = getconstant(Value, 65)
            end
        end 
    end
end)()


LPH_NO_VIRTUALIZE(function()
    for Index, Object in next, game:GetDescendants() do
        if Object:IsA("RemoteEvent") and string.find(Object.Name, "\n") then
            Object.Changed:Once(function()
                table.insert(PropertyChangeOrder, Object)
            end)
        end
    end
end)()


repeat
    task.wait()
until #PropertyChangeOrder == 3


local ShouldPlayerJump = PropertyChangeOrder[1]
local MainRemote = PropertyChangeOrder[2]
local GetOpponentPosition = PropertyChangeOrder[3]

local Parry_Key

for Index, Value in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
    if Value and Value.Function and not iscclosure(Value.Function)  then
        for Index2,Value2 in pairs(getupvalues(Value.Function)) do
            if type(Value2) == "function" then
                Parry_Key = getupvalue(getupvalue(Value2, 2), 17);
            end;
        end;
    end;
end;

local function Parry(...)
    ShouldPlayerJump:FireServer(HashOne, Parry_Key, ...)
    MainRemote:FireServer(HashTwo, Parry_Key, ...)
    GetOpponentPosition:FireServer(HashThree, Parry_Key, ...)
end

local Parries = 0

function create_animation(object, info, value)
    local animation = game:GetService('TweenService'):Create(object, info, value)

    animation:Play()
    task.wait(info.Time)

    Debris:AddItem(animation, 0)

    animation:Destroy()
    animation = nil
end

local Animation = {}
Animation.storage = {}

Animation.current = nil
Animation.track = nil

for _, v in pairs(game:GetService("ReplicatedStorage").Misc.Emotes:GetChildren()) do
    if v:IsA("Animation") and v:GetAttribute("EmoteName") then
        local Emote_Name = v:GetAttribute("EmoteName")
        Animation.storage[Emote_Name] = v
    end
end

local Emotes_Data = {}

for Object in pairs(Animation.storage) do
    table.insert(Emotes_Data, Object)
end

table.sort(Emotes_Data)

local Auto_Parry = {}

function Auto_Parry.Parry_Animation()
    local Parry_Animation = game:GetService("ReplicatedStorage").Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword = Player.Character:GetAttribute('CurrentlyEquippedSword')

    if not Current_Sword then
        return
    end

    if not Parry_Animation then
        return
    end

    local Sword_Data = game:GetService("ReplicatedStorage").Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)

    if not Sword_Data or not Sword_Data['AnimationType'] then
        return
    end

    for _, object in pairs(game:GetService('ReplicatedStorage').Shared.SwordAPI.Collection:GetChildren()) do
        if object.Name == Sword_Data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                local sword_animation_type = 'GrabParry'

                if object:FindFirstChild('Grab') then
                    sword_animation_type = 'Grab'
                end

                Parry_Animation = object[sword_animation_type]
            end
        end
    end

    Grab_Parry = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
    Grab_Parry:Play()
end

function Auto_Parry.Play_Animation(v)
    local Animations = Animation.storage[v]

    if not Animations then
        return false
    end

    local Animator = Player.Character.Humanoid.Animator

    if Animation.track then
        Animation.track:Stop()
    end

    Animation.track = Animator:LoadAnimation(Animations)
    Animation.track:Play()

    Animation.current = v
end

function Auto_Parry.Get_Balls()
    local Balls = {}

    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            table.insert(Balls, Instance)
        end
    end
    return Balls
end

function Auto_Parry.Get_Ball()
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            return Instance
        end
    end
end

function Auto_Parry.Lobby_Balls()
    for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
        if Instance:GetAttribute("realBall") then
            return Instance
        end
    end
end


local Closest_Entity = nil

function Auto_Parry.Closest_Player()
    local Max_Distance = math.huge
    local Found_Entity = nil
    
    for _, Entity in pairs(workspace.Alive:GetChildren()) do
        if tostring(Entity) ~= tostring(Player) then
            if Entity.PrimaryPart then  -- Check if PrimaryPart exists
                local Distance = Player:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < Max_Distance then
                    Max_Distance = Distance
                    Found_Entity = Entity
                end
            end
        end
    end
    
    Closest_Entity = Found_Entity
    return Found_Entity
end

function Auto_Parry:Get_Entity_Properties()
    Auto_Parry.Closest_Player()

    if not Closest_Entity then
        return false
    end

    local Entity_Velocity = Closest_Entity.PrimaryPart.Velocity
    local Entity_Direction = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local Entity_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude

    return {
        Velocity = Entity_Velocity,
        Direction = Entity_Direction,
        Distance = Entity_Distance
    }
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled


function Auto_Parry.Parry_Data(Parry_Type)
    Auto_Parry.Closest_Player()
    
    local Events = {}
    local Camera = workspace.CurrentCamera
    local Vector2_Mouse_Location
    
    if Last_Input == Enum.UserInputType.MouseButton1 or (Enum.UserInputType.MouseButton2 or Last_Input == Enum.UserInputType.Keyboard) then
        local Mouse_Location = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {Mouse_Location.X, Mouse_Location.Y}
    else
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    
    if isMobile then
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    
    local Players_Screen_Positions = {}
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v ~= Player.Character then
            local worldPos = v.PrimaryPart.Position
            local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
            
            if isOnScreen then
                Players_Screen_Positions[v] = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            Events[tostring(v)] = screenPos
        end
    end
    
    if Parry_Type == 'Camera' then
        return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Backwards' then
        local Backwards_Direction = Camera.CFrame.LookVector * -10000
        Backwards_Direction = Vector3.new(Backwards_Direction.X, 0, Backwards_Direction.Z)
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Backwards_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'Straight' then
        local Aimed_Player = nil
        local Closest_Distance = math.huge
        local Mouse_Vector = Vector2.new(Vector2_Mouse_Location[1], Vector2_Mouse_Location[2])
        
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character then
                local worldPos = v.PrimaryPart.Position
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
                
                if isOnScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (Mouse_Vector - playerScreenPos).Magnitude
                    
                    if distance < Closest_Distance then
                        Closest_Distance = distance
                        Aimed_Player = v
                    end
                end
            end
        end
        
        if Aimed_Player then
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Aimed_Player.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        else
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Closest_Entity.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        end
    end
    
    if Parry_Type == 'Random' then
        return {0, CFrame.new(Camera.CFrame.Position, Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'High' then
        local High_Direction = Camera.CFrame.UpVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + High_Direction), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Left' then
        local Left_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Left_Direction), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Right' then
        local Right_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Right_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'RandomTarget' then
        local candidates = {}
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character and v.PrimaryPart then
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(v.PrimaryPart.Position)
                if isOnScreen then
                    table.insert(candidates, {
                        character = v,
                        screenXY  = { screenPos.X, screenPos.Y }
                    })
                end
            end
        end
        if #candidates > 0 then
            local pick = candidates[ math.random(1, #candidates) ]
            local lookCFrame = CFrame.new(Player.Character.PrimaryPart.Position, pick.character.PrimaryPart.Position)
            return {0, lookCFrame, Events, pick.screenXY}
        else
            return {0, Camera.CFrame, Events, { Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 }}
        end
    end
    
    return Parry_Type
end

function Auto_Parry.Parry(Parry_Type)
    local Parry_Data = Auto_Parry.Parry_Data(Parry_Type)

    if not firstParryFired then
        performFirstPress(firstParryType)
        firstParryFired = true
    else
        Parry(Parry_Data[1], Parry_Data[2], Parry_Data[3], Parry_Data[4])
    end

    if Parries > 7 then
        return false
    end

    Parries += 1

    task.delay(0.5, function()
        if Parries > 0 then
            Parries -= 1
        end
    end)
end

local Lerp_Radians = 0
local Last_Warping = tick()

function Auto_Parry.Linear_Interpolation(a, b, time_volume)
    return a + (b - a) * time_volume
end

local Previous_Velocity = {}
local Curving = tick()

local Runtime = workspace.Runtime


function Auto_Parry.Is_Curved()
    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return false
    end

    local Zoomies = Ball:FindFirstChild('zoomies')

    if not Zoomies then
        return false
    end

    local Velocity = Zoomies.VectorVelocity
    local Ball_Direction = Velocity.Unit
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)
    local Speed = Velocity.Magnitude
    local Speed_Threshold = math.min(Speed / 100, 40)
    local Direction_Difference = (Ball_Direction - Velocity).Unit
    local Direction_Similarity = Direction:Dot(Direction_Difference)
    local Dot_Difference = Dot - Direction_Similarity
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Pings = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
    local Dot_Threshold = 0.5 - (Pings / 1000)
    local Reach_Time = Distance / Speed - (Pings / 1000)
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold
    local Clamped_Dot = math.clamp(Dot, -1, 1)
    local Radians = math.rad(math.asin(Clamped_Dot))

    Lerp_Radians = Auto_Parry.Linear_Interpolation(Lerp_Radians, Radians, 0.8)

    if Speed > 100 and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end

    if Distance < Ball_Distance_Threshold then
        return false
    end

    if Dot_Difference < Dot_Threshold then
        return true
    end

    if Lerp_Radians < 0.018 then
        Last_Warping = tick()
    end

    if (tick() - Last_Warping) < (Reach_Time / 1.5) then
        return true
    end

    if (tick() - Curving) < (Reach_Time / 1.5) then
        return true
    end

    return Dot < Dot_Threshold
end

function Auto_Parry:Get_Ball_Properties()
    local Ball = Auto_Parry.Get_Ball()
    local Ball_Velocity = Vector3.zero
    local Ball_Origin = Ball
    local Ball_Direction = (Player.Character.PrimaryPart.Position - Ball_Origin.Position).Unit
    local Ball_Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Ball_Dot = Ball_Direction:Dot(Ball_Velocity.Unit)

    return {
        Velocity = Ball_Velocity,
        Direction = Ball_Direction,
        Distance = Ball_Distance,
        Dot = Ball_Dot
    }
end

function Auto_Parry.Spam_Service(self)
    local Ball = Auto_Parry.Get_Ball()

    local Entity = Auto_Parry.Closest_Player()

    if not Ball then
        return false
    end

    if not Entity or not Entity.PrimaryPart then
        return false
    end

    local Spam_Accuracy = 0

    local Velocity = Ball.AssemblyLinearVelocity
    local Speed = Velocity.Magnitude

    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Velocity.Unit)

    local Target_Position = Entity.PrimaryPart.Position
    local Target_Distance = Player:DistanceFromCharacter(Target_Position)

    local Maximum_Spam_Distance = self.Ping + math.min(Speed / 6, 95)

    if self.Entity_Properties.Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    if self.Ball_Properties.Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    if Target_Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    local Maximum_Speed = 5 - math.min(Speed / 5, 5)
    local Maximum_Dot = math.clamp(Dot, -1, 0) * Maximum_Speed

    Spam_Accuracy = Maximum_Spam_Distance - Maximum_Dot

    return Spam_Accuracy
end

local Connections_Manager = {}
local Selected_Parry_Type = "Camera"
local Infinity = false

ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    if b then
        Infinity = true
    else
        Infinity = false
    end
end)

local Parried = false
local Last_Parry = 0
local AutoParry = true
local Balls = workspace:WaitForChild('Balls')
local CurrentBall = nil
local InputTask = nil
local Cooldown = 0.02
local RunTime = workspace:FindFirstChild("Runtime")

local function GetBall()
    for _, Ball in ipairs(Balls:GetChildren()) do
        if Ball:FindFirstChild("ff") then
            return Ball
        end
    end
    return nil
end

local function SpamInput(Label)
    if InputTask then return end
    InputTask = task.spawn(function()
        while AutoParry do
            Auto_Parry.Parry(Selected_Parry_Type)
            task.wait(Cooldown)
        end
        InputTask = nil
    end)
end

Balls.ChildAdded:Connect(function(Value)
    Value.ChildAdded:Connect(function(Child)
        if getgenv().SlashOfFuryDetection and Child.Name == 'ComboCounter' then
            local Sof_Label = Child:FindFirstChildOfClass('TextLabel')

            if Sof_Label then
                repeat
                    local Slashes_Counter = tonumber(Sof_Label.Text)

                    if Slashes_Counter and Slashes_Counter < 32 then
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end

                    task.wait()

                until not Sof_Label.Parent or not Sof_Label
            end
        end
    end)
end)

local player10239123 = Players.LocalPlayer

RunTime.ChildAdded:Connect(function(Object)
    local Name = Object.Name
    if getgenv().PhantomV2Detection then
        if Name == "maxTransmission" or Name == "transmissionpart" then
            local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
            if Weld then
                local Character = player10239123.Character or player10239123.CharacterAdded:Wait()
                if Character and Weld.Part1 == Character.HumanoidRootPart then
                    CurrentBall = GetBall()
                    Weld:Destroy()
    
                    if CurrentBall then
                        local FocusConnection
                        FocusConnection = RunService.RenderStepped:Connect(function()
                            local Highlighted = CurrentBall:GetAttribute("highlighted")
    
                            if Highlighted == true then
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
    
                                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                                if HumanoidRootPart then
                                    local PlayerPosition = HumanoidRootPart.Position
                                    local BallPosition = CurrentBall.Position
                                    local PlayerToBall = (BallPosition - PlayerPosition).Unit
    
                                    game.Players.LocalPlayer.Character.Humanoid:Move(PlayerToBall, false)
                                end
    
                            elseif Highlighted == false then
                                FocusConnection:Disconnect()
    
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
                                game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, 0), false)
    
                                task.delay(3, function()
                                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                end)
    
                                CurrentBall = nil
                            end
                        end)
    
                        task.delay(3, function()
                            if FocusConnection and FocusConnection.Connected then
                                FocusConnection:Disconnect()
    
                                game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, 0), false)
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                CurrentBall = nil
                            end
                        end)
                    end
                end
            end
        end
    end
end)

local player11 = game.Players.LocalPlayer
local PlayerGui = player11:WaitForChild("PlayerGui")
local playerGui = player11:WaitForChild("PlayerGui")
local Hotbar = PlayerGui:WaitForChild("Hotbar")
local ParryCD = playerGui.Hotbar.Block.UIGradient
local AbilityCD = playerGui.Hotbar.Ability.UIGradient

local function isCooldownInEffect1(uigradient)
    return uigradient.Offset.Y < 0.4
end

local function isCooldownInEffect2(uigradient)
    return uigradient.Offset.Y == 0.5
end

local function cooldownProtection()
    if isCooldownInEffect1(ParryCD) then
        game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:Fire()
        return true
    end
    return false
end

local function AutoAbility()
    if isCooldownInEffect2(AbilityCD) then
        if Player.Character.Abilities["Raging Deflection"].Enabled or Player.Character.Abilities["Rapture"].Enabled or Player.Character.Abilities["Calming Deflection"].Enabled or Player.Character.Abilities["Aerodynamic Slash"].Enabled or Player.Character.Abilities["Fracture"].Enabled or Player.Character.Abilities["Death Slash"].Enabled then
            Parried = true
            game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:Fire()
            task.wait(2.432)
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
            return true
        end
    end
    return false
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Library-DYHUB/refs/heads/main/DYHUB1-UI.lua"))()
local UI = Library.new()
UI:load()

local BlatantTab = UI:create_tab("Blatant", "rbxassetid://76499042599127")
local PlayerTab = UI:create_tab("Player", "rbxassetid://126017907477623")
local WorldTab = UI:create_tab("World", "rbxassetid://7733964126")
local MicTab = UI:create_tab("Misc", "rbxassetid://10723424838")

local AutoParryModule = BlatantTab:create_module({
    title = "Auto Parry",
    description = "Automatically Parries Ball",
    section = "left",
    flag = "auto_parry",
    callback = function(state)
        if state then
             Connections_Manager['Auto Parry'] = RunService.PreSimulation:Connect(function()
                    local One_Ball = Auto_Parry.Get_Ball()
                    local Balls = Auto_Parry.Get_Balls()

                    for _, Ball in pairs(Balls) do

                        if not Ball then
                            return
                        end

                        local Zoomies = Ball:FindFirstChild('zoomies')
                        if not Zoomies then
                            return
                        end

                        Ball:GetAttributeChangedSignal('target'):Once(function()
                            Parried = false
                        end)

                        if Parried then
                            return
                        end

                        local Ball_Target = Ball:GetAttribute('target')
                        local One_Target = One_Ball:GetAttribute('target')

                        local Velocity = Zoomies.VectorVelocity

                        local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude

                        local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 10

                        local Ping_Threshold = math.clamp(Ping / 10, 5, 17)

                        local Speed = Velocity.Magnitude

                        local cappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                        local speed_divisor_base = 2.4 + cappedSpeedDiff * 0.002

                        local effectiveMultiplier = Speed_Divisor_Multiplier
                        if getgenv().RandomParryAccuracyEnabled then
                            if Speed < 200 then
                                effectiveMultiplier = 0.7 + (math.random(40, 100) - 1) * (0.35 / 99)
                            else
                                effectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                            end
                        end

                        local speed_divisor = speed_divisor_base * effectiveMultiplier
                        local Parry_Accuracy = Ping_Threshold + math.max(Speed / speed_divisor, 9.5)

                        local Curved = Auto_Parry.Is_Curved()

                        if Ball:FindFirstChild('AeroDynamicSlashVFX') then
                            Debris:AddItem(Ball.AeroDynamicSlashVFX, 0)
                            Tornado_Time = tick()
                        end

                        if Runtime:FindFirstChild('Tornado') then
                            if (tick() - Tornado_Time) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then
                            return
                            end
                        end

                        if One_Target == tostring(Player) and Curved then
                            return
                        end

                        if Ball:FindFirstChild("ComboCounter") then
                            return
                        end

                        local Singularity_Cape = Player.Character.PrimaryPart:FindFirstChild('SingularityCape')
                        if Singularity_Cape then
                            return
                        end 

                        if getgenv().InfinityDetection and Infinity then
                            return
                        end

                        if getgenv().DeathSlashDetection and deathshit then
                            return
                        end

                        if getgenv().TimeHoleDetection and timehole then
                            return
                        end

                        if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                            if getgenv().AutoAbility and AutoAbility() then
                                return
                            end
                        end

                        if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                            if getgenv().CooldownProtection and cooldownProtection() then
                                return
                            end

                            local Parry_Time = os.clock()
                            local Time_View = Parry_Time - (Last_Parry)
                            if Time_View > 0.5 then
                                Auto_Parry.Parry_Animation()
                            end

                            if getgenv().AutoParryKeypress then
                                VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
                            else
                                Auto_Parry.Parry(Selected_Parry_Type)
                            end

                            Last_Parry = Parry_Time
                            Parried = true
                        end
                        local Last_Parrys = tick()
                        repeat
                            RunService.PreSimulation:Wait()
                        until (tick() - Last_Parrys) >= 1 or not Parried
                        Parried = false
                    end
                end)
            else
                if Connections_Manager['Auto Parry'] then
                    Connections_Manager['Auto Parry']:Disconnect()
                    Connections_Manager['Auto Parry'] = nil
                end
            end
        end
    })
    
local parryTypeMap = {
    ["Camera"] = "Camera",
    ["Random"] = "Random",
    ["Backwards"] = "Backwards",
    ["Straight"] = "Straight",
    ["High"] = "High",
    ["Left"] = "Left",
    ["Right"] = "Right",
    ["Random Target"] = "RandomTarget"
}
    
AutoParryModule:create_dropdown({
    title = "Curve Type",
    flag = "curve_type",
    options = {"Camera", "Random", "Backwards", "Straight", "High", "Left", "Right", "Random Target"},
    maximum_options = 8,
    multi_dropdown = false,
    callback = function(value)
       Selected_Parry_Type = parryTypeMap[value] or value
    end
})

AutoParryModule:create_slider({
    title = "Parry Accuracy",
    flag = "parry_accuracy",
    minimum_value = -5,
    maximum_value = 100,
    value = 100,
    round_number = true,
    callback = function(value)
        Speed_Divisor_Multiplier = 0.7 + (value - 1) * (0.35 / 99)
	end
})

AutoParryModule:create_divider({
    showtopic = true,
    title = "",
    disableline = false
})

AutoParryModule:create_checkbox({
    title = "Randomized Parry Accuracy",
    flag = "random_parry_accuracy",
    callback = function(value)
       getgenv().RandomParryAccuracyEnabled = value      
    end
})

AutoParryModule:create_checkbox({
    title = "Phantom Detection",
    flag = "Phantom",
    callback = function(value)
        PhantomV2Detection = value 
    end
})

AutoParryModule:create_checkbox({
    title = "Infinity Detection",
    flag = "infinity",
    callback = function(value)
        getgenv().InfinityDetection = value
    end
})

AutoParryModule:create_checkbox({
    title = "Keypress",
    flag = "keypress1",
    callback = function(value)
        getgenv().AutoParryKeypress = value
    end
})

AutoParryModule:create_checkbox({
    title = "Notify",
    flag = "notify1",
    callback = function(state)
     end
})

local AutoSpamModule = BlatantTab:create_module({
    title = "Auto Spam Parry",
    description = "Automatically Spam Parries Ball",
    section = "right",
    flag = "auto_spam",
    callback = function(value)
        if value then
            Connections_Manager['Auto Spam'] = RunService.PreSimulation:Connect(function()
                local Ball = Auto_Parry.Get_Ball()

                if not Ball then
                    return
                end

                local Zoomies = Ball:FindFirstChild('zoomies')

                if not Zoomies then
                    return
                end

                Auto_Parry.Closest_Player()

                local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()

                local Ping_Threshold = math.clamp(Ping / 10, 18.5, 70)

                local Ball_Target = Ball:GetAttribute('target')

                local Ball_Properties = Auto_Parry:Get_Ball_Properties()
                local Entity_Properties = Auto_Parry:Get_Entity_Properties()

                local Spam_Accuracy = Auto_Parry.Spam_Service({
                    Ball_Properties = Ball_Properties,
                    Entity_Properties = Entity_Properties,
                    Ping = Ping_Threshold
                })

                local Target_Position = Closest_Entity.PrimaryPart.Position
                local Target_Distance = Player:DistanceFromCharacter(Target_Position)

                local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
                local Ball_Direction = Zoomies.VectorVelocity.Unit

                local Dot = Direction:Dot(Ball_Direction)

                local Distance = Player:DistanceFromCharacter(Ball.Position)

                if not Ball_Target then
                    return
                end

                if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then
                    return
                end
                
                local Pulsed = Player.Character:GetAttribute('Pulsed')

                if Pulsed then
                    return
                end

                if Ball_Target == tostring(Player) and Target_Distance > 25 and Distance > 25 then
                    return
                end

                local threshold = ParryThreshold

                if Distance <= Spam_Accuracy and Parries > threshold then
                    if getgenv().SpamParryKeypress then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                    else
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                end
            end)
        else
            if Connections_Manager['Auto Spam'] then
                Connections_Manager['Auto Spam']:Disconnect()
                Connections_Manager['Auto Spam'] = nil
            end
        end
    end
})

AutoSpamModule:create_slider({
    title = "Spam Threshold",
    flag = "spam_threshould",
    minimum_value = 1,
    maximum_value = 3,
    value = 2.5,
    round_number = false,
    callback = function(value)
        SpamThreshold = value
	end
})

AutoSpamModule:create_divider({
    showtopic = true,
    title = "",
    disableline = false
})

AutoSpamModule:create_checkbox({
    title = "UI",
    flag = "u_i",
    callback = function(value)
        getgenv().spamui = value

        if value then
            local gui = Instance.new("ScreenGui")
            gui.Name = "ManualSpamUI"
            gui.ResetOnSpawn = false
            gui.Parent = game.CoreGui

            local frame = Instance.new("Frame")
            frame.Name = "MainFrame"
            frame.Position = UDim2.new(0, 20, 0, 20)
            frame.Size = UDim2.new(0, 200, 0, 100)
            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Draggable = true
            frame.Parent = gui

            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, 12)
            uiCorner.Parent = frame

            local uiStroke = Instance.new("UIStroke")
            uiStroke.Thickness = 2
            uiStroke.Color = Color3.fromRGB(255, 0, 0)
            uiStroke.Parent = frame

            local button = Instance.new("TextButton")
            button.Name = "ClashModeButton"
            button.Text = "Clash Mode"
            button.Size = UDim2.new(0, 160, 0, 40)
            button.Position = UDim2.new(0.5, -80, 0.5, -20)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Font = Enum.Font.GothamSemibold
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 22
            button.Parent = frame

            local activated = false

            local function toggle()
                activated = not activated
                button.Text = activated and "Stop" or "Clash Mode"
                if activated then
                    Connections_Manager['Manual Spam UI'] = game:GetService("RunService").Heartbeat:Connect(function()
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end)
                else
                    if Connections_Manager['Manual Spam UI'] then
                        Connections_Manager['Manual Spam UI']:Disconnect()
                        Connections_Manager['Manual Spam UI'] = nil
                    end
                end
            end

            button.MouseButton1Click:Connect(toggle)
        else
            if game.CoreGui:FindFirstChild("ManualSpamUI") then
                game.CoreGui:FindFirstChild("ManualSpamUI"):Destroy()
            end

            if Connections_Manager['Manual Spam UI'] then
                Connections_Manager['Manual Spam UI']:Disconnect()
                Connections_Manager['Manual Spam UI'] = nil
            end
        end
    end
})

local LobbyModule = BlatantTab:create_module({
    title = "Lobby AP",
    description = "Automatically Parries Ball In Lobby",
    section = "left",
    flag = "lobby_ap",
    callback = function(state)
        if state then
              Connections_Manager['Lobby AP'] = RunService.Heartbeat:Connect(function()
                    local Ball = Auto_Parry.Lobby_Balls()
                    if not Ball then
                        return
                    end
    
                    local Zoomies = Ball:FindFirstChild('zoomies')
                    if not Zoomies then
                        return
                    end
    
                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        Training_Parried = false
                    end)
    
                    if Training_Parried then
                        return
                    end
    
                    local Ball_Target = Ball:GetAttribute('target')
                    local Velocity = Zoomies.VectorVelocity
                    local Distance = Player:DistanceFromCharacter(Ball.Position)
                    local Speed = Velocity.Magnitude
    
                    local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 10
                    local LobbyAPcappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                    local LobbyAPspeed_divisor_base = 2.4 + LobbyAPcappedSpeedDiff * 0.002
    
                    local LobbyAPeffectiveMultiplier = LobbyAP_Speed_Divisor_Multiplier
                    if getgenv().LobbyAPRandomParryAccuracyEnabled then
                        LobbyAPeffectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                    end
    
                    local LobbyAPspeed_divisor = LobbyAPspeed_divisor_base * LobbyAPeffectiveMultiplier
                    local LobbyAPParry_Accuracys = Ping + math.max(Speed / LobbyAPspeed_divisor, 9.5)
    
                    if Ball_Target == tostring(Player) and Distance <= LobbyAPParry_Accuracys then
                            if getgenv().LobbyAPKeypress then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                            else
                                Auto_Parry.Parry(Selected_Parry_Type)
                            end
                        Training_Parried = true
                    end
                    local Last_Parrys = tick()
                    repeat 
                        RunService.PreSimulation:Wait() 
                    until (tick() - Last_Parrys) >= 1 or not Training_Parried
                    Training_Parried = false
                end)
            else
                if Connections_Manager['Lobby AP'] then
                    Connections_Manager['Lobby AP']:Disconnect()
                    Connections_Manager['Lobby AP'] = nil
                end
            end
        end
    })
    
LobbyModule:create_slider({
    title = "Lobby AP Accuracy",
    flag = "lobby_ap_accuracy",
    minimum_value = 1, 
    maximum_value = 100,
    value = 100,
    round_number = true,
    callback = function(value)
        Speed_Divisor_Multiplier = 0.7 + (value - 1) * (0.325 / 99)
	end
})

LobbyModule:create_divider({
    showtopic = true,
    title = "",
    disableline = false
})

LobbyModule:create_checkbox({
    title = "Randomized Lobby Parry Accuracy",
    flag = "radom_lobby_parry",
    callback = function(value)
        getgenv().LobbyAPRandomParryAccuracyEnabled = value
    end
})

LobbyModule:create_checkbox({
    title = "Keypress",
    flag = "keypress5",
    callback = function(value)
        getgenv().LobbyAPKeypress = value
    end
})

LobbyModule:create_checkbox({
    title = "Notify",
    flag = "notify5",
    callback = function(state)
     end
})

local SpeedModule = PlayerTab:create_module({
  title = "Speed",
  flag = "speed_hack",
  description = "Increases Player Speed",
  section = "left",
  callback = function(value)
      if value then
            Connections_Manager['Strafe'] = game:GetService("RunService").PreSimulation:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = StrafeSpeed
                end
            end)
        else
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 36
            end
            
            if Connections_Manager['Strafe'] then
                Connections_Manager['Strafe']:Disconnect()
                Connections_Manager['Strafe'] = nil
            end
        end
    end
})

SpeedModule:create_slider({
    title = "Strafe Speed",
    flag = "strafe_speed",
    minimum_value = 36, 
    maximum_value = 200,
    value = 36,
    round_number = true,
    callback = function(value)
        StrafeSpeed = value
    end
})

local SpinModule = PlayerTab:create_module({
    title = "Spinbot",
    description = "Spins Player",
    section = "right",
    flag = "spin_bot",
    callback = function(value)
        getgenv().Spinbot = value
        if value then
            getgenv().spin = true
            getgenv().spinSpeed = getgenv().spinSpeed or 1 
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local Client = Players.LocalPlayer

            
            local function spinCharacter()
                while getgenv().spin do
                    RunService.Heartbeat:Wait()
                    local char = Client.Character
                    local funcHRP = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if char and funcHRP then
                        funcHRP.CFrame *= CFrame.Angles(0, getgenv().spinSpeed, 0)
                    end
                end
            end

            
            if not getgenv().spinThread then
                getgenv().spinThread = coroutine.create(spinCharacter)
                coroutine.resume(getgenv().spinThread)
            end

        else
            getgenv().spin = false

            
            if getgenv().spinThread then
                getgenv().spinThread = nil
            end
        end
    end
})

SpinModule:create_slider({
    title = "Spinbot Speed",
    flag = "spin_bot_Speed",
    minimum_value = 1, 
    maximum_value = 150,
    value = 1,
    round_number = true,
    callback = function(value)
        getgenv().spinSpeed = math.rad(value)
    end
})

local FovModule = PlayerTab:create_module({
    title = "Field of View",
    description = "Changes Camera POV",
    section = "left",
    flag = "field_of_view",
    callback = function(value)
        getgenv().CameraEnabled = value
        local Camera = game:GetService("Workspace").CurrentCamera

        if value then
            getgenv().CameraFOV = getgenv().CameraFOV or 70
            Camera.FieldOfView = getgenv().CameraFOV
            
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = game:GetService("RunService").RenderStepped:Connect(function()
                    if getgenv().CameraEnabled then
                        Camera.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            Camera.FieldOfView = 70
            
            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end
})

FovModule:create_slider({
    title = "Camera FOV",
    flag = "camera_fov",
    minimum_value = 50, 
    maximum_value = 120,
    value = 70,
    round_number = true,
    callback = function(value)
        getgenv().CameraFOV = value
        if getgenv().CameraEnabled then
            game:GetService("Workspace").CurrentCamera.FieldOfView = value
        end
    end
})

-- Khởi tạo danh sách emote từ Animation.storage
local Emotes_Data = {}
for emoteName in pairs(Animation.storage) do
	table.insert(Emotes_Data, emoteName)
end
table.sort(Emotes_Data)

-- Emote mặc định
local selected_animation = Emotes_Data[1]

-- Hàm phát emote
March = March or {}
March.Play_Anim = function(emoteName)
	local anim = Animation.storage[emoteName]
	if not anim then return false end

	local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then return false end

	if Animation.track then
		Animation.track:Stop()
	end

	local track = animator:LoadAnimation(anim)
	Animation.track = track
	track:Play()
	Animation.current = emoteName

	return true
end

-- Biến điều khiển trạng thái toggle
local Emotes_Enabled = false

local EmoteModule = PlayerTab:create_module({
    title = "Emotes",
    description = "Custom Emotes",
    section = "right",
    flag = "emote",
    callback = function(value)
        if value then
            Emotes_Enabled = true
        else
            Emotes_Enabled = false
            if Animation.track then
                Animation.track:Stop()
                Animation.track = nil
                Animation.current = nil
            end
        end
    end
})

EmoteModule:create_dropdown({
    title = "Selected Emotes",
    flag = "select_emote",
    options = Emotes_Data,
    maximum_options = 10000,
    multi_dropdown = false,
    callback = function(value)
       selected_animation = value
		if Emotes_Enabled then
			March.Play_Anim(value)
		end
	end
})

_G.PlayerCosmeticsCleanup = {}

local CosmeticModule = PlayerTab:create_module({
    title = "Player Cosmetics",
    description = "Apply Headless And Korblox",
    section = "left",
    flag = "player_cosmetic",
    callback = function(value)
       local players = game:GetService("Players")
        local lp = players.LocalPlayer

        local function applyKorblox(character)
            local rightLeg = character:FindFirstChild("RightLeg") or character:FindFirstChild("Right Leg")
            if not rightLeg then
                warn("Right leg not found on character")
                return
            end
            
            for _, child in pairs(rightLeg:GetChildren()) do
                if child:IsA("SpecialMesh") then
                    child:Destroy()
                end
            end
            local specialMesh = Instance.new("SpecialMesh")
            specialMesh.MeshId = "rbxassetid://101851696"
            specialMesh.TextureId = "rbxassetid://115727863"
            specialMesh.Scale = Vector3.new(1, 1, 1)
            specialMesh.Parent = rightLeg
        end

        local function saveRightLegProperties(char)
            if char then
                local rightLeg = char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
                if rightLeg then
                    local originalMesh = rightLeg:FindFirstChildOfClass("SpecialMesh")
                    if originalMesh then
                        _G.PlayerCosmeticsCleanup.originalMeshId = originalMesh.MeshId
                        _G.PlayerCosmeticsCleanup.originalTextureId = originalMesh.TextureId
                        _G.PlayerCosmeticsCleanup.originalScale = originalMesh.Scale
                    else
                        _G.PlayerCosmeticsCleanup.hadNoMesh = true
                    end
                    
                    _G.PlayerCosmeticsCleanup.rightLegChildren = {}
                    for _, child in pairs(rightLeg:GetChildren()) do
                        if child:IsA("SpecialMesh") then
                            table.insert(_G.PlayerCosmeticsCleanup.rightLegChildren, {
                                ClassName = child.ClassName,
                                Properties = {
                                    MeshId = child.MeshId,
                                    TextureId = child.TextureId,
                                    Scale = child.Scale
                                }
                            })
                        end
                    end
                end
            end
        end
        
        local function restoreRightLeg(char)
            if char then
                local rightLeg = char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
                if rightLeg and _G.PlayerCosmeticsCleanup.rightLegChildren then
                    for _, child in pairs(rightLeg:GetChildren()) do
                        if child:IsA("SpecialMesh") then
                            child:Destroy()
                        end
                    end
                    
                    if _G.PlayerCosmeticsCleanup.hadNoMesh then
                        return
                    end
                    
                    for _, childData in ipairs(_G.PlayerCosmeticsCleanup.rightLegChildren) do
                        if childData.ClassName == "SpecialMesh" then
                            local newMesh = Instance.new("SpecialMesh")
                            newMesh.MeshId = childData.Properties.MeshId
                            newMesh.TextureId = childData.Properties.TextureId
                            newMesh.Scale = childData.Properties.Scale
                            newMesh.Parent = rightLeg
                        end
                    end
                end
            end
        end

        if value then
            CosmeticsActive = true

            getgenv().Config = {
                Headless = true
            }
            
            if lp.Character then
                local head = lp.Character:FindFirstChild("Head")
                if head and getgenv().Config.Headless then
                    _G.PlayerCosmeticsCleanup.headTransparency = head.Transparency
                    
                    local decal = head:FindFirstChildOfClass("Decal")
                    if decal then
                        _G.PlayerCosmeticsCleanup.faceDecalId = decal.Texture
                        _G.PlayerCosmeticsCleanup.faceDecalName = decal.Name
                    end
                end
                
                saveRightLegProperties(lp.Character)
                applyKorblox(lp.Character)
            end
            
            _G.PlayerCosmeticsCleanup.characterAddedConn = lp.CharacterAdded:Connect(function(char)
                local head = char:FindFirstChild("Head")
                if head and getgenv().Config.Headless then
                    _G.PlayerCosmeticsCleanup.headTransparency = head.Transparency
                    
                    local decal = head:FindFirstChildOfClass("Decal")
                    if decal then
                        _G.PlayerCosmeticsCleanup.faceDecalId = decal.Texture
                        _G.PlayerCosmeticsCleanup.faceDecalName = decal.Name
                    end
                end
                
                saveRightLegProperties(char)
                applyKorblox(char)
            end)
            
            if getgenv().Config.Headless then
                headLoop = task.spawn(function()
                    while CosmeticsActive do
                        local char = lp.Character
                        if char then
                            local head = char:FindFirstChild("Head")
                            if head then
                                head.Transparency = 1
                                local decal = head:FindFirstChildOfClass("Decal")
                                if decal then
                                    decal:Destroy()
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end

        else
            CosmeticsActive = false

            if _G.PlayerCosmeticsCleanup.characterAddedConn then
                _G.PlayerCosmeticsCleanup.characterAddedConn:Disconnect()
                _G.PlayerCosmeticsCleanup.characterAddedConn = nil
            end

            if headLoop then
                task.cancel(headLoop)
                headLoop = nil
            end

            local char = lp.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head and _G.PlayerCosmeticsCleanup.headTransparency ~= nil then
                    head.Transparency = _G.PlayerCosmeticsCleanup.headTransparency
                    
                    if _G.PlayerCosmeticsCleanup.faceDecalId then
                        local newDecal = head:FindFirstChildOfClass("Decal") or Instance.new("Decal", head)
                        newDecal.Name = _G.PlayerCosmeticsCleanup.faceDecalName or "face"
                        newDecal.Texture = _G.PlayerCosmeticsCleanup.faceDecalId
                        newDecal.Face = Enum.NormalId.Front
                    end
                end
                
                restoreRightLeg(char)
            end

            _G.PlayerCosmeticsCleanup = {}
        end
    end
})

local player = game.Players.LocalPlayer
local flying = false
local arrowGui = nil

local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastCtrl = {f = 0, b = 0, l = 0, r = 0}
local speed = 0
local humanoidConnection

function notify(msg)
	game.StarterGui:SetCore("SendNotification", {
		Title = "Fly Status",
		Text = msg,
		Duration = 3
	})
end

function createArrowGui()
	if arrowGui then arrowGui:Destroy() end

	arrowGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	arrowGui.Name = "FlyControlGui"
	arrowGui.ResetOnSpawn = false

	local function createButton(name, pos, txt)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, 50, 0, 50)
		btn.Position = pos
		btn.Text = txt
		btn.TextScaled = true
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.BackgroundTransparency = 0.3
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Parent = arrowGui
		return btn
	end

	local centerX = 0.1
	local centerY = 0.65

	local up = createButton("Up", UDim2.new(centerX, 0, centerY - 0.1, 0), "↑")
	local down = createButton("Down", UDim2.new(centerX, 0, centerY + 0.1, 0), "↓")
	local left = createButton("Left", UDim2.new(centerX - 0.1, 0, centerY, 0), "←")
	local right = createButton("Right", UDim2.new(centerX + 0.1, 0, centerY, 0), "→")

	up.MouseButton1Down:Connect(function() ctrl.f = 1 end)
	up.MouseButton1Up:Connect(function() ctrl.f = 0 end)

	down.MouseButton1Down:Connect(function() ctrl.b = -1 end)
	down.MouseButton1Up:Connect(function() ctrl.b = 0 end)

	left.MouseButton1Down:Connect(function() ctrl.l = -1 end)
	left.MouseButton1Up:Connect(function() ctrl.l = 0 end)

	right.MouseButton1Down:Connect(function() ctrl.r = 1 end)
	right.MouseButton1Up:Connect(function() ctrl.r = 0 end)
end

function Fly()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end

	local bg = Instance.new("BodyGyro")
	local bv = Instance.new("BodyVelocity")
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.cframe = hrp.CFrame
	bg.Parent = hrp

	bv.velocity = Vector3.new(0, 0.1, 0)
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Parent = hrp

	flying = true
	notify("Fly Turned On✅")

	if humanoidConnection then humanoidConnection:Disconnect() end
	humanoidConnection = humanoid.Died:Connect(function()
		Unfly()
	end)

	coroutine.wrap(function()
		while flying and player.Character do
			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed + 0.5 + (speed / 15)
				if speed > 50 then speed = 50 end
			elseif speed ~= 0 then
				speed = speed - 1
				if speed < 0 then speed = 0 end
			end
			if speed ~= 0 then
				bv.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (ctrl.f + ctrl.b)) +
					(workspace.CurrentCamera.CFrame.RightVector * (ctrl.r + ctrl.l))) * speed
				lastCtrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			else
				bv.velocity = Vector3.new(0, 0.1, 0)
			end
			bg.cframe = workspace.CurrentCamera.CFrame
			task.wait()
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastCtrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)()
end

function Unfly()
	flying = false
	if arrowGui then
		arrowGui:Destroy()
		arrowGui = nil
	end
	if humanoidConnection then
		humanoidConnection:Disconnect()
	end
	notify("Fly Turned Off❌")
end

local FlyModule = PlayerTab:create_module({
    title = "Fly",
    description = "Allows Players to Fly",
    section = "right",
    flag = "fly",
    callback = function(value)
        if value then
			Fly()
		else
			Unfly()
		end
	end
})

FlyModule:create_checkbox({
    title = "UI [For Mobile]",
    flag = "u_i_mobile",
    callback = function(value)
        if value and flying then
			createArrowGui()
		elseif not value and arrowGui then
			arrowGui:Destroy()
			arrowGui = nil
		end
	end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noSlowConnection = nil
local stateDisablers = {}
local speedEnforcer = nil

local function enableNoSlow()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	-- Disable states that can cause slowdown
	local statesToDisable = {
		Enum.HumanoidStateType.Swimming,
		Enum.HumanoidStateType.Seated,
		Enum.HumanoidStateType.Climbing,
		Enum.HumanoidStateType.PlatformStanding
	}
	for _, state in ipairs(statesToDisable) do
		humanoid:SetStateEnabled(state, false)
		stateDisablers[state] = true
	end

	-- Remove potential interfering values
	for _, v in pairs(humanoid:GetDescendants()) do
		if v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("ObjectValue") then
			v:Destroy()
		end
	end

	-- Set speed immediately
	humanoid.WalkSpeed = 36

	-- Re-enforce speed if changed
	noSlowConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= 36 then
			humanoid.WalkSpeed = 36
		end
	end)

	-- Continuous check every frame
	speedEnforcer = RunService.RenderStepped:Connect(function()
		if humanoid and humanoid.WalkSpeed ~= 36 then
			humanoid.WalkSpeed = 36
		end
	end)
end

local function disableNoSlow()
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		-- Re-enable states
		for state, _ in pairs(stateDisablers) do
			humanoid:SetStateEnabled(state, true)
		end
	end

	if noSlowConnection then
		noSlowConnection:Disconnect()
		noSlowConnection = nil
	end

	if speedEnforcer then
		speedEnforcer:Disconnect()
		speedEnforcer = nil
	end
end

local NoSlowModule = PlayerTab:create_module({
    title = "No Slow",
    description = "Players Cannot Be Slowed Down In Any Way",
    section = "left",
    flag = "no_slow",
    callback = function(value)
       if value then
			enableNoSlow()
		else
			disableNoSlow()
		end
	end
})

local Sound_Effect = true
local sound_effect_type = "DC_15X"
local CustomId = "" -- Should be set to just the numeric ID, like "1234567890"
local sound_assets = {
    DC_15X = 'rbxassetid://936447863',
    Neverlose = 'rbxassetid://8679627751',
    Minecraft = 'rbxassetid://8766809464',
    MinecraftHit2 = 'rbxassetid://8458185621',
    TeamfortressBonk = 'rbxassetid://8255306220',
    TeamfortressBell = 'rbxassetid://2868331684',
    Custom = 'empty'
}
local SlashesNet = ReplicatedStorage:WaitForChild("Packages")._Index:FindFirstChild("sleitnick_net@0.1.0")
local SlashesRemote = SlashesNet and SlashesNet:FindFirstChild("net"):FindFirstChild("RE/SlashesOfFuryActivate")
local IsSlashesPending = false
local SlashesParryCount = 0
local SlashesActive = false
if SlashesRemote then
    SlashesRemote.OnClientEvent:Connect(function()
    if SOFD then
        IsSlashesPending = true
    end
    end)
end

local HitsoundModule = PlayerTab:create_module({
    title = "Hit Sounds",
    description = "Toggles Hit Sounds",
    section = "right",
    flag = "hit_sound",
    callback = function(state)
       if state then
	print("[ Debug ] Sound Effect Enabled")
	Sound_Effect = true
	Connections_Manager["SoundEffect"] = game.ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
		if not Sound_Effect then return end
		
		local sound_id
		if CustomId ~= "" and sound_effect_type == "Custom" then
			sound_id = "rbxassetid://" .. CustomId
		else
			sound_id = sound_assets[sound_effect_type]
		end
		
		if not sound_id then return end
		
		local sound = Instance.new("Sound")
		sound.SoundId = sound_id
		sound.Volume = 1
		sound.PlayOnRemove = true
		sound.Parent = workspace
		sound:Destroy()
	end)
else
	print("[ Debug ] Sound Effect Disabled")
	Sound_Effect = false
	if Connections_Manager["SoundEffect"] then
		Connections_Manager["SoundEffect"]:Disconnect()
		Connections_Manager["SoundEffect"] = nil
	end
end
    end
})

HitsoundModule:create_dropdown({
    title = "Sound Type",
    flag = "sound_effects",
    options = {"Disabled", "DC_15X", "Minecraft", "MinecraftHit2", "Neverlose", "TeamfortressBonk", "TeamfortressBell"},
    maximum_options = 14,
    multi_dropdown = false,
    callback = function(Option) sound_effect_type = Option end
})

local rainbowConnection = nil
local colorCorrection = nil
local lighting = game:GetService("Lighting")

local FilterModule = WorldTab:create_module({
    title = "Filter",
    description = "Toggles Custom World Filter Effects",
    section = "left",
    flag = "world_filter",
    callback = function(value)
     end
})

FilterModule:create_checkbox({
    title = "Enabled Hue",
    flag = "enable_hue",
    callback = function(value)
        if value then
			if not colorCorrection then
				colorCorrection = Instance.new("ColorCorrectionEffect")
				colorCorrection.Name = "RainbowFilter"
				colorCorrection.Saturation = 1
				colorCorrection.Contrast = 0.1
				colorCorrection.Brightness = 0
				colorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
				colorCorrection.Parent = lighting
			end

			local hue = 0
			rainbowConnection = RunService.RenderStepped:Connect(function()
				hue = (hue + 1) % 360
				local color = Color3.fromHSV(hue / 360, 1, 1)
				colorCorrection.TintColor = color
			end)
		else
			if rainbowConnection then
				rainbowConnection:Disconnect()
				rainbowConnection = nil
			end
			if colorCorrection then
				colorCorrection:Destroy()
				colorCorrection = nil
			end
		end
	end
})

local trailConnection = nil

local BallTrailModule = WorldTab:create_module({
    title = "Ball Trail",
    description = "Add Rainbow Line As The Ball Moves",
    section = "right",
    flag = "trial_ball",
    callback = function(value)
       if value then
			trailConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local function CreateRainbowTrail(ball)
					if ball:FindFirstChild("TriasTrail") then return end

					local at1 = Instance.new("Attachment", ball)
					local at2 = Instance.new("Attachment", ball)
					at1.Position = Vector3.new(0, 0.5, 0)
					at2.Position = Vector3.new(0, -0.5, 0)

					local trail = Instance.new("Trail")
					trail.Name = "TriasTrail"
					trail.Attachment0 = at1
					trail.Attachment1 = at2
					trail.Lifetime = 0.3
					trail.MinLength = 0.1
					trail.WidthScale = NumberSequence.new(1)
					trail.FaceCamera = true
					trail.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
						ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 127, 0)),
						ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 255, 0)),
						ColorSequenceKeypoint.new(0.48, Color3.fromRGB(0, 255, 0)),
						ColorSequenceKeypoint.new(0.64, Color3.fromRGB(0, 0, 255)),
						ColorSequenceKeypoint.new(0.80, Color3.fromRGB(75, 0, 130)),
						ColorSequenceKeypoint.new(1.0, Color3.fromRGB(148, 0, 211))
					})

					trail.Parent = ball
				end

				local ball = GetBall()
				if ball and not ball:FindFirstChild("TriasTrail") then
					CreateRainbowTrail(ball)
				end
			end)
		else
			if trailConnection then
				trailConnection:Disconnect()
				trailConnection = nil
			end

			-- Xoá trail nếu đang tắt toggle
			for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
				local trail = Ball:FindFirstChild("TriasTrail")
				if trail then
					trail:Destroy()
				end
				for _, att in ipairs(Ball:GetChildren()) do
					if att:IsA("Attachment") then
						att:Destroy()
					end
				end
			end
		end
	end
})

local cam = workspace.CurrentCamera
local originalSubject = cam.CameraSubject
local viewConnection = nil

local ViewBallModule = WorldTab:create_module({
    title = "View Ball",
    description = "Switch View From Character To Ball",
    section = "left",
    flag = "view_ball",
    callback = function(value)
        if value then
			viewConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local ball = GetBall()
				if ball and cam.CameraSubject ~= ball then
					cam.CameraSubject = ball
				end
			end)
		else
			if viewConnection then
				viewConnection:Disconnect()
				viewConnection = nil
			end
			cam.CameraSubject = Players.LocalPlayer.Character or Players.LocalPlayer
		end
	end
})

local abilityESPEnabled = false
local billboardLabels = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Connections_Manager = {}

local function createBillboardGui(p)
    local character = p.Character
    while not character or not character.Parent do
        task.wait()
        character = p.Character
    end
    local head = character:WaitForChild("Head")
    
    -- Check if BillboardGui already exists for this player
    local existingGui = billboardLabels[p] and billboardLabels[p].gui
    if existingGui then
        existingGui:Destroy() -- Clean up old GUI
    end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "AbilityESP_Billboard"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 200, 0, 25)
    billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.6
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.TextWrapped = true
    textLabel.Parent = billboardGui
    textLabel.Visible = false -- Start with label hidden
    textLabel.Text = "" -- Start with no text

    billboardLabels[p] = {
        gui = billboardGui,
        label = textLabel
    }

    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        -- Connect to humanoid's death to clean up
        humanoid.Died:Connect(function()
            textLabel.Visible = false
            textLabel.Text = ""
            billboardGui:Destroy() -- Destroy GUI on death
            billboardLabels[p] = nil -- Remove from tracking
        end)
    end
end

-- Handle existing players
for _, p in Players:GetPlayers() do
    if p ~= Player then
        p.CharacterAdded:Connect(function()
            createBillboardGui(p)
        end)
        if p.Character then
            createBillboardGui(p)
        end
    end
end

-- Handle new players
Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer ~= Player then
        newPlayer.CharacterAdded:Connect(function()
            createBillboardGui(newPlayer)
        end)
    end
end)

local AbilityModule = WorldTab:create_module({
    title = "Ability ESP",
    description = "ESP Ability All Player",
    section = "right",
    flag = "esp_ability",
    callback = function(state)
        abilityESPEnabled = state
        print("[ Debug ] Ability ESP " .. (state and "Enabled" or "Disabled"))
        if state then
            Connections_Manager["AbilityESP"] = RunService.Heartbeat:Connect(function()
                for p, data in pairs(billboardLabels) do
                    local label = data.label
                    if p.Character and p.Character:FindFirstChild("Head") then
                        local ability = p:GetAttribute("EquippedAbility")
                        label.Text = ability and (p.DisplayName .. " [" .. ability .. "]") or p.DisplayName
                        label.Visible = true
                    else
                        label.Visible = false
                        label.Text = ""
                    end
                end
            end)
        else
            if Connections_Manager["AbilityESP"] then
                Connections_Manager["AbilityESP"]:Disconnect()
                Connections_Manager["AbilityESP"] = nil
            end
            for _, data in pairs(billboardLabels) do
                local label = data.label
                label.Visible = false
                label.Text = "" -- Clear the text content
            end
        end
    end
})

local selectedSky = "Default"
local skyen = false
local function applySkybox(presetName)
if not skyen then return end
    local skyPresets = {
        Default = {"591058823", "591059876", "591058104", "591057861", "591057625", "591059642"},
        Vaporwave = {"1417494030", "1417494146", "1417494253", "1417494402", "1417494499", "1417494643"},
        Redshift = {"401664839", "401664862", "401664960", "401664881", "401664901", "401664936"},
        Desert = {"1013852", "1013853", "1013850", "1013851", "1013849", "1013854"},
        DaBaby = {"7245418472", "7245418472", "7245418472", "7245418472", "7245418472", "7245418472"},
        Minecraft = {"1876545003", "1876544331", "1876542941", "1876543392", "1876543764", "1876544642"},
        SpongeBob = {"7633178166", "7633178166", "7633178166", "7633178166", "7633178166", "7633178166"},
        Skibidi = {"14952256113", "14952256113", "14952256113", "14952256113", "14952256113", "14952256113"},
        Blaze = {"150939022", "150939038", "150939047", "150939056", "150939063", "150939082"},
        ["Pussy Cat"] = {"11154422902", "11154422902", "11154422902", "11154422902", "11154422902", "11154422902"},
        ["Among Us"] = {"5752463190", "5752463190", "5752463190", "5752463190", "5752463190", "5752463190"},
        ["Space Wave"] = {"16262356578", "16262358026", "16262360469", "16262362003", "16262363873", "16262366016"},
        ["Space Wave2"] = {"1233158420", "1233158838", "1233157105", "1233157640", "1233157995", "1233159158"},
        ["Turquoise Wave"] = {"47974894", "47974690", "47974821", "47974776", "47974859", "47974909"},
        ["Dark Night"] = {"6285719338", "6285721078", "6285722964", "6285724682", "6285726335", "6285730635"},
        ["Bright Pink"] = {"271042516", "271077243", "271042556", "271042310", "271042467", "271077958"},
        ["White Galaxy"] = {"5540798456", "5540799894", "5540801779", "5540801192", "5540799108", "5540800635"},
        ["Blue Galaxy"] = {"14961495673", "14961494492", "14961492844", "14961491298", "14961490439", "14961489508"}
    }

    local skyboxData = skyPresets[presetName]
    if not skyboxData then
        warn("Unknown sky preset: " .. tostring(presetName))
        return
    end

    local Lighting = game:GetService("Lighting")
    local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    local faces = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}

    for i, face in ipairs(faces) do
        Sky[face] = "rbxassetid://" .. skyboxData[i]
    end

    Lighting.GlobalShadows = not skyen -- Disable shadows only when sky is enabled
end

local SkyModule = WorldTab:create_module({
    title = "Custom Sky",
    description = "Changes Sky",
    section = "left",
    flag = "change_sky",
    callback = function(state)
        local Lighting = game:GetService("Lighting")
        local Sky = Lighting:FindFirstChildOfClass("Sky")

        if state then
            print("[ Debug ] Custom Sky Enabled")
            skyen = true
            if not Sky then
                Sky = Instance.new("Sky", Lighting)
            end
            while task.wait(1) and state do
            applySkybox(selectedSky)
            end
        else
            print("[ Debug ] Custom Sky Disabled")
            if Sky then
                Sky:Destroy() -- Remove the skybox entirely when disabled
            end
            skyen = false
            Lighting.GlobalShadows = true -- Restore default lighting settings
        end
    end
})

SkyModule:create_dropdown({
    title = "Selected Sky",
    flag = "select_sky",
    options = {"Default", "Vaporwave", "Redshift", "Desert", "DaBaby", "Minecraft", "SpongeBob", "Skibidi", "Blaze", "Pussy Cat", "Among Us", "Space Wave", "Space Wave2", "Turquoise Wave", "Dark Night", "Bright Pink", "White Galaxy", "Blue Galaxy"},
    maximum_options = 18,
    multi_dropdown = false,
    callback = function(option)
        selectedSky = option
        print("[ Debug ] Selected Sky: " .. option)
        applySkybox(option) -- Apply the skybox immediately
    end
})

local RunService = game:GetService("RunService")  
local Players = game:GetService("Players")  
local Camera = workspace.CurrentCamera  
local Player = Players.LocalPlayer  
  
local lookAtBallToggle = false  
local parryLookType = "Camera"  
  
local playerConn, cameraConn = nil, nil  
  
-- Hàm lấy quả bóng thật  
local function GetBall()  
	for _, Ball in ipairs(workspace.Balls:GetChildren()) do  
		if Ball:GetAttribute("realBall") then  
			return Ball  
		end  
	end  
end  
  
-- Hàm bật chức năng xoay  
local function EnableLookAt()  
	if parryLookType == "Character" then  
		playerConn = RunService.Stepped:Connect(function()  
			local Ball = GetBall()  
			local Character = Player.Character  
			if not Ball or not Character then return end  
  
			local HRP = Character:FindFirstChild("HumanoidRootPart")  
			if not HRP then return end  
  
			local lookPos = Vector3.new(Ball.Position.X, HRP.Position.Y, Ball.Position.Z)  
			HRP.CFrame = CFrame.lookAt(HRP.Position, lookPos)  
		end)  
	elseif parryLookType == "Camera" then  
		cameraConn = RunService.RenderStepped:Connect(function()  
			local Ball = GetBall()  
			if not Ball then return end  
  
			local camPos = Camera.CFrame.Position  
			Camera.CFrame = CFrame.lookAt(camPos, Ball.Position)  
		end)  
	end  
end  
  
-- Hàm tắt chức năng xoay  
local function DisableLookAt()  
	if playerConn then playerConn:Disconnect() playerConn = nil end  
	if cameraConn then cameraConn:Disconnect() cameraConn = nil end  
end  

local LookatModule = WorldTab:create_module({
    title = "Lookat Ball",
    description = "Look The Ball",
    section = "right",
    flag = "look_ball",
    callback = function(value)
        lookAtBallToggle = value  
		if value then  
			EnableLookAt()  
		else  
			DisableLookAt()  
		end  
	end  
})  

LookatModule:create_dropdown({
    title = "Look Type",
    flag = "look_type",
    options = {"Camera", "Character"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(value)
        parryLookType = value  
				if lookAtBallToggle then  
					DisableLookAt()  
					EnableLookAt()  
				end  
			end  
})

local enabled = false
local swordName = ""
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local swords = require(rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9))
local ctrl, playFx, lastParry = nil, nil, 0
local function getSlash(name)
    local s = swords:GetSword(name)
    return (s and s.SlashName) or "SlashEffect"
end
local function setSword()
    if not enabled then return end
    setupvalue(rawget(swords, "EquipSwordTo"), 2, false)
    swords:EquipSwordTo(p.Character, swordName)
    ctrl:SetSword(swordName)
end
updateSword = function()
    setSword()
end
while task.wait() and not ctrl do
    for _, v in getconnections(rs.Remotes.FireSwordInfo.OnClientEvent) do
        if v.Function and islclosure(v.Function) then
            local u = getupvalues(v.Function)
            if #u == 1 and type(u[1]) == "table" then
                ctrl = u[1]
                break
            end
        end
    end
end
local parryConnA, parryConnB
while task.wait() and not parryConnA do
    for _, v in getconnections(rs.Remotes.ParrySuccessAll.OnClientEvent) do
        if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
            parryConnA, playFx = v, v.Function
            v:Disable()
            break
        end
    end
end
while task.wait() and not parryConnB do
    for _, v in getconnections(rs.Remotes.ParrySuccessClient.Event) do
        if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
            parryConnB = v
            v:Disable()
            break
        end
    end
end
rs.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
    setthreadidentity(2)
    local args = {...}
    if tostring(args[4]) ~= p.Name then
        lastParry = tick()
    elseif enabled then
        args[1] = getSlash(swordName)
        args[3] = swordName
    end
    return playFx(unpack(args))
end)
task.spawn(function()
    while task.wait(1) do
        if enabled and swordName ~= "" then
            local c = p.Character or p.CharacterAdded:Wait()
            if p:GetAttribute("CurrentlyEquippedSword") ~= swordName or not c:FindFirstChild(swordName) then
                setSword()
            end
            for _, m in pairs(c:GetChildren()) do
                if m:IsA("Model") and m.Name ~= swordName then
                    m:Destroy()
                end
                task.wait()
            end
        end
    end
end)

local SkinChangerModule = MicTab:create_module({
    title = "Skin Changer",
    description = "Change Sword Skin",
    section = "left",
    flag = "skin_changer",
    callback = function(state)
        enabled = state
	end
})

SkinChangerModule:create_textbox({
    title = "↓ Skin Name [Case Sensitive] ↓",
    placeholder = "Enter Sword Name...",
    flag = "skin_input",
    callback = function(value)
        swordName = value
	end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local targetDistance = 30
local autoPlayConnection = nil
local lastTargetTime = 0
local targetDuration = 0

local AutoPlayModule = MicTab:create_module({
    title = "Auto Play",
    description = "Use AI To Play Automatically",
    section = "right",
    flag = "auto_play",
    callback = function(enabled)
	    if enabled then
			autoPlayConnection = RunService.RenderStepped:Connect(function()
				if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
				rootPart = player.Character.HumanoidRootPart

				-- Tìm bóng thật
				local ball
				for _, b in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
					if b:GetAttribute("realBall") then
						ball = b
						break
					end
				end
				if not ball then return end

				local dir = (ball.Position - rootPart.Position).Unit
				local dist = (ball.Position - rootPart.Position).Magnitude
				local speed = ball.Velocity.Magnitude
				local currentTime = tick()
				local ballTarget = ball:GetAttribute("target")

				-- Kiểm tra target liên tục
				if ballTarget == player.Name then
					if currentTime - lastTargetTime < 0.2 then
						targetDuration += RunService.RenderStepped:Wait()
					else
						targetDuration = 0
					end
					lastTargetTime = currentTime
				else
					targetDuration = 0
				end

				-- Reset tất cả nút
				for _, key in pairs({"W", "A", "S", "D"}) do
					VirtualInputManager:SendKeyEvent(false, key, false, game)
				end

				-- Nếu bị target liên tục hoặc bóng quá gần → luôn lùi
				if dist < targetDistance or targetDuration > 0.5 then
					local backDir = -dir
					local backPos = rootPart.Position + backDir * 6

					-- Kiểm tra player khác phía sau
					local safeToBack = true
					for _, other in ipairs(Players:GetPlayers()) do
						if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
							local otherHRP = other.Character.HumanoidRootPart
							if (otherHRP.Position - backPos).Magnitude < 5 then
								safeToBack = false
								break
							end
						end
					end

					if safeToBack then
						VirtualInputManager:SendKeyEvent(true, "S", false, game)
					else
						-- Né sang bên nếu bị vướng
						local sideKey = math.random(1, 2) == 1 and "A" or "D"
						VirtualInputManager:SendKeyEvent(true, sideKey, false, game)
					end

					return -- ❗ Dừng tại đây, không xử lý di chuyển khác
				end

				-- Nếu đang xa hơn targetDistance + buffer → tiến tới để giữ vị trí tốt
				local buffer = 5
				if dist > targetDistance + buffer then
					VirtualInputManager:SendKeyEvent(true, "W", false, game)
				elseif speed > 120 then
					local dodgeKey = math.random(1, 2) == 1 and "A" or "D"
					VirtualInputManager:SendKeyEvent(true, dodgeKey, false, game)
				elseif math.random() < 0.01 then
					VirtualInputManager:SendKeyEvent(true, "W", false, game)
				end
			end)
		else
			if autoPlayConnection then
				autoPlayConnection:Disconnect()
				autoPlayConnection = nil
			end
			for _, key in pairs({"W", "A", "S", "D"}) do
				VirtualInputManager:SendKeyEvent(false, key, false, game)
			end
		end
	end
})

AutoPlayModule:create_checkbox({
    title = "Anti AFK",
    flag = "anti_afk",
    callback = function(value)
     end
})

AutoPlayModule:create_checkbox({
    title = "Enable Jumping [soon]",
    flag = "enable_jump",
    callback = function(state)
	end
})

AutoPlayModule:create_checkbox({
    title = "Notify",
    flag = "notify5",
    callback = function(value)
     end
})

AutoPlayModule:create_divider({
    showtopic = true,
    title = "",
    disableline = false
})

AutoPlayModule:create_slider({
    title = "Distance From Ball",
    flag = "1",
    minimum_value = 1,
    maximum_value = 100,
    value = 30,
    round_number = true,
    callback = function(value)
     targetDistance = value
	end
})

AutoPlayModule:create_slider({
    title = "Speed Multiplier",
    flag = "2",
    minimum_value = 1,
    maximum_value = 100,
    value = 70,
    round_number = true,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Transversing",
    flag = "3",
    minimum_value = 10,
    maximum_value = 150,
    value = 25,
    round_number = true,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Direction",
    flag = "4",
    minimum_value = 0.1,
    maximum_value = 1,
    value = 1,
    round_number = false,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Offset Factor",
    flag = "5",
    minimum_value = 1, 
    maximum_value = 5,
    value = 2,
    round_number = true,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Movement Duration",
    flag = "6",
    minimum_value = 1,
    maximum_value = 8,
    value = 6,
    round_number = true,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Generation Threshold",
    flag = "7",
    minimum_value = 1,
    maximum_value = 10,
    value = 2,
    round_number = true,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Jump Chance [soon]",
    flag = "8",
    minimum_value = 1,
    maximum_value = 50,
    value = 50,
    round_number = true,
    callback = function(value)
     end
})

AutoPlayModule:create_slider({
    title = "Double Jump Chance [soon]",
    flag = "9",
    minimum_value = 1,
    maximum_value = 50,
    value = 50,
    round_number = true,
    callback = function(value)
     end
})

local statsGui = nil
local statsConnection = nil

local StatModule = MicTab:create_module({
    title = "Ball Stats",
    description = "Show Ball Index",
    section = "left",
    flag = "ball_stats",
    callback = function(value)
        if value then
			local player = Players.LocalPlayer

			-- Tạo GUI
			statsGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
			statsGui.Name = "BallStatsUI"
			statsGui.ResetOnSpawn = false

			local frame = Instance.new("Frame", statsGui)
			frame.Size = UDim2.new(0, 180, 0, 80)
			frame.Position = UDim2.new(1, -200, 0, 100)
			frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
			frame.BackgroundTransparency = 0.2
			frame.BorderSizePixel = 0
			frame.Active = true
			frame.Draggable = true -- 🟢 Cho phép kéo

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1, -10, 1, -10)
			label.Position = UDim2.new(0, 5, 0, 5)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextScaled = true
			label.Font = Enum.Font.GothamBold
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Top
			label.Text = "Loading..."

			statsConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local ball = GetBall()
				if not ball then
					label.Text = "No ball found"
					return
				end

				local char = player.Character or player.CharacterAdded:Wait()
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end

				local speed = math.floor(ball.Velocity.Magnitude)
				local distance = math.floor((ball.Position - hrp.Position).Magnitude)
				local target = ball:GetAttribute("target") or "N/A"
				local status = speed < 3 and "Idle" or "Flying"

				label.Text = string.format(
					"⚽ Ball Stats | Zeryx\nSpeed: %s\nDistance: %s\nTarget: %s",
					speed, distance, target
				)
			end)
		else
			if statsConnection then
				statsConnection:Disconnect()
				statsConnection = nil
			end
			if statsGui then
				statsGui:Destroy()
				statsGui = nil
			end
		end
	end
})

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local fieldPart = nil
local visualizeConnection = nil

local VisualizeModule = MicTab:create_module({
    title = "Visualize",
    description = "Show Visualize",
    section = "right",
    flag = "visu_alize",
    callback = function(value)
        if value then
			-- Tạo forcefield visual nếu chưa có
			if not fieldPart then
				fieldPart = Instance.new("Part")
				fieldPart.Anchored = true
				fieldPart.CanCollide = false
				fieldPart.Transparency = 0.5
				fieldPart.Shape = Enum.PartType.Ball
				fieldPart.Material = Enum.Material.ForceField
				fieldPart.CastShadow = false
				fieldPart.Color = Color3.fromRGB(88, 131, 202)
				fieldPart.Name = "VisualField"
				fieldPart.Parent = workspace
			end

			visualizeConnection = RunService.RenderStepped:Connect(function()
				local function GetBall()
					for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
						if Ball:GetAttribute("realBall") then
							return Ball
						end
					end
				end

				local ball = GetBall()
				if not ball then return end

				local ballVel = ball.AssemblyLinearVelocity
				local speed = ballVel.Magnitude

				-- Tính khoảng cách co giãn (clamp từ 25 đến 400)
				local size = math.clamp(speed, 25, 250)

				-- Cập nhật field
				fieldPart.Position = root.Position
				fieldPart.Size = Vector3.new(size, size, size)
			end)
		else
			if visualizeConnection then
				visualizeConnection:Disconnect()
				visualizeConnection = nil
			end
			if fieldPart then
				fieldPart:Destroy()
				fieldPart = nil
			end
		end
	end
})
