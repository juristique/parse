local Stats = require "penalyzer.stats"

return function (parser)

  local command = parser:command "sentences" {
    description = "compute sentences complexity",
  }
  command:option "--sentence-length" {
    description = "maximal sentence length for readability",
    default     = 30,
    convert     = tonumber,
  }

  return function (data, result, options)
    if options.sentences then
      local sentences = {}
      for id, article in pairs (data.articles) do
        local count    = 0
        local sentence = nil
        local text     = article.markdown
        text = text:sub (text:find ("----", 1, true) + 4)
        for word in text:gmatch "[%S]+" do
          if (word:match "%.$" or word:match "%;$" or word:match "%:$")
          and not word:match "[A-Z]%."
          and not word:match "Art%."
          and not word:match "%d+%-%d+%."
          and not word:match "bis%." then
            sentence = sentence
                   and sentence .. " " .. word
                    or word
            if count > 0 then
              sentences [sentence] = sentences [sentence] or {
                count      = count + 1,
                articles   = {},
              }
              sentences [sentence].articles [id] = true
            end
            count  = 0
            sentence = nil
          else
            sentence = sentence
                   and sentence .. " " .. word
                    or word
            count = count + 1
          end
        end
      end
      -- number of sentences for each word count:
      local per_count = {}
      for _, t in pairs (sentences) do
        per_count [t.count] = (per_count [t.count] or 0) + 1
      end
      -- number of sentences above threshold:
      local above     = 0
      local above_all = 0
      for _, t in pairs (sentences) do
        local n = 0
        for _ in pairs (t.articles) do
          n = n + 1
        end
        if t.count >= options.sentence_length then
          above     = above     + 1
          above_all = above_all + n
        end
      end
      -- compute statistics:
      local t = {}
      for _, s in pairs (sentences) do
        for _ in pairs (s.articles) do
          t [#t+1] = s.count
        end
      end
      local stats = Stats (t)
      result.sentences = {
        mean      = stats.mean,
        median    = stats.median,
        deviation = stats.deviation,
        maximum   = stats.maximum,
        minimum   = stats.minimum,
        above     = above,
        above_all = above_all,
        per_count = options.detailed and per_count,
        details   = options.detailed and sentences,
      }
    end
  end

end
