function onSay(player, words, param)
    -- Quando jogador abre o Pass, enviar todos os dados
    player:sendPassData()
    return false
end