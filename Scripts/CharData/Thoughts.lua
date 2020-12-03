local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");

Mod.CharData = Mod.CharData or {}
Mod.CharData.Thoughts = Mod.CharData.Thoughts or {}
local Thoughts = Mod.CharData.Thoughts

Thoughts.ByKey = {
    Scene = {},
    Target = {},
    Emotion = {},
}
Thoughts.Races = {}

function Thoughts:Init()
    local raceInfoDataIter = CS.XiaWorld.HumanoidEvolutionMgr.Instance.RaceInfos.ForEachKey:GetEnumerator()
    while raceInfoDataIter:MoveNext() do 
        local race = raceInfoDataIter.Current.Value
        local raceData = {
            Weight = race.Frag.Weight,
            Tags = {},
        }

        for i=1,race.Frag.FragR.Count do 
            local fragR = race.Frag.FragR[i-1]
            raceData.Tags[fragR.Type] = {}
            for j=1,fragR.ModifyTagWeight.Count do 
                raceData.Tags[fragR.Type][fragR.ModifyTagWeight[j-1].Tag] = fragR.ModifyTagWeight[j-1].Weight
            end
        end

        Thoughts.Races[raceInfoDataIter.Current.Key] = raceData
    end

    local fragmentDataIter = CS.XiaWorld.HumanoidEvolutionMgr.Instance.Fragments.ForEachKey:GetEnumerator()
    while fragmentDataIter:MoveNext() do 
        local fragment = fragmentDataIter.Current.Value 
        local fragmentData = {
            Type = fragment.Type,
            Tag = fragment.Tag,
            Name = fragment.Name,
        }

        if fragment.BaseFive and fragment.BaseFive ~= "" then 
            fragmentData.BaseFive = Mod.CharData.Utils:BaseFiveFromString(fragment.BaseFive)
        end 

        if fragment.Skills and fragment.Skills.Count > 0 then 
            fragmentData.Skills = Mod.CharData.Utils:SkillsFromModDef(fragment.Skills)
        end

        Thoughts.ByKey[fragmentData.Type][fragmentData.Name] = fragmentData
    end
end 
