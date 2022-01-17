return function(t_table, get_type)
    local keywords = {
        'and', 'break', 'do', 'else', 'elseif', 'end', 'for', 'function', 'if',
        'in', 'local', 'not', 'or', 'repeat', 'return', 'then', 'until', 'while',
        'self', 'true', 'false'
    }
    local cursor_progress = 0
    local buffer = ''


    local expected_types = { 'whitespace', 'eol', 'symbol' }
    local last_check = t_table:checkback(0, expected_types, 'type')

    if not last_check then
        return nil
    end

    for _, key_word in pairs(keywords) do
        if buffer ~= '' then break end
        for index = 1, #key_word do
            local char = key_word:sub(index, index)

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
        if buffer == 'true' or buffer == 'false' then
            return get_type('boolean', buffer)
        end
        --[[
            I want booleans seperate for style reasons,
            but don't want a whole type check function for it.
            So I'll just lazily do this ⬆
        ]]--

        return get_type('keyword', buffer)
    end

    t_table:advance(-cursor_progress)
    return nil
end
