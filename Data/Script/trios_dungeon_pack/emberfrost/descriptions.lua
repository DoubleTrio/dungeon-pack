local descriptions = {}

function descriptions.Number(value, color)
  assert(type(value) == "number", "Description value must be a number")
  return M_HELPERS.MakeColoredText(tostring(value), color or PMDColor.Cyan)
end

function descriptions.Format(definition)
  if definition.description == nil then return "" end

  local values = {}
  return (definition.description:gsub("{([^{}]+)}", function(token)
    local name, singular, plural = token:match("^([%w_]+):plural:([^:]+):([^:]+)$")
    name = name or token
    local variable = (definition.description_vars or {})[name]
    local label = "Description " .. tostring(definition.id or "<unnamed>") .. ": " .. name
    assert(variable and (type(variable.field) == "string" or type(variable.get) == "function" or variable.value ~= nil),
      label .. " has no field binding")
    local format = variable.format or "number"
    assert(format == "number" or format == "percent" or format == "money" or format == "text",
      label .. " has an unsupported format")
    local value = values[name]
    if value == nil then
      if variable.field then
        value = definition[variable.field]
      elseif variable.get then
        value = variable.get(definition)
      else
        value = variable.value
      end
      values[name] = value
    end
    if format == "text" then
      assert(type(value) == "string", label .. " must resolve to text")
    else
      assert(type(value) == "number", label .. " must reference a numeric field")
    end

    if singular then
      assert(type(value) == "number", label .. " needs a numeric plural count")
      return value == 1 and singular or plural
    end
    local color = variable.color and assert(PMDColor[variable.color], label .. " has an unknown color")
    if format == "text" then
      return color and M_HELPERS.MakeColoredText(value, color) or value
    elseif format == "number" then
      return descriptions.Number(value, color)
    end
    local suffix = format == "percent" and "%" or ((variable.space == false and "" or " ") .. PMDSpecialCharacters.Money)
    return M_HELPERS.MakeColoredText(tostring(value) .. suffix, color or PMDColor.Cyan)
  end))
end

return descriptions
