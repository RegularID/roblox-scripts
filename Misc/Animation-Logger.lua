if not game:IsLoaded() then game.Loaded:Wait() end


local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer") and Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Target
local Selected = {}
local Dragging = {}
local Animations = {}
local Draggables = {}


function protect_gui(Gui, Parent)
    if syn and syn.protect_gui then
        syn.protect_gui(Gui)
        Gui.Parent = Parent
    elseif gethui then
        Gui.Parent = gethui()
    else
        Gui.Parent = Parent
    end
end


function GetPlayer(Name)
    for _, v in ipairs(Players:GetPlayers()) do
        if Player == v then continue end
        local Player = v
        local _Name = string.lower(tostring(Player))
        local _DisplayName = string.lower(Player.DisplayName)

        if _Name == Name or _DisplayName == Name or "!" .. Player.UserId == Name then
            return Player
        end
    end
end


function GetHumanoid(_Player)
    local Player = typeof(_Player) == "Instance" and _Player or Player
    local Character = Player and Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    return Humanoid
end


-- menu sextion


local gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Underline = Instance.new("TextLabel")
local List = Instance.new("ScrollingFrame")
local ListLayout = Instance.new("UIListLayout")
local SelectedBox = Instance.new("TextBox")
local CopyIdButton = Instance.new("TextButton")
local IsPlayingLabel = Instance.new("TextLabel")
local IsPlayingCheckBox = Instance.new("TextButton")
local TargetBox = Instance.new("TextBox")


function SetDraggable(self)
    table.insert(Draggables, self)
    local DragOrigin
    local GuiOrigin

    self.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
            for _, v in ipairs(Draggables) do
                v.ZIndex = 1
            end
            self.ZIndex = 2

            Dragging = {Gui = self, True = true}
            DragOrigin = Vector2.new(Input.Position.X, Input.Position.Y)
            GuiOrigin = self.Position
        end
    end)

    UserInput.InputChanged:Connect(function(Input, Process)
        if Dragging.Gui ~= self then return end
        if not (UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
            Dragging = {Gui = nil, True = false}
            return
        end
        if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragOrigin
            local ScreenSize = gui.AbsoluteSize

            local ScaleX = (ScreenSize.X * GuiOrigin.X.Scale)
            local ScaleY = (ScreenSize.Y * GuiOrigin.Y.Scale)
            local OffsetX = math.clamp(GuiOrigin.X.Offset + Delta.X + ScaleX,   0, ScreenSize.X - self.AbsoluteSize.X)
            local OffsetY = math.clamp(GuiOrigin.Y.Offset + Delta.Y + ScaleY, -36, ScreenSize.Y - self.AbsoluteSize.Y)
            
            local Position = UDim2.fromOffset(OffsetX, OffsetY) -- Yeah we don't keep Scale but if some math god hits me up I will fix it
			self.Position = Position
        end
    end)
end


gui.Name = "gui"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protect_gui(gui, CoreGui)

Main.Name = "Main"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderColor3 = Color3.fromRGB(133, 135, 236)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0, 50, 0, 50)
Main.Size = UDim2.new(0, 200, 0, 290)
Main.Parent = gui
SetDraggable(Main)

Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 200, 0, 15)
Title.Font = Enum.Font.SourceSans
Title.Text = "Animation Logger"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.TextStrokeTransparency = 0.4
Title.TextTransparency = 0.2
Title.Parent = Main

Underline.Name = "Underline"
Underline.BackgroundColor3 = Color3.fromRGB(86, 40, 117)
Underline.BorderSizePixel = 0
Underline.Position = UDim2.new(0, 3, 1, 0)
Underline.Size = UDim2.new(1, -10, 0, 1)
Underline.Font = Enum.Font.SourceSans
Underline.Text = ""
Underline.TextColor3 = Color3.fromRGB(0, 0, 0)
Underline.TextSize = 14
Underline.Parent = Title

List.Name = "List"
List.Active = true
List.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
List.BorderSizePixel = 0
List.Position = UDim2.new(0, 5, 0, 25)
List.Size = UDim2.new(0, 190, 0, 180)
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.ScrollBarThickness = 4
List.Parent = Main

ListLayout.Name = "ListLayout"
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = List


