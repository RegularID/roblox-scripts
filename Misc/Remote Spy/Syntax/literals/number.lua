return function(t_table, get_type)
    local cursor_position = 0
    local buffer = ""

    local is_hex = false
    local is_float = false

    local function isNumber(input)
        local str_byte = string.byte(tostring(input)) or 0
        local is_numeric = str_byte >= 0x30 and str_byte <= 0x39

        local hex_literal = #buffer == 1 and buffer:sub(1, 1):byte() == 0x30 and str_byte == 0x78 -- E.g: 0x3e literal
        local float_literal = (#buffer == 1 or #buffer == 0) and str_byte == 0x2e -- E.g: 1.33 literal or .333 literal

        if is_hex then
            local lower = input and string.byte(string.lower(input))
            if lower and ((lower >= 0x61 and lower <= 0x66) or is_numeric) then -- hex char or numb allowed
                return true
            else
                return false
            end
        elseif is_float then
            local decimal =  '.'
            local invalid = string.match(buffer, decimal) and input == decimal -- multiple decimal places
            if not invalid and is_numeric then -- valid and is a number
                return true
            else
                return false
            end
        end

        if hex_literal then -- enable hex code path
            is_hex = true
            return true
        elseif float_literal  then -- enable float code path
            is_float = true
            return true
        end

        return is_numeric -- normal number
    end

    while isNumber(t_table.char) do
        buffer = buffer .. t_table.char
        cursor_position = cursor_position + 1
        t_table:advance()
    end

    if #buffer == 1 and buffer:sub(1, 1):byte() == 0x2e then
        t_table:advance(-cursor_position)
        return nil
    end

    if #buffer > 0 then
        return get_type("number", buffer)
    end
    
    t_table:advance(-cursor_position)
    return nil
end