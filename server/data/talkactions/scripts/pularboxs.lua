        function onSay(player, words, param)
            local storageID = 10020 -- ID da storage que você deseja alterar
            local currentValue = player:getStorageValue(storageID) or 0

            player:setStorageValue(storageID, currentValue + 1)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "O valor da storage foi incrementado em 1.")
            return false
        end