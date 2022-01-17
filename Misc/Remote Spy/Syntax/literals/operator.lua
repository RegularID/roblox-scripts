return function(t_table, get_type)
    local buffer = ''
    local cursor_progress = 0
    local operators = {
        "*", "+", "-", "/", "^", "%", ">", ">=", "<", "<=", "==", "~="
    }

    for _, lua_op in pairs(operators) do
        if buffer ~= '' then break end
        for index = 1, #lua_op do
            local op_char = lua_op:sub(index, index)
            if op_char == t_table.char then
                buffer = buffer .. t_table.char
                cursor_progress = cursor_progress + 1
                t_table:advance()
            else
                t_table:advance(-cursor_progress)
                buffer = ''
                cursor_progress = 0
                break
            end
        end
    end


    if #buffer > 0 then
        return get_type('operator', buffer)
    end

    t_table:advance(-cursor_progress)
    return nil
end
