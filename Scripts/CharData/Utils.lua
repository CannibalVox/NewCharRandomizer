local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");

Mod.CharData = Mod.CharData or {}
Mod.CharData.Utils = Mod.CharData.Utils or {}
local Utils = Mod.CharData.Utils

local skillCount = 0
local skillMap = {}

while true do
    local skill = CS.XiaWorld.g_emNpcSkillType.__CastFrom(skillCount+1)
    if skill and skill ~= CS.XiaWorld.g_emNpcSkillType._Count then 
        skillCount = skillCount + 1
        skillMap[skill] = skillCount
    else 
        break
    end 
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end

function Utils:BaseFiveFromString(baseFiveStr)
    local baseFive = baseFiveStr:split(",")
    local baseFiveVals = {}
    for i=1,5 do 
        baseFiveVals[i] = tonumber(baseFive[i]) or 0
    end

    return baseFiveVals
end 

function Utils:SkillsFromModDef(skills)
    local skillValues = {}

    for i=1,skillCount do 
        skillValues[i] = {
            Name = skillMap[i],
            Level = 0,
            LevelOver = 0,
        }
    end

    for i=1,skills.Count do 
        local skill = skills[i-1]
        local skillIndex = skillMap[skill.Name]
        local skillData = skillValues[skillIndex]

        skillData.Level = skillData.Level + skill.Level 
        skillData.LevelOver = skillData.LevelOver + skill.LevelOver
    end

    return skillValues
end
