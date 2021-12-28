local Time = os.clock()
if not game:IsLoaded() then game.Loaded:Wait() end


local wait = task.wait
local delay = task.delay
local spawn = task.spawn
local request = syn and syn.request or http and http.request or request
local secure_call = syn and syn.secure_call or secure_call or function(f, _, ...) return f(...) end -- Meh
local get_custom_asset = syn and getsynasset or getcustomasset
local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport


local Stats = game:GetService("Stats")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Marketplace = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local ScriptContext = game:GetService("ScriptContext")
local ContextAction = game:GetService("ContextActionService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player:WaitForChild("Backpack")
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("UpperTorso")
local Root = Humanoid.RootPart
local Tool = Character:FindFirstChildOfClass("Tool")
local PlayerGui = Player:WaitForChild("PlayerGui")
local HUD = PlayerGui and PlayerGui:WaitForChild("HUD")
local Camera = workspace.CurrentCamera


local Script = Player.PlayerScripts.BubbleChat
for _, v in pairs(getreg()) do
    if typeof(v) == "function" and getfenv(v).script == Script then
        local Functions = debug.getupvalue(v, 1)
        Functions["OnGameChatMessage"] = function() end
        debug.setupvalue(v, 1, Functions)
        break
    end
end


function OnCharacterAdded(_Character)
    Tool = nil
    Character = _Character
    HUD = PlayerGui:WaitForChild("HUD")
    Backpack = Player:WaitForChild("Backpack")
    Humanoid = Character:WaitForChild("Humanoid")
    Torso = Character:WaitForChild("UpperTorso")
    Root = Humanoid.RootPart
end


local Index, NewIndex, NameCall


function OnIndex(self, Key)
    local Caller = checkcaller()
    local Name = tostring(self)

    if not Caller then
        if Name == "HumanoidRootPart" and Key == "Magnitude" then
        end
    end

    return Index(self, Key)
end


function OnNewIndex(self, Key, Value)
    local Caller = checkcaller()
    local Name = tostring(self)
    
    if Caller then
        return NewIndex(self, Key, Value)
    end

    if self == Mouse and Key == "Icon" then return end

    if self == Humanoid then
        if Key == "WalkSpeed" then
           
        end

        if Key == "JumpPower" then
            
        end

        if Key == "AutoRotate" then Value = true end

        --if (Key == "Jump" and not Value) and (Config.NoSlow.Enabled or Config.God.Enabled) then return end
        if Key == "Health" then return end
    end
    return NewIndex(self, Key, Value)
end


function OnNameCall(self, ...)
    local Arguments = {...}
    local Name = tostring(self)
    local Caller, Method = checkcaller(), getnamecallmethod()

    if self == Player and Method == "Kick" then return end

    if Method == "FireServer" then
        if Name == "Input" then
            local Key = Arguments[1]
            if Key == "x" then return end
            if Arguments[2] then
				--[[
                if Arguments[2].mousehit then
                    if not Caller and Target and Config.Aimbot.Enabled then
                        Arguments[2].mousehit = GetAimbotCFrame()
                    end
                end
				-]]
			end
		end
    end
    if not Caller then
        if Method == "Destroy" then
            if self == Character then return end
            if Name == "Head" then return end
            if string.find(self.ClassName, "Body") then return end
        end
        if self == Character and Method == "BreakJoints" then return end
        if (Method == "WaitForChild" or Method == "FindFirstChild" or Method == "findFirstChild") then
            local Key = Arguments[1]
            if self == Character and (Key == "x" or Key == "Override") then
                Arguments[1] = "Head" -- Maybe Change This
            end
        end
    end
    
    return NameCall(self, unpack(Arguments))
end


NewIndex = hookmetamethod(game, "__newindex", OnNewIndex)
NameCall = hookmetamethod(game, "__namecall", OnNameCall)


print(os.clock() - Time)
