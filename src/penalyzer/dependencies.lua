local Lustache = require "lustache"
local Stats    = require "penalyzer.stats"

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
      -- maximum reference depth:
      local depths = {}
      local cycles = {}
      local function acyclic_depth (id, seen)
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
            r = math.max (r, acyclic_depth (target, seen) + 1)
          end
          seen [#seen] = nil
        end
        depths [id] = r
        return r
      end
      local depth_acyclic = 0
      for id in pairs (data.articles) do
        depth_acyclic = math.max (acyclic_depth (id), depth_acyclic)
      end
      -- compute statistics for breadth:
      local breadth = {}
      for _, d in pairs (dependencies) do
        local n = 0
        for _ in pairs (d) do
          n = n + 1
        end
        breadth [#breadth+1] = n
      end
      local depth = {}
      for _, d in pairs (depths) do
        depth [#depth+1] = d
      end
      result.dependencies = {
        breadth = Stats (breadth),
        depth   = Stats (depth),
        png     = png,
        cycles  = cycles,
        depths  = options.detailed and depths,
        details = options.detailed and dependencies,
      }
    end
  end

end
