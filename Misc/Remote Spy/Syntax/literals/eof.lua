return function (t_table, get_type)
    local empty = string.byte(t_table.char) == nil
    local eof = t_table.cursor + 1 == t_table.str_length
    
    if empty and eof then
        return get_type("eof")
    end
    
    return nil -- Even reachable?
end