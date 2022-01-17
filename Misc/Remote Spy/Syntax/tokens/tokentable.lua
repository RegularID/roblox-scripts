return function(string)
    return setmetatable({
        cursor = 0, -- Cursor position relative to string
        column = 0, -- Cursor pos relative to line
        line = 1, -- Line at which cursor resides within string
        char = nil, -- Current character at cursor position
        string = string, -- String that is being parsed
        str_length = #string + 2, -- Length of the string with eof terminator at end (add to to reach nil)
        unknown_buffer = "", -- Undeterminable strings
        lex_tree = {}, -- Token tree
        complete = false, -- Completed status of parsed string
        result = nil, -- Result of parsed string
        --[[
            The 'advance' function moves the cursor forwards and
            updates the new character position. Avoids doing it manually
            in tokenizer.
        ]] --
        advance = function(__self, skip)
            __self.cursor = __self.cursor + (skip or 1)
            __self.column = __self.column + 1
            __self.char = __self.string:sub(__self.cursor, __self.cursor)
        end,
        unknowns = function(__self)
            local unknown_type = __self.unknown_buffer
            if unknown_type ~= "" then
                table.insert(__self.lex_tree, { type = 'unknown', value = unknown_type })
                __self.unknown_buffer = ""
            end
        end,
        checkback = function (__self, offset, checks, to_check)
            local token_elem = __self.lex_tree[#__self.lex_tree - offset]
            if offset == 0x0 and __self.unknown_buffer ~= '' then
                return false -- previous char is unknown
            end
            if token_elem then
                for _, value in pairs(checks) do
                    if token_elem[to_check] == value then
                        return true -- expected found!
                    end
                end
                return false -- expected type not found
            else
                return true -- start of file?
            end
        end,
        eof = function (__self)
            __self.result = __self.lex_tree
            __self.complete = true
        end,
        eol = function (__self)
            __self.column = 1
            __self.line = __self.line +  1
        end
    }, { __metatable = false }) -- Return table
end