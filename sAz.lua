local Cash = getgenv().Cash or 0
local OpenBestEgg1 = getgenv().Open or 10
local OpenBestEgg = getgenv().Egg or false  

local args2 = {
    "EggZombie",
    {
        amount = -Cash
    }
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PurchaseEvent"):FireServer(unpack(args2))

if OpenBestEgg then
    local bestEggArgs = {
        "EggWarrior",
        {
            amount = OpenBestEgg1
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PurchaseEvent"):FireServer(unpack(bestEggArgs))
end
