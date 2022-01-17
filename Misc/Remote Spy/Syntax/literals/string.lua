return function (t_table, get_type)
    local string_initializer = nil
    local cursor_progress = 0
    local buffer = ""
    local string_escape = false

    local function parseString(input)
        local byte = input and string.byte(input)

        local is_double_quote = byte == 0x22
        local is_single_quote = byte == 0x27
        local is_escaping = byte == 0x5C

        if is_escaping then -- Check if initializing escape sequence
            string_escape = true
            buffer = buffer .. '\\'
            return true
        end

        if string_escape and (is_single_quote or is_double_quote) then -- Escape quotes in string
            buffer = buffer .. input
            string_escape = false
            return true
        else
            string_escape = false
        end

        if string_initializer and string.byte(string_initializer) == byte and not string_escape then -- End of string
            string_initializer = true
            buffer = buffer .. input
            return false
        elseif not string_initializer and (is_single_quote or is_double_quote) then -- Start of string
            string_initializer = is_single_quote and "'" or is_double_quote and '"'
            buffer = buffer .. input
            return true
        elseif byte ~= nil and string_initializer and not is_single_quote and not is_double_quote then -- string content
            buffer = buffer .. input
            return true
        elseif not string_initializer and not is_single_quote and not is_double_quote then -- Not string
            buffer = ''
            return false
        elseif not byte == nil then -- String is never terminated (EOF reached)
            buffer = ''
            return false
        end

    end

    while parseString(t_table.char) do
        cursor_progress = cursor_progress + 1
        t_table:advance()
    end

    if #buffer > 0 and string_initializer == true then
        t_table:advance()
        return get_type("string", buffer)
    end

    t_table:advance(-cursor_progress)
    return nil
end