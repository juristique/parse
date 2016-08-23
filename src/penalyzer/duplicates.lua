return function (parser)

  parser:command "duplicates" {
    description = "compute copy/pasted lines",
  }

  return function (data, result, options)
    if options.duplicates then
      local lines = {}
      for _, article in pairs (data.articles) do
        for line in article.markdown:gmatch "[^\r\n]+" do
          if not line:match "^----$" then
            lines [line] = lines [line] or {}
            lines [line] [article] = true
          end
        end
      end
      local copied  = 0
      local total   = 0
      local max     = -math.huge
      for _, t in pairs (lines) do
        local n = 0
        for _ in pairs (t) do
          n = n + 1
        end
        total = total + n
        max   = math.max (max, n)
        if n >= 2 then
          copied = copied + n - 1
        end
      end
      result.duplicates = {
        total   = total,
        copied  = copied,
        ratio   = copied / total,
        max     = max,
        details = options.detailed and lines,
      }
    end
  end

end
