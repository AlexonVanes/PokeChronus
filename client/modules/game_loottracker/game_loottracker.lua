local OPCODE_LOOTTRACKER = 119
lootTrackerWindow = nil
contentsPanel = nil
lootButton = nil
local sessionLoot = {}

function init()
    ProtocolGame.registerExtendedOpcode(OPCODE_LOOTTRACKER, onExtendedOpcode)
    
    g_ui.importStyle('game_loottracker')
    
    -- Load the MiniWindow into the right panel
    lootTrackerWindow = g_ui.createWidget('LootTrackerWindow', modules.game_interface.getRightPanel())
    lootTrackerWindow:setup()
    lootTrackerWindow:close()
    
    contentsPanel = lootTrackerWindow:recursiveGetChildById('lootListPanel')
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE_LOOTTRACKER, onExtendedOpcode)
    
    if lootTrackerWindow then
        lootTrackerWindow:destroy()
    end
    if lootButton then
        lootButton:destroy()
    end
    
    sessionLoot = {}
end

function toggle()
    if lootButton then
        if lootButton:isOn() then
            lootTrackerWindow:close()
            lootButton:setOn(false)
        else
            lootTrackerWindow:open()
            lootButton:setOn(true)
        end
    end
end

function onMiniWindowClose()
    if lootButton then
        lootButton:setOn(false)
    end
end

function resetSession()
    sessionLoot = {}
    contentsPanel:destroyChildren()
end

function onExtendedOpcode(protocol, opcode, buffer)
    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or type(data) ~= 'table' then return end
    
    for i=1, #data do
        addLoot(data[i].id, data[i].count, data[i].name)
    end
end

function addLoot(clientId, count, name)
    if not sessionLoot[clientId] then
        sessionLoot[clientId] = {count = 0, name = name, widget = nil}
    end
    
    sessionLoot[clientId].count = sessionLoot[clientId].count + count
    local lootEntry = sessionLoot[clientId]
    
    if not lootEntry.widget then
        local widget = g_ui.createWidget('LootItemEntry', contentsPanel)
        widget:getChildById('itemDisplay'):setItemId(clientId)
        lootEntry.widget = widget
    end
    
    local textDesc = lootEntry.count .. 'x ' .. (name or 'Item')
    lootEntry.widget:getChildById('nameLabel'):setText(textDesc)
end
