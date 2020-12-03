local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");

Mod.CharData = Mod.CharData or {}
Mod.CharData.Backgrounds = Mod.CharData.Backgrounds or {}
local Backgrounds = Mod.CharData.Backgrounds

Backgrounds.Childhood = {
    Male = {},
    Female = {},
}
Backgrounds.Adult = {
    Male = {},
    Female = {},
}
Backgrounds.Event = {
    Male = {},
    Female = {},
}
Backgrounds.ByKey = {}

local function AddBackgrounds(type, gender)
    local list = Backgrounds[type][gender]
    local typeEnum = CS.XiaWorld.g_emBackstoryGrades.__CastFrom(type)
    local genderEnum = CS.XiaWorld.g_emNpcSex.__CastFrom(gender)

    local backstories = NpcMgr:GetAllkNpcBackstoryDatas(typeEnum, genderEnum, "Human")
    for i=1,backstories.Count do 
        local backstory = backstories[i-1]
        table.insert(list, backstory.ID)

        if not Backgrounds.ByKey[backstory.ID] then 
            local backstoryData = {
                ID = backstory.ID,
                BaseFive = {},
                SkillLevel = {},
                SkillLove = {},
                Features = {},
            }

            for j=1,5 do 
                backstoryData.BaseFive[j] = backstory.BaseProperty[j-1]
            end

            for j=1,16 do 
                backstoryData.SkillLevel[j] = backstory.SkillLevel[j]
                backstoryData.SkillLove[j] = backstory.SkillLove[j]
            end

            for j=1,backstory.Features.Length do 
                backstoryData.Features[j] = backstory.Features[j-1]
            end

            Backgrounds.ByKey[backstoryData.ID] = backstoryData
        end
    end
end

function Backgrounds:Init()
    AddBackgrounds("Childhood", "Male")
    AddBackgrounds("Childhood", "Female")
    AddBackgrounds("Adult", "Male")
    AddBackgrounds("Adult", "Female")
    AddBackgrounds("Event", "Male")
    AddBackgrounds("Event", "Female")
end