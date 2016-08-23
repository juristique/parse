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
  "lustache",
  "lyaml",
  "serpent",
  -- "xml",
}

build = {
  type    = "builtin",
  modules = {
    ["penalyzer.parse"       ] = "src/penalyzer/parse.lua",
    ["penalyzer.dependencies"] = "src/penalyzer/dependencies.lua",
    ["penalyzer.duplicates"  ] = "src/penalyzer/duplicates.lua",
    ["penalyzer.sentences"   ] = "src/penalyzer/sentences.lua",
  },
  install = {
    bin = {
      ["penalyzer"] = "src/penalyzer/bin.lua",
    },
  },
}
