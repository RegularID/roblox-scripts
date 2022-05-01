local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("b\7\n\7\n\7")
if not Remote then return end

local ID, Settings, Commands

-- The ID doesn't change as of now, so u can save it as a global var
Remote:FireServer("KuID")
local Ev
Ev = Remote.OnClientEvent:Connect(function(_, a)
    ID = a[1]
    Settings = a[3]
    Commands = a[4]
    Ev:Disconnect()
end)

repeat wait() until ID and Settings and Commands


function FireCommand(Command:string, ...)
    Remote:FireServer(ID .. "K" .. Command, ..., ID)
end

--Valid Commands: [Refresh, Hat, Trail, Shine, Kick]
--[[ Example script, kicks localplayer out of the game n amount of times by the server
for i = 1, 10000 do
    FireCommand("Kick")
end
]]
