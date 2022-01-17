return function (t_table, get_type)
    local cursor_progress = 0
    local buffer = ''

    local first_char = t_table.char
    local first_byte = first_char and string.byte(first_char) or 0
    local first_numeric = first_byte >= 0x30 and first_byte <= 0x39
    
    local function is_valid_variable(input)
        local byte = input and string.byte(input) or 0
        if byte >= 97 and byte <= 122 then return true end
        if byte >= 65 and byte <= 90 then return true end
        if byte >= 48 and byte <= 57 then return true end
        if byte == 95 then return true end

        return false
    end

    if first_numeric or not is_valid_variable(first_char) then
        return
    end

    while is_valid_variable(t_table.char) do
        cursor_progress = cursor_progress + 1
        buffer = buffer .. t_table.char
        t_table:advance()
    end

    local next_parenthesis = t_table.char and string.byte(t_table.char) == 0x28
    
    if buffer ~= 'function' and next_parenthesis and #buffer > 0 then
        return get_type('method', buffer)
    end

    t_table:advance(-cursor_progress)
    return nil
end