local randomizerMod = GameMain:GetMod("CanVox.NewCharRandomizer");

randomizerMod.CharUI = randomizerMod.CharUI or {}
local CharUI = randomizerMod.CharUI

function RandomClicked(context)
    world:ShowMsgBox(context.sender.name,context.type);
end

function CharUI:MarkUp(UIInfo) 
    UIInfo.m_PropertyPanel.m_n48:RemoveEventListeners()
    UIInfo.m_PropertyPanel.m_n48:AddEventListener("onClick", RandomClicked)
end
