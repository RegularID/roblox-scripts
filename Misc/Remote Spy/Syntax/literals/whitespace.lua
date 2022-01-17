return function (t_table, get_type)
    local buffer = ''
    local add_advance = function(char)
        buffer = char ~= "\r" and buffer .. char or buffer
        t_table:advance()
    end
    local function is_space(input)
        return input == ' ' or input == '\r'
    end

    if is_space(t_table.char) then
        add_advance(t_table.char)
    else
        return nil
    end
    
    while is_space(t_table.char) do
        add_advance(t_table.char)
    end

    return get_type("whitespace", buffer)
end