local Lfs = require "lfs"
-- local Lustache = require "lustache"
-- local Xml      = require "xml"

return function (configuration)
  assert (configuration.source)
  local data = {
    livres   = {},
    articles = {},
  }
  for livre_dir in Lfs.dir (configuration.source) do
    local livre_path = configuration.source .. "/" .. livre_dir
    if  livre_dir:sub (1, 1) ~= "."
    and Lfs.attributes (livre_path, "mode") == "directory" then
      local livre_id = livre_dir:match "Livre (.*)"
      if not livre_id then
        print ("Error:", livre_dir)
        livre_id = livre_dir
      end
      data.livres [livre_id] = data.livres [livre_id] or {
        id        = livre_id,
        type      = "livre",
        titres    = {},
        chapitres = {},
      }
      local livre = data.livres [livre_id]
      for titre_dir in Lfs.dir (livre_path) do
        local titre_path = livre_path .. "/" .. titre_dir
        if titre_dir:sub (1, 1) ~= "."
        and Lfs.attributes (titre_path, "mode") == "directory" then
          local titre_id    = titre_dir:match "Titre (.*)"
          local chapitre_id = titre_dir:match "Chapitre (.*)"
          local titre
          if titre_id then
            livre.titres [titre_id] = livre.titres [titre_id] or {
              id       = titre_id,
              type     = "titre",
              articles = {},
            }
            titre = livre.titres [titre_id]
          elseif chapitre_id then
            livre.chapitres [chapitre_id] = livre.chapitres [chapitre_id] or {
              id       = chapitre_id,
              type     = "chapitre",
              articles = {},
            }
            titre = livre.chapitres [chapitre_id]
          else
            print ("Error:", titre_path)
          end
          for article_file in Lfs.dir (titre_path) do
            local article_path = titre_path .. "/" .. article_file
            if  article_file:sub (1, 1) ~= "."
            and Lfs.attributes (article_path, "mode") == "file" then
              local article_id = article_file:match "Article (.*)%.md"
              local file       = io.open (article_path, "r")
              local article = {
                id       = article_id,
                type     = "article",
                markdown = file:read "*all",
              }
              file:close ()
              if titre then
                titre.articles [article_id] = article
              end
              data.articles [article_id] = article
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
