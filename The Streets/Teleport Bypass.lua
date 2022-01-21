local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local Root = Humanoid.RootPart
local Torso = Character.Torso
local Seats = {}
local Seat
local Loop


for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Seat") then
        if v:FindFirstAncestor("Jeep", true) then continue end
        table.insert(Seats, v)
    end
end
if #Seats == 0 then return end


function GetSeat()
    for _, v in ipairs(Seats) do
        if v.Occupant then continue end
        Seat = v
        return v
    end
end


local SitDebounce = false
function SitOnSeat()
    if Character and Character.Parent == nil then return Loop:Disconnect() end
    if not Torso or not Root or not Humanoid or not Character then return Loop:Disconnect() end
    if Seat and not Seat.Occupant and not Seat:FindFirstChild("SeatWeld") then
        pcall(Seat.Sit, Seat, Humanoid)
    else
        GetSeat()
    end
end


SitOnSeat()
Root.RootJoint:Destroy()
Root.Parent = workspace

Loop = RunService.Stepped:Connect(SitOnSeat)
