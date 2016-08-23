#! /usr/bin/env lua

local Arguments  = require "argparse"
local Parse      = require "penalyzer.parse"

local parser = Arguments () {
  name        = "penalyzer",
  description = "",
}
parser:mutex (
  parser:flag "--lua",
  parser:flag "--yaml",
  parser:flag "--json"
)
parser:flag "--detailed"

local commands = {
  require "penalyzer.dependencies" (parser),
  require "penalyzer.duplicates"   (parser),
  require "penalyzer.sentences"    (parser),
}

parser:argument "source" {
  description = "directory containing files to parse",
}

local arguments  = parser:parse ()
if not arguments.lua and not arguments.yaml and not arguments.json then
  arguments.yaml = true
end

local dump
if arguments.lua then
  local Serpent = require "serpent"
  dump = Serpent.dump
elseif arguments.json then
  local Json = require "cjson"
  dump = Json.encode
elseif arguments.yaml then
  local Yaml = require "lyaml"
  dump = function (t)
    return Yaml.dump { t }
  end
end

local data   = Parse (arguments)
local result = {}
for _, f in ipairs (commands) do
  f (data, result, arguments)
end

print (dump (result))
