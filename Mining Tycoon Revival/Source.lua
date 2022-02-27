_G.Config = {
    AutoOre = {
        Enabled = true
    },
    AutoExplode = {
        Enabled = true
    },
    AutoUpgrade = {
        Enabled = true
    },
    AutoRebirth = {
        Enabled = true
    }
}


if _G[game.PlaceId] then return end
_G[game.PlaceId] = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function GetTycoon(Player)
    local Player = typeof(Player) == "Instance" and Player:IsA("Player") and Player or Players.LocalPlayer
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and string.find(tostring(v), "Tycoon") then
            if v:FindFirstChild(tostring(Player)) then
                return v
            end
        end
    end
end

function GetOres(Player)
    local Player = typeof(Player) == "Instance" and Player:IsA("Player") and Player or Players.LocalPlayer
    return GetTycoon(Player).Ores:GetChildren()
end


function GetButtons(Player)
    local Player = typeof(Player) == "Instance" and Player:IsA("Player") and Player or Players.LocalPlayer
    return GetTycoon(Player).Buttons
end


function GetStructures(Player)
    local Player = typeof(Player) == "Instance" and Player:IsA("Player") and Player or Players.LocalPlayer
    return GetTycoon(Player).Structures
end


function GetUpgrades(Player)
    local Player = typeof(Player) == "Instance" and Player:IsA("Player") and Player or Players.LocalPlayer
    return GetTycoon(Player).Data.Upgrades
end


function GetCash(Player)
    local Player = typeof(Player) == "Instance" and Player:IsA("Player") and Player or Players.LocalPlayer
    return Player.leaderstats.Cash.Value
end


function Buy(Button)
    local Remote = ReplicatedStorage.Tycoon.ButtonClicked
    Remote:FireServer(Button)
end


function Rebirth()
    local Rebirth = ReplicatedStorage.Prestige.Rebirth
    Rebirth:InvokeServer()
end


function OnIdle()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end


function Loop()
    local Ores = GetOres()
    
    if #Ores > 0 then
        if _G.Config.AutoOre.Enabled then
            local Structures = GetStructures()
            local Upgrades = GetUpgrades()
            local BlastFurnace = Structures:FindFirstChild("Blast_Furnace")
            local Cleaner = Structures:FindFirstChild("Cleaner")
            local Purifier = Structures:FindFirstChild("Purifier")
            local SellArea = CFrame.new(1205, 11, -877)
            
            pcall(function()
                for _, Ore in ipairs(Ores) do
                    if Ore.Smelted.Value then
                        if Ore.Cleaning.Value == Upgrades.CleanAmount.Value then
                            if Ore.Purification.Value == Upgrades.PurifyAmount.Value then
                                Ore.CFrame = SellArea
                            else
                                if Purifier then
                                    Ore.CFrame = Purifier:GetPivot()
                                else
                                    Ore.CFrame = SellArea
                                end
                            end
                        else
                            if Cleaner then
                                Ore.CFrame = Cleaner:GetPivot()
                            else
                                Ore.CFrame = SellArea
                            end
                        end
                    else
                        if BlastFurnace then
                            Ore.CFrame = BlastFurnace:GetPivot()
                        else
                            Ore.CFrame = SellArea
                        end
                    end
                end
            end)
        end
    else
        local Buttons = GetButtons()
        if _G.Config.AutoExplode.Enabled then
            pcall(function()
                local OreButton = Buttons:FindFirstChild("Support") or Buttons:FindFirstChild("Explode")
                if OreButton and GetCash() > OreButton.Head.Cost.Value then
                    Buy(OreButton.Head)
                end
            end)
        end
    end
    if _G.Config.AutoUpgrade.Enabled then
        pcall(function()
            local Buttons = GetButtons()
            local IgnoreList = {Buttons.Crisis, Buttons.Conveyor}
            
            for _, Button in ipairs(Buttons:GetChildren()) do
                if table.find(IgnoreList, Button) then continue end
                if Button.Head.Cost.Value == 0 then continue end
                if GetCash() > Button.Head.Cost.Value * 1.5 then
                    Buy(Button.Head)
                end
            end
        end)
    end
    if _G.Config.AutoRebirth.Enabled then
        Rebirth()
    end
end


while not GetTycoon(Players.LocalPlayer) do wait() end


RunService.Stepped:Connect(Loop)
Players.LocalPlayer.Idled:Connect(OnIdle)
