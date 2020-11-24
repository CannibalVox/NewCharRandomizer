local randomizerMod = GameMain:GetMod("CanVox.NewCharRandomizer");
local debug = true
randomizerMod.markedUpCreator = randomizerMod.markedUpCreator or false

function randomizerMod:OnRender(dt)
    local talkUIExists = CS.Wnd_NpcGentrate.Instance ~= nil
        and CS.Wnd_JianghuTalk.Instance.UIInfo ~= nil
    
    if randomizerMod.CharUI then 
        if talkUIExists ~= randomizerMod.markedUpCreator then 
            if talkUIExists then 
                randomizerMod.CharUI:MarkUp(CS.Wnd_NpcGentrate.Instance.UIInfo)
                randomizerMod.markedUpCreator = true 
            elseif debug then 
                randomizerMod.markedUpCreator = false 
            end
        end
    end
end
