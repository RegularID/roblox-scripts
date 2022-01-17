return function(t_table, get_type)
    local symbol = {
        ",", ".", "..", "...", ";", ":", "{", "}", "(", ")", "[", "]", "="
    }

    local function in_table(input, find)
        for _, value in pairs(input) do
            if value == find then
                return find
            end
        end
        return false
    end

    local is_symbol = in_table(symbol, t_table.char)
    if is_symbol then
        t_table:advance()
        return get_type('symbol', is_symbol)
    end

    return nil
end