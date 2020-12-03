local Mod = GameMain:GetMod("CanVox.NewCharRandomizer");

local needMarkup = true

function findPropertyPanel(wnd)
    if not wnd.GetChildren then 
        return 
    end

    local children = wnd:GetChildren()

    for i=1,children.Length do 
        local child = children[i-1]
        if child and child.name == "PropertyPanel" then 
            return child 
        end

        local foundPanel = findPropertyPanel(child)
        if foundPanel then 
            return foundPanel
        end
    end

    return nil
end

function Mod:OnInit()
    self.CharData.Backgrounds:Init()
    self.CharData.Features:Init()
    self.CharData.Thoughts:Init()

    local filterMap = {}

    -- Build a map of class-ified filters from the FilterConfig folder
    for i=1,#Mod.InputFilter do 
        local filter = Mod.InputFilter[i]
        if filter.DoRemove then 
            filterMap[filter.Name] = nil 
        else
            local filterObj = Lib:NewClass(Mod.Filter)
            for key, value in pairs(filter) do
                filterObj[key] = value 
            end 
            filterMap[filter.Name] = filterObj
        end 
    end

    -- Figure out the one with the highest default priority while building
    -- a sorted list
    local bestDefaultName = ""
    local bestDefaultValue = 0
    local filterList = {}
    for key, value in pairs(filterMap) do 
        table.insert(filterList, value)

        if value.DefaultPriority > bestDefaultValue then 
            bestDefaultValue = value.DefaultPriority 
            bestDefaultName = key 
        end 
    end 

    table.sort(filterList, function(a, b) return a.Sort <= b.Sort end)

    -- Get index of best default
    local defaultIndex = 0
    for i=1,#filterList do 
        if filterList[i].Name == bestDefaultName then 
            defaultIndex = i-1
            break
        end
    end

    Mod.FilterConfig = {
        DefaultFilter = defaultIndex,
        Filters = filterList,
    }
end

function Mod:OnRender(dt)
    local charUIExists = CS.Wnd_NpcGentrate.Instance ~= nil and 
    CS.Wnd_NpcGentrate.Instance.isShowing and
    Mod.CreateUI
    
    if charUIExists then 
        if needMarkup then 
            needMarkup = false 

            local npcPanel = findPropertyPanel(GRoot.inst)  
            Mod.CreateUI:MarkUp(npcPanel)
        else
            Mod.CreateUI:OnRender(dt)
        end
    end
end
