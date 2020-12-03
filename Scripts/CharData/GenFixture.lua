local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")
Mod.CharData.GenFixture = Mod.CharData.GenFixture or {}
GenFixture = Mod.CharData.GenFixture

function GenFixture:SetNpc(npc)
    self.Npc = npc 
    self.NpcFiveBase = {}
    self.NpcSkillLevels = {}
    self.NpcSkillLove = {}
    self.NpcSkillAddion = {}
    self.NpcSkillAddionOver = {}
    self.NpcSkillBans = {}

    self.NpcFeatures = {}
    self.NpcBackgrounds = {}

    for i=1,5 do 
        self.NpcFiveBase[i] = npc.PropertyMgr.BaseData:GetValue(CS.XiaWorld.g_emNpcBasePropertyType.__CastFrom(i-1))
    end

    for i=1,16 do 
        local skill = npc.PropertyMgr.SkillData:GetSkill(CS.XiaWorld.g_emNpcSkillType.__CastFrom(i))

        self.NpcSkillLevels[i] = skill.BaseLevel
        self.NpcSkillLove[i] = skill.Love
        self.NpcSkillAddion[i] = skill.Addv
        self.NpcSkillAddionOver[i] = skill.Addv2
        self.NpcSkillBans[i] = skill.Ban 
    end

    for i=1,npc.FeatureList.Count do 
        local featureKey = npc.FeatureList[i-1].Name
        self.NpcFeatures[featureKey] = true
    end

    for i=1,3 do 
        local story = npc.PropertyMgr.BackStory[i-1]
        if story then 
            self.NpcBackgrounds[i] = story.ID 
        end
    end
end

function GenFixture:WipeBackgrounds()
    self.RandomFiveBase = {0, 0, 0, 0, 0}
    self.BackgroundFiveBase = {0, 0, 0, 0, 0}

    self.Backgrounds = {}
    self.AdditionalFeatures = {}
    self.Thoughts = {}

    self.BackgroundSkillLevels = {}
    self.BackgroundSkillLove = {}
    self.BackgroundSkillAddion = {}
    self.BackgroundSkillAddionOver = {}
    self.BackgroundSkillBans = {}

    for i=1,16 do 
        self.BackgroundSkillLevels[i] = 0
        self.BackgroundSkillLove[i] = 0
        self.BackgroundSkillAddion[i] = 0
        self.BackgroundSkillAddionOver[i] = 0
        self.BackgroundSkillBans[i] = false
    end

    self:WipeSkills()
end

function GenFixture:WipeSkills()
    self.RandomSkillBase = {}
    self.RandomSkillLove = {}

    -- Wipe Skills
    for i=1,16 do 
        self.RandomSkillBase[i] = 0
        self.RandomSkillLove[i] = 0
    end
end

function GenFixture:GetStat(index)
    return self.NpcFiveBase[index] + self.BackgroundFiveBase[index] + self.RandomFiveBase[index]
end

function GenFixture:Perception()
    return self:GetStat(1)
end

function GenFixture:Constitution()
    return self:GetStat(2)
end

function GenFixture:Charisma()
    return self:GetStat(3)
end

function GenFixture:Intelligence()
    return self:GetStat(4)
end

function GenFixture:Luck()
    return self:GetStat(5)
end 

function GenFixture:TotalStats()
    local total = 0 
    for i=1,5 do 
        total = total + self:GetStat(i)
    end
    return total 
end
