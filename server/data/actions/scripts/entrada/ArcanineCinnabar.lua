local cfg = {
    pos = {x = 2195, y = 2802, z = 9},  -- Posição para onde os jogadores serão teleportados.
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    doSendMagicEffect(getPlayerPosition(cid), CONST_ME_TELEPORT)
    doTeleportThing(cid, cfg.pos)

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE)

    return true
end
