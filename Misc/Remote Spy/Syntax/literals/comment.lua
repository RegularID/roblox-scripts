return function (t_table, get_type)
    local cursor_progress = 0
    local buffer = ''
    local hit_eof = false
    local in_comment = false
    local multiline_comment = false

    local function is_comment(input)
        local dashes = #buffer:sub(1, 2) 
        local dash_byte = 0x2d
        local terminator_byte = 0x0a
        local multi_terminator_byte = 0x5d
        local multi_byte = 0x5b

        local in_byte = input and string.byte(input) or 0

        local is_dash = in_byte == dash_byte
        local is_terminator = in_byte == terminator_byte
        local is_multi_char = in_byte == multi_byte
        local is_multi_term = in_byte == multi_terminator_byte

        if is_dash and not in_comment then
            if dashes == 1 then
                in_comment = true
            end
            return true
        end

        if in_comment then
            if in_byte == 0 then -- eof on comment
                hit_eof = true
                return false
            end

            if is_multi_char then -- adding '[' to comment check if start 
                if buffer == '--[' then -- begin multiline comment
                    multiline_comment = true
                    return true
                end
            end

            if not multiline_comment then -- single line comment
                if is_terminator then -- new line reached; end single line comment
                    return false
                else
                    return true -- single line comment content
                end
            else
                if is_multi_term then -- character is ] and initial closer is there
                    if buffer:sub(#buffer, #buffer):byte() == multi_terminator_byte then -- multiline comment complete
                        buffer = buffer .. t_table.char
                        return false
                    else
                        return true -- begin to end comment?
                    end
                else
                    return true -- multiline comment content
                end
            end
        end

        return nil -- not comment
    end

    while is_comment(t_table.char) do
        cursor_progress = cursor_progress + 1
        buffer = buffer .. t_table.char
        t_table:advance()
    end

    if hit_eof then
        t_table:advance(-1)
    end

    if #buffer > 1 then
        if multiline_comment then -- remove extra '[' if were dealing with multiline
            t_table:advance()
        end
        return get_type('comment', buffer)
    end

    t_table:advance(-cursor_progress)
    return nil
end