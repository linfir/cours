yann = yann or {}
local Y = yann
local lpeg = require "lpeg"

local symbols_file = "symbols.txt"
local abbrev_file  = "abbreviations.txt"

function Y.strip(x)
    -- The outer parenthesis are necessary to return only one value
    return (x:gsub("^%s+", ""):gsub("%s+$", ""))
end

function Y.init_symbols()
    for line,i in io.lines(symbols_file) do
        line = line:gsub("#.*", "")
        if line == "" then goto continue end
        local x, y = line:match("^%s*(%S+)%s+(%S+)%s*$")
        if not x then
            tex.error("Error in " .. symbols_file)
        end
        tex.print("\\catcode`" .. x .. "=13")
        tex.print("\\def" .. x .. "{\\" .. y .. "}")
        ::continue::
    end
end

do
    local simple = 1 - lpeg.S"{},;!\\"
    local g_simple = 1 - lpeg.S"{}\\"
    local escape = lpeg.P"\\" * 1
    local semicolon = lpeg.P";" / "\\\\"
    local colon = lpeg.P"," / "&"
    local normal = lpeg.C(lpeg.P{ "N" ;
        N = lpeg.C( (simple + escape + lpeg.V"G")^1 ) / Y.strip,
        G = lpeg.P"{" * (g_simple + escape + lpeg.V"G")^0 * lpeg.P"}"
    }) / Y.strip
    local matrix = lpeg.Ct( (semicolon + colon + normal)^0 ) / table.concat
    local parser = matrix * lpeg.P(-1)

    function Y.matrix(src)
        local m = parser:match(src)
        if not m then tex.error("Syntax error in \\Matrix") end
        tex.print(m)
    end
end

Y.abbrev_table = {}
function Y.init_abbrev()
    for line in io.lines(abbrev_file) do
        line = Y.strip(line)
        if line ~= "" then
            local x, y = line:match("^(%a+)%s+(.*)$")
            assert(x)
            -- y = y:gsub("\\(%a+)", "£%1.")
            Y.abbrev_table[x] = y
            tex.print("\\newcommand{\\" .. x .."}{" .. y .. "}")
        end
    end
end

function Y.abbrev(x)
    local y = Y.abbrev_table[x]
    if y then
        tex.print(y)
    else
        tex.error("Abréviation £" .. x .. ". non définie")
    end
end
