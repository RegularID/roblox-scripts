local Directory = "https://raw.githubusercontent.com/RegularID/roblox-scripts/main/Misc/Remote%20Spy/Syntax/"

local Modules = {}
local Directories = {
    styles = Directory .. "config/styles",
    tagtable = Directory .. "config/tagtable",
    comment = Directory .. "literals/comment",
    eof = Directory .. "literals/comment",
    eol = Directory .. "literals/comment",
    global = Directory .. "literals/comment",
    identifier = Directory .. "literals/comment",
    keyword = Directory .. "literals/comment",
    method = Directory .. "literals/comment",
    ["nil"] = Directory .. "literals/nil",
    number = Directory .. "literals/number",
    operator = Directory .. "literals/operator",
    property = Directory .. "literals/property",
    string = Directory .. "literals/string",
    symbol = Directory .. "literals/symbol",
    whitespace = Directory .. "literals/whitespace",
    highlight = Directory .. "methods/highlight",
    tokenizer = Directory .. "tokens/tokenizer",
    tokentable = Directory .. "tokens/tokentable",
    lexer = Directory .. "lexer"
}


local Initialized = false
local Count = 0
for k, Path in pairs(Directories) do
    task.spawn(function()
        Modules[k] = game:HttpGet(Path .. ".lua")
        Count += 1
        if Count == 20 then
            Initialized = true
        end
    end)
end

local wait = task.wait
while not Initialized do wait() end

_G.require = function(Path)
    if Modules[Path] then
        return loadstring(Path)()
    else
        warn("missing module", Path)
    end
end

return setmetatable({ 
    __highlight = _G.require('methods/highlight'),
    highlight = function(__self, ...)
        return __self.__highlight(__self, ...)
    end
}, {
    __index = { },
    __newindex = function (_, _, _) end,
    __metatable = false
})
