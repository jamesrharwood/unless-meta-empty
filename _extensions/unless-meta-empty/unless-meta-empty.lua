local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local cached_meta = {}

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

local function meta_has_value(path)
  local value = meta_lookup(cached_meta, path)

  if value == nil then
    return false
  end

  local text = pandoc.utils.stringify(value)
  if text == nil then
    return false
  end

  return trim(text) ~= ""
end

local function process_div(el)
  local has_control_attribute = el.attributes["unless-meta-empty"] ~= nil
  local has_control_class = el.classes:includes("unless-meta-empty")

  if not has_control_attribute and not has_control_class then
    return nil
  end

  local key = el.attributes["key"]
  if key == nil or trim(key) == "" then
    return pandoc.Null()
  end

  if meta_has_value(key) then
    -- Remove control attributes before emitting output.
    el.attributes["unless-meta-empty"] = nil
    el.classes = el.classes:filter(function(c) return c ~= "unless-meta-empty" end)
    el.attributes["key"] = nil
    return el
  else
    return pandoc.Null()
  end
end

function Pandoc(doc)
  cached_meta = doc.meta or {}
  return doc:walk({ Div = process_div })
end