local Lustache = require "lustache"

return function (parser)

  parser:command "dependencies" {
    description = "compute dependencies between articles",
  }

  return function (data, result, options)
    if options.dependencies then
      local dependencies = {}
      for id, article in pairs (data.articles) do
        dependencies [id] = dependencies [id] or {}
        for ref in article.markdown:gmatch "(%d%d%d%-%d%d?)" do
          if ref ~= id then
            dependencies [id] [ref] = true
          end
        end
      end
      local dot  = os.tmpname ()
      local file = io.open (dot, "w")
      file:write [[digraph G { ]]
      for source, t in pairs (dependencies) do
        for target in pairs (t) do
          file:write (Lustache:render ([[  "{{{source}}}" -> "{{{target}}}"; ]], {
            source = source,
            target = target,
          }))
        end
      end
      file:write [[}]]
      file:close ()
      local png  = os.tmpname ()
      os.execute (Lustache:render ([[ dot -Tpng "{{{dot}}}" -o "{{{png}}}" ]], {
        dot = dot,
        png = png,
      }))
      os.remove (dot)
      -- maximum number of references in an article:
      local max = -math.huge
      for _, t in pairs (dependencies) do
        local n = 0
        for _ in pairs (t) do
          n = n + 1
        end
        max = math.max (max, n)
      end
      -- average
      local count = 0
      local total = 0
      for id in pairs (data.articles) do
        local n = 0
        for _ in pairs (dependencies [id]) do
          n = n + 1
        end
        count = count + n
        total = total + 1
      end
      local average = count / total
      -- maximum reference depth:
      local depths = {}
      local cycles = {}
      local function depth (id, seen)
        seen = seen or {}
        if depths [id] then
          return depths [id]
        else
          for _, x in ipairs (seen) do
            if id == x then
              local cycle = {}
              for i, y in ipairs (seen) do
                cycle [i] = y
              end
              cycles [#cycles+1] = cycle
              return 0
            end
          end
        end
        local r = 0
        if dependencies [id] then
          seen [#seen+1] = id
          for target in pairs (dependencies [id]) do
            r = math.max (r, depth (target, seen) + 1)
          end
          seen [#seen] = nil
        end
        depths [id] = r
        return r
      end
      local depth_acyclic = 0
      for id in pairs (data.articles) do
        depth_acyclic = math.max (depth (id), depth_acyclic)
      end
      result.dependencies = {
        max     = max,
        average = average,
        png     = png,
        depth   = depth_acyclic,
        cycles  = cycles,
        depths  = options.detailed and depths,
        details = options.detailed and dependencies,
      }
    end
  end

end
