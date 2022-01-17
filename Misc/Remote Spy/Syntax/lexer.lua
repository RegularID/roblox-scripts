local tt_gen = _G.require("tokens/tokentable")
local tokenizer = _G.require("tokens/tokenizer")

local function lex_str(string)
    local token_table = tt_gen(string)
    token_table:advance()

    while not token_table.complete do
        tokenizer:tokenize(token_table)
    end

    return token_table
end

return lex_str