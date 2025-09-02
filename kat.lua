
--[[
    Modified Compkiller UI with Trap n Bang Logic
    
    Author: 4lpaca (modified to include Trap n Bang logic)
    
    Press Left Alt to open / close
]]


loadstring(game:HttpGet('https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua'))()

-- Auto-execute on error message
game.GuiService.ErrorMessageChanged:Connect(function()
    wait()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)

local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();

local Notifier = Compkiller.newNotify();

local ConfigManager = Compkiller:ConfigManager({
    Directory = "Compkiller-UI",
    Config = "TrapnBang-Configs"
});

Compkiller:Loader("rbxassetid://104487529937663" , 2.5).yield();

local Window = Compkiller.new({
    Name = "DYHUB | KAT X",
    Keybind = "LeftAlt",
    Logo = "rbxassetid://104487529937663",
    Scale = Compkiller.Scale.Window,
    TextSize = 15,
});

Notifier.new({
    Title = "Notification",
    Content = "Welcome to DYHUB! - Join our at (dsc.gg/dyhub)",
    Duration = 10,
    Icon = "rbxassetid://104487529937663"
});

local Watermark = Window:Watermark();

Watermark:AddText({
    Icon = "user",
    Text = "Main",
});

Watermark:AddText({
    Icon = "clock",
    Text = Compkiller:GetDate(),
});

local Time = Watermark:AddText({
    Icon = "hourglass",
    Text = "Time",
});

task.spawn(function()
    while true do task.wait()
        Time:SetText(Compkiller:GetTimeNow());
    end
end)

Watermark:AddText({
    Icon = "server",
    Text = Compkiller.Version,
});

local scriptsettings = {
    tpmethod = 2,
    vehicles = {
        closest = false
    },
    target = '',
    dishes = {
        underground = false,
        walk = false,
        autosale = false
    },
    vulns = {
        antiKick = false,
        antiBan = false
    }
};

local Players = game:GetService("Players");
local LocalPlayer = game.Players.LocalPlayer;

