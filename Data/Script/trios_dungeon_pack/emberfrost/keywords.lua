local keywords = {}

-- Display metadata only. Effects must explicitly implement their own behavior.
keywords.definitions = {
  BAG_SIZE = {
    id = "BAG_SIZE",
    title = "Bag size",
    explanation = "Maximum number of items the bag can hold.",
    color = "Cyan",
  },
  ACTIVE_PARTY = {
    id = "ACTIVE_PARTY",
    title = "Active party",
    explanation = "Your exploring team; excludes members in assembly.",
    color = "Yellow",
  },
}

function keywords.GetDescription(definition)
  local lines = { definition:get_description() }
  local seen = {}
  for _, id in ipairs(definition.keywords or {}) do
    local keyword = assert(keywords.definitions[id], "Unknown enchantment keyword: " .. tostring(id))
    if not seen[id] then
      lines[#lines + 1] = M_HELPERS.MakeColoredText(keyword.title, PMDColor[keyword.color]) ..
          ": " .. keyword.explanation
      seen[id] = true
    end
  end
  return table.concat(lines, "\n")
end

return keywords
