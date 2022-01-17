return function (t_table, get_type)
    local buffer = ''
    local is_numeric = function(input)
        return input and (input:byte() or 0) >= 0x30 and (input:byte() or 0) <= 0x39
    end

    local function is_valid_variable(input)
        local byte = input and string.byte(input) or 0
        if byte >= 97 and byte <= 122 then return true end
        if byte >= 65 and byte <= 90 then return true end
        if byte >= 48 and byte <= 57 then return true end
        if byte == 95 then return true end

        return false
    end
    local last_token = t_table.lex_tree[#t_table.lex_tree]
    local init_sub_prop = last_token and t_table:checkback(0, { 'symbol' }, 'type') and t_table:checkback(0, { '.' }, 'value') and not is_numeric(t_table.char)
    -- check if last token was dot and not starting sub property with number
    if not init_sub_prop then
        return false
    end

    while is_valid_variable(t_table.char) do
        buffer = buffer .. t_table.char
        t_table:advance()
    end

    if #buffer > 0 then
        return get_type('property', buffer)
    end

    return nil
end