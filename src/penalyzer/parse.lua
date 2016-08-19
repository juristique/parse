local Lfs      = require "lfs"
-- local Lustache = require "lustache"
-- local Xml      = require "xml"

local function romantonumber (s)
  if     s == "Ier"    then return 1
  elseif s == "II"     then return 2
  elseif s == "III"    then return 3
  elseif s == "IV"     then return 4
  elseif s == "IV bis" then return 4.5
  elseif s == "V"      then return 5
  elseif s == "VI"     then return 6
  elseif s == "VII"    then return 7
  elseif s == "VIII"   then return 8
  elseif s == "IX"     then return 9
  elseif s == "X"      then return 10
  else assert (false, s)
  end
end

return function (configuration)
  assert (configuration.source)
  local data = {}
  for livre in Lfs.dir (configuration.source) do
    local livre_path = configuration.source .. "/" .. livre
    if  livre:sub (1, 1) ~= "."
    and Lfs.attributes (livre_path, "mode") == "directory" then
      for titre in Lfs.dir (livre_path) do
        local titre_path = livre_path .. "/" .. titre
        if titre:sub (1, 1) ~= "."
        and Lfs.attributes (titre_path, "mode") == "directory" then
          for article in Lfs.dir (titre_path) do
            local article_path = titre_path .. "/" .. article
            if  article:sub (1, 1) ~= "."
            and Lfs.attributes (article_path, "mode") == "file" then
              local nlivre       = romantonumber (livre:match "Livre (.*)"   )
              local ntitre       = romantonumber (titre:match "Titre (.*)" or titre:match "Chapitre (.*)")
              local narticle     = article:match "Article (.*)%.md"
              local article_file = io.open (article_path, "r")
              data [nlivre]     = data [nlivre]   or {}
              data [nlivre].raw = data [nlivre].raw or livre
              data [nlivre][ntitre]     = data [nlivre][ntitre]     or {}
              data [nlivre][ntitre].raw = data [nlivre][ntitre].raw or titre -- FIXME: not working with "Livre IVbis"
              data [nlivre][ntitre][narticle] = {}
              data [nlivre][ntitre][narticle].markdown = article_file:read "*all"
              article_file:close ()
              -- local output = os.tmpname () .. ".html"
              -- assert (os.execute (Lustache:render ([[ pandoc "{{{input}}}" -o "{{{output}}}" ]], {
              --   input  = article_path,
              --   output = output,
              -- })))
              -- local html_file = io.open (output, "r")
              -- local html      = html_file:read "*all"
              -- html = Lustache:render ([[<article>{{{contents}}}</article>]], {
              --   contents = html,
              -- })
              -- html_file:close ()
              -- os.remove (output)
              -- data [nlivre][ntitre][narticle].html = Xml.load (html)
            end
          end
        end
      end
    end
  end
  return data
end
