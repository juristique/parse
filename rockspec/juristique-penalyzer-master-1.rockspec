package = "juristique-penalyzer"
version = "master-1"
source  = {
  url    = "git+https://github.com/juristique/penalyzer.git",
  branch = "master",
}

description = {
  summary    = "Juristique: code penalyzer",
  detailed   = [[]],
  homepage   = "https://github.com/juristique/penalyzer",
  license    = "MIT/X11",
  maintainer = "Alban Linard <alban@linard.fr>",
}

dependencies = {
  "lua >= 5.1",
  "argparse",
  "lua-cjson",
  "luafilesystem",
  "lyaml",
  "serpent",
  -- "lustache",
  -- "xml",
}

build = {
  type    = "builtin",
  modules = {
    ["penalyzer.parse"     ] = "src/penalyzer/parse.lua",
    ["penalyzer.duplicates"] = "src/penalyzer/duplicates.lua",
  },
  install = {
    bin = {
      ["penalyzer"] = "src/penalyzer/bin.lua",
    },
  },
}
