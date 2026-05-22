OPCODE_NEW_SELL = 88

local function isRentalSellItem(item)
    return RentalSystem and RentalSystem.isRentalItem and RentalSystem.isRentalItem(item) or false
end

function Player:getItemCountInBags(itemId)
    local totalCount = 0

    for i = CONST_SLOT_FIRST, CONST_SLOT_LAST do
        local item = self:getInventoryItem(i)
        if item then
            if item:getId() == itemId then
                if not isRentalSellItem(item) then
                    totalCount = totalCount + item:getCount()
                end
            elseif item:isContainer() then
                totalCount = totalCount + self:getItemCountInContainer(item, itemId)
            end
        end
    end

    return totalCount
end

function Player:getItemCountInContainer(container, itemId)
    local count = 0

    if not container or not container:isContainer() then
        return count
    end

    for i = 0, container:getCapacity() - 1 do
        local item = container:getItem(i)
        if item then
            if item:getId() == itemId then
                if not isRentalSellItem(item) then
                    count = count + item:getCount()
                end
            elseif item:isContainer() then
                count = count + self:getItemCountInContainer(item, itemId)
            end
        end
    end

    return count
end

function Player:removeItemFromBags(itemId, count)
    local remainingCount = count

    for i = CONST_SLOT_FIRST, CONST_SLOT_LAST do
        if remainingCount <= 0 then break end

        local item = self:getInventoryItem(i)
        if item then
            if item:getId() == itemId then
                if not isRentalSellItem(item) then
                    local itemCount = item:getCount()
                    local toRemove = math.min(itemCount, remainingCount)
                    if item:remove(toRemove) then
                        remainingCount = remainingCount - toRemove
                    end
                end
            elseif item:isContainer() then
                remainingCount = self:removeItemFromContainer(item, itemId, remainingCount)
            end
        end
    end

    return count - remainingCount
end

function Player:removeItemFromContainer(container, itemId, count)
    local remainingCount = count

    if not container or not container:isContainer() or remainingCount <= 0 then
        return remainingCount
    end

    for i = 0, container:getCapacity() - 1 do
        if remainingCount <= 0 then break end

        local item = container:getItem(i)
        if item then
            if item:getId() == itemId then
                if not isRentalSellItem(item) then
                    local itemCount = item:getCount()
                    local toRemove = math.min(itemCount, remainingCount)
                    if item:remove(toRemove) then
                        remainingCount = remainingCount - toRemove
                    end
                end
            elseif item:isContainer() then
                remainingCount = self:removeItemFromContainer(item, itemId, remainingCount)
            end
        end
    end

    return remainingCount
end

SELL_DATA = {}

SELL_DATA.ORDEM = {
    [1] = "ITEMS",
}

SELL_DATA.STYLES = {
    ["outfit"] = "baseOutfit",
    ["item"] = "baseItem",
    ["pokemon"] = "basePokemon",
    ["pack"] = "basePack",
    ["shader"] = "baseOutfit",
    ["wings"] = "baseOutfit",
    ["aura"] = "baseOutfit"
}

SELL_DATA.CATEGORYINFO = {
    ["ITEMS"] = {icon = "assets/categories/icon_items", size = '34 34', iconOffet = {x = 8, y = 8}},
}

