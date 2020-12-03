local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")
Mod.InputFilter = Mod.InputFilter or {}

local filter = {
    Name = "NoAssist",
    Sort = 1000,
    DefaultPriority = 1000,
    DisplayName = "Assist Off",
}

table.insert(Mod.InputFilter, filter)
