local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local f = luasnip.function_node

-- Function to generate 32 random hex chars
local function generate_32_char_string()
    local template = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    return string.gsub(template, "x", function()
        return string.format("%x", math.random(0, 15))
    end)
end


luasnip.add_snippets("all", {
    s("rand32", {
        f(generate_32_char_string, {}),
    }),
    s({trig="helloworld", snippetType="snippet", desc="A hello world snippet",wordTrig=true},
        {t("Just a hint of what's to come!"),}
    ),
})