SELL_DATA.CATEGORY = {
    ["ITEMS"] = {
        {type = "item", valor = 1, moeda = 23498, item = {id = 24682, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"},
    },
}

local isSellLoaded = false

SELL_CACHE = {}
SELL_JSON = {}

function handleSell(player, buffer)
    if not buffer then 
        return false 
    end

    local success, data = pcall(json.decode, buffer)
    if not success then
        return false
    end

    if not data then 
        return false 
    end

    local type = data.type
    if not type then 
        return false 
    end

    if type == "sell" then
        local infos = data.info
        local category = infos.category
        local selectedCat = SELL_DATA.CATEGORY[category]
        if not selectedCat then
            return false
        end

        local quantityClient = infos.quantity or 1
        local clientId = tonumber(infos.id)
        local item = nil

        for catName, catItems in pairs(SELL_DATA.CATEGORY) do
            for _, itemData in ipairs(catItems) do
                if itemData.type == "item" then
                    local itemType = ItemType(itemData.item.id)
                    if itemType and itemType:getClientId() then
                        local itemClientId = itemType:getClientId()
                        if itemClientId == clientId then
                            item = itemData
                            break
                        end
                    end
                end
            end
            if item then break end
        end

        if not item then
            player:popupFYI("Item nao encontrado.")
            return false
        end

        local currency = tonumber(item.moeda)
        local price = tonumber(item.valor) * quantityClient

        if item.type == "item" then
            local playerItemCount = player:getItemCount(item.item.id)
            local playerItemCountInBags = player:getItemCountInBags(item.item.id)
            local totalItemCount = playerItemCount + playerItemCountInBags
            local requiredCount = item.item.qtd * quantityClient

            if totalItemCount < requiredCount then
                player:popupFYI("Voce nao possui itens suficientes para vender.")
                return false
            end

            local currentCount = player:getItemCount(item.item.id)
            local currentCountInBags = player:getItemCountInBags(item.item.id)
            local currentTotalCount = currentCount + currentCountInBags

            if currentTotalCount < requiredCount then
                player:popupFYI("Quantidade de itens mudou durante a venda. Tente novamente.")
                return false
            end

            local removedCount = player:removeItemFromBags(item.item.id, requiredCount)
            player:addItem(currency, price)
            player:popupFYI(string.format("Parabens, sua venda foi bem sucedida."))
        elseif item.type == "outfit" then
            if not item.subtype then
                if not player:hasOutfit(item.lookType.type) then
                    player:popupFYI("Voce nao possui este outfit para vender.")
                    return false
                end
                player:removeOutfit(item.lookType.type)
                player:addItem(currency, price)
            else
                local subtype = item.subtype
                if subtype == "wing" then
                    if not player:hasWing(item.name) then
                        player:popupFYI("Voce nao possui esta wing para vender.")
                        return false
                    end
                    player:removeWing(item.name)
                    player:addItem(currency, price)
                elseif subtype == "aura" then
                    if not player:hasAura(item.name) then
                        player:popupFYI("Voce nao possui esta aura para vender.")
                        return false
                    end
                    player:removeAura(item.name)
                    player:addItem(currency, price)
                elseif subtype == "shader" then
                    if not player:hasShader(item.lookType.shader) then
                        player:popupFYI("Voce nao possui este shader para vender.")
                        return false
                    end
                    player:removeShader(item.lookType.shader)
                    player:addItem(currency, price)
                end
            end
        elseif item.type == "pokemon" then
            if not player:hasPokemon(item.pokeName) then
                player:popupFYI("Voce nao possui este pokemon para vender.")
                return false
            end
            player:removePokemon(item.pokeName)
            player:addItem(currency, price)
        end
    end
    return true
end

Player.handleSell = handleSell

function loadSellJSONCache()
    local ok, encoded = pcall(json.encode, SELL_CACHE)
    if ok and type(encoded) == "string" then
        SELL_JSON = encoded
    else
        SELL_JSON = "{}"
    end
end

function loadSellCache()
    SELL_CACHE = {}
    SELL_CACHE.CATEGORY = {}
    SELL_CACHE.ORDEM = SELL_DATA.ORDEM
    SELL_CACHE.STYLES = SELL_DATA.STYLES
    SELL_CACHE.CATEGORYINFO = SELL_DATA.CATEGORYINFO

    for category, list in pairs(SELL_DATA.CATEGORY) do
        SELL_CACHE.CATEGORY[category] = {}
        for id, itemData in ipairs(list) do
            SELL_CACHE.CATEGORY[category][id] = {}
            SELL_CACHE.CATEGORY[category][id].type = itemData.type

            if itemData.type == "outfit" then
                SELL_CACHE.CATEGORY[category][id].lookType = itemData.lookType
                SELL_CACHE.CATEGORY[category][id].name = itemData.name
                SELL_CACHE.CATEGORY[category][id].animated = itemData.animated or false
            elseif itemData.type == "item" then
                local itemType = ItemType(itemData.item.id)
                SELL_CACHE.CATEGORY[category][id].item = {id = itemType:getClientId(), qtd = itemData.item.qtd, name = itemType:getName()}
            elseif itemData.type == "pokemon" then
                local mType = MonsterType(itemData.pokeName)
                if mType then
                    SELL_CACHE.CATEGORY[category][id].lookType = {type = mType and mType:outfit().lookType or 0}
                    SELL_CACHE.CATEGORY[category][id].bonus = {boost = itemData.bonus.boost}
                    SELL_CACHE.CATEGORY[category][id].pokeName = itemData.pokeName
                    SELL_CACHE.CATEGORY[category][id].rank = mType:pokemonRank() or "A"
                end
            end

            SELL_CACHE.CATEGORY[category][id].valor = itemData.valor
            SELL_CACHE.CATEGORY[category][id].offset = itemData.offset
            SELL_CACHE.CATEGORY[category][id].size = itemData.size
            SELL_CACHE.CATEGORY[category][id].backgroundImage = itemData.backgroundImage
            SELL_CACHE.CATEGORY[category][id].moeda = ItemType(itemData.moeda):getClientId()
        end
    end
end

function loadSell()
    if not isSellLoaded then
        local time = os.mtime()
        loadSellCache()
        loadSellJSONCache()
        isSellLoaded = true
    end
end

local function cloneSellEntry(entry)
    local cloned = {}
    for key, value in pairs(entry) do
        cloned[key] = value
    end

    if entry.item then
        cloned.item = {
            id = entry.item.id,
            qtd = entry.item.qtd,
            name = entry.item.name
        }
    end

    if entry.lookType then
        cloned.lookType = {}
        for key, value in pairs(entry.lookType) do
            cloned.lookType[key] = value
        end
    end

    if entry.bonus then
        cloned.bonus = {}
        for key, value in pairs(entry.bonus) do
            cloned.bonus[key] = value
        end
    end

    return cloned
end

local function countPokemonInContainerByName(container, pokeNameLower)
    if not container then
        return 0
    end

    local count = 0
    for i = 0, container:getSize() - 1 do
        local item = container:getItem(i)
        if item then
            if item:isPokeball() then
                local ballPokeName = item:getSpecialAttribute("pokeName")
                if ballPokeName and ballPokeName:lower() == pokeNameLower then
                    count = count + 1
                end
            elseif item:isContainer() then
                count = count + countPokemonInContainerByName(item, pokeNameLower)
            end
        end
    end

    return count
end

local function getSellableQuantityFromEntry(player, categoryName, entry)
    if categoryName == "POKEMONS" then
        local catchBag = player:getCatchBag()
        if not catchBag or not entry.pokeName then
            return 0
        end
        return countPokemonInContainerByName(catchBag, entry.pokeName:lower())
    end

    if entry.item and entry.item.id then
        local serverItemId = nil
        local categoryList = SELL_DATA.CATEGORY[categoryName]
        if categoryList then
            for _, itemData in ipairs(categoryList) do
                if itemData.type == "item" then
                    local itemType = ItemType(itemData.item.id)
                    if itemType and itemType:getClientId() == entry.item.id then
                        serverItemId = itemData.item.id
                        break
                    end
                end
            end
        end

        if not serverItemId then
            return 0
        end

        local inInventory = player:getItemCount(serverItemId)
        local inBags = player:getItemCountInBags(serverItemId)
        return inInventory + inBags
    end

    return 0
end

function Player:sendSellStructure()
    loadSell()

    local structure = {
        ORDEM = SELL_CACHE.ORDEM,
        STYLES = SELL_CACHE.STYLES,
        CATEGORYINFO = SELL_CACHE.CATEGORYINFO,
        type = "structure"
    }

    local ok, encoded = pcall(json.encode, structure)
    if not ok or type(encoded) ~= "string" then
        encoded = "{}"
    end

    return self:sendExtendedOpcode(OPCODE_NEW_SELL, encoded)
end

function Player:sendSellCategory(categoryName)
    loadSell()

    local categoryItems = SELL_CACHE.CATEGORY[categoryName]
    if not categoryName or not categoryItems then
        return false
    end

    local payloadItems = {}
    for index, entry in ipairs(categoryItems) do
        local cloned = cloneSellEntry(entry)
        cloned.availableQuantity = getSellableQuantityFromEntry(self, categoryName, entry)
        payloadItems[index] = cloned
    end

    local categoryPayload = {
        type = "category",
        category = categoryName,
        items = payloadItems
    }

    local ok, encoded = pcall(json.encode, categoryPayload)
    if not ok or type(encoded) ~= "string" then
        encoded = "{}"
    end

    return self:sendExtendedOpcode(OPCODE_NEW_SELL, encoded)
end

function Player:sendSellData()
    return self:sendSellStructure()
end 
