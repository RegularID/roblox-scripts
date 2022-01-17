return function (t_table, get_type)
    local cursor_progress = 0
    local buffer = ''
    local has_space = t_table:checkback(0, { 'whitespace', 'symbol', 'eol' }, 'type') 
    local intializer = t_table:checkback(-1, { 'local', 'function' }, 'value')
    local init_byte = t_table.char and string.byte(t_table.char or '') or 0
    local first_was_number = init_byte >= 0x30 and init_byte <= 0x39
    local was_intitialized = has_space and intializer and not first_was_number
    
    if not was_intitialized then return nil end -- improper initialization

    local function is_valid_variable(input)
        local byte = input and string.byte(input) or 0

        -- alpha lowercase
        if byte >= 97 and byte <= 122 then return true end
        -- alpha uppercase
        if byte >= 65 and byte <= 90 then return true end
        -- numeric
        if byte >= 48 and byte <= 57 then return true end
        -- underscore
        if byte == 95 then return true end

        return false
    end

    while is_valid_variable(t_table.char) do
        buffer = buffer .. t_table.char
        t_table:advance()
    end

    if #buffer > 0 then
        return get_type('identifier', buffer)
    end

    t_table:advance(-cursor_progress) -- send cursor back
    return nil
end