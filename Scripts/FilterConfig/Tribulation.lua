local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")
Mod.InputFilter = Mod.InputFilter or {}

local filter = {
    Name = "Tribulation",
    DisplayName = "Tribulation",
    Sort = 2000,
    DefaultPriority = 3000,
    Stats = {
        Total = {
            Min = 16,
            Max = 23,
            MainMin = 18,
            MainMax = 25,
        },
        Luck = {
            MainMin = 4,
        }
    },
    YaoGuai = {
        MinTribulationDays = 75,
    },
    SkillLevels = {
        Qi = {
            Max = 10,
            MainMin = 4,
        },
        DouFa = {
            Max = 10,
        }
    },
    SkillGroups = {
        CultivatorSkills = {
            Hits = {
                Min = 1,
                MainMin = 2,
                Max = 2,
                MainMax = 3,
            },
            Default = {
                CutoffEvalMax = {
                    Min = 20,
                    Max = 35,
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
                MainMax = 2,
                Max = 4,
            },
            Default = {
                CutoffEvalMax = {
                    Min = 20,
                    Max = 35,
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
                        Min = 20,
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
