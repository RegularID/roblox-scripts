--[[ Color: '#3A00FF', Bold: true, Font: 'code', Types: {
    This is just an example type, demonstrating how to edit
    the styles of different types.
} ]]--
local example = {
    color = '#3A00FF',
    bold = true,
    font = 'code'
}

--[[ Color: '#ffffff', Types: Symbols, Operators, Unknowns ]]--
local operator = { color = '#ffffff' }
local symbol = { color = '#ffffff' }
local unknown = { color = '#ff0000', underline = true }

--[[ Color: '#f86d7c', Types: Keywords ]]--
local keyword = { color = '#f86d7c' }

--[[ Color: '#666666', Types: Comments ]]--
local comment = { color = '#666666' }

--[[ Color: '#adf195', Types: Strings ]]--
local string = { color = '#adf195' }

--[[ Color: '#84d6f7', Types: Globals ]]--
local global = { color = '#84d6f7' }

--[[ Color: '#ffc600', Types: Numbers ]]--
local number = { color = '#ffc600' }

--[[ Color: '#cccccc', Types: Identifiers ]]--
local identifier = { color = '#cccccc' }

--[[ Color: '#ffc600', Types: null, Booleans ]]--
local null = { color = '#ffc600', bold = true } -- damnit!
local boolean = { color = '#ffc600', bold = true } -- damnit!

--[[ Color: '#61a1f1', Types: Subproperty ]]--
local property = { color = '#61a1f1' }

--[[ Color: '#fdfbac', Types: Method ]]--
local method = { color = '#fdfbac' }

--[[ NO_ATTRIBUTES, Types: EOF's, EOL's, Whitespaces ]]--
local eof = { }
local eol = { }
local whitespace = { }

local DEFAULT = {
    color = '#ffffff',
    bold = false,
    italic = false,
    underline = false,
    strikethrough = false,
    smallcaps = false
}

return setmetatable({ 
    __font = { 'color', 'size', 'face' },
    default = DEFAULT
}, {
    __index = {
        comment = comment,
        eof = eof,
        eol = eol,
        global = global,
        keyword = keyword,
        number = number,
        operator = operator,
        boolean = boolean,
        string = string,
        method = method,
        symbol = symbol,
        property = property,
        identifier = identifier,
        whitespace = whitespace,
        unknown = unknown,
        ['nil'] = null -- damnit again
    },
    __newindex = function () end,
    __metatable = false
})