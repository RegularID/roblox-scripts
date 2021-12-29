local SERVER_HOP = true -- Might get you a cooldown better to do it in a private server
local SERVER_HOP_DELAY = 60


if not game:IsLoaded() then game.Loaded:Wait() end
math.randomseed(os.clock()) -- I got unlucky with serverhop


local wait = task.wait
local delay = task.delay
local spawn = task.spawn


local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")


local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player:WaitForChild("Backpack")
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Humanoid.RootPart


function OnWorkspaceChildAdded(self)
    delay(0, function()
        pcall(function()
            if tostring(self) == "RandomSpawner" then
                while self and self.Parent == workspace do
                    if Humanoid.Sit then Humanoid.Sit = false end
                    RootPart.CFrame = self.CFrame
                    wait()
                end
            end
        end)
    end)
end


function OnBackpackChildAdded(self)
    if self:IsA("Tool") then
        if string.find(tostring(self), "Cash") then
            delay(0, function()
                self.Parent = Character
                self:Activate()
            end)
        end
    end
end

function OnCharacterAdded(_Character)
    Character = _Character
    Backpack = Player:WaitForChild("Backpack")
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Humanoid.RootPart
    Backpack.ChildAdded:Connect(OnBackpackChildAdded)
end


function OnIdle()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end


function ServerHop()
    local Servers = {}
    local Url = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    for _, v in ipairs(HttpService:JSONDecode(Url).data) do
        if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
	    Servers[#Servers + 1] = v.id
        end
    end
    if #Servers > 0 then
	TeleportService:TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)])
    end
    delay(5, ServerHop)
end


if SERVER_HOP then delay(SERVER_HOP_DELAY, ServerHop) end
for _, v in ipairs(workspace:GetChildren()) do
    OnWorkspaceChildAdded(v)
end


workspace.ChildAdded:Connect(OnWorkspaceChildAdded)
Backpack.ChildAdded:Connect(OnBackpackChildAdded)
Player.CharacterAdded:Connect(OnCharacterAdded)
Player.Idled:Connect(OnIdle)
