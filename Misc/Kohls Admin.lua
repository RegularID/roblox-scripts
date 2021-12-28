local Command = "Hat" -- Hat || Refresh || Vote || Trail || Shine || CClr
local Argument = true


local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("b\7\n\7\n\7")
function GetID()
    local ID
    Remote:FireServer("KuID")
    local Ev
    Ev = Remote.OnClientEvent:Connect(function(_, a)
        for k, v in pairs(a) do
            ID = v
            break
        end
        Ev:Disconnect()
    end)
    repeat wait() until ID
    return ID
end


function FireCommand(Command, Argument)
    local ID = GetID()
    Remote:FireServer(ID .. "K" .. Command, Argument, ID)
end
