package = "juristique-penalyzer-env"
version = "master-1"
source  = {
  url    = "git+https://github.com/juristique/penalyzer.git",
  branch = "master",
}

description = {
  summary    = "Juristique: code penalyzer (development environment)",
  detailed   = [[]],
  homepage   = "https://github.com/juristique/penalyzer",
  license    = "MIT/X11",
  maintainer = "Alban Linard <alban@linard.fr>",
}

dependencies = {
  "lua >= 5.1",
  "busted",
  "cluacov",
  "luacheck",
  "luacov",
  "luacov-coveralls",
}

build = {
  type    = "builtin",
  modules = {},
}
