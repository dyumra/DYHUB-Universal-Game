if not game.PlaceId == 8260276694 then
    return 
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local function Notify(title, cotent, duration, image)
    Rayfield:Notify({
        Title = title,
        Content = cotent,
        Duration = duration,
        Image = image
    })
end

local Players = game:GetService('Players');
local RunService = game:GetService('RunService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
-- local PathfindingService = game:GetService('PathfindingService');
local BadgeService = game:GetService('BadgeService');
local Workspace = game:GetService('Workspace');

local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Arena = Workspace.Portals['Arena Frame']
local MapItems = Workspace:WaitForChild('Map Items')
local Secrets = Workspace.Secrets

local Bosses = ReplicatedStorage:WaitForChild('Bosses')
local RemoteEvents = ReplicatedStorage:WaitForChild('Remote Events')
local Punch = RemoteEvents.Punch

local ID = 314159265359;

local Window = Rayfield:CreateWindow({
   Name = "Ablilty Wars",
   Icon = 0,
   LoadingTitle = "DYHUB Loader | Ablilty Wars",
   LoadingSubtitle = "(dsc.gg/dyhub)",
   Theme = "Default",
   ToggleUIKeybind = "K",
})

local IS_FLAGS = {
    ["player"] = {
        ["speed-slider"] = 21,
        ["speed-enable"] = false,
        ["jump-slider"] = 50,
        ["jump-enable"] = false,
        -- ["target-player"] = false
    },
    ["auto"] = {
        ["punch-hit-delay"] = 0.2,
        ["player-hit-distance"] = 20,
        ["punch-aura"] = false,
        ["kill-boss"] = false
    },
    ["anti"] = {
        ["anti-void"] = false,
    },
    ["visuals"] = {
        ["disable-tag-name"] = false
    },
    ["misc"] = {
        ["teleport-arena"] = false
    }
}

local Part_Void = nil
local Items = {"Burger", "Cake", "Pizza"}

local Get_ItemTouch = {
    Burger = function()
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, MapItems.Burger, 0)
        task.wait(0.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, MapItems.Burger, 1)
    end,
    Cake = function()
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, MapItems.Cake, 0)
        task.wait(0.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, MapItems.Cake, 1)
    end,
    Pizza = function()
        local pizzaHitbox = MapItems:WaitForChild("Pizza"):WaitForChild("Pizza Hitbox")
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, pizzaHitbox, 0)
        task.wait(0.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, pizzaHitbox, 1)
    end
}

local Get_Bagde = {
    Backrooms = function()
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Secrets["Cave Teleport"], 0)
        task.wait(.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Secrets["Cave Teleport"], 1)
    end,
    Cake = function()
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, MapItems.Cake, 0)
        task.wait(0.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, MapItems.Cake, 1)
    end,
    Boring = function()
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Secrets["Big Mushroom Hitbox"], 0)
        task.wait(0.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Secrets["Big Mushroom Hitbox"], 1)
    end,
    GroceryShopping = function()
        for _, item in pairs(Items) do
            task.wait()
            if Get_ItemTouch[item] and not game.Players.LocalPlayer.Backpack:FindFirstChild(item) then
                Get_ItemTouch[item]()
            end
        end
    end
}

function get_bossesNames()
    local bossNames = {}

    for _, v in pairs(Bosses:GetChildren()) do
        table.insert(bossNames, v.Name)
    end

    return bossNames
end

local player = Window:CreateTab("player")
local auto = Window:CreateTab("auto")
local anti = Window:CreateTab("anti")
local visuals = Window:CreateTab("visuals")
local misc = Window:CreateTab("misc")

-- player tabs
player:CreateSection("movement")

player:CreateSlider({
   Name = "walkspeed-slider",
   Range = {0, 350},
   Increment = 10,
   CurrentValue = IS_FLAGS["player"]["speed-slider"],
   Callback = function(value)
        IS_FLAGS["player"]["speed-slider"] = value
   end
})

player:CreateToggle({
   Name = "walkspeed-enable",
   CurrentValue = IS_FLAGS["player"]["walkspeed-enable"],
   Callback = function(state)
        IS_FLAGS["player"]["walkspeed-enable"] = state

        if not IS_FLAGS["player"]["speed-enable"] then
            LocalPlayer.Character.Humanoid.WalkSpeed = 21
        end
   end
})

player:CreateDivider()

player:CreateSlider({
   Name = "jump-slider",
   Range = {0, 550},
   Increment = 10,
   CurrentValue = IS_FLAGS["player"]["jump-slider"],
   Callback = function(value)
        IS_FLAGS["player"]["jump-slider"] = value
   end
})

player:CreateToggle({
   Name = "jump-enable",
   CurrentValue = IS_FLAGS["player"]["jump-enable"],
   Callback = function(state)
        IS_FLAGS["player"]["jump-enable"] = state

        if not IS_FLAGS["player"]["jump-enable"] then
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
   end
})

--[[

not now cause i am lazy

player:CreateSection("ai")

player:CreateToggle({
   Name = "target-player",
   CurrentValue = IS_FLAGS["player"]["target-player"],
   Callback = function(state)
        IS_FLAGS["player"]["target-player"] = state
   end
})

]]

-- auto tabs
auto:CreateSection("combat")

auto:CreateSlider({
   Name = "player-hit-distance",
   Range = {0, 20},
   Increment = 10,
   CurrentValue = IS_FLAGS["auto"]["player-hit-distance"],
   Callback = function(value)
        IS_FLAGS["auto"]["player-hit-distance"] = value
   end
})

auto:CreateSlider({
   Name = "punch-hit-delay",
   Range = {0.2, 0.4},
   Increment = 10,
   CurrentValue = IS_FLAGS["auto"]["punch-hit-delay"],
   Callback = function(value)
        IS_FLAGS["auto"]["punch-hit-delay"] = value
   end
})

auto:CreateDivider()

auto:CreateToggle({
   Name = "punch-aura",
   CurrentValue = IS_FLAGS["auto"]["punch-aura"],
   Callback = function(state)
        IS_FLAGS["auto"]["punch-aura"] = state

        repeat
            task.wait(IS_FLAGS["auto"]["punch-hit-delay"])
            for k, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    local Character = v.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local distance = LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)

                        if distance <= IS_FLAGS["auto"]["player-hit-distance"] then
                            Punch:FireServer(ID, Character, Character:WaitForChild("HumanoidRootPart"))   
                        end
                    end
                end
            end
        until not IS_FLAGS["auto"]["punch-aura"]
   end
})

auto:CreateToggle({
   Name = "kill-boss",
   CurrentValue = IS_FLAGS["auto"]["kill-boss"],
   Callback = function(state)
        IS_FLAGS["auto"]["kill-boss"] = state

        while IS_FLAGS["auto"]["kill-boss"] do
            local Get_Bosses = get_bossesNames()

            for i, v in pairs(Workspace:GetChildren()) do
                if table.find(Get_Bosses, v.Name) then
                    if v and v:FindFirstChild("HumanoidRootPart") then
                        Punch:FireServer(ID, v, v:WaitForChild("HumanoidRootPart"))
                    end
                end
            end
            task.wait()
        end
   end
})

-- anti tabs
anti:CreateSection("anti")

anti:CreateToggle({
   Name = "anti-void",
   CurrentValue = IS_FLAGS["anti"]["anti-void"],
   Callback = function(state)
        IS_FLAGS["anti"]["anti-void"] = state

        if Part_Void then
            Part_Void.CanCollide = IS_FLAGS["anti"]["anti-void"]
            Part_Void.Transparency = (IS_FLAGS["anti"]["anti-void"] and 0.8) or 1
        end
   end
})

-- visuals tabs
visuals:CreateSection("remove")

visuals:CreateToggle({
   Name = "disable-tag-name",
   CurrentValue = IS_FLAGS["visuals"]["disable-tag-name"],
   Callback = function(state)
        IS_FLAGS["visuals"]["disable-tag-name"] = state
        LocalPlayer.Character:WaitForChild("Head"):FindFirstChild("Name Tag").Enabled = not IS_FLAGS["visuals"]["disable-tag-name"]
   end
})

-- misc tabs
misc:CreateSection("teleport")

misc:CreateToggle({
   Name = "teleport-arena",
   CurrentValue = IS_FLAGS["misc"]["teleport-arena"],
   Callback = function(state)
        IS_FLAGS["misc"]["teleport-arena"] = state

        while IS_FLAGS["misc"]["teleport-arena"] do
            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for i, v in pairs(Arena.Portal:GetChildren()) do
                    if v:IsA("TouchTransmitter") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                        wait(.1)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
            task.wait()
        end
   end
})

misc:CreateSection("bagde")

misc:CreateButton({
   Name = "get-backrooms",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2124927822) then
            Get_Bagde.Backrooms()
        else
            Notify("get-backrooms", "You already have backrooms Bagde.", 5)
        end
   end
})

misc:CreateButton({
   Name = "get-cake",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2124923949) then
            Get_Bagde.Cake()
        else
            Notify("get-cake", "You already have cake Bagde.", 5)
        end
   end
})

misc:CreateButton({
   Name = "get-boring",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2125734830) then
            Get_Bagde.Boring()
        else
            Notify("get-boring", "You already have boring Bagde.", 5)
        end
   end
})

misc:CreateButton({
   Name = "get-grocery-shopping",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2126802066) then
            Get_Bagde.GroceryShopping()
        else
            Notify("get-grocery-shopping", "You already have grocery-shopping Bagde.", 5)
        end
   end
})


task.spawn(function()
    Part_Void = Instance.new("Part", Workspace);
    Part_Void.Name = "Anti_Void";
    Part_Void.Anchored = true
    Part_Void.Size = Vector3.new(10000, 10, 10000);
    Part_Void.CFrame = CFrame.new(0, -2.46101189, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
    Part_Void.Transparency = 1;
    Part_Void.Material = "Neon";
    Part_Void.CanCollide = false;
    Part_Void.Color = Color3.fromRGB(146, 145, 145);
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    pcall(function()
        character:WaitForChild("Head"):FindFirstChild("Name Tag").Enabled = not IS_FLAGS["visuals"]["disable-tag-name"]
    end)
end)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character.Humanoid.Health > 0 then
        if IS_FLAGS["player"]["walkspeed-enable"] == true then
            LocalPlayer.Character.Humanoid.WalkSpeed = IS_FLAGS["player"]["speed-slider"]
        end

        if IS_FLAGS["player"]["jump-enable"] == true then
            LocalPlayer.Character.Humanoid.JumpPower = IS_FLAGS["player"]["jump-slider"]
        end
    end
end)