local function findCar(closest)
    local cars = {};
    local character = LocalPlayer.Character;
    local humanoid = character and character:FindFirstChild("Humanoid");
    local rootPart = character and character:FindFirstChild("HumanoidRootPart");

    if not humanoid or not rootPart then
        return;
    end

    for _, plr in pairs(game.Players:GetPlayers()) do
        local carName = plr.Name .. "'s Vehicle";
        local car = game.Workspace:FindFirstChild(carName);

        if car then
            local seat = car:FindFirstChild("DriveSeat");
            if seat and not seat.Occupant then
                table.insert(cars, {car = car, seat = seat});
            end
        end
    end

    if #cars == 0 then
        return;
    end

    local selected;

    if closest then
        local shortestDistance = math.huge;
        for _, data in ipairs(cars) do
            local car = data.car;
            local seat = data.seat;
            local distance = (car.DriveSeat.CFrame.Position - rootPart.Position).Magnitude;
            if distance < shortestDistance then
                shortestDistance = distance;
                selected = data;
            end
        end
    else
        selected = cars[math.random(1, #cars)];
    end

    if selected and selected.seat then
        selected.seat:Sit(humanoid);
    end
end

function SitInRandomPassengerSeat()
    local seats = {};
    for _, seat in ipairs(workspace:GetDescendants()) do
        if seat:IsA("VehicleSeat") and seat.Disabled and seat.Occupant == nil then
            table.insert(seats, seat);
        end
    end
    if #seats > 0 and game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
        seats[math.random(1, #seats)]:Sit(game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"));
    end
end

local function teleport(where, method)
    method = scriptsettings.tpmethod;
    if method == 2 then
        LocalPlayer.Character.Humanoid.Sit = true;
        
        local SitLoop = game:GetService("RunService").Heartbeat:Connect(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = where;
        end);
        
        task.wait(1.5);
        
        LocalPlayer.Character.Humanoid.Sit = false;
        SitLoop:Disconnect();
    elseif method == 1 then 
        local speed = 50;
        local targetPosition = where.Position - Vector3.new(0, 3, 0);
        local function smoothMove(target)
            local distance = (target - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude;
            local flightTime = distance / speed;
            local startPos = LocalPlayer.Character.HumanoidRootPart.Position;
            local startTime = tick();
            while tick() - startTime < flightTime do
                local progress = math.clamp((tick() - startTime) / flightTime, 0, 1);
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(startPos:Lerp(target, progress));
                task.wait(0.02);
            end
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target);
        end
        smoothMove(targetPosition);
    end
end

local function firePrompt(proximityPrompt)
    assert(proximityPrompt:IsA("ProximityPrompt"), "Argument #1 expects a ProximityPrompt object");

    local oldMaxActivationDistance = proximityPrompt.MaxActivationDistance;
    local oldRequiresLineOfSight = proximityPrompt.RequiresLineOfSight;
    local oldExclusivity = proximityPrompt.Exclusivity;
    
    proximityPrompt.MaxActivationDistance = 15;
    proximityPrompt.RequiresLineOfSight = false;
    proximityPrompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow;
    
    local holdDuration = proximityPrompt.HoldDuration;
    proximityPrompt.HoldDuration = 0;
    fireproximityprompt(proximityPrompt);
    
    proximityPrompt.MaxActivationDistance = oldMaxActivationDistance;
    proximityPrompt.RequiresLineOfSight = oldRequiresLineOfSight;
    proximityPrompt.Exclusivity = oldExclusivity;
    proximityPrompt.HoldDuration = holdDuration;
end

local function GetPlayer(Name)
    for _, Value in ipairs(game.Players:GetPlayers()) do
        if Value ~= LocalPlayer then
            if Value.Name:lower():match(Name:lower()) then
                return Value;
            end
        end
    end
end

local function walkTo(position)
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
    if humanoid then
        humanoid:MoveTo(position);
        local reached = false;
        local conn;
        conn = humanoid.MoveToFinished:Connect(function(success)
            reached = true;
            conn:Disconnect();
        end);
        while not reached and not pauseFarm do
            task.wait(0.1);
        end
    end
end

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "InventoryGui";
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");

local inventoryFrame;

function showInventory(targetName)
    local target = Players:FindFirstChild(targetName);
    if not target then
        print("Player not found: " .. targetName);
        return;
    end

    if not inventoryFrame or not inventoryFrame.Parent then
        inventoryFrame = Instance.new("Frame");
        inventoryFrame.Size = UDim2.new(0, 250, 0, 300);
        inventoryFrame.Position = UDim2.new(1, -270, 0.5, -150);
        inventoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
        inventoryFrame.BorderSizePixel = 0;
        inventoryFrame.AnchorPoint = Vector2.new(0, 0);
        inventoryFrame.Parent = ScreenGui;

        local corner = Instance.new("UICorner", inventoryFrame);
        corner.CornerRadius = UDim.new(0, 8);

        local closeButton = Instance.new("TextButton");
        closeButton.Size = UDim2.new(0, 25, 0, 25);
        closeButton.Position = UDim2.new(1, -30, 0, 5);
        closeButton.Text = "X";
        closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60);
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        closeButton.Font = Enum.Font.Gotham;
        closeButton.TextSize = 14;
        closeButton.Parent = inventoryFrame;

        local closeCorner = Instance.new("UICorner", closeButton);
        closeCorner.CornerRadius = UDim.new(0, 5);

        closeButton.MouseButton1Click:Connect(function()
            inventoryFrame:Destroy();
            inventoryFrame = nil;
        end);
    else
        for _, child in ipairs(inventoryFrame:GetChildren()) do
            if not child:IsA("TextButton") then
                child:Destroy();
            end
        end
    end

    local title = Instance.new("TextLabel");
    title.Size = UDim2.new(1, 0, 0, 30);
    title.Position = UDim2.new(0, 0, 0, 5);
    title.Text = target.Name .. "'s Inventory";
    title.BackgroundTransparency = 1;
    title.TextColor3 = Color3.fromRGB(255, 255, 255);
    title.Font = Enum.Font.GothamBold;
    title.TextSize = 16;
    title.Parent = inventoryFrame;

    local scrollingFrame = Instance.new("ScrollingFrame");
    scrollingFrame.Size = UDim2.new(1, -10, 0, 235);
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35);
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    scrollingFrame.BackgroundTransparency = 1;
    scrollingFrame.ScrollBarThickness = 6;
    scrollingFrame.Parent = inventoryFrame;

    local layout = Instance.new("UIListLayout");
    layout.SortOrder = Enum.SortOrder.LayoutOrder;
    layout.Padding = UDim.new(0, 5);
    layout.Parent = scrollingFrame;

    local items = {};

    local backpack = target:FindFirstChild("Backpack");
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(items, tool.Name);
            end
        end
    end

    local character = target.Character;
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(items, tool.Name .. " (Equipped)");
            end
        end
    end

    if #items == 0 then
        table.insert(items, "No items found.");
    end

    for _, itemName in ipairs(items) do
        local itemLabel = Instance.new("TextLabel");
        itemLabel.Size = UDim2.new(1, 0, 0, 20);
        itemLabel.BackgroundTransparency = 1;
        itemLabel.TextColor3 = Color3.fromRGB(200, 200, 200);
        itemLabel.Font = Enum.Font.Gotham;
        itemLabel.TextSize = 14;
        itemLabel.Text = "- " .. itemName;
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left;
        itemLabel.Parent = scrollingFrame;
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y);
    end);
end

Window:DrawCategory({
    Name = "Main"
});

local MainTab = Window:DrawTab({
    Name = "Main",
    Icon = "rocket",
    EnableScrolling = true
});

local AutofarmTab = Window:DrawTab({
    Name = "Auto Farm",
    Icon = "dollar-sign",
    EnableScrolling = true
});

local VulnsTab = Window:DrawTab({
    Name = "Valne",
    Icon = "triangle-alert",
    EnableScrolling = true
});

local playerSection = MainTab:DrawSection({
    Name = "LocalPlayer",
    Icon = "candy",
    Position = 'left'
});

local playersSection = MainTab:DrawSection({
    Name = "Players",
    Icon = "user",
    Position = 'left'
});

local vehicleSection = MainTab:DrawSection({
    Name = "Vehicle",
    Icon = "car",
    Position = 'right'
});

local teleportSection = MainTab:DrawSection({
    Name = "Teleports",
    Icon = "hexagon",
    Position = 'right'
});

local dishwasherSection = AutofarmTab:DrawSection({
    Name = "Dishwasher",
    Icon = "file-user",
    Position = 'left'
});

local shelfStockerSection = AutofarmTab:DrawSection({
    Name = "Shelf Stocker",
    Icon = "shield",
    Position = 'left'
});

local vulnSection = VulnsTab:DrawSection({
    Name = "Vulnerabilities",
    Icon = "search",
    Position = 'left'
});

local speedKeyDown = false;
local speedusing = false;

playerSection:AddToggle({
    Name = "Speed",
    Flag = "Speed_Toggle",
    Default = false,
    Callback = function(enabled)
        speedusing = enabled;
        if enabled then
            game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
                if input.KeyCode == Enum.KeyCode.LeftShift then
                    speedKeyDown = true;
                    task.spawn(function()
                        while speedKeyDown and speedusing do
                            if speedusing then
                                task.wait(0.03);
                                pcall(function()
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame +
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 2;
                                end);
                                task.wait();
                            end
                        end
                    end);
                end
            end);

            game:GetService("UserInputService").InputEnded:Connect(function(input, gpe)
                if input.KeyCode == Enum.KeyCode.LeftShift then
                    speedKeyDown = false;
                end
            end);
        else
            speedKeyDown = false;
        end
    end
});

local Clip = true;
local Noclipping = nil;
playerSection:AddToggle({
    Name = "Noclip",
    Flag = "Noclip_Toggle",
    Default = false,
    Callback = function(Value)
        if Value then
            Clip = false;
            task.wait(0.1);
            local function NoclipLoop()
                if Clip == false and game.Players.LocalPlayer.Character then
                    for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true then
                            child.CanCollide = false;
                        end
                    end
                end
            end
            Noclipping = game:GetService("RunService").Stepped:Connect(NoclipLoop);
        else
            if Noclipping then
                Noclipping:Disconnect();
            end
            Clip = true;
        end
    end
});

playerSection:AddToggle({
    Name = "Infinite Stamina [RISKY]",
    Flag = "InfStamina_Toggle",
    Default = false,
    Risky = true,
    Callback = function(enabled)
        if enabled then
            LocalPlayer.Character:FindFirstChild("StaminaValue").Changed:Connect(function()
                if LocalPlayer.Character:FindFirstChild("StaminaValue").Value ~= 100 then
                    LocalPlayer.Character:FindFirstChild("StaminaValue").Value = 100;
                end
            end);
        end
    end
});

playerSection:AddToggle({
    Name = "Infinite Hunger [RISKY]",
    Flag = "InfHunger_Toggle",
    Default = false,
    Risky = true,
    Callback = function(enabled)
        if enabled then
            LocalPlayer.Character:FindFirstChild("Hunger").Changed:Connect(function()
                if LocalPlayer.Character:FindFirstChild("Hunger").Value ~= 100 then
                    LocalPlayer.Character:FindFirstChild("Hunger").Value = 100;
                end
            end);
        end
    end
});

playerSection:AddToggle({
    Name = "Hide Name",
    Flag = "HideName_Toggle",
    Default = false,
    Callback = function(value)
        if value then
            game.Players.LocalPlayer.Character.Head.usernameGUI.TextLabel.Text = "@k8zj"
            game.Players.LocalPlayer.Character.Head.Rank.TextLabel.Text = "@1eu6"
        else
            game.Players.LocalPlayer.Character.Head.usernameGUI.TextLabel.Text = game.Players.LocalPlayer.Name
            game.Players.LocalPlayer.Character.Head.Rank.TextLabel.Text = game.Players.LocalPlayer.Name
        end
        LocalPlayer.Character.Head.usernameGUI.Enabled = not value
        LocalPlayer.Character.Head.Rank.Enabled = not value
    end
})

playerSection:AddToggle({
    Name = "Anti Shiftlock",
    Flag = "AntiShiftlock_Toggle",
    Default = false,
    Callback = function(Value)
        character.ForceShiftLock.Disabled = Value;
    end
});

playerSection:AddToggle({
    Name = "No Jump Cooldown",
    Flag = "NoJumpCooldown_Toggle",
    Default = false,
    Callback = function(Value)
        character["Jump Cooldown"].Disabled = Value;
    end
});

playersSection:AddTextBox({
    Name = "Target",
    Placeholder = "username",
    Default = "username",
    Callback = function(Value)
        scriptsettings.target = GetPlayer(Value).Name;
    end
});

playersSection:AddButton({
    Name = "Goto",
    Callback = function()
        if game.Players:FindFirstChild(scriptsettings.target) ~= nil then
            teleport(game.Players:FindFirstChild(scriptsettings.target).Character.HumanoidRootPart.CFrame);
        end
    end
});

playersSection:AddButton({
    Name = "Show Inventory",
    Callback = function()
        if game.Players:FindFirstChild(scriptsettings.target) ~= nil then
            showInventory(scriptsettings.target);
        end
    end
});

playersSection:AddToggle({
    Name = "View",
    Flag = "View_Toggle",
    Default = false,
    Callback = function(Value)
        if Value then
            if game.Players:FindFirstChild(scriptsettings.target) ~= nil then
                game.Workspace.CurrentCamera.CameraSubject = game.Players[scriptsettings.target].Character:WaitForChild("Humanoid");
            end
        else
            game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid");
        end
    end
});

teleportSection:AddDropdown({
    Name = "Teleportation Method",
    Default = "Instant [RISKY]",
    Values = {"Instant [RISKY]", "Tween [SAFE]"},
    Callback = function(Value)
        if Value == "Instant [RISKY]" then
            scriptsettings.tpmethod = 2;
        else
            scriptsettings.tpmethod = 1;
        end
    end
});

local teleportLocations = {
    {"Car Spawn 2", CFrame.new(276, 4, -1804)},
    {"Knife Dealer", CFrame.new(306, 3, 135)},
    {'"D" Convinence Store', CFrame.new(177, 3, -328)},
{'"D" Convinence Store 2', CFrame.new(778, 3, -3314)},
    {"PureGym", CFrame.new(178, 3, -23)},
    {"Barber", CFrame.new(293, 3, 185)},
    {"Mask", CFrame.new(382, 3, 217)},
    {"Paint", CFrame.new(583, 3, 221)},
    {"Farmer Market", CFrame.new(1483, 3, -5539)},
    {"Vans", CFrame.new(2166, 3, -6520)},
    {"Primark", CFrame.new(167, 3, -1409)},
    {"Tattoo Shop", CFrame.new(170, 3, 608)},
    {"Dealership", CFrame.new(-34, 3, 809)},
    {"Dishwasher", CFrame.new(120, 5, 1251)},
    {"Mall", CFrame.new(123, 3, 601)},
    {"Apt 2", CFrame.new(-923, 4, -2038)},
};

for _, loc in ipairs(teleportLocations) do
    teleportSection:AddButton({
        Name = loc[1],
        Callback = function()
            teleport(loc[2]);
        end
    });
end

vehicleSection:AddButton({
    Name = "Borrow Vehicle",
    Callback = function()
        findCar(scriptsettings.vehicles.closest);
    end
});

vehicleSection:AddToggle({
    Name = "Closest Vehicle",
    Flag = "ClosestVehicle_Toggle",
    Default = false,
    Callback = function(Value)
        scriptsettings.vehicles.closest = Value;
    end
});

-- New Vulnerabilities Section

vulnSection:AddToggle({
    Name = "Touch Kick",
    Flag = "Fling_Toggle",
    Default = false,
    Risky = true,
    Callback = function(enabled)
        scriptsettings.vulns.touchFling = enabled
        if enabled then
            -- Start touch fling
            local lp = game:GetService("Players").LocalPlayer
            local RunService = game:GetService("RunService")
            local flingConnection

            local function fling()
                local c, hrp, vel, movel = nil, nil, nil, 0.1
                while scriptsettings.vulns.touchFling do
                    RunService.Heartbeat:Wait()
                    c = lp.Character
                    hrp = c and c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        vel = hrp.Velocity
                        hrp.Velocity = vel * 1e35 + Vector3.new(0, 1e35, 0)
                        RunService.RenderStepped:Wait()
                        hrp.Velocity = vel
                        RunService.Stepped:Wait()
                        hrp.Velocity = vel + Vector3.new(0, movel, 0)
                        movel = -movel
                    end
                end
            end

            flingConnection = coroutine.wrap(fling)()
            scriptsettings.vulns.flingConnection = flingConnection

            Notifier.new({
                Title = "Touch Fling",
                Content = "Touch fling enabled!",
                Duration = 5,
                Icon = "rbxassetid://107364585564917"
            })
        else
            -- Stop touch fling
            scriptsettings.vulns.touchFling = false
            if scriptsettings.vulns.flingConnection then
                -- Note: Coroutines cannot be directly stopped in Lua; the loop stops when touchFling is false
                scriptsettings.vulns.flingConnection = nil
            end

            Notifier.new({
                Title = "Touch Fling",
                Content = "Touch fling disabled!",
                Duration = 5,
                Icon = "rbxassetid://107364585564917"
            })
        end
    end
})

local pauseFarm = false;
local washCount = 0;

task.spawn(function()
    local gui = LocalPlayer:WaitForChild("PlayerGui");
    local notifications = gui:WaitForChild("Notifications");
    local frame = notifications:WaitForChild("Frame");

    frame.ChildAdded:Connect(function(child)
        if child.Name == "Error" then
            local message = child:WaitForChild("TheMessage", 3);
            if message and message.Text == "Suspicious activity detected" and not pauseFarm then
                pauseFarm = true;
                print("⚠️ Suspicious activity detected. Pausing.");
                task.spawn(function()
                    task.wait(25);
                    pauseFarm = false;
                    print("✅ Resuming farm.");
                end);
            end
        end
    end);
end);

dishwasherSection:AddToggle({
    Name = "Enabled",
    Flag = "AutoDishWash_Toggle",
    Default = false,
    Callback = function(Value)
        _G.AutoDishWash = Value;
        task.spawn(function()
            while _G.AutoDishWash do
                if pauseFarm then
                    repeat task.wait(1) until not pauseFarm;
                end

                local job = workspace:FindFirstChild("DishwasherJob");
                if not job then break end

                local pickUp = job:FindFirstChild("PickupPlates") and job.PickupPlates:FindFirstChild("Pick Up Plate");
                local wash = job:FindFirstChild("WashDish") and job.WashDish:FindFirstChild("WashDish");
                local place = job:FindFirstChild("PlacePlates") and job.PlacePlates:FindFirstChild("Place Plate");

                if scriptsettings.dishes.underground ~= true then
                    if pickUp and pickUp:FindFirstChild("ProximityPrompt") then
                        local pos = Vector3.new(123, 5, 1258);
                        if scriptsettings.dishes.walk then
                            walkTo(pos);
                        else
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos);
                            task.wait(0.5);
                        end
                        repeat 
                            if pauseFarm then repeat task.wait(1) until not pauseFarm end
                            task.wait(1);
                            firePrompt(pickUp.ProximityPrompt);
                            wait(1.5);
                        until LocalPlayer.Character:FindFirstChild("DirtyPlate");
                    end
                    wait(3);
                    if wash and wash:FindFirstChild("ProximityPrompt") then
                        local pos = Vector3.new(119, 5, 1268);
                        if scriptsettings.dishes.walk then
                            walkTo(pos);
                        else
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos);
                            task.wait(0.5);
                        end
                        repeat 
                            if pauseFarm then repeat task.wait(1) until not pauseFarm end
                            task.wait(1);
                            firePrompt(wash.ProximityPrompt);
                            wait(1.5);
                        until LocalPlayer.Character:FindFirstChild("CleanPlate");
                    end
                    wait(3);
                    if place and place:FindFirstChild("ProximityPrompt") then
                        local pos = Vector3.new(118, 5, 1263);
                        if scriptsettings.dishes.walk then
                            walkTo(pos);
                        else
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos);
                            task.wait(0.5);
                        end
                        repeat 
                            if pauseFarm then repeat task.wait(1) until not pauseFarm end
                            task.wait(1);
                            firePrompt(place.ProximityPrompt);
                            wait(1.5);
                        until not LocalPlayer.Character:FindFirstChild("CleanPlate");
                    end
                else
                    if pickUp and pickUp:FindFirstChild("ProximityPrompt") then
                        local pos = Vector3.new(123, 5, 1258);
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos) + Vector3.new(0, -7, 0);
                        task.wait(0.01);
                        repeat 
                            if pauseFarm then repeat task.wait(1) until not pauseFarm end
                            task.wait(1);
                            firePrompt(pickUp.ProximityPrompt);
                            wait(1.5);
                        until LocalPlayer.Character:FindFirstChild("DirtyPlate");
                    end
                    wait(3);
                    if wash and wash:FindFirstChild("ProximityPrompt") then
                        local pos = Vector3.new(119, 5, 1268);
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos) + Vector3.new(0, -7, 0);
                        task.wait(0.01);
                        repeat 
                            if pauseFarm then repeat task.wait(1) until not pauseFarm end
                            task.wait(1);
                            firePrompt(wash.ProximityPrompt);
                            wait(1.5);
                        until LocalPlayer.Character:FindFirstChild("CleanPlate");
                    end
                    wait(3);
                    if place and place:FindFirstChild("ProximityPrompt") then
                        local pos = Vector3.new(118, 5, 1263);
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos) + Vector3.new(0, -7, 0);
                        task.wait(0.01);
                        repeat 
                            if pauseFarm then repeat task.wait(1) until not pauseFarm end
                            task.wait(1);
                            firePrompt(place.ProximityPrompt);
                            wait(1.5);
                        until not LocalPlayer.Character:FindFirstChild("CleanPlate");
                    end
                end

                washCount = washCount + 1;
                if washCount >= 10 and scriptsettings.dishes.autosale == true then
                    local args = {
                        [1] = workspace:WaitForChild("DishwasherJob"):WaitForChild("StartJob"):WaitForChild("Start Job"):WaitForChild("ProximityPrompt")
                    };
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Quit"):FireServer(unpack(args));
                    repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.Employment.Enabled == false;
                    wait(10);
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.DishwasherJob.StartJob["Start Job"].CFrame + Vector3.new(0,0,3);
                    repeat wait(1); firePrompt(workspace.DishwasherJob.StartJob["Start Job"].ProximityPrompt); until game:GetService("Players").LocalPlayer.PlayerGui.Employment.Enabled == true;
                    washCount = 0;
                end

                task.wait(2);
            end
        end);
    end
});

dishwasherSection:AddToggle({
    Name = "Underground",
    Flag = "Underground_Toggle",
    Default = false,
    Callback = function(Value)
        scriptsettings.dishes.underground = Value;
        if scriptsettings.dishes.walk == true and Value == true then
            scriptsettings.dishes.walk = false;
        end
    end
});

dishwasherSection:AddToggle({
    Name = "Walk",
    Flag = "Walk_Toggle",
    Default = false,
    Callback = function(Value)
        scriptsettings.dishes.walk = Value;
        if scriptsettings.dishes.underground == true and Value == true then
            scriptsettings.dishes.underground = false;
        end
    end
});

dishwasherSection:AddToggle({
    Name = "Autosale",
    Flag = "Autosale_Toggle",
    Default = false,
    Callback = function(Value)
        scriptsettings.dishes.autosale = Value;
    end
});

shelfStockerSection:AddToggle({
    Name = "Manual Autofarm",
    Flag = "ShelfStocker_Toggle",
    Default = false,
    Callback = function(Value)
        _G.AutoShelfStock = Value;
        task.spawn(function()
            local workspace = game:GetService("Workspace")
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local backpack = player.Backpack

            -- Cache ProximityPrompts
            local shelfJob = workspace:FindFirstChild("Shelf Job")
            local cratePrompt = shelfJob and shelfJob.CratePickups and shelfJob.CratePickups:GetChildren()[2] and shelfJob.CratePickups:GetChildren()[2].ProximityPrompt
            local shelfPrompt = shelfJob and shelfJob.ShelfPrompts and shelfJob.ShelfPrompts:GetChildren()[5] and shelfJob.ShelfPrompts:GetChildren()[5].ProximityPrompt

            -- Optimized crate check
            local function isHoldingCrate()
                if not character then return false end
                local tool = character:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("crate|box") then return true end
                local hasCrate = player:FindFirstChild("HasCrate") or player:FindFirstChild("CrateCount")
                if hasCrate and ((hasCrate:IsA("BoolValue") and hasCrate.Value) or (hasCrate:IsA("IntValue") and hasCrate.Value > 0)) then return true end
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Model") or (child:IsA("BasePart") and child.Name:lower():find("crate")) then return true end
                end
                return false
            end

            -- Use existing firePrompt function from the UI
            local function triggerPrompt(prompt)
                if prompt and prompt:IsA("ProximityPrompt") then
                    firePrompt(prompt) -- Reuse the UI's firePrompt function
                end
            end

            -- Main loop
            while _G.AutoShelfStock do
                if pauseFarm then
                    repeat task.wait(1) until not pauseFarm
                end

                -- Refresh character and rootPart
                character = player.Character
                rootPart = character and character:FindFirstChild("HumanoidRootPart")
                backpack = player.Backpack

                if not character or not character.Humanoid or character.Humanoid.Health <= 0 or not rootPart then
                    break
                end

                if isHoldingCrate() then
                    triggerPrompt(shelfPrompt)
                else
                    triggerPrompt(cratePrompt)
                end

                task.wait(0.1)
            end
        end)
    end
})

shelfStockerSection:AddToggle({
    Name = "Underground",
    Flag = "ShelfStockerUnderground_Toggle",
    Default = false,
    Callback = function(Value)
        scriptsettings.shelf = scriptsettings.shelf or {}
        scriptsettings.shelf.underground = Value
    end
})

shelfStockerSection:AddToggle({
    Name = "Enabled",
    Flag = "ShelfStocker_Toggle",
    Default = false,
    Callback = function(Value)
        _G.AutoShelfStock = Value
        task.spawn(function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            -- Cache ProximityPrompts
            local shelfJob = workspace:FindFirstChild("Shelf Job")
            local cratePickupPrompt = shelfJob and shelfJob.CratePickups and shelfJob.CratePickups:FindFirstChild("Pick Up Crate") and shelfJob.CratePickups["Pick Up Crate"]:WaitForChild("ProximityPrompt")
            local shelfPrompt = shelfJob and shelfJob.ShelfPrompts and shelfJob.ShelfPrompts:FindFirstChild("Shelf") and shelfJob.ShelfPrompts.Shelf:WaitForChild("ProximityPrompt")

            -- Function to check if the player is holding a crate
            local function isHoldingCrate()
                return character:FindFirstChild("Crate") ~= nil
            end

            -- Function to teleport to a position
            local function teleportTo(position)
                local yOffset = scriptsettings.shelf and scriptsettings.shelf.underground and -7 or 3
                humanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, yOffset, 0))
            end

            -- Function to trigger a ProximityPrompt
            local function triggerPrompt(prompt)
                if prompt and prompt:IsA("ProximityPrompt") then
                    local promptPosition = prompt.Parent.Position
                    teleportTo(promptPosition)
                    task.wait(0.1)
                    firePrompt(prompt) -- Use existing firePrompt function
                end
            end

            -- Main autofarm loop
            local function autofarm()
                while _G.AutoShelfStock do
                    if pauseFarm then
                        repeat task.wait(1) until not pauseFarm
                    end

                    -- Refresh character
                    character = player.Character
                    humanoidRootPart = character and character:WaitForChild("HumanoidRootPart")

                    if not character or not character.Humanoid or character.Humanoid.Health <= 0 or not humanoidRootPart then
                        break
                    end

                    -- Step 1: If not holding a crate, go to crate pickup prompt
                    if not isHoldingCrate() then
                        triggerPrompt(cratePickupPrompt)
                        task.wait(0.5)
                    end

                    -- Step 2: If holding a crate, go to shelf prompt
                    if isHoldingCrate() then
                        triggerPrompt(shelfPrompt)
                        task.wait(0.5)
                    end

                    task.wait(0.1)
                end
            end

            -- Start autofarm immediately if character exists
            if character then
                autofarm()
            end

            -- Handle character respawn
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                if _G.AutoShelfStock then
                    task.spawn(autofarm)
                end
            end)
        end)
    end
})

Window:DrawCategory({
    Name = "Misc"
});

local ThemeTab = Window:DrawTab({
    Icon = "paintbrush",
    Name = "Themes",
    Type = "Single"
});

ThemeTab:DrawSection({
    Name = "UI Themes"
}):AddDropdown({
    Name = "Select Theme",
    Default = "Dark Blue",
    Values = {
        "Default",
        "Dark Green",
        "Dark Blue",
        "Purple Rose",
        "Skeet"
    },
    Callback = function(v)
        Compkiller:SetTheme(v)
    end,
});

local ConfigUI = Window:DrawConfig({
    Name = "Config",
    Icon = "folder",
    Config = ConfigManager
});

ConfigUI:Init();
