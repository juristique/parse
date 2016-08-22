return function (data)
  local lines = {}
  for _, livre in pairs (data) do
    if type (livre) == "table" then
      for _, titre in pairs (livre) do
        if type (titre) == "table" then
          for _, article in pairs (titre) do
            if type (article) == "table" then
              for line in article.markdown:gmatch "[^\r\n]+" do
                if not line:match "^----$" then
                  lines [line] = (lines [line] or 0) + 1
                end
              end
            end
          end
        end
      end
    end
  end
  local copied = 0
  local total  = 0
  local max    = 0
  for _, n in pairs (lines) do
    total = total + n
    max   = math.max (max, n)
    if n >= 2 then
      copied = copied + n - 1
    end
  end
  return {
    total  = total,
    copied = copied,
    ratio  = copied / total,
    max    = max,
  }, lines
end
