-- AI upgrades taken from MistressNebula. Thank you so much for them for allowing me to borrow their code!
HARD_MODE = {}

HARD_MODE.AIUpgrade = {
    item_finder = "item_finder_smart",        -- smart action pick, keeps distance
    loot_guard = "loot_guard_smart",          -- smart action pick
    patrol = "patrol_smart",                  -- smart action pick, wont disturb
    retreater_itemless = "retreater",         -- vanilla
    retreater = "retreater_smart",            -- smart action pick, keeps distance
    thief = "thief_smart",                    -- smart action pick while keeping distance
    tit_for_tat = "tit_for_tat_smart",      -- smart action, can grab items after aggro
    turret = "turret_smart",                  -- smart action pick, wont disturb
    wander_dumb_itemless = "wander_dumb",     -- vanilla
    wander_dumb = "wander_normal",            -- vanilla
    wander_normal_itemless = "wander_normal", -- vanilla
    wander_normal = "wander_smart",           -- vanilla
    wander_smart = "wander_boss",             -- wander Smart but it avoids traps and allies and knows matchups
    weird_tree = "weird_tree_smart"           -- smart action pick when approached
}

function HARD_MODE.upgradeAI(chara)
  local tactic_id = HARD_MODE.AIUpgrade[chara.Tactic.ID]
  if tactic_id then
    chara.Tactic = RogueEssence.Data.AITactic(_DATA:GetAITactic(tactic_id))
    chara.Tactic:Initialize(chara)
  end
end

local function chooseStat(stats)
  local total = 0
  for _, stat in ipairs(stats) do total = total + stat.weight end
  if total <= 0 then return stats[1], 1 end
  local roll = _DATA.Save.Rand:Next(total)
  for i, stat in ipairs(stats) do
    roll = roll - stat.weight
    if roll < 0 then return stat, i end
  end
end

HARD_MODE.boostStats = function(chara)
    local boostn = chara.Level/10
    local boostchance = boostn%1
    if boostchance*10 > (_DATA.Save.Rand:Next(10)+1) then
        boostn = math.ceil(boostn)
    end
    local stats = {
        {stat = "atk", weight = chara.Atk},
        {stat = "def", weight = chara.Def},
        {stat = "mat", weight = chara.MAtk},
        {stat = "mdf", weight = chara.MDef},
        {stat = "spd", weight = chara.Speed}
    }
    local boosts = {}
    while boostn>=1 do
        local boost, i = chooseStat(stats)
        ---@cast boost -?
        boosts[boost.stat] = boosts[boost.stat] or 0
        boosts[boost.stat] = boosts[boost.stat] + 1
        stats[i].weight = math.floor(stats[i].weight*0.9)
        boostn=boostn-1
    end
    for stat, num in pairs(boosts) do
        if stat=="atk" then
            chara.ProxyAtk = chara.Atk + math.max(1, math.floor(chara.Atk*num/10))
        elseif stat=="def" then
            chara.ProxyDef = chara.Def + math.max(1, math.floor(chara.Def*num/10))
        elseif stat=="mat" then
            chara.ProxyMAtk = chara.MAtk + math.max(1, math.floor(chara.MAtk*num/10))
        elseif stat=="mdf" then
            chara.ProxyMDef = chara.MDef + math.max(1, math.floor(chara.MDef*num/10))
        elseif stat=="spd" then
            chara.ProxySpeed = chara.Speed + math.max(1, math.floor(chara.Speed*num/10))
        end
    end
end

return HARD_MODE
