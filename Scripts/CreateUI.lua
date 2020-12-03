local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");
local math = require("math")

Mod.CreateUI = Mod.CreateUI or {}
local CreateUI = Mod.CreateUI

math.randomseed(os.time())
math.random()
math.random()
math.random()

function CreateUI:RandomClicked(context)
    -- local selectedNPC = self.NPCSelect.selectedIndex

    -- if selectedNPC == 0 then 
    --     self:ResetSlots()
    -- end

    -- local randFunc = function(race)
        

    --     local npc = CS.XiaWorld.NpcRandomMechine(race, , seed, )
    --     return self.Window.Mechine:RandomNpc(selectedNPC, false, CS.XiaWorld.g_emNpcSex.None, seed, false, nil, nil, false, false, race)
    -- end

    -- self:GenerateRandom(selectedNPC, randFunc, self.NPCSelect.numChildren)
    -- CS.XiaWorld.NpcRandomMechine.MakeRelation(selectedNPC, self.Window.Mechine.npcs, true)

    -- if selectedNPC == 0 then 
    --     self.Window:InitData(self.Window.Mechine)
    -- else
    --     self.NPCSelect:DispatchEvent("onClickItem", self.NPCSelect:GetChildAt(selectedNPC))
    -- end 

    -- self:PackNpcs()
end

function CreateUI:InitNPCs()
    local diff = self.CurrentDifficulty+1
    self.LoadedNpcs[diff] = {}

    for i=1,5 do 
        self.LoadedNpcs[diff][i] = Mod.Generator:NewCharacter(self.CurrentFilter, i, self.LoadedNpcs[diff], i)
    end
end

function CreateUI:ResetSlots() 
    while self.Window.Mechine.npcs.Length > 3 do 
        self.Window.Mechine:RemoveNpcSlot()
    end
    while self.Window.Mechine.npcs.Length < 3 do 
        self.Window.Mechine:AddNpcSlot()
    end
end

function CreateUI:PackNpcs() 
    local diff = self.CurrentDifficulty+1

    for i=1,self.Window.Mechine.npcs.Length do 
        self.LoadedNpcs[diff][i] = self.Window.Mechine.npcs[i-1]
    end
end

function CreateUI:UnpackNpcs()
    local diff = self.CurrentDifficulty+1
    if not self.LoadedNpcs[diff] then
        self:InitNPCs()
    end

    for i=1,self.Window.Mechine.npcs.Length do 
        self.Window.Mechine.npcs[i-1] = self.LoadedNpcs[diff][i]
    end

    self.LoadedNpcs[diff].MaxRelation = self.LoadedNpcs[diff].MaxRelation or 0 

    for i=1,self.Window.Mechine.npcs.Length do 
        if i > self.LoadedNpcs[diff].MaxRelation then 
            CS.XiaWorld.NpcRandomMechine.MakeRelation(i-1, self.Window.Mechine.npcs, true)
        end
    end

    self.LoadedNpcs[diff].MaxRelation = self.Window.Mechine.npcs.Length

    self.Window:InitData(self.Window.Mechine)
end

function CreateUI:PerkClicked(context)
    local perk = NpcMgr.ExperienceMgr:GetDef(context.data.data)

    if perk and perk.NpcSlot and perk.NpcSlot ~= 0 then 
        self:UnpackNpcs()
    end
end

function CreateUI:DifficultyChanged()
    self:ResetSlots()

    self.CurrentDifficulty = self.DifficultyDropdown.selectedIndex
    self.CurrentFilter = Mod.FilterConfig.Filters[self.CurrentDifficulty+1]
    self:UnpackNpcs()
end

function CreateUI:MarkUp(UIInfo)
    self.NPCSelect = UIInfo.parent.m_n67
    self.Window = CS.Wnd_NpcGentrate.Instance
    Mod.Mechine = self.Window.Mechine
    self.LoadedNpcs = {}

    self.OldDropdown = UIInfo.m_n260
    self.DifficultyDropdown = UIPackage.CreateObjectFromURL("ui://0xrxw6g7hdhl1i")
    local items = {}
    local displayNames = {}
    for i=1,#Mod.FilterConfig.Filters do
        items[i] = i
        displayNames[i] = Mod.FilterConfig.Filters[i].Name
    end
    self.DifficultyDropdown.values = items 
    self.DifficultyDropdown.items = displayNames
    self.DifficultyDropdown.selectedIndex = Mod.FilterConfig.DefaultFilter
    self.DifficultyDropdown.x = UIInfo.m_n260.x 
    self.DifficultyDropdown.y = UIInfo.m_n260.y 
    self.DifficultyDropdown:SetSize(UIInfo.m_n260.width, UIInfo.m_n260.height)
    UIInfo:AddChild(self.DifficultyDropdown)

    self.DifficultyDropdown.onChanged:Add(
        function(ctx)
            local success, err = pcall(function()
                self:DifficultyChanged()
            end)

            if not success then 
                print(err)
            end
        end
    )

    UIInfo.m_n260.visible = false
    UIInfo.m_n48:RemoveEventListeners()
    UIInfo.m_n48:AddEventListener("onClick", 
        function(ctx)
            local success, err = pcall(function()
                self:RandomClicked(ctx)
            end)

            if not success then 
                print(err)
            end
        end)

    UIInfo.m_n143.m_n149.onClickItem:Add(
        function(ctx)
            local success, err = pcall(function()
                self:PerkClicked(ctx)
            end)
            if not success then 
                print(err)
            end
        end
    )
    
    self:DifficultyChanged()
end

local timeAccum = 0
function CreateUI:OnRender(dt) 
    timeAccum = timeAccum + dt 
    if timeAccum > 0.1 then 
        timeAccum = timeAccum - 0.1 
    else
        return 
    end

    self.DifficultyDropdown.x = self.OldDropdown.x 
    self.DifficultyDropdown.y = self.OldDropdown.y 
end
