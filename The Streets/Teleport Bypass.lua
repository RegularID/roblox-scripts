local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local Player = Players.LocalPlayer
local Root = Player.Character.Humanoid.RootPart
local Torso = Player.Character.Torso


local Seat
for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Seat") and not v:FindFirstAncestor("Jeep", true) and not v.Occupant then
        Seat = v
        break
    end
end

Root.RootJoint:Destroy()
Root.Parent = workspace

RunService.Stepped:Connect(function()
    if Root and Torso and Seat and firetouchinterest then
        firetouchinterest(Torso, Seat, 0)
        firetouchinterest(Torso, Seat, 1)
    end
end)
