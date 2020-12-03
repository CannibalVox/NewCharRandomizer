local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")
Mod.InputFilter = Mod.InputFilter or {}

local filter = {
    Name = "Immortal",
    DisplayName = "Immortal",
    Sort = 3000,
    DefaultPriority = 4000,
    Stats = {
        Total = {
            Min = 20,
        },
        Luck = {
            MainMin = 5,
            Min = 4,
        },
    },
    YaoGuai = {
        MaxYaoGuai = 2,
        NotMain = true,
        MinTribulationDays = 140,
    },
    SkillLevels = {
        Qi = {
            MainMin = 6,
            Min = 4,
        },
    },
    SkillGroups = {
        CultivatorSkills = {
            Hits = {
                Min = 1,
                MainMin = 2,
            },
            Default = {
                CutoffEvalCurrent = {
                    Min = 20,
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
                        Min = 15,
                    },
                },
            },
            Manual = {
                Prerequisites = {
                    DanQi = {
                        Min = 15,
                    },
                },
            },
            DouFa = {
                CutoffLevel = {
                    Min = 6,
                },
                CrowdCost = 0.3,
            },
        },
        WorkSkills = {
            Hits = {
                Min = 2,
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
