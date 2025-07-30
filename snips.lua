-- run the command `:%lua` to load snippets

---@diagnostic disable: unused-local
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local extras = require 'luasnip.extras'
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local u = require 'handdara.util'

local S = {}
local function use(snip)
    table.insert(S, snip)
end

use(s({ trig = 'example', snippetType = 'autosnippet', wordTrig = false },
    c(1, { t "this will auto complete", t 'example' })))

ls.add_snippets("all", S, { key = "session" })
