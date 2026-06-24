local luasnip = require("luasnip")
local s = luasnip.snippet
local f = luasnip.function_node

local function generate_32_char_string()
	local template = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	return string.gsub(template, "x", function()
		return string.format("%x", math.random(0, 15))
	end)
end

local function generate_64_char_string()
	local template = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	return string.gsub(template, "x", function()
		return string.format("%x", math.random(0, 15))
	end)
end

luasnip.add_snippets("all", {
	s("rand32", {
		f(generate_32_char_string, {}),
	}),
	s("rand64", {
		f(generate_64_char_string, {}),
	}),
})
