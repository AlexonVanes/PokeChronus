local cfg = {
    pos = {x = 2194, y = 2796, z = 7},  -- Posição para onde os jogadores serão teleportados.(2194, 2796, 7)
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    doSendMagicEffect(getPlayerPosition(cid), CONST_ME_TELEPORT)
    doTeleportThing(cid, cfg.pos)

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE)

    return true
end
