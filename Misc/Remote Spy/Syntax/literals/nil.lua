return function (t_table, getType)
    local cursor_progress = 0
    local nil_str = 'nil'
    local tok_was_nil = true
    local was_space = t_table:checkback(0, { 'whitespace', 'eol', 'symbol' }, 'type')

    for index = 1, #nil_str do
        local nil_char_match = nil_str:sub(index, index) == t_table.char
        if nil_char_match then
            cursor_progress = cursor_progress + 1
            t_table:advance()
        else
            break
        end
    end

    if cursor_progress == #nil_str then
        return getType('nil', nil_str) -- curse you lua!! (although its my fault)
    end

    t_table:advance(-cursor_progress)
    return
end