_G.AutoFarm = true


if not game:IsLoaded() then game.Loaded:Wait() end
if _G.AlreadyRunningAutoFarm then return end
_G.AlreadyRunningAutoFarm = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Humanoid.Torso
local Head = Character:FindFirstChild("Head")


local wait = task.wait
local spawn = task.spawn
local delay = task.delay


local Teleporting = false
function Teleport(Destination)
    Teleporting = false
    local Event
    local Distance = Player:DistanceFromCharacter(Destination.Position)
    local Destination = CFrame.new(Destination.Position, Root.Orientation)
    if Distance < 50 then
        Root.CFrame = Destination
        Teleporting = false
        return true
    end

    Teleporting = true
    local Info = TweenInfo.new(Distance / 125, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, Info, {CFrame = Destination})

    Root.CFrame = CFrame.new(Root.Position, Destination.Position)
    spawn(function()
        while Teleporting do wait() end
        Tween:Cancel()
    end)
    Tween.Completed:Connect(function()
        Teleporting = false
    end)

    Tween:Play()
    return Tween
end


function OnCharacterAdded(_Character)
    Character = _Character
    Backpack = Player:WaitForChild("Backpack")
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Humanoid.Torso
    Head = Character:WaitForChild("Head")
end


function Loop()
    if _G.AutoFarm then
        if not Humanoid then return end
        Humanoid:UnequipTools()
        if Root then Root.CanCollide = false end
        if Head then Head.CanCollide = false end
        local Closest
        local Magnitude = math.huge
        for _, v in ipairs(workspace.Shops:GetChildren()) do
            if tostring(v) == "Cash" then
                local Click = v:FindFirstChild("ClickDetector")
                local Hover = v:FindFirstChild("Hover")
                if Click and Hover.Adornee and not v:GetAttribute("Ignore") then
                    local _Magnitude = Player:DistanceFromCharacter(v.Position)
                    if _Magnitude < Magnitude then
                        Closest = v
                        Magnitude = _Magnitude
                    end
                end
            end
        end
        
        if Humanoid.Sit then Humanoid:ChangeState(3) end
        if not Closest then return wait() end
        Teleport(Closest.CFrame)
        while Teleporting do wait() end
        wait(0.3)
        fireclickdetector(Closest.ClickDetector)
        Closest:SetAttribute("Ignore", true)
        delay(30, function()
            Closest:SetAttribute("Ignore", nil)
        end)
    end
end


RunService.Stepped:Connect(Loop)
Player.CharacterAdded:Connect(OnCharacterAdded)
