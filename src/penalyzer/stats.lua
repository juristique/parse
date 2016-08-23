-- Small stats library                      --
----------------------------------------------
-- Version History --
-- 1.0 First written.
-- http://lua-users.org/wiki/SimpleStats
-- Tables supplied as arguments are not changed.

local function mean (t)
  local sum   = 0
  local count = 0
  for _, v in ipairs (t) do
    sum   = sum   + v
    count = count + 1
  end
  return sum / count
end

local function median (t)
  local temp = {}
  -- deep copy table so that when we sort it, the original is unchanged
  for i, v in pairs (t) do
    temp [i] = v
  end
  table.sort (temp)
  -- If we have an even number of table elements or odd.
  if math.fmod (#temp, 2) == 0 then
    -- return mean value of middle two elements
    return (temp [#temp/2] + temp [(#temp/2)+1]) / 2
  else
    -- return middle element
    return temp [math.ceil (#temp/2)]
  end
end

-- Get the standard deviation of a table
local function deviation (t)
  local result
  local sum   = 0
  local count = 0
  local m     = mean (t)
  for _, v in pairs (t) do
    local vm = v - m
    sum      = sum + (vm * vm)
    count    = count + 1
  end
  result = math.sqrt (sum / (count-1))
  return result
end

local function maximum (t)
  local max = -math.huge
  for _, v in pairs (t) do
    max = math.max (max, v)
  end
  return max
end

local function minimum (t)
  local min = math.huge
  for _, v in pairs (t) do
    min = math.min (min, v)
  end
  return min
end

return function (t)
  return {
    mean      = mean (t),
    maximum   = maximum (t),
    minimum   = minimum (t),
    median    = median (t),
    deviation = deviation (t),
  }
end
