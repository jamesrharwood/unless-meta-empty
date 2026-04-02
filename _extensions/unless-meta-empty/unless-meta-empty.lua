local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function meta_lookup(meta, path)
  local value = meta
  for key in string.gmatch(path, "[^.]+") do
    if value == nil then
      return nil
    end
    value = value[key]
  end
  return value
end

local function meta_has_value(meta, path)
  local value = meta_lookup(meta, path)

  if value == nil then
    return false
  end

  local text = pandoc.utils.stringify(value)
  if text == nil then
    return false
  end

  return trim(text) ~= ""
end

function Div(el)
  if not el.classes:includes("if-meta") then
    return nil
  end

  local key = el.attributes["key"]
  if key == nil or trim(key) == "" then
    return pandoc.Null()
  end

  if meta_has_value(quarto.doc.metadata, key) then
    -- Remove the control class/attribute before output
    el.classes = el.classes:filter(function(c) return c ~= "if-meta" end)
    el.attributes["key"] = nil
    return el
  else
    return pandoc.Null()
  end
end