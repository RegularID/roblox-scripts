return function (t_table, get_type)
    local buffer = ''
    local eol_advance = function (char)
        buffer = buffer .. char
        t_table:advance()
        t_table:eol()
    end
    local function is_new_line(input)
        return input == '\n'
    end

    if is_new_line(t_table.char) then
        eol_advance(t_table.char)
    else
        return nil
    end
    
    while is_new_line(t_table.char) do
        eol_advance(t_table.char)
    end

    return get_type("eol", buffer)
end