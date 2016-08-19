#! /usr/bin/env lua

local Arguments = require "argparse"
local Parse     = require "penalyzer.parse"
local Lines     = require "penalyzer.lines"

local parser = Arguments () {
  name        = "penalyzer",
  description = "",
}
parser:mutex (
  parser:flag "--lua",
  parser:flag "--yaml",
  parser:flag "--json"
)
parser:argument "source" {
  description = "directory containing files to parse",
}

local arguments = parser:parse ()
local data      = Parse (arguments)
local lines     = Lines (data)

if arguments.lua then
  local Serpent = require "serpent"
  print (Serpent.dump (lines))
elseif arguments.json then
  local Json = require "cjson"
  print (Json.encode (lines))
elseif arguments.yaml then
  local Yaml = require "lyaml"
  print (Yaml.dump { lines })
end
