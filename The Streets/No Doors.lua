local Doors = {}
for _, v in ipairs(workspace:GetDescendants()) do
    if tostring(v) == "Door" and v:FindFirstChild("WoodPart") and v:FindFirstChild("RemoteEvent", true) then
        table.insert(Doors, v)
    end
end
getgenv()._Doors = Doors


for _, Door in ipairs(Doors) do
    for _, Object in ipairs(Door:GetDescendants()) do
        if Object:IsA("BasePart") then
            Object.Transparency = 1
            Object.CanCollide = false
        end
    end
end
