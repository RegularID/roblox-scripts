local TOOL_CHAMS_ENABLED = true
local TOOL_CHAMS_COLOR = Color3.new()
local TOOL_CHAMS_MATERIAL = Enum.Material.ForceField -- Can also be a string
local TOOL_CHAMS_REFLECTANCE = 0.5
local TOOL_CHAMS_TRANSPARENCY = 0


function GetToolParts(Tool)
    local Parts = {}
    for _, v in ipairs(Tool:GetChildren()) do
        if v:IsA("BasePart") then
            if v:GetAttribute("DefaultTransparency") == 1 then continue end
            table.insert(Parts, v)
        end
    end
    return Parts
end


function SetToolDefaults(Tool, Parts)
    if not Tool:GetAttribute("DefaultsSet") then
        for _, Part in ipairs(Parts) do
            Part:SetAttribute("DefaultColor", Part.Color)
            Part:SetAttribute("DefaultMaterial", Part.Material.Name)
            Part:SetAttribute("DefaultReflectance", Part.Reflectance)
            Part:SetAttribute("DefaultTransparency", Part.Transparency)
            if Part:IsA("UnionOperation") then
                Part:SetAttribute("DefaultUsePartColor", Part.UsePartColor)
            end
        end
        Tool:SetAttribute("DefaultsSet", true)
    end
end


function SetToolProperties(Parts, Color, Material, Reflectance, Transparency, UsePartColor)
    for _, Part in ipairs(Parts) do
        Part.Color = Color or Part:GetAttribute("DefaultColor")
        Part.Material = Material or Part:GetAttribute("DefaultMaterial")
        Part.Reflectance = Reflectance or Part:GetAttribute("DefaultReflectance")
        Part.Transparency = Transparency or Part:GetAttribute("DefaultTransparency")
        if Part:IsA("UnionOperation") then
            Part.UsePartColor = UsePartColor or Part:GetAttribute("DefaultUsePartColor")
        end
    end
end


function SetToolChams(Tool)
    SetToolDefaults(Tool, GetToolParts(Tool))
    if TOOL_CHAMS_ENABLED then
        SetToolProperties(GetToolParts(Tool), TOOL_CHAMS_COLOR, TOOL_CHAMS_MATERIAL, TOOL_CHAMS_REFLECTANCE, TOOL_CHAMS_TRANSPARENCY, true)
    else
        SetToolProperties(GetToolParts(Tool))
    end
end


--SetToolChams(game.Players.LocalPlayer.Character.Glock)
