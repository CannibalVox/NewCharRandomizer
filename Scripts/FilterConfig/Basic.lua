local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")
Mod.InputFilter = Mod.InputFilter or {}

local filter = {
    Name = "Basic",
    DisplayName = "Basic",
    Sort = 4000,
    DefaultPriority = 6000,
    Age = {
        Min = 23,
        Max = 40,
    },
    Stats = {
        Total = {
            Min = 21,
            MainMin = 23,
        },
        Luck = {
            Min = 4,
        }
    },
    YaoGuai = {
        MaxYaoGuai = 1,
        NotMain = true,
        MinTribulationDays = 190,
    },
    ForceBackstory = {100006}, -- +Luck Reincarnated
    SkillLevels = {
        Qi = {
            Min = 6,
        },
        SocialContact = {
            MainMin = 8,
        },
    },
    SkillGroups = {
        CultivatorSkills = {
            Hits = {
                Min = 1,
                MainMin = 3,
            },
            Default = {
                CutoffLevel = {
                    Min = 10,
                },
                CrowdCost = 1,
                InspValue = 0,
            },
            Qi = {
                CrowdCost = 0,
            },
            SocialContact = {},
            Medicine = {
                Prerequisites = {
                    DanQi = {
                        Min = 8,
                    },
                },
            },
            Manual = {
                Prerequisites = {
                    DanQi = {
                        Min = 8,
                    },
                },
            },
            DouFa = {
                CutoffLevel = {
                    Min = 4,
                    MainMin = 6,
                },
                CrowdCost = 0.3,
            },
        },
        WorkSkills = {
            Hits = {
                Min = 3,
                MainMin = 1,
            },
            Default = {
                CutoffEvalCurrent = {
                    Min = 25,
                },
                CrowdCost = 1,
                InspValue = 0.5,
            },
            Fight = {
                CrowdCost = 1.5,
            },
            Medicine = {
                CrowdCost = 1.5,
            },
            Cooking = {
                CrowdCost = 1.5,
            },
            Building = {
                CrowdCost = 0.5,
            },
            Farming = {
                CrowdCost = 0.5,
            },
            Mining = {},
            Art = {
                Prerequisites = {
                    Manual = {
                        Min = 25,
                    },
                },
                CrowdCost = 1.5,
            },
            Manual = {
                InspValue = 1,
            },
        },
    },
}

table.insert(Mod.InputFilter, filter)
