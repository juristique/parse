return function (data, n)
  n = n or 10
  local result = {}
  for _, livre in pairs (data) do
    if type (livre) == "table" then
      for _, titre in pairs (livre) do
        if type (titre) == "table" then
          for _, article in pairs (titre) do
            if type (article) == "table" then
              local current  = 0
              local total    = {}
              local sentence = nil
              for word in article.markdown:gmatch "[%S]+" do
                if word:match "%.$" or word:match "%;$" or word:match "%:$" then
                  sentence = sentence
                         and sentence .. " " .. word
                          or word
                  total [sentence] = current
                  current = 0
                else
                  sentence = sentence
                         and sentence .. " " .. word
                          or word
                  current  = current + 1
                end
              end
              result [article] = total
            end
          end
        end
      end
    end
  end
  local sentences = {}
  local articles  = {}
  for article, t in pairs (result) do
    for sentence, m in pairs (t) do
      if m >= n then
        articles  [article ] = true
        sentences [sentence] = m
      end
    end
  end
  local count = 0
  for _ in pairs (articles) do
    count = count + 1
  end
  local max = 0
  local sentence
  for s, m in pairs (sentences) do
    max = math.max (m, max)
    if max == m then
      sentence = s
    end
  end
  return {
    count = count,
    max   = {
      size     = max,
      sentence = sentence,
    },
  }
end
