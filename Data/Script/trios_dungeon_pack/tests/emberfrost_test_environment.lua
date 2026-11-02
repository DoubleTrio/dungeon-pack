-- Minimal engine stand-ins for description and registration tests; no gameplay simulation.
local function loadEnvironment(root)
  local proxy
  proxy=setmetatable({}, {__index=function() return proxy end,__call=function() return proxy end})
  local function named(id)
    return {GetColoredName=function() return '<name:'..tostring(id)..'>' end,
      GetIconName=function() return '<icon:'..tostring(id)..'>' end}
  end
  local env=setmetatable({
    print=function() end, luanet=proxy,RogueEssence=proxy,RogueElements=proxy,PMDC=proxy,LUA_ENGINE=proxy,
    PMDColor=setmetatable({},{__index=function(_,key) return key end}), PMDSpecialCharacters={Money='$'},
    M_HELPERS={MakeColoredText=function(t,c)return '[color='..c..']'..t..'[color]' end,
      GetItemName=function(id,amount)return '<item:'..id..(amount and ':'..amount or '')..'>' end,
      FormatPercent=function(n,c)return '[color='..(c or 'Cyan')..']'..string.format('%d%%',n)..'[color]' end},
    _DATA={GetZone=function(_,id)return named(id) end,GetElement=function(_,id)return named(id) end,
      GetStatus=function(_,id)return named(id) end,
      GetMonster=function(_,id)return {Forms={[0]={FormName={ToLocal=function()return '<monster:'..tostring(id)..'>' end}}}} end,
      DataIndices=setmetatable({},{__index=function()return {Get=function(_,id)return named(id)end}end})},
    AchievementStatus={Hidden=0,Visible=1,Achieved=2},EnchantmentStatus={NotSeen=0,Seen=1,Selected=2,SelectedAndWon=3},
    SV={EmberFrost={Quests={Data={}},Enchantments={Data={}}}},
  },{__index=_G})
  local loaded={}
  env.require=function(name)
    if loaded[name] then return loaded[name] end
    local path=name:match('^trios_dungeon_pack%.emberfrost%.(.+)$')
    if not path then return true end
    loaded[name]=assert(loadfile(root..'/'..path:gsub('%.','/')..'.lua','t',env))() or true
    return loaded[name]
  end
  for _,name in ipairs({'enchantments.enchants','enchantments.type_enchantments','enchantments.character_enchantments','achievements'}) do env.require('trios_dungeon_pack.emberfrost.'..name) end
  return env
end

return loadEnvironment
