local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");
Mod.Filter = Mod.Filter or {}
local Filter = Mod.Filter 

local debug = false 
local additionalCrowdDebug = false 

local function Debug(msg)
    if debug then 
        print(msg)
    end
end

function Filter:EnforceSingleValue(val, stat, npcIndex)
    if npcIndex == 1 and stat.MainMin then 
        if stat.MainMin > val then 
            Debug("val too low for main- wanted "..tostring(stat.MainMin).." got "..tostring(val))
            return false
        end
    elseif stat.Min then 
        if stat.Min > val then 
            Debug("val too low- wanted "..tostring(stat.Min).." got "..tostring(val))
            return false
        end
    end

    if npcIndex == 1 and stat.MainMax then 
        if stat.MainMax < val then 
            Debug("val too high for main- wanted "..tostring(stat.MainMax).." got "..tostring(val))
            return false 
        end
    elseif stat.Max then 
        if stat.Max < val then 
            Debug("val too high- wanted "..tostring(stat.Max).." got "..tostring(val))
            return false 
        end
    end

    return true 
end

function Filter:MergeTables(table1, table2) 
    local output = {}
    for key, value in pairs(table1) do 
        output[key] = value 
    end 

    for key, value in pairs(table2) do 
        if not output[key] then 
            output[key] = value 
        end
    end

    return output
end

function Filter:EnforceSkillLevelsPolicy(npc, skillLevels, npcIndex)
    for skillName, skillPolicy in pairs(skillLevels) do 
        local skillEnum = CS.XiaWorld.g_emNpcSkillType.__CastFrom(skillName)
        if not skillEnum then
            print("FAILED TO FIND SKILL NAMED "..tostring(skillName))
            return false
        end

        local skill = npc.PropertyMgr.SkillData:GetSkill(skillEnum)
        if not skill then
            Debug("No value for skill "..skillName)
            return false 
        end

        if not self:EnforceSingleValue(skill.Level, skillPolicy, npcIndex) then 
            Debug("skill "..skillName)
            return false 
        end
    end

    return true
end

function Filter:EnforceStatsPolicy(npc, npcIndex) 
    local total = 0
    local cha = npc.PropertyMgr.Charisma
    local int = npc.PropertyMgr.Intelligence
    local luk = npc.PropertyMgr.Luck
    local per = npc.PropertyMgr.Perception
    local con = npc.PropertyMgr.Physique
    local total = cha + int + luk + per + con

    if self.Stats.Total and not self:EnforceSingleValue(total, self.Stats.Total, npcIndex) then 
        Debug("Total stats")
        return false 
    end 

    if self.Stats.Luck and not self:EnforceSingleValue(luk, self.Stats.Luck, npcIndex) then 
        Debug("Luck")
        return false 
    end

    if self.Stats.Intelligence and not self:EnforceSingleValue(int, self.Stats.Intelligence, npcIndex) then 
        Debug("Intelligence")
        return false
    end

    if self.Stats.Charisma and not self:EnforceSingleValue(cha, self.Stats.Charisma, npcIndex) then 
        Debug("Charisma")
        return false 
    end

    if self.Stats.Perception and not self:EnforceSingleValue(per, self.Stats.Perception, npcIndex) then 
        Debug("Perception")
        return false 
    end
    
    if self.Stats.Constitution and not self:EnforceSingleValue(con, self.Stats.Constitution, npcIndex) then 
        Debug("Constitution")
        return false 
    end

    return true 
end

function Filter:EnforceYaoGuaiPolicy(npc, npcIndex, currentYaoGuai)
    if self.YaoGuai.MaxYaoGuai and currentYaoGuai+1 > self.YaoGuai.MaxYaoGuai then 
        Debug("Too many yaoguai")
        return false 
    end

    if npcIndex == 1 and self.YaoGuai.NotMain then 
        Debug("Yaoguai not permitted for main")
        return false 
    end

    if self.YaoGuai.MinTribulationDays and (npc.AnimalHumanFrom.ThunderComing/600) < self.YaoGuai.MinTribulationDays then
        Debug("Tribulation too close- was "..tostring(npc.AnimalHumanFrom.ThunderComing/600).." days, wanted more than "..tostring(yaoguai.MinTribulationDays))
        return false 
    end

    return true
end

function Filter:ValueBase(stat, npcIndex)
    if stat.MainMin and npcIndex == 1 then 
        return stat.MainMin 
    elseif stat.Min then 
        return stat.Min 
    end 

    return 1
end

function Filter:GetCutoffData(npc, skillEnum, priceData) 
    if priceData.CutoffLevel then 
        local skill = npc.PropertyMgr.SkillData:GetSkill(skillEnum)
        if not skill then
            return 0, priceData.CutoffLevel
        end

        return skill.Level, priceData.CutoffLevel 
    elseif priceData.CutoffEvalCurrent or priceData.CutoffEvalMax then 
        local eval = npc.PropertyMgr.SkillData:GetSkillEvaluate(skillEnum)
        if not eval then 
            return 0, priceData.CutoffEvalCurrent or priceData.CutoffEvalMax 
        end 

        if priceData.CutoffEvalCurrent then 
            return eval.x, priceData.CutoffEvalCurrent
        else
            return eval.y, priceData.CutoffEvalMax
        end 
    end

    return 0, {Min=1}
end

function Filter:PriceSkill(npc, skillName, priceData, npcIndex)
    local skillEnum = CS.XiaWorld.g_emNpcSkillType.__CastFrom(skillName)
    if not skillEnum then
        print("FAILED TO FIND SKILL NAMED "..tostring(skillName))
        return 0
    end

    local skill = npc.PropertyMgr.SkillData:GetSkill(skillEnum)
    if not skill then
        return 0
    end

    local value, cutoff = self:GetCutoffData(npc, skillEnum, priceData)
    if not cutoff or not self:EnforceSingleValue(value*1.25, cutoff, npcIndex) then 
        return 0
    end

    local valueBase = self:ValueBase(cutoff, npcIndex)

    if priceData.Prerequisites then 
        for prereqName, prereqData in pairs(priceData.Prerequisites) do 
            local prereqSkillEnum = CS.XiaWorld.g_emNpcSkillType.__CastFrom(prereqName)
            if not prereqSkillEnum then
                print("FAILED TO FIND SKILL NAMED "..tostring(prereqName))
                return 0
            end

            Debug("Testing prereq "..tostring(prereqName))
            local prereqValue = self:GetCutoffData(npc, prereqSkillEnum, priceData)
            if not self:EnforceSingleValue(prereqValue, prereqData, npcIndex) then 
                Debug("Prerequisite too low")
                return 0
            end 
            Debug("Met prereq with value of "..tostring(prereqValue))
        end 
    end 

    Debug("Pricing: value - "..tostring(value).." - valueBase - "..tostring(valueBase).." - inspvalue - "..tostring(priceData.InspValue))
    local price = value / valueBase

    price = price + (skill.Love * priceData.InspValue)

    return price
end

function Filter:EnforceSkillGroupsPolicy(npc, npcIndex, crowdData)
    for skillGroupName, skillGroup in pairs(self.SkillGroups) do 
        local hitCount = 0
        local groupCrowdData = crowdData[skillGroupName] or {}

        for skillName, skillPriceData in pairs(skillGroup) do 
            if skillName ~= "Default" and skillName ~= "Hits" then 
                local priceData = skillPriceData
                if skillGroup.Default then 
                    priceData = self:MergeTables(skillPriceData, skillGroup.Default)
                end

                if debug then 
                    local skillEnum = CS.XiaWorld.g_emNpcSkillType.__CastFrom(skillName)
                    local skill = npc.PropertyMgr.SkillData:GetSkill(skillEnum)
                    local skillEval =  npc.PropertyMgr.SkillData:GetSkillEvaluate(skillEnum)
                    Debug("Skill value "..skillName..": Level "..skill.Level..", "..skillEval.x.."/"..skillEval.y..", Insp: "..skill.Love)
                end

                local crowdFactor = groupCrowdData[skillName] or 1
                local basePrice = self:PriceSkill(npc, skillName, priceData, npcIndex) 
                local price = basePrice * crowdFactor

                Debug("Pricing skill "..skillName.." in group "..skillGroupName..": Base "..tostring(basePrice)..", Price "..tostring(price).." after applying crowd factor of "..tostring(crowdFactor))

                if price >= 1 then 
                    Debug("Hit recorded")
                    hitCount = hitCount + 1
                end
            end
        end

        if not self:EnforceSingleValue(hitCount, skillGroup.Hits, npcIndex) then 
            Debug("Hits on skill group "..skillGroupName)
            return false 
        end

        Debug("Skill group accepted with "..tostring(hitCount).." hits")
    end

    return true 
end

function Filter:CanGenYaoguai(npcList, npcIndex, maxNpcConsider)
    if not self.YaoGuai then 
        return true 
    end 

    if self.YaoGuai.NotMain and npcIndex == 1 then 
        return false 
    end 

    local totalYaoGuai = 0 
    maxNpcConsider = maxNpcConsider or 5
    for i=1,maxNpcConsider do 
        if i ~= npcIndex and npcList[i] and npcList[i].AnimalHumanFrom then 
            totalYaoGuai = totalYaoGuai + 1
        end 
    end 

    if self.YaoGuai.MaxYaoGuai and totalYaoGuai >= self.YaoGuai.MaxYaoGuai then 
        return false 
    end 

    return true
end

function Filter:FilterCheck(npc, npcList, npcIndex, maxNpcConsider)
    maxNpcConsider = maxNpcConsider or 5
    Debug("Filter character "..tostring(npc.PropertyMgr.PrefixName)..tostring(npc.PropertyMgr.SuffixName).." ("..tostring(npcIndex)..")")

    local currentYaoGuai = 0

    for i=1,maxNpcConsider do
        if i ~= npcIndex and npcList[i] then 

            if npcList[i].AnimalHumanFrom then 
                currentYaoGuai = currentYaoGuai + 1
            end
        end
    end

    if self.YaoGuai and npc.AnimalHumanFrom and not self:EnforceYaoGuaiPolicy(npc, filter.YaoGuai, npcIndex, currentYaoGuai) then  
        return false 
    end

    if self.Stats and not self:EnforceStatsPolicy(npc, npcIndex) then 
        return false 
    end

    if self.SkillLevels and not self:EnforceSkillLevelsPolicy(npc, npcIndex) then 
        return false 
    end

    Debug("Luck before: "..tostring(npc.PropertyMgr.Luck))
    if self.ForceBackstory then 
        for i=1,#self.ForceBackstory do 
            local backstoryID = tonumber(self.ForceBackstory[i])
            local backstory = nil 
            
            if backstoryID ~= nil then 
                backstory = NpcMgr:GetStory(backstoryID)
            end

            if backstory then 
                npc.PropertyMgr:EffectStory(backstory, false, backstory:GetDesc(npc))
            end
        end
    end
    Debug("Luck after: "..tostring(npc.PropertyMgr.Luck))

    local crowdData = {}
    local oldDebug = debug 
    debug = additionalCrowdDebug 

    if self.SkillGroups then 
        for skillGroupName, skillGroup in pairs(self.SkillGroups) do 
            local totalCrowd = 0
            local crowdingValues = {}
            
            for i=1,maxNpcConsider do 
                if i ~= npcIndex and npcList[i] then 
                    Debug("Considering NPC "..tostring(i))
                    for skillName, skillData in pairs(skillGroup) do
                        if skillName ~= "Default" and skillName ~= "Hits" then 
                            local priceData = skillGroup
                            if skillGroup.Default then 
                                priceData = self:MergeTables(skillData, skillGroup.Default)
                            end

                            local skillValue = self:PriceSkill(npcList[i], skillName, priceData, npcIndex)
                            if skillValue then 
                                local crowdValue = crowdingValues[skillName] or 0
                                local crowdCost = priceData.CrowdCost or 1

                                local finalCrowdValue = skillValue*crowdCost

                                if finalCrowdValue >= 1 then 
                                    Debug("Adding crowd "..tostring(finalCrowdValue).." to skill "..skillName)
                                    crowdingValues[skillName] = crowdValue + finalCrowdValue
                                    totalCrowd = totalCrowd + finalCrowdValue
                                end
                            end
                        end
                    end
                end
            end

            if totalCrowd == 0 then 
                totalCrowd = 1 
            end

            local groupCrowdData = {}
            for skillName, crowdValue in pairs(crowdingValues) do 
                local crowdFactor = 1 - (crowdValue / totalCrowd)
                Debug("Group "..skillGroupName.." - "..skillName.." "..tostring(crowdValue).." / "..tostring(totalCrowd).." = "..tostring(crowdFactor))
                groupCrowdData[skillName] = crowdFactor*(1+crowdFactor)/2
            end
            crowdData[skillGroupName] = groupCrowdData
        end
    end
    debug = oldDebug

    if debug then 
        Debug("--CROWD--")
        for skillGroupName, groupCrowd in pairs(crowdData) do 
            for skillName, crowdValue in pairs(groupCrowd) do 
                Debug(skillGroupName.." - "..skillName..": "..tostring(crowdValue))
            end
        end
        Debug("--END CROWD--")
    end

    if self.SkillGroups and not self:EnforceSkillGroupsPolicy(npc, npcIndex, crowdData) then 
        return false 
    end

    Debug("Character accepted")
    return true 
end
