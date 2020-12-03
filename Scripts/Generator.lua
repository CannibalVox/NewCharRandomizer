local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")

Mod.Generator = Mod.Generator or {}
local Generator = Mod.Generator

function Generator:NewCharacter(filter, npcIndex, npcList, maxNpcConsider)
    local fixture = Lib:NewClass(Mod.CharData.GenFixture)

    local race = "Human"

    while true do

        repeat
            race = self:GetGenRace(filter, npcIndex, npcList, maxNpcConsider)
            local raceDef = NpcMgr:GetRaceDef(race)
            local minAge, maxAge = self:GetAgeRange(filter, npcIndex, raceDef)

            fixture:SetNpc(self:GenerateBaseNpc(raceDef, minAge, maxAge))
        until filter:AcceptBaseNpc(fixture, npcIndex, npcList, maxNpcConsider)

        for i=1,100 do 
            fixture:WipeBackgrounds()

            -- Set forced backgrounds

            if race == "Human" then 
                -- Random backgrounds

                -- Random features 

            else 
                -- Random thought shards 

            end

            -- Randomize +stats

            if filter:AcceptBackgrounds(fixture, npcIndex, npcList, maxNpcConsider) then 
                for j=1,100 do 
                    fixture:WipeSkills()

                    -- Random skills 

                    if filter:AcceptSkills(fixture, npcIndex, npcList, maxNpcConsider) then 
                        return fixture:Apply()
                    end
                end
            end
        end
    end
end

function Generator:GetGenRace(filter, npcIndex, npcList, maxNpcConsider)
    -- Figure out what race they are
    if filter:CanGenYaoguai(npcList, npcIndex, maxNpcConsider) then 
        if math.random(2) == 1 then
            local raceCount = CS.XiaWorld.NpcMgr.GentrateNpcRaces.Count
            return CS.XiaWorld.NpcMgr.GentrateNpcRaces[math.random(raceCount)-1]
        end
    end

    return "Human"
end

function Generator:GetAgeRange(filter, npcIndex, raceDef)
    local minAge = raceDef.GenerateMinAge
    local maxAge = raceDef.GenerateMaxAge

    if filter.Age then 
        if filter.Age.MainMin and npcIndex == 1 then 
            minAge = filter.Age.MainMin
        elseif filter.Age.Min then 
            minAge = filter.Age.Min 
        end 

        if filter.AgeMainMax and npcIndex == 1 then 
            maxAge = filter.Age.MainMax 
        elseif filter.Age.Max then 
            maxAge = filter.Age.Max 
        end 
    end 

    return minAge, maxAge
end

function Generator:GenerateBaseNpc(raceDef, minAge, maxAge)
    -- Generate guy
    local seed = 0
    local npc = nil 
    local race = raceDef.Name
    
    repeat 
        seed = math.floor(math.random()*2000000000)
        npc = Mod.Mechine:RandomNpc(0, false, CS.XiaWorld.g_emNpcSex.None, seed, false, nil, nil, false, false, race)
    until npc.PropertyMgr.Age >= minAge and npc.PropertyMgr.Age <= maxAge

    Mod.Mechine.npcs[0] = nil 

    -- Wipe backstories, reset to base
    for i=1,3 do 
        local story = npc.PropertyMgr.BackStory[i-1]
        if story then 
            -- Remove backstory features 
            for j=1,story.Features.Length do 
                local feature = story.Features[j-1]
                if feature then 
                    npc.PropertyMgr:RemoveFeature(feature)
                end
            end

            -- Leave the "YaoGuai" backstory intact
            -- but wipe the description
            if i ~= 2 or race == "Human" then
                npc.PropertyMgr.BackStory[i-1] = nil 
            end

            npc.PropertyMgr.BackStoryDesc[i-1] = nil
        end
    end

    -- Remove all features
    for i=npc.PropertyMgr.FeatureList.Count,1,-1 do 
        npc.PropertyMgr:RemoveFeature(npc.PropertyMgr.FeatureList[i-1])
    end
    
    -- Wipe thought shards
    if race ~= "Human" then
        CS.XiaWorld.HumanoidEvolutionMgr.Instance:ModifyNpcPropertyByThinkFinals(npc, npc.AnimalHumanFrom.thinkFinals, true)

        -- Wipe features from thoughts
        local features = CS.XiaWorld.HumanoidEvolutionMgr.Instance:FindFeature(npc.AnimalHumanFrom.thinkFinals)
        for i=1,features.Count do  
            npc.PropertyMgr:RemoveFeature(features[i-1])
        end

        -- TODO: There's a bug right now that causes skill addion removal to double it
        -- instead of removing it.  Trying to counteract that would certainly break when
        -- they fix the bug, so we're just going to add the Addion to stuff in skills
        -- that we clear, but hey wouldn't it be nice if we didn't have to do that?
        -- Revisit after bug is fixed
        
        npc.AnimalHumanFrom.thinkFinals:Clear()

        -- local shardCount = 0
        -- while shardCount < 3 or shardCount > 10 do 
        --     local density = 0 
        --     local U1 = 0
        --     repeat 
        --         U1 = 2*math.random() - 1
        --         local U2 = 2*math.random() - 2
        --         density = U1*U2 + U2*U2 
        --     until density ~= 0 and density < 1

        --     local randVal = U1 * math.sqrt(-2 * math.log(density) / density)
        --     shardCount = randVal + 5
        -- end
    end
    
    -- Wipe Stats
    local baseStats = raceDef:GetBaseProperties(npc.Sex,math.floor(npc.Age))
    for i=0,4 do 
        npc.PropertyMgr.BaseData:SetBaseValue(CS.XiaWorld.g_emNpcBasePropertyType.__CastFrom(i), baseStats[i])
    end
    
    -- Wipe Skills
    for i=0,12 do 
        local skill = npc.PropertyMgr.SkillData:GetSkill(CS.XiaWorld.g_emNpcSkillType.__CastFrom(i))
        if skill then 
            skill.Ban = false 
            skill.Love = 0
            skill.BaseLevel = 0
            skill.Exp = 0
            skill.Addv = 0
        end
    end

    if race ~= "Human" then
        -- Re-add "Cat Yaoguai" etc. backstory
        local backstory = NpcMgr:GetRandomStory(CS.XiaWorld.g_emBackstoryGrades.Childhood, npc.PropertyMgr.Sex, npc.PropertyMgr.Race, false)
        npc.PropertyMgr:EffectStory(backstory, true, nil)
    end

    return npc
end
