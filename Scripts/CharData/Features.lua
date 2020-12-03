local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");

Mod.CharData = Mod.CharData or {}
Mod.CharData.Features = Mod.CharData.Features or {}
local Features = Mod.CharData.Features

Features.NormalFeatures = {}
Features.ByKey = {}

function Features:Init()
    local inputFeatureIter = NpcMgr.FeatureMgr:GetMapFeatureDefs():GetEnumerator()
    while inputFeatureIter:MoveNext() do 
        local key = inputFeatureIter.Current.Key 
        local feature = inputFeatureIter.Current.Value 

        if feature.Type == CS.XiaWorld.g_emFeatureType.Normal then 
            table.insert(Features.NormalFeatures, key)
        end

        local featureData = {
            Name = key,
            Type = feature.Type,
            Mutex = feature.Mutex,
        }

        if feature.ModifierDef then 
            if feature.ModifierDef.BaseFive and feature.ModifierDef.BaseFive ~= "" then 
                featureData.BaseFive = Mod.CharData.Utils:BaseFiveFromString(feature.ModifierDef.BaseFive)
            end 

            if feature.ModifierDef.Skills and feature.ModifierDef.Skills.Count > 0 then 
                featureData.Skills = Mod.CharData.Utils:SkillsFromModDef(feature.ModifierDef.Skills)
            end            
        end

        Features.ByKey[key] = featureData
    end
end 
