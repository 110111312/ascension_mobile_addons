-- MobileUIChat.lua - Chat Toggle module (Phase 3)
--
-- A dedicated "chat bubble" button sits at the bottom-left corner, just above
-- the action bar.  Click it to completely hide the chat UI; click again to
-- show it.  Slash command "/mui chat" also toggles.
--
-- Hiding is bulletproof: we reparent chat frames onto a hidden container so
-- Blizzard's re-show calls (combat, relog, FloatingChatFrame_Update) can never
-- make them visible again while hidden.  A frame whose PARENT is hidden never
-- renders, no matter how often :Show() is called on it.

-- ============================================================================
-- Locals
-- ============================================================================

local chatHideContainer  -- never-shown frame we reparent chat onto
local chatBubble          -- the bottom-left toggle button
local CHAT_UI_FRAMES = {} -- top-level chat frames we manage (built once)

-- ============================================================================
-- Build list of chat frames to manage
-- ============================================================================

local function BuildChatFrameList()
    CHAT_UI_FRAMES = {}
    local n = NUM_CHAT_WINDOWS or 10
    for i = 1, n do
        local cf = _G["ChatFrame" .. i]
        local tab = _G["ChatFrame" .. i .. "Tab"]
        if cf  then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = cf  end
        if tab then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = tab end
    end
    if _G["GENERAL_CHAT_DOCK"]   then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = _G["GENERAL_CHAT_DOCK"]   end
    if _G["FriendsMicroButton"]  then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = _G["FriendsMicroButton"]  end
    if _G["ChatFrameMenuButton"] then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = _G["ChatFrameMenuButton"] end
end

-- ============================================================================
-- Create the chat bubble button
-- ============================================================================

function MobileUI:CreateChatBubble()
    if chatBubble then return end
    if not chatHideContainer then
        chatHideContainer = CreateFrame("Frame", nil, UIParent)
        chatHideContainer:Hide()
        chatHideContainer:SetScale(1)
    end

    BuildChatFrameList()

    chatBubble = CreateFrame("Button", "MobileUIChatBubble", UIParent)
    chatBubble:SetSize(32, 32)
    chatBubble:SetFrameStrata("MEDIUM")
    chatBubble:SetClampedToScreen(true)
    chatBubble:SetMovable(true)
    chatBubble:RegisterForClicks("LeftButtonUp")
    chatBubble:RegisterForDrag("LeftButton")

    if MobileDB.bubbleX and MobileDB.bubbleY then
        chatBubble:SetPoint(MobileDB.bubblePoint or "BOTTOMLEFT",
            UIParent, MobileDB.bubbleRelPoint or "BOTTOMLEFT",
            MobileDB.bubbleX, MobileDB.bubbleY)
    else
        -- Default: bottom-left, raised above the bag icon (mobile layout)
        -- or above the action bar (default layout)
        local defaultY = MobileDB.layoutEnabled and 82 or 64
        chatBubble:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 2, defaultY)
    end

    chatBubble:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Up")
    chatBubble:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Down")
    chatBubble:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

    chatBubble:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            MobileUI:ToggleChat()
        end
    end)
    chatBubble:SetScript("OnDragStart", function(self) self:StartMoving() end)
    chatBubble:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, x, y = self:GetPoint()
        MobileDB.bubblePoint    = point
        MobileDB.bubbleRelPoint = relPoint
        MobileDB.bubbleX        = x
        MobileDB.bubbleY        = y
    end)
    chatBubble:SetScript("OnEnter", function(self)
        if GameTooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(MobileDB.chatHidden and "|cff00ccffShow Chat|r" or "|cff00ccffHide Chat|r", 1, 1, 1)
            GameTooltip:AddLine("Drag to move.", 0.6, 0.6, 0.6)
            GameTooltip:Show()
        end
    end)
    chatBubble:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    chatBubble:Show()
end

-- ============================================================================
-- Toggle / Apply
-- ============================================================================

function MobileUI:ToggleChat()
    self:SetChatHidden(not MobileDB.chatHidden)
end

function MobileUI:SetChatHidden(hidden)
    MobileDB.chatHidden = hidden and true or false
    self:ApplyChatVisibility()
end

function MobileUI:ApplyChatVisibility()
    if not chatHideContainer then return end
    local hide = MobileDB.chatHidden and true or false

    if hide then
        -- Close the input box first so keystrokes aren't captured while hidden.
        local cf = _G["ChatFrame1"]
        if cf and cf.editBox and cf.editBox:IsShown() and ChatEdit_DeactivateChat then
            ChatEdit_DeactivateChat(cf.editBox)
        end
        for _, f in ipairs(CHAT_UI_FRAMES) do
            if f and not f._muiHiddenParent then
                f._muiHiddenParent = f:GetParent()
                f:SetParent(chatHideContainer)
            end
        end
    else
        for _, f in ipairs(CHAT_UI_FRAMES) do
            if f and f._muiHiddenParent then
                f:SetParent(f._muiHiddenParent)
                f._muiHiddenParent = nil
            end
        end
        local cf = _G["ChatFrame1"]
        if cf then cf:Show() end
        local tab = _G["ChatFrame1Tab"]
        if tab then tab:Show() end
        if _G["GENERAL_CHAT_DOCK"] and FCFDock_SetDirty then
            FCFDock_SetDirty(_G["GENERAL_CHAT_DOCK"])
        end
    end
end