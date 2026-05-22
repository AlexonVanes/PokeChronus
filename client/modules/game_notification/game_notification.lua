local OPCODE_NOTIFICATION = 118
local notifications = {}
local marginTopBase = 10 -- Espaço a partir do topo
local marginRightBase = 200 -- Altere AQUI! Aumente este valor (ex: 200, 300) para empurrar a notificação mais para a esquerda.
local checkEvent = nil

function init()
    g_ui.importStyle('game_notification')
    ProtocolGame.registerExtendedOpcode(OPCODE_NOTIFICATION, onExtendedOpcode)
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE_NOTIFICATION, onExtendedOpcode)
    for _, notif in pairs(notifications) do
        notif:destroy()
    end
    notifications = {}
    if checkEvent then
        removeEvent(checkEvent)
        checkEvent = nil
    end
end

function onExtendedOpcode(protocol, opcode, buffer)
    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or not data then return end

    showNotification(data.title or "Notificação", data.message or "")
end

function showNotification(title, message)
    local notif = g_ui.createWidget('NotificationWindow', rootWidget)
    notif:setId('Notif_' .. os.time() .. '_' .. math.random(1000))
    notif:getChildById('title'):setText(title)
    notif:getChildById('message'):setText(message)

    -- Auto adjust height
    notif:getChildById('message'):resizeToText()
    local msgHeight = notif:getChildById('message'):getHeight()
    notif:setHeight(msgHeight + 40) -- padding and title base size

    table.insert(notifications, notif)
    rearrangeNotifications()

    -- Auto close after 5 seconds
    scheduleEvent(function()
        closeNotification(notif)
    end, 5000)
end

function closeNotification(notifToRemove)
    local found = false
    for i, notif in ipairs(notifications) do
        if notif == notifToRemove then
            table.remove(notifications, i)
            found = true
            break
        end
    end
    
    if found and notifToRemove then
        notifToRemove:destroy()
        rearrangeNotifications()
    end
end

function rearrangeNotifications()
    local y = marginTopBase
    for i, notif in ipairs(notifications) do
        notif:setMarginRight(marginRightBase) -- É aqui que a margem da direita é aplicada visualmente
        notif:setMarginTop(y)
        notif:addAnchor(AnchorRight, 'parent', AnchorRight)
        notif:addAnchor(AnchorTop, 'parent', AnchorTop)
        y = y + notif:getHeight() + marginTopBase
    end
end
