local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");
Mod.InputFilter = Mod.InputFilter or {}

local filter = {
    Name = "Generous",
    DisplayName = "Generous",
    Sort = 5000,
    DefaultPriority = 5000,
    Age = {
        Min = 23,
        Max = 40,
    },
    Stats = {
        Total = {
            Min = 20,
        },
        Luck = {
            Min = 3,
            MainMin = 4,
        },
        Charisma = {
            MainMin = 3,
        },
    },
    YaoGuai = {
        MaxYaoGuai = 0,
    },
    SkillLevels = {
        Qi = {
            MainMin = 3,
        },
        SocialContact = {
            MainMin = 8,
        },
    },
    ForceBackstory = {100007}, -- Immortal Agreement
    SkillGroups = {
        CultivatorSkills = {
            Hits = {
                Min = 1,
                MainMin = 2,
            },
            Default = {
                CutoffLevel = {
                    Min = 8,
                },
                CrowdCost = 1,
                InspValue = 0,
            },
            SocialContact = {},
            Medicine = {
                CrowdCost = 2,
                CutoffLevel = {
                    Min = 10,
                },
                Prerequisites = {
                    DanQi = {
                        Min = 8,
                    },
                },
            },
            Manual = {
                CutoffLevel = {
                    Min = 10,
                },
                CrowdCost = 2,
                Prerequisites = {
                    DanQi = {
                        Min = 8,
                    },
                },
            },
            DouFa = {
                CutoffLevel = {
                    Min = 6,
                },
                CrowdCost = 0.5,
            },
        },
        WorkSkills = {
            Hits = {
                Min = 3,
                MainMin = 2,
            },
            Default = {
                CutoffEvalCurrent = {
                    Min = 40,
                },
                CrowdCost = 1,
                InspValue = 0.5,
            },
            Fight = {},
            Medicine = {},
            Cooking = {},
            Building = {
                CrowdCost = 0.7,
            },
            Farming = {
                CrowdCost = 0.7,
            },
            Mining = {},
            Art = {
                Prerequisites = {
                    Manual = {
                        Min = 40,
                    },
                },
            },
            Manual = {
                InspValue = 1,
            },
        },
    },
}

table.insert(Mod.InputFilter, filter)
