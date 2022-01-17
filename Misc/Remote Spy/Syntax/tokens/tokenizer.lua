local tokenizer = {
    __fileloc = 'literals/',
    __types = {
        'number',
        'string',
        'symbol',
        'comment',
        'operator',
        'property',
        'whitespace',
        'nil',
        'keyword',
        'global',
        'method',
        'identifier',
        'eol',
        'eof',
    }
    --[[
        Order of type checking; based on mean occurance of each type and
        which type should be parsed first to avoid mistakes.
        This list excludes unknown; that type is examined after 
        all other type checks fail.
    ]]--
}
function tokenizer:tokenize(t_table)
    local token_result = nil

    for _, type in pairs(self.__types) do
        token_result = self[type](t_table, function (t, v)
            return { type = t, value = v }
        end)
        if token_result then
            t_table:unknowns() -- Flush unknown characters
            break
        end
    end

    if not token_result then -- Unknown characters are stored in a seperate buffer and cleared later
        t_table.unknown_buffer = t_table.unknown_buffer .. t_table.char
        t_table:advance()
        return
    end

    table.insert(t_table.lex_tree, token_result)

    if token_result.type == "eof" then
        t_table:eof()
    end

    return true
end

return setmetatable(tokenizer, {
    __call = function(__self, files)
        for _, file in pairs(files) do
            __self[file] = _G.require(__self.__fileloc .. file)
        end
        return __self
    end
})(tokenizer.__types)