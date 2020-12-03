local Mod = GameMain:GetMod("CanVox.NewCharRandomizer")
Mod.InputFilter = Mod.InputFilter or {}

local filter = {
    Name = "Starstruck",
    DisplayName = "Starstruck",
    Sort = 6000,
    DefaultPriority = 2000,
    ForceBackstory = {200143},  --Starstruck
}

table.insert(Mod.InputFilter, filter)
