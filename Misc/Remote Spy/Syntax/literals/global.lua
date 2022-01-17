return function(t_table, get_type)
    local lua_globals = {
        "getrawmetatable", "game", "workspace", "script", "math", "string",
        "table", "print", "wait", "BrickColor", "Color3", "next", "pairs",
        "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3",
        "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick",
        "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy",
        "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall",
        "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring",
        "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn",
        "LoadLibrary", "settings", "stats", "time", "UserSettings", "version",
        "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint",
        "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo",
        "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect",
        "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16"
    }

    local expected_types = { 'whitespace', 'eol', 'symbol' }
    local last_check = t_table:checkback(0, expected_types, 'type')

    if not last_check then
        return nil
    end

    local cursor_progress = 0
    local buffer = ''

    for _, global in pairs(lua_globals) do
        if buffer ~= '' then break end
        for index = 1, #global do
            local char = global:sub(index, index)
            if char == t_table.char then
                buffer = buffer .. char
                cursor_progress = cursor_progress + 1
                t_table:advance()
            else
                t_table:advance(-cursor_progress)
                buffer = ''
                cursor_progress =  0
                break
            end
        end
    end

    if #buffer > 0 then
        return get_type('global', buffer)
    end

    return nil
end
