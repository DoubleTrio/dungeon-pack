require 'origin.common'

function COMMON.NumToGender(num)
    local res = Gender.Unknown
    if num == 0 then
        res = Gender.Genderless
    elseif num == 1 then
        res = Gender.Male
    elseif num == 2 then
        res = Gender.Female
    end
    return res
end

function COMMON.GenderToNum(gender)
    local res = -1
    if gender == Gender.Genderless then
        res = 0
    elseif gender == Gender.Male then
        res = 1
    elseif gender == Gender.Female then
        res = 2
    end
    return res
end
