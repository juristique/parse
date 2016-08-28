return function (parser)

  parser:command "identifiers" {
    description = "compute bis/ter/... identifiers",
  }

  return function (data, result, options)
    if options.identifiers then
      local ids   = {}
      local count = 0
      local total = 0
      for article_id in pairs (data.articles) do
        total = total + 1
        if  not article_id:match "^%d+-%d+$"
        and not article_id:match "^%d+$" then
          count = count + 1
          ids [article_id] = true
        end
      end
      result.duplicates = {
        count   = count,
        total   = total,
        ratio   = count / total,
        details = options.detailed and ids,
      }
    end
  end

end
