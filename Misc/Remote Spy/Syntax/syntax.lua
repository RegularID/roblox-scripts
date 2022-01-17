local Directory = "https://raw.githubusercontent.com/RegularID/roblox-scripts/main/Misc/Remote%20Spy/Syntax/"

local Modules = {}
local Directories = {
    ["config/styles"] = Directory .. "config/styles",
    ["config/tagtable"] = Directory .. "config/tagtable",
    ["literals/comment"] = Directory .. "literals/comment",
    ["literals/eof"] = Directory .. "literals/eof",
    ["literals/eol"] = Directory .. "literals/eol",
    ["literals/global"] = Directory .. "literals/global",
    ["literals/identifier"] = Directory .. "literals/identifier",
    ["literals/keyword"] = Directory .. "literals/keyword",
    ["literals/method"] = Directory .. "literals/method",
    ["literals/nil"] = Directory .. "literals/nil",
    ["literals/number"] = Directory .. "literals/number",
    ["literals/operator"] = Directory .. "literals/operator",
    ["literals/property"] = Directory .. "literals/property",
    ["literals/string"] = Directory .. "literals/string",
    ["literals/symbol"] = Directory .. "literals/symbol",
    ["literals/whitespace"] = Directory .. "literals/whitespace",
    ["methods/highlight"] = Directory .. "methods/highlight",
    ["tokens/tokenizer"] = Directory .. "tokens/tokenizer",
    ["tokens/tokentable"] = Directory .. "tokens/tokentable",
    ["lexer"] = Directory .. "lexer"
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
    local Module = Modules[Path]
    if Module then
        return loadstring(Module)()
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
