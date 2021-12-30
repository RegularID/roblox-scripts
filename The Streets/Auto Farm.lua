local SERVER_HOP = true -- Might get you a cooldown better to do it in a private server
local SERVER_HOP_DELAY = 10


local wait = task.wait
local delay = task.delay
local spawn = task.spawn


if not game:IsLoaded() then game.Loaded:Wait() end
local Original = 455366377 or false
if not Original and game.PlaceId ~= 4669040 then return end


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")


local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player:WaitForChild("Backpack")
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Humanoid.RootPart


function FireTouch(Part, Part2)
    firetouchinterest(Part, Part2, 0)
    firetouchinterest(Part, Part2, 1)
end


function Loop()
    if Humanoid.Sit then Humanoid.Sit = false end
end


function OnWorkspaceChildAdded(self)
    delay(0, function()
        if tostring(self) == "RandomSpawner" then
            while self and self.Parent == workspace do
                Root.CFrame = self.CFrame
                FireTouch(Root, self)
                wait()
            end
        end
    end)
end


function OnBackpackChildAdded(self)
    if self:IsA("Tool") then
        if string.find(tostring(self), "Cash") then
            delay(0, function()
                Humanoid:EquipTool(self)
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
    pcall(function()
        local Servers = {}
        local Url = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. 455366377 .. "/servers/Public?sortOrder=Asc&limit=100")
        for _, v in ipairs(HttpService:JSONDecode(Url).data) do
            if typeof(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                Servers[#Servers + 1] = v.id
            end
        end
        if #Servers > 0 then
            TeleportService:TeleportToPlaceInstance(455366377, Servers[math.random(1, #Servers)])
        end
    end)
    delay(5, ServerHop)
end


if not Original then ServerHop() end
if SERVER_HOP then delay(SERVER_HOP_DELAY, ServerHop) end
for _, v in ipairs(workspace:GetChildren()) do
    OnWorkspaceChildAdded(v)
end


RunService.Stepped:Connect(Loop)
workspace.ChildAdded:Connect(OnWorkspaceChildAdded)
Backpack.ChildAdded:Connect(OnBackpackChildAdded)
Player.CharacterAdded:Connect(OnCharacterAdded)
Player.Idled:Connect(OnIdle)
