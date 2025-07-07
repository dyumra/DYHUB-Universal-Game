for h,i in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frame["Main Body"].Main.Shop.Cars.CarList.CarList:GetChildren()) do

local args = {
    -1e999,
    i.Name,
    "purchase"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CarShop"):FireServer(unpack(args))
end