SelectedBox.Name = "SelectedBox"
SelectedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SelectedBox.BorderSizePixel = 0
SelectedBox.Position = UDim2.new(0, 5, 0, 250)
SelectedBox.Size = UDim2.new(0, 190, 0, 15)
SelectedBox.ClearTextOnFocus = false
SelectedBox.Font = Enum.Font.SourceSans
SelectedBox.Text = "rbxassetid://0"
SelectedBox.TextColor3 = Color3.new(1, 1, 1)
SelectedBox.TextSize = 14
SelectedBox.TextStrokeTransparency = 0.2
SelectedBox.Parent = Main

CopyIdButton.Name = "CopyIdButton"
CopyIdButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CopyIdButton.BorderSizePixel = 0
CopyIdButton.Position = UDim2.new(0, 5, 0, 270)
CopyIdButton.Size = UDim2.new(0, 190, 0, 15)
CopyIdButton.Font = Enum.Font.SourceSans
CopyIdButton.Text = "Copy Asset Id"
CopyIdButton.TextColor3 = Color3.new(1, 1, 1)
CopyIdButton.TextSize = 14
CopyIdButton.TextStrokeTransparency = 0.2
CopyIdButton.Parent = Main
CopyIdButton.MouseButton1Click:Connect(function()
    if setclipboard and Selected and Selected.Id then
        setclipboard(Selected.Id)
    end
end)

IsPlayingLabel.Name = "IsPlayingLabel"
IsPlayingLabel.BackgroundTransparency = 1
IsPlayingLabel.Position = UDim2.new(0, 20, 0, 210)
IsPlayingLabel.Size = UDim2.new(0, 175, 0, 15)
IsPlayingLabel.Font = Enum.Font.SourceSans
IsPlayingLabel.Text = "Is Playing"
IsPlayingLabel.TextColor3 = Color3.new(1, 1, 1)
IsPlayingLabel.TextSize = 14
IsPlayingLabel.TextStrokeTransparency = 0.2
IsPlayingLabel.TextXAlignment = Enum.TextXAlignment.Left
IsPlayingLabel.Parent = Main

IsPlayingCheckBox.Name = "IsPlayingCheckBox"
IsPlayingCheckBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IsPlayingCheckBox.BorderColor3 = Color3.fromRGB(30, 30, 30)
IsPlayingCheckBox.Position = UDim2.new(0, -15, 0, 2)
IsPlayingCheckBox.Size = UDim2.new(0, 10, 0, 10)
IsPlayingCheckBox.AutoButtonColor = false
IsPlayingCheckBox.Font = Enum.Font.SourceSans
IsPlayingCheckBox.Text = ""
IsPlayingCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
IsPlayingCheckBox.TextSize = 14
IsPlayingCheckBox.Parent = IsPlayingLabel

TargetBox.Name = "Target"
TargetBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetBox.BorderSizePixel = 0
TargetBox.Position = UDim2.new(0, 5, 0, 230)
TargetBox.Size = UDim2.new(0, 190, 0, 15)
TargetBox.ClearTextOnFocus = false
TargetBox.Font = Enum.Font.SourceSans
TargetBox.PlaceholderColor3 = Color3.new(1, 1, 1)
TargetBox.PlaceholderText = "LocalPlayer"
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.new(1, 1, 1)
TargetBox.TextSize = 14
TargetBox.TextStrokeTransparency = 0.2
TargetBox.Parent = Main


function AddAnimation(Animation)
    local Button = Instance.new("TextButton")
    Button.Name = Animation.AnimationId
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(0, 180, 0, 15)
    Button.Font = Enum.Font.SourceSans
    Button.Text = Animation.Name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    Button.TextStrokeTransparency = 0.2
    Button.Parent = List
    Button.MouseButton1Click:Connect(function()
        local AssetId = string.gsub(Animation.AnimationId, "%D", "")
        Selected = {
            Animation = Animation,
            Id = AssetId,
            Name = Animation.Name
        }

        SelectedBox.Text = "rbxassetid://" .. AssetId
    end)

    List.CanvasSize += UDim2.fromOffset(0, 15)
end


RunService.Stepped:Connect(function()
    local NewTarget = GetPlayer(TargetBox.Text)
    Target = typeof(NewTarget) == "Instance" and NewTarget or Player


    local Humanoid = GetHumanoid(Target)
    if Humanoid then
        local AnimationTracks = Humanoid:GetPlayingAnimationTracks()
        for _, Track in ipairs(AnimationTracks) do
            local Animation = Track.Animation
            if not Animations[Animation.AnimationId] then
                AddAnimation(Animation)
            end

            Animations[Animation.AnimationId] = Animation.AnimationId
            if Selected.Animation == Animation then
                IsPlayingCheckBox.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
            else
                IsPlayingCheckBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        end
    end
end)
