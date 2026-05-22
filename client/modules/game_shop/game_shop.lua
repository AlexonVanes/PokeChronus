local mainWindow = nil
local cachedData = nil
local buttonShop = nil
local CATEGORY_FOCUSED = nil
local createdWindow = nil
local itemPrice = nil
local quantidade_items = 1
local searchCurrency = 0
local searchCurrencyName = "Todas"
local diamondBalance = 0
local diamondTransferWindow = nil
local DIAMOND_CLIENT_ID = 25218

local CURRENCIES = {
    {name = "Todas",         id = 0},
    {name = "Diamond",       id = DIAMOND_CLIENT_ID},
    {name = "Black Diamond", id = 11304},
    {name = "Space Coin",    id = 22298},
    {name = "Online Coin",   id = 22297},
    {name = "Reset Coin",    id = 22296},
    {name = "Goal Coin",     id = 24439},
    {name = "E-Coin",        id = 25726},
}
local acceptWindow = {}
local currentMode = "buy"
local categoryPanel = nil
local categoryVerticalPanel = nil

local loaded = false

local OPCODE_BUY = 87
local OPCODE_SELL = 88

local cachedBuyData = nil
local cachedSellData = nil
local cachedBuyCategories = {}
local cachedSellCategories = {}

function getItemCountInBags(itemId)
    local totalCount = 0
    local localPlayer = g_game.getLocalPlayer()

    if not localPlayer then
        return totalCount
    end

    for i = 1, 10 do
        local item = localPlayer:getInventoryItem(i)
        if item then
            if item:getId() == itemId then
                totalCount = totalCount + item:getCount()
            elseif item:isContainer() then
                totalCount = totalCount + getItemCountInContainer(item, itemId)
            end
        end
    end

    return totalCount
end

function getItemCountInContainer(container, itemId)
    local count = 0

    if not container or not container:isContainer() or not container.getCapacity then
        return count
    end

    local capacity = container:getCapacity()
    if not capacity or capacity <= 0 then
        return count
    end

    for i = 0, capacity - 1 do
        local item = container:getItem(i)
        if item then
            if item:getId() == itemId then
                count = count + item:getCount()
            elseif item:isContainer() then
                count = count + getItemCountInContainer(item, itemId)
            end
        end
    end

    return count
end

local onGameStartHandler = nil
local onGameEndHandler = nil

local function trim(value)
    if not value then
        return ""
    end
    return tostring(value):gsub("^%s*(.-)%s*$", "%1")
end

local function showShopMessage(title, message)
    local messageBox
    messageBox = displayGeneralBox(title, message, {
        {text = "OK", callback = function()
            if messageBox and messageBox:isVisible() then
                messageBox:destroy()
            end
        end},
        anchor = AnchorHorizontalCenter
    })
end

local function shopWidget(id)
    if not mainWindow then
        return nil
    end

    if mainWindow.recursiveGetChildById then
        return mainWindow:recursiveGetChildById(id)
    end
    return mainWindow:getChildById(id)
end

local function bindWalletRelease(widget, callback)
    if not widget then
        return
    end

    widget.onMouseRelease = function(self, mousePos, mouseButton)
        if mouseButton == MouseLeftButton or mouseButton == MouseTouch then
            if not mousePos or self:containsPoint(mousePos) then
                callback()
                return true
            end
        end
        return false
    end
    widget.onTouchRelease = widget.onMouseRelease
end

local function handleDiamondWalletClick(mousePos)
    local rechargeButton = shopWidget('diamondRechargeButton')
    if mousePos and rechargeButton and rechargeButton:containsPoint(mousePos) then
        openDiamondRecharge()
        return true
    end

    openDiamondTransferWindow()
    return true
end

local function setupDiamondWallet()
    local panel = shopWidget('diamondBalancePanel')
    if panel then
        panel.onMouseRelease = function(self, mousePos, mouseButton)
            if mouseButton ~= MouseLeftButton and mouseButton ~= MouseTouch then
                return false
            end

            if mousePos and not self:containsPoint(mousePos) then
                return false
            end

            return handleDiamondWalletClick(mousePos)
        end
        panel.onTouchRelease = panel.onMouseRelease
    end

    local transferButton = shopWidget('diamondTransferButton')
    if transferButton then
        transferButton:setTooltip("Transferir diamantes")
        bindWalletRelease(transferButton, function()
            openDiamondTransferWindow()
        end)
    end

    local rechargeButton = shopWidget('diamondRechargeButton')
    if rechargeButton then
        rechargeButton:setTooltip("Recarregar via Pix")
        bindWalletRelease(rechargeButton, function()
            openDiamondRecharge()
        end)
    end

    local icon = shopWidget('diamondBalanceIcon')
    if icon then
        icon:setItemId(DIAMOND_CLIENT_ID)
        icon:setVirtual(true)
    end
end

function updateDiamondBalance(value, clientId)
    diamondBalance = math.max(0, math.floor(tonumber(value) or 0))

    if clientId then
        DIAMOND_CLIENT_ID = tonumber(clientId) or DIAMOND_CLIENT_ID
        CURRENCIES[2].id = DIAMOND_CLIENT_ID
    end

    if mainWindow then
        setupDiamondWallet()

        local balancePanel = shopWidget('diamondBalancePanel')
        if balancePanel then
            balancePanel:setTooltip("Diamantes: " .. diamondBalance .. "\nSeta: transferir\n+: recarregar via Pix")
        end

        local balanceLabel = shopWidget('diamondBalanceLabel')
        if balanceLabel then
            balanceLabel:setText(tostring(diamondBalance))
        end

        local balanceIcon = shopWidget('diamondBalanceIcon')
        if balanceIcon then
            balanceIcon:setItemId(DIAMOND_CLIENT_ID)
            balanceIcon:setVirtual(true)
        end
    end

    if diamondTransferWindow and not diamondTransferWindow:isDestroyed() then
        local currentBalance = diamondTransferWindow:getChildById('currentBalance')
        if currentBalance then
            currentBalance:setText("Saldo atual: " .. diamondBalance)
        end
    end
end

function requestDiamondBalance()
    local protocol = g_game.getProtocolGame()
    if not protocol or not protocol:isConnected() then
        return
    end

    protocol:sendExtendedOpcode(OPCODE_BUY, json.encode({type = "balance"}))
end

local function bringShopToFront()
    if not mainWindow or mainWindow:isDestroyed() then
        return
    end

    mainWindow:raise()
    if mainWindow.focus then
        mainWindow:focus()
    end

    scheduleEvent(function()
        if mainWindow and not mainWindow:isDestroyed() and mainWindow:isVisible() then
            mainWindow:raise()
            if mainWindow.focus then
                mainWindow:focus()
            end
        end
    end, 1)
end

function init()
    mainWindow = g_ui.loadUI("game_shop", modules.game_interface.getRootPanel())
    if not mainWindow then
        error("Failed to load game_shop UI")
        return
    end
    categoryPanel = mainWindow.panelCategorias
    categoryVerticalPanel = mainWindow.verticalPanel
    mainWindow:setFocusable(true)
    mainWindow:setDraggable(true)
    mainWindow.onMousePress = function()
        bringShopToFront()
        return false
    end

    local headerBar = mainWindow:getChildById('headerBar')
    if headerBar then
        headerBar:setDraggable(true)
        headerBar.onDragEnter = function(widget, mousePos)
            bringShopToFront()
            return mainWindow:onDragEnter(mousePos)
        end
        headerBar.onDragMove = function(widget, mousePos, mouseMoved)
            return mainWindow:onDragMove(mousePos, mouseMoved)
        end
        headerBar.onDragLeave = function(widget, droppedWidget, mousePos)
            return mainWindow:onDragLeave(droppedWidget, mousePos)
        end
    end
    ProtocolGame.registerExtendedOpcode(OPCODE_BUY, receiveOpcode)
    ProtocolGame.registerExtendedOpcode(OPCODE_SELL, receiveOpcode)
    buttonShop = modules.client_topmenu.addRightGameToggleButton("buttonShop", tr("Loja"), "assets/topbutton/diamond", toggleShop, true)
    mainWindow:hide()
    updateDiamondBalance(0)
    onGameStartHandler = function()
        if not mainWindow or mainWindow:isDestroyed() then return end
        closeDiamondTransferWindow()
        mainWindow:hide()
        loaded = false
        cachedBuyData = nil
        cachedSellData = nil
        cachedData = nil
        cachedBuyCategories = {}
        cachedSellCategories = {}
        CATEGORY_FOCUSED = nil
        scheduleEvent(function()
            modules.game_request.sendRequest("shop")
            requestDiamondBalance()
        end, 200)
    end
    onGameEndHandler = function()
        closeDiamondTransferWindow()
        if mainWindow and not mainWindow:isDestroyed() then
            mainWindow:hide()
        end
    end
    connect(g_game, {
        onGameStart = onGameStartHandler,
        onGameEnd = onGameEndHandler
    })
    currentMode = "buy"
    local modeButton = mainWindow:getChildById('modeButton')
    if modeButton then
        modeButton:setText("Modo: Compra")
        modeButton.onClick = function()
            setMode(currentMode == "buy" and "sell" or "buy")
        end
    end
    connect(mainWindow, { onShow = function()
        bringShopToFront()
        requestDiamondBalance()
        if not cachedData or not cachedData.ORDEM or #cachedData.ORDEM == 0 then
            forceLoadShop()

            local attempts = 0
            local function waitForData()
                if not mainWindow then return end

                attempts = attempts + 1
                if attempts > 20 then
                    return
                end

                if cachedData and cachedData.ORDEM and #cachedData.ORDEM > 0 then
                    generateShopInterface()
                else
                    scheduleEvent(waitForData, 100)
                end
            end
            scheduleEvent(waitForData, 100)
            return
        end

        generateShopInterface()
    end, onHide = function()
        searchCurrency = 0
        searchCurrencyName = "Todas"
        if mainWindow and mainWindow.typeMoeda then
            mainWindow.typeMoeda:setText("Moeda: Todas")
        end
    end})
end

function terminate()
    if onGameStartHandler or onGameEndHandler then
        disconnect(g_game, {
            onGameStart = onGameStartHandler,
            onGameEnd = onGameEndHandler
        })
        onGameStartHandler = nil
        onGameEndHandler = nil
    end

    ProtocolGame.unregisterExtendedOpcode(OPCODE_BUY, receiveOpcode)
    ProtocolGame.unregisterExtendedOpcode(OPCODE_SELL, receiveOpcode)

    closeDiamondTransferWindow()

    if mainWindow and not mainWindow:isDestroyed() then
        mainWindow:destroy()
    end
    mainWindow = nil

    if buttonShop then
        buttonShop:destroy()
        buttonShop = nil
    end
end

function receiveOpcode(protocol, opcode, data)
    local success, decodedData = pcall(json.decode, data)
    if not success or type(decodedData) ~= "table" then
        return 
    end

    if opcode == OPCODE_BUY then
        if decodedData.type == "balance" then
            updateDiamondBalance(decodedData.diamonds or decodedData.balance, decodedData.diamondClientId)
            return
        elseif decodedData.type == "transferResult" then
            if decodedData.diamonds or decodedData.balance then
                updateDiamondBalance(decodedData.diamonds or decodedData.balance, decodedData.diamondClientId)
            end
            if decodedData.success then
                closeDiamondTransferWindow()
            end
            return
        end

        if decodedData.type == "structure" then
            cachedBuyData = {
                ORDEM = decodedData.ORDEM,
                STYLES = decodedData.STYLES,
                CATEGORYINFO = decodedData.CATEGORYINFO,
                CATEGORY = {}
            }
            cachedBuyCategories = {}

            if currentMode == "buy" then
                cachedData = cachedBuyData
                if cachedData.ORDEM and #cachedData.ORDEM > 0 then
                    local firstCategory = cachedData.ORDEM[1]
                    CATEGORY_FOCUSED = firstCategory
                    requestShopCategory(firstCategory)
                end

                if mainWindow and mainWindow:isVisible() then
                    generateShop()
                end
            end

        elseif decodedData.type == "category" then
            local categoryName = decodedData.category

            cachedBuyCategories[categoryName] = decodedData.items

            if cachedBuyData and cachedBuyData.CATEGORY then
                cachedBuyData.CATEGORY[categoryName] = decodedData.items
            end

            if currentMode == "buy" then
                cachedData = cachedBuyData

                if mainWindow and mainWindow:isVisible() and CATEGORY_FOCUSED == categoryName then
                    generateShopCategory(categoryName)
                end
            end

        else
            cachedBuyData = decodedData

            if currentMode == "buy" then
                cachedData = cachedBuyData
                if mainWindow and mainWindow:isVisible() then
                    generateShop()
                    if CATEGORY_FOCUSED then
                        generateShopCategory(CATEGORY_FOCUSED)
                    end
                end
            end
        end

    elseif opcode == OPCODE_SELL then
        if decodedData.type == "structure" then
            cachedSellData = {
                ORDEM = decodedData.ORDEM,
                STYLES = decodedData.STYLES,
                CATEGORYINFO = decodedData.CATEGORYINFO,
                CATEGORY = {}
            }
            cachedSellCategories = {}

            if currentMode == "sell" then
                cachedData = cachedSellData
                if cachedData.ORDEM and #cachedData.ORDEM > 0 then
                    CATEGORY_FOCUSED = cachedData.ORDEM[1]
                    requestShopCategory(CATEGORY_FOCUSED)
                end

                if mainWindow and mainWindow:isVisible() then
                    generateShop()
                end
            end
        elseif decodedData.type == "category" then
            local categoryName = decodedData.category
            cachedSellCategories[categoryName] = decodedData.items

            if cachedSellData and cachedSellData.CATEGORY then
                cachedSellData.CATEGORY[categoryName] = decodedData.items
            end

            if currentMode == "sell" then
                cachedData = cachedSellData
                if mainWindow and mainWindow:isVisible() and CATEGORY_FOCUSED == categoryName then
                    generateShopCategory(categoryName)
                end
            end
        else
            cachedSellData = decodedData
            if currentMode == "sell" then
                cachedData = cachedSellData
                if mainWindow and mainWindow:isVisible() then
                    generateShop()
                    if CATEGORY_FOCUSED then
                        generateShopCategory(CATEGORY_FOCUSED)
                    end
                end
            end
        end
    end

    loaded = true

    if mainWindow and mainWindow:isVisible() and cachedData and cachedData.ORDEM and #cachedData.ORDEM > 0 then
        if not CATEGORY_FOCUSED then
            CATEGORY_FOCUSED = cachedData.ORDEM[1]
            requestShopCategory(CATEGORY_FOCUSED)
        end
        if categoryPanel and categoryPanel:getChildCount() == 0 then
            generateShop()
        end
    end
end

function updateCategorySelection(categoryName)
    if not categoryPanel then return end

    local children = categoryPanel:getChildCount()
    for i = 1, children do
        local child = categoryPanel:getChildByIndex(i)
        if child and child:getId() == categoryName then
            child:focus()
            break
        end
    end
end

function requestShopCategory(categoryName, forceRefresh)
    if not categoryName then return end

    local cacheTable = currentMode == "buy" and cachedBuyCategories or cachedSellCategories
    if cacheTable[categoryName] and not forceRefresh then
        return
    end

    if currentMode == "buy" then
        modules.game_request.sendRequest("shop_category:" .. categoryName)
    else
        modules.game_request.sendRequest("sell_category:" .. categoryName)
    end
end

function showVertical()
    hideClube()
    categoryVerticalPanel:setVisible(true)
    mainWindow.verticalBar:setVisible(true)
end

function showHorizontal()
    hideClube()
    categoryVerticalPanel:setVisible(false)
    mainWindow.verticalBar:setVisible(false)
end

function hideBoth()
    hideClube()
    categoryVerticalPanel:setVisible(false)
    mainWindow.verticalBar:setVisible(false)
end

function showClube()
    hideBoth()
    if mainWindow.vipPanel then mainWindow.vipPanel:setVisible(true) end
    mainWindow.vipImage:setVisible(true)
    mainWindow.clubBeneficiosTopText:setVisible(true)
    mainWindow.verticalTextBar:setVisible(true)
    mainWindow.backgroundClubText:setVisible(true)
    mainWindow.VIP_BUY:setVisible(true)
    mainWindow.vip_info:setVisible(true)
    mainWindow.typeMoeda:setVisible(false)
end

function hideClube()
    if mainWindow.vipPanel then mainWindow.vipPanel:setVisible(false) end
    mainWindow.vipImage:setVisible(false)
    mainWindow.clubBeneficiosTopText:setVisible(false)
    mainWindow.verticalTextBar:setVisible(false)
    mainWindow.backgroundClubText:setVisible(false)
    mainWindow.VIP_BUY:setVisible(false)
    mainWindow.vip_info:setVisible(false)
    mainWindow.typeMoeda:setVisible(true)
end

function generateShop()
    if not mainWindow then return end
    if not categoryPanel then return end

    if not cachedData then
        if currentMode == "buy" then
            cachedData = cachedBuyData
        else
            cachedData = cachedSellData
        end
    end

    if not cachedData or not cachedData.CATEGORY or not cachedData.ORDEM or not cachedData.CATEGORYINFO then
        return
    end

    categoryPanel:destroyChildren()
    local categories = cachedData.CATEGORY
    local categoriesOrdem = cachedData.ORDEM
    local categoriesInfo = cachedData.CATEGORYINFO

    if not CATEGORY_FOCUSED then
        if currentMode == "sell" then
            local hasPokemons = false
            if categories.POKEMONS then
                for _, item in ipairs(categories.POKEMONS) do
                    if item.availableQuantity and item.availableQuantity > 0 then
                        hasPokemons = true
                        break
                    end
                end
            end

            if hasPokemons and categories.POKEMONS then
                CATEGORY_FOCUSED = "POKEMONS"
            elseif categories.ITEMS then
                CATEGORY_FOCUSED = "ITEMS"
            else
                CATEGORY_FOCUSED = categoriesOrdem[1]
            end
        else
            CATEGORY_FOCUSED = categoriesOrdem[1]
        end
    end

    for id, category in pairs(categoriesOrdem) do
        local widget = g_ui.createWidget("baseCategoria", categoryPanel)
        widget:setId(category)
        widget.onClick = function() 
            CATEGORY_FOCUSED = category
            generateShopCategory(category)
        end
        local infos = categoriesInfo[category]
        widget:setIcon(infos.icon)
        widget:setIconSize(infos.size)
        widget:setIconOffsetX(infos.iconOffet.x + 10)
        widget:setIconOffsetY(infos.iconOffet.y)
        widget:setText(category)

        if category == CATEGORY_FOCUSED then
            widget:focus()
        end
    end

end

function generateShopCategory(categoryName)
    if not mainWindow then 
        return 
    end
    if not categoryVerticalPanel then
        return
    end
    if not cachedData then 
        return 
    end
    if not cachedData.CATEGORY then 
        return 
    end

    CATEGORY_FOCUSED = categoryName

    updateCategorySelection(categoryName)

    if not cachedData.CATEGORY[categoryName] then
        requestShopCategory(categoryName)

        if categoryVerticalPanel then
            categoryVerticalPanel:destroyChildren()
        end
        return
    end

    if mainWindow.typeMoeda then
        mainWindow.typeMoeda:setText("Moeda: " .. searchCurrencyName)
    end

    if categoryVerticalPanel then
        categoryVerticalPanel:destroyChildren()
    end

    local layout = categoryVerticalPanel:getLayout()
    if categoryName == "PACKS" then
        layout:setCellSize({width = 192, height = 220})
        layout:setNumColumns(2)
    else
        layout:setCellSize({width = 100, height = 116})
        layout:setNumColumns(4)
    end

    setupCurrencyMenu()

    local list = cachedData.CATEGORY[categoryName]
    if not list then 
        return 
    end

    for id, itemInfo in ipairs(list) do
        if not itemInfo then goto continue end

        local type = itemInfo.type
        if categoryName == "ASSINATURA" and type == "clube" then
            showClube()
            mainWindow.vip_info:setTooltip(itemInfo.info)
            local textBox = mainWindow.backgroundClubText.text
            textBox:setText(itemInfo.beneficios)
            textBox:setSize('170 ' .. #itemInfo.beneficios + 100)
            return
        end

        local style = cachedData.STYLES[type]
        if not style then goto continue end

        local widget = g_ui.createWidget(style, categoryVerticalPanel)
        if not widget then goto continue end

        widget:setId(id)
        widget.category = categoryName
        local SKIP_BG = {
          ["default_item"]   = true,
          ["default_item2"]  = true,
          ["default_item22"] = true,
          ["pascoa"]         = true,
        }
        if itemInfo.backgroundImage
           and not SKIP_BG[itemInfo.backgroundImage]
           and type ~= "pack" then
          widget:setImageSource("assets/backgrounds/" .. itemInfo.backgroundImage)
        end
        widget.preco:setText(itemInfo.valor)
        widget.icon_currency:setItemId(itemInfo.moeda)
        widget.icon_currency:setVirtual(true)

        widget.onClick = function() createWindow(id, widget) end

        setupItemWidget(widget, itemInfo, type)

        ::continue::
    end

    if searchCurrency ~= 0 then
        onSearchCurrency(searchCurrency)
    end
end

function setupCurrencyMenu()
    if not mainWindow.typeMoeda then return end

    mainWindow.typeMoeda.onMouseRelease = function(widget, mousePos, mouseButton)
        if mouseButton == MouseRightButton or mouseButton == MouseLeftButton then
            local menu = g_ui.createWidget("PopupMenu")
            menu:setGameMenu(true)

            for _, currency in ipairs(CURRENCIES) do
                menu:addOption(currency.name, function()
                    searchCurrencyName = currency.name
                    mainWindow.typeMoeda:setText("Moeda: " .. currency.name)
                    onSearchCurrency(currency.id)
                end)
            end

            menu:display(pos)
        end
    end
end

function setupItemWidget(widget, itemInfo, type)
    if type == "item" then
        showVertical()
        widget.item:setItemId(itemInfo.item.id)
        widget.item:setMarginLeft(itemInfo.offset.x)
        widget.item:setMarginTop(itemInfo.offset.y)
        widget.item:setSize(itemInfo.size)
        widget.item:setItemCount(itemInfo.item.qtd)
        widget.item:setVirtual(true)
        setupItemName(widget, itemInfo.item.name)

    elseif type == "outfit" then
        showVertical()
        setupOutfitWidget(widget, itemInfo)
    elseif type == "pokemon" then
        showVertical()
        setupPokemonWidget(widget, itemInfo)
    elseif type == "shader" then
        showVertical()
        setupShaderWidget(widget, itemInfo)
    elseif type == "wings" then
        showVertical()
        setupWingsWidget(widget, itemInfo)
    elseif type == "aura" then
        showVertical()
        setupAuraWidget(widget, itemInfo)
    elseif type == "pack" then
        showVertical()
        setupPackWidget(widget, itemInfo)
    else
        hideBoth()
    end
end

function setupItemName(widget, name)
    widget.tooltipName:setTooltip(name)
    if #name > 9 then
        name = string.sub(name, 1, 9) .. ".."
    end
    widget.name:setText(name)
end

local function buildPokemonTooltip(itemInfo)
    if not itemInfo then
        return nil
    end

    local name = itemInfo.pokeName or itemInfo.name or "Pokemon"
    local stats = itemInfo.pokemonStats
    if not stats then
        return name
    end

    local lines = {name, "\n\nStatus:"}

    if stats.health and stats.health > 0 then
        table.insert(lines, "\nVida: " .. stats.health)
    end

    if stats.moveMagicAttackBase and stats.moveMagicAttackBase > 0 then
        table.insert(lines, "\nAtaque Magico: " .. stats.moveMagicAttackBase)
    end

    if stats.moveMagicDefenseBase and stats.moveMagicDefenseBase > 0 then
        table.insert(lines, "\nDefesa Magica: " .. stats.moveMagicDefenseBase)
    end

    return table.concat(lines)
end

function setupOutfitWidget(widget, itemInfo)
    widget.outfit:setOutfit(itemInfo.lookType)
    widget.outfit:setMarginLeft(itemInfo.offset.x)
    widget.outfit:setMarginTop(itemInfo.offset.y)
    widget.outfit:setOldScaling(true)
    widget.outfit:setSize(itemInfo.size)
    if itemInfo.subtype == "shader" or itemInfo.subtype == "wings" or itemInfo.subtype == "aura" or itemInfo.animated == true then
        widget.outfit:setAnimate(true)
    end
    setupItemName(widget, itemInfo.name)
end

function setupPokemonWidget(widget, itemInfo)
    widget.outfit:setOutfit(itemInfo.lookType)
    widget.outfit:setMarginLeft(itemInfo.offset.x)
    widget.outfit:setMarginTop(itemInfo.offset.y)
    widget.outfit:setOldScaling(true)
    widget.outfit:setSize(itemInfo.size)
    local rank = itemInfo.rank or "A"
    local rankImagePath = "assets/ranks/" .. rank .. "special"
    if g_resources.fileExists(rankImagePath .. ".png") then
        widget.iconRank:setImageSource(rankImagePath)
        widget.iconRank:setVisible(true)
    else
        widget.iconRank:setVisible(false)
    end
    widget.iconRank:setMarginBottom(widget.iconRank:getHeight() * 1.5)
    widget.iconRank:setMarginRight(widget.iconRank:getWidth() / 2)
    setupItemName(widget, itemInfo.pokeName)

    local tooltip = buildPokemonTooltip(itemInfo)
    if tooltip then
        widget:setTooltip(tooltip)
        widget.outfit:setTooltip(tooltip)
        widget.tooltipName:setTooltip(tooltip)
    end

end

function setupShaderWidget(widget, itemInfo)
    widget.outfit:setOutfit({type = 510, shader = itemInfo.shaderId})
    widget.outfit:setMarginLeft(itemInfo.offset.x)
    widget.outfit:setMarginTop(itemInfo.offset.y)
    widget.outfit:setOldScaling(true)
    widget.outfit:setSize(itemInfo.size)
    widget.outfit:setAnimate(true)
    setupItemName(widget, itemInfo.name)
end

function setupWingsWidget(widget, itemInfo)
    widget.outfit:setOutfit({type = 510, wings = itemInfo.wingsId})
    widget.outfit:setMarginLeft(itemInfo.offset.x)
    widget.outfit:setMarginTop(itemInfo.offset.y)
    widget.outfit:setOldScaling(true)
    widget.outfit:setSize(itemInfo.size)
    widget.outfit:setAnimate(true)
    setupItemName(widget, itemInfo.name)
end

function setupAuraWidget(widget, itemInfo)
    widget.outfit:setOutfit({type = 510, aura = itemInfo.auraId})
    widget.outfit:setMarginLeft(itemInfo.offset.x)
    widget.outfit:setMarginTop(itemInfo.offset.y)
    widget.outfit:setOldScaling(true)
    widget.outfit:setSize(itemInfo.size)
    widget.outfit:setAnimate(true)
    setupItemName(widget, itemInfo.name)
end

function setupPackWidget(widget, itemInfo)
    local packName = itemInfo.name or "Pack"
    local packDescription = itemInfo.description or "Pacote de itens"
    widget.name:setText(packName)
    widget.tooltipName:setTooltip(packDescription)

    local hasDisplayItems = itemInfo.displayItems and #itemInfo.displayItems > 0

    if hasDisplayItems then
        widget.outfit:setVisible(false)
        if widget.iconRank then
            widget.iconRank:setVisible(false)
        end

        local displayPanel = g_ui.createWidget('UIWidget', widget)
        displayPanel:setId('displayItemsPanel')
        local layout = UIHorizontalLayout.create(displayPanel)
        layout:setSpacing(4)
        layout:setFitChildren(true)
        displayPanel:setLayout(layout)

        displayPanel:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
        displayPanel:addAnchor(AnchorVerticalCenter, 'parent', AnchorVerticalCenter)
        displayPanel:setMarginBottom(30)
        displayPanel:setPhantom(true)

        local itemSize = 32
        local totalWidth = (#itemInfo.displayItems * (itemSize + 4)) - 4
        displayPanel:setSize({width = totalWidth, height = itemSize})

        for _, displayId in ipairs(itemInfo.displayItems) do
            local itemWidget = g_ui.createWidget('UIItem', displayPanel)
            itemWidget:setSize({width = itemSize, height = itemSize})
            itemWidget:setItemId(displayId)
            itemWidget:setVirtual(true)
            itemWidget:setPhantom(true)
        end

        widget:setTooltip(packDescription)
        widget.tooltipName:setTooltip(packDescription)

        for i = 1, #itemInfo.items do
            local packItem = itemInfo.items[i]
            if packItem.type == "item" then
                local containerWidget = g_ui.createWidget('packItemWidget', widget.itemsPanel)
                local itemWidget = containerWidget:getChildById('itemWidget')
                itemWidget:setItemId(packItem.id)
                itemWidget:setItemCount(packItem.qtd)

                local tooltipText = ""
                local itemName = packItem.name or "Item"
                if packItem.qtd > 1 then
                    tooltipText = string.format("%dx %s\nParte do Pack %s", packItem.qtd, itemName, itemInfo.name)
                else
                    tooltipText = string.format("%s\nParte do Pack %s", itemName, itemInfo.name)
                end

                containerWidget:setTooltip(tooltipText)
                itemWidget:setTooltip(tooltipText)
            end
        end
    elseif itemInfo and itemInfo.items and #itemInfo.items > 0 then
        local firstItem = itemInfo.items[1]
        if firstItem and firstItem.type == "pokemon" then
            if firstItem.lookType and firstItem.lookType.type and firstItem.lookType.type > 0 then
                widget.outfit:setOutfit(firstItem.lookType)
            else
                widget.outfit:setOutfit({type = 510})
            end
            widget.outfit:setMarginLeft(0)
            widget.outfit:setMarginTop(0)
            widget.outfit:setOldScaling(true)
            widget.outfit:setSize("48 48")

            if firstItem.rank and widget.iconRank then
                local rank = firstItem.rank
                local rankImagePath = "assets/ranks/" .. rank .. "special"
                if g_resources.fileExists(rankImagePath .. ".png") then
                    widget.iconRank:setImageSource(rankImagePath)
                    widget.iconRank:setVisible(true)
                    widget.iconRank:setMarginBottom(widget.iconRank:getHeight() * 1.5)
                    widget.iconRank:setMarginRight(widget.iconRank:getWidth() / 2)
                else
                    widget.iconRank:setVisible(false)
                end
            end

            local tooltip = buildPokemonTooltip(firstItem)
            if packDescription and packDescription ~= "" then
                if tooltip then
                    tooltip = tooltip .. "\n\nDescricao do Pack:\n" .. packDescription
                else
                    tooltip = packDescription
                end
            end

            if tooltip then
                widget:setTooltip(tooltip)
                widget.outfit:setTooltip(tooltip)
                widget.tooltipName:setTooltip(tooltip)
            end
        end

        for i = 2, #itemInfo.items do
            local packItem = itemInfo.items[i]
            if packItem.type == "item" then
                local containerWidget = g_ui.createWidget('packItemWidget', widget.itemsPanel)
                local itemWidget = containerWidget:getChildById('itemWidget')
                itemWidget:setItemId(packItem.id)
                itemWidget:setItemCount(packItem.qtd)

                local tooltipText = ""
                local itemName = packItem.name or "Item"
                if packItem.qtd > 1 then
                    tooltipText = string.format("%dx %s\nParte do Pack %s", packItem.qtd, itemName, itemInfo.name)
                else
                    tooltipText = string.format("%s\nParte do Pack %s", itemName, itemInfo.name)
                end

                containerWidget:setTooltip(tooltipText)
                itemWidget:setTooltip(tooltipText)
            end
        end
    else
        widget.outfit:setOutfit({type = 510})
        widget.outfit:setMarginLeft(0)
        widget.outfit:setMarginTop(0)
        widget.outfit:setOldScaling(true)
        widget.outfit:setSize("48 48")
    end

    if #packName > 13 then
        packName = string.sub(packName, 1, 13) .. ".."
        widget.name:setText(packName)
    end

end

function generateShopInterface()
    if not cachedData then
        cachedData = cachedBuyData or cachedSellData
    end

    if not cachedData or not cachedData.ORDEM or #cachedData.ORDEM == 0 then
        if mainWindow and mainWindow:isVisible() then
            if categoryPanel then
                categoryPanel:destroyChildren()
            end
            if categoryVerticalPanel then
                categoryVerticalPanel:destroyChildren()
            end
        end
        return false
    end

    if not CATEGORY_FOCUSED then
        CATEGORY_FOCUSED = cachedData.ORDEM[1]
    end

    generateShop()

    local cacheTable = currentMode == "buy" and cachedBuyCategories or cachedSellCategories
    if cacheTable[CATEGORY_FOCUSED] or (cachedData.CATEGORY and cachedData.CATEGORY[CATEGORY_FOCUSED]) then
        generateShopCategory(CATEGORY_FOCUSED)
    else
        requestShopCategory(CATEGORY_FOCUSED)
    end

    return true
end

function toggleShop()
    if mainWindow:isVisible() then
        mainWindow:hide()
        return
    end

    if not loaded or not cachedData or not cachedData.ORDEM or #cachedData.ORDEM == 0 then
        forceLoadShop()
        requestDiamondBalance()

        mainWindow:show()
        bringShopToFront()

        local attempts = 0
        local function waitAndLoad()
            if not mainWindow then return end

            attempts = attempts + 1
            if attempts > 15 then
                if cachedData and cachedData.ORDEM then
                    generateShopInterface()
                end
                return
            end

            if cachedData and cachedData.ORDEM and #cachedData.ORDEM > 0 then
                generateShopInterface()
            else
                scheduleEvent(waitAndLoad, 100)
            end
        end
        scheduleEvent(waitAndLoad, 50)
    else
        mainWindow:show()
        bringShopToFront()
        requestDiamondBalance()
        generateShopInterface()
    end
end

function sendBuffer(id, category)
    local cancelFunc = function()
        acceptWindow[#acceptWindow]:destroy()
        acceptWindow = {}
    end

    local acceptFunc = function()
        acceptWindow[#acceptWindow]:destroy()
        acceptWindow = {}
        if currentMode == "buy" then
            sendBuyAttempt(CATEGORY_FOCUSED, id)
        else
            local sellCategory = category or CATEGORY_FOCUSED
            if sellCategory == "POKEMONS" then
                local cancelRefund = function()
                    acceptWindow[#acceptWindow]:destroy()
                    acceptWindow = {}
                end
                local acceptRefundYes = function()
                    acceptWindow[#acceptWindow]:destroy()
                    acceptWindow = {}
                    sendSellAttempt(sellCategory, id, true)
                end
                local acceptRefundNo = function()
                    acceptWindow[#acceptWindow]:destroy()
                    acceptWindow = {}
                    sendSellAttempt(sellCategory, id, false)
                end
                if #acceptWindow > 0 then
                    acceptWindow[#acceptWindow]:destroy()
                end
                acceptWindow[#acceptWindow + 1] = displayGeneralBox("CONFIRMAR",
                    "Deseja receber os itens do seu Pokemon de volta por 25% a menos do preco dele?",
                {
                    {text = "Sim (receber itens, -25%)", callback = acceptRefundYes},
                    {text = "Nao (preco total)", callback = acceptRefundNo},
                    {text = "Cancelar", callback = cancelRefund},
                    anchor = AnchorHorizontalCenter
                }, acceptRefundYes, cancelRefund)
            else
                sendSellAttempt(sellCategory, id)
            end
        end
    end

    if #acceptWindow > 0 then
        acceptWindow[#acceptWindow]:destroy()
    end

    local text = currentMode == "buy" and "Voce deseja comprar?" or "Voce deseja vender?"
    acceptWindow[#acceptWindow + 1] = displayGeneralBox("CONFIRMAR", text,
    {
        {text = currentMode == "buy" and "Comprar" or "Vender", callback = acceptFunc},
        {text = "Cancelar", callback = cancelFunc},
        anchor = AnchorHorizontalCenter
    }, acceptFunc, cancelFunc)
end

function onSearch()
    local searchWidget = mainWindow.searchTextEdit
    local text = searchWidget:getText()
    local children = categoryVerticalPanel:getChildCount()

    for i = 1, children do
        local child = categoryVerticalPanel:getChildByIndex(i)
        local offerName = child.tooltipName:getTooltip():lower()
        local shouldShow = text:len() < 1 or offerName:find(text:lower())
        shouldShow = shouldShow and (searchCurrency == 0 or child.icon_currency:getItemId() == searchCurrency)
        child:setVisible(shouldShow)
    end
end

function onSearchCurrency(ID)
    searchCurrency = ID
    if not categoryVerticalPanel then return end

    local children = categoryVerticalPanel:getChildCount()
    for i = 1, children do
        local child = categoryVerticalPanel:getChildByIndex(i)
        child:setVisible(ID == 0 or child.icon_currency:getItemId() == ID)
    end
end

function showShop()
    if not mainWindow then return end
    if mainWindow:isVisible() then
        bringShopToFront()
        return
    end
    toggleShop()
end

function sendBuyAttempt(category, id)
    if createdWindow then
        createdWindow:destroy()
        createdWindow = nil
    end

    local buffer = {
        type = "buy",
        info = {
            category = category,
            id = id,
            quantity = quantidade_items or 1
        }
    }
    local protocol = g_game.getProtocolGame()
    if not protocol or not protocol:isConnected() then
        return
    end
    protocol:sendExtendedOpcode(OPCODE_BUY, json.encode(buffer))
    scheduleEvent(requestDiamondBalance, 300)
end

function openDiamondTransferWindow()
    if not mainWindow then return end

    if diamondTransferWindow then
        if diamondTransferWindow:isDestroyed() then
            diamondTransferWindow = nil
        else
            diamondTransferWindow:show()
            diamondTransferWindow:raise()
            diamondTransferWindow:focus()
            requestDiamondBalance()
            return
        end
    end

    diamondTransferWindow = g_ui.createWidget("diamondTransferWindow", mainWindow)
    if not diamondTransferWindow then
        return
    end

    diamondTransferWindow:show()
    diamondTransferWindow:raise()
    diamondTransferWindow:focus()

    local currentBalance = diamondTransferWindow:getChildById('currentBalance')
    if currentBalance then
        currentBalance:setText("Saldo atual: " .. diamondBalance)
    end

    local targetName = diamondTransferWindow:getChildById('targetName')
    if targetName then
        targetName:clearText()
        targetName:focus()
    end

    local amountEdit = diamondTransferWindow:getChildById('amount')
    if amountEdit then
        amountEdit:clearText()
    end

    requestDiamondBalance()
end

function closeDiamondTransferWindow()
    if diamondTransferWindow and not diamondTransferWindow:isDestroyed() then
        diamondTransferWindow:destroy()
    end
    diamondTransferWindow = nil
end

function openDiamondRecharge()
    if modules.game_donate then
        if modules.game_donate.openRechargeWindow then
            modules.game_donate.openRechargeWindow()
            return
        elseif modules.game_donate.openWindow then
            modules.game_donate.openWindow()
            return
        elseif modules.game_donate.toggle then
            modules.game_donate.toggle()
            return
        end
    end

    showShopMessage("Recarga", "Modulo de Pix indisponivel.")
end

function confirmDiamondTransfer()
    if not diamondTransferWindow or diamondTransferWindow:isDestroyed() then
        return
    end

    local targetWidget = diamondTransferWindow:getChildById('targetName')
    local amountWidget = diamondTransferWindow:getChildById('amount')
    local targetName = trim(targetWidget and targetWidget:getText() or "")
    local amount = math.floor(tonumber(amountWidget and amountWidget:getText() or "") or 0)

    if targetName == "" then
        showShopMessage("Transferir", "Informe o nome do jogador.")
        return
    end

    if amount < 1 then
        showShopMessage("Transferir", "Informe uma quantidade valida.")
        return
    end

    if amount > diamondBalance then
        showShopMessage("Transferir", "Voce nao possui essa quantidade de diamantes.")
        return
    end

    local protocol = g_game.getProtocolGame()
    if not protocol or not protocol:isConnected() then
        return
    end

    protocol:sendExtendedOpcode(OPCODE_BUY, json.encode({
        type = "transferDiamonds",
        info = {
            target = targetName,
            amount = amount
        }
    }))
    scheduleEvent(requestDiamondBalance, 300)
end

function sendSellAttempt(category, id, wantRefund)
    if createdWindow then
        createdWindow:destroy()
        createdWindow = nil
    end

    if not cachedData or not cachedData.CATEGORY or not cachedData.CATEGORY[category] then
        return
    end

    local itemInfo = cachedData.CATEGORY[category][id]
    if not itemInfo then
        return
    end

    local quantidade = quantidade_items or 1
    if quantidade <= 0 then
        quantidade = 1
    end

    local buffer = {
        type = "sell",
        category = category,
        quantity = quantidade
    }

    if category == "POKEMONS" and itemInfo.type == "pokemon" then
        buffer.pokeName = itemInfo.pokeName
        buffer.wantRefund = (wantRefund == true)
    else
        buffer.id = math.floor(itemInfo.item.id)
    end

    local protocol = g_game.getProtocolGame()
    if not protocol or not protocol:isConnected() then
        return
    end

    local encodedBuffer = json.encode(buffer)
    if not encodedBuffer then
        return
    end

    protocol:sendExtendedOpcode(OPCODE_SELL, encodedBuffer)
end

function setMode(mode)
    if not mainWindow then return end

    quantidade_items = 1
    if mode == currentMode then return end
    currentMode = mode

    local modeButton = mainWindow:getChildById('modeButton')
    if modeButton then
        modeButton:setText("Modo: " .. (mode == "buy" and "Compra" or "Venda"))
        modeButton:setOn(mode == "sell")
    end

    CATEGORY_FOCUSED = nil

    if mode == "buy" then
        if cachedBuyData and cachedBuyData.ORDEM then
            cachedData = cachedBuyData

            if mainWindow and mainWindow:isVisible() then
                generateShop()

                if cachedData.ORDEM and #cachedData.ORDEM > 0 then
                    CATEGORY_FOCUSED = cachedData.ORDEM[1]

                    if not cachedBuyCategories[CATEGORY_FOCUSED] then
                        requestShopCategory(CATEGORY_FOCUSED)
                    else
                        generateShopCategory(CATEGORY_FOCUSED)
                    end
                end
            end
        else
            cachedData = nil
            modules.game_request.sendRequest("shop")

            local attempts = 0
            local function waitForStructure()
                if not mainWindow then return end

                attempts = attempts + 1
                if attempts > 20 then return end

                if cachedBuyData and cachedBuyData.ORDEM then
                    cachedData = cachedBuyData
                    if mainWindow and mainWindow:isVisible() then
                        generateShop()
                        if CATEGORY_FOCUSED then
                            generateShopCategory(CATEGORY_FOCUSED)
                        end
                    end
                else
                    scheduleEvent(waitForStructure, 100)
                end
            end
            scheduleEvent(waitForStructure, 100)
        end

    else
        cachedData = nil
        cachedSellData = nil
        cachedSellCategories = {}
        modules.game_request.sendRequest("sell")

        local function atualizarSell()
            if not mainWindow then return end

            if cachedSellData then
                cachedData = cachedSellData
                if mainWindow and mainWindow:isVisible() then
                    generateShop()
                    if CATEGORY_FOCUSED then
                        generateShopCategory(CATEGORY_FOCUSED)
                    end
                end
            else
                scheduleEvent(atualizarSell, 100)
            end
        end
        scheduleEvent(atualizarSell, 100)
    end
end

function createWindow(id, widget)
    if not id or not widget then return end

    if type(id) == "string" then
        id = tonumber(id) or id
    end

    if currentMode == "buy" then
        createBuyWindow(id, widget)
    else
        local category = widget.category
        if not category then return end

        requestShopCategory(category, true)

        local attempts = 0
        local function waitSellCategoryAndOpen()
            if not mainWindow then return end

            attempts = attempts + 1
            if attempts > 20 then
                return
            end

            if not cachedData or not cachedData.CATEGORY or not cachedData.CATEGORY[category] then
                scheduleEvent(waitSellCategoryAndOpen, 100)
                return
            end

            local itemInfo = cachedData.CATEGORY[category][id]
            if not itemInfo then
                return
            end

            local availableQuantity = itemInfo.availableQuantity or 0

            if category == "ITEMS" and itemInfo.type == "item" then
                local itemId = itemInfo.item.id
                local countInBags = getItemCountInBags(itemId)
                availableQuantity = availableQuantity + countInBags
            end

            if (category == "POKEMONS" and itemInfo.type == "pokemon" and availableQuantity <= 0) or
               (category == "ITEMS" and itemInfo.type == "item" and availableQuantity <= 0) then
                local errorBox = displayGeneralBox("Erro", "Voce nao possui este item para vender.",
                {
                    {text = "OK", callback = function()
                        if errorBox and errorBox:isVisible() then
                            errorBox:destroy()
                        end
                    end},
                    anchor = AnchorHorizontalCenter
                })

                errorBox.onClick = function()
                    errorBox:destroy()
                end

                scheduleEvent(function()
                    if errorBox and errorBox:isVisible() then
                        errorBox:destroy()
                    end
                end, 2000)

                return
            end

            createSellWindow(id, widget, category)
        end

        scheduleEvent(waitSellCategoryAndOpen, 100)
    end
end

function createBuyWindow(id, widget)
    quantidade_items = 1
    if createdWindow then
        createdWindow:destroy()
    end

    createdWindow = g_ui.createWidget("quantityWindow", mainWindow)
    createdWindow:show()
    createdWindow:raise()
    createdWindow:focus()
    createdWindow.buyButton:show()
    createdWindow.sellButton:hide()
    createdWindow.topText:setText("COMPRANDO")

    if not cachedData or not cachedData.CATEGORY or not cachedData.CATEGORY[CATEGORY_FOCUSED] then
        createdWindow:destroy()
        return
    end

    local itemInfo = cachedData.CATEGORY[CATEGORY_FOCUSED][id]
    if not itemInfo then
        createdWindow:destroy()
        return
    end

    itemPrice = itemInfo.valor or 0
    createdWindow.precoItem:setText(itemPrice)
    createdWindow.quantidadeBuy:setValue(1)
    createdWindow.quantidadeLabel:setText("1 x")

    createdWindow.quantidadeBuy.onValueChange = function(widget, value)
        local total = itemPrice * value
        createdWindow.quantidadeLabel:setText(value .. " x")
        createdWindow.precoItem:setText("Preco: " .. total)
        quantidade_items = value
    end

    createdWindow.buyButton.onClick = function()
        local quantidade = createdWindow.quantidadeBuy:getValue()
        local total = itemPrice * quantidade
        quantidade_items = quantidade
        sendBuffer(id, CATEGORY_FOCUSED)
        createdWindow:destroy()
    end
end

function createSellWindow(id, widget, category)
    if createdWindow then
        createdWindow:destroy()
    end

    createdWindow = g_ui.createWidget("quantityWindow", mainWindow)
    createdWindow:show()
    createdWindow:raise()
    createdWindow:focus()
    createdWindow.buyButton:hide()
    createdWindow.sellButton:show()
    createdWindow.topText:setText("VENDENDO")

    if not cachedData or not cachedData.CATEGORY or not cachedData.CATEGORY[category] then
        createdWindow:destroy()
        return
    end

    local itemInfo = cachedData.CATEGORY[category][id]
    if not itemInfo then
        createdWindow:destroy()
        return
    end

    itemPrice = itemInfo.valor or 0
    createdWindow.precoItem:setText(itemPrice)

    local maxQuantity = itemInfo.availableQuantity or 0

    if itemInfo.type == "item" then
        local itemId = itemInfo.item.id
        local countInBags = getItemCountInBags(itemId)
        maxQuantity = maxQuantity + countInBags
    end

    createdWindow.quantidadeBuy:setMinimum(1)
    createdWindow.quantidadeBuy:setMaximum(maxQuantity)
    createdWindow.quantidadeBuy:setValue(1)
    createdWindow.quantidadeLabel:setText("1 x")

    createdWindow.quantidadeBuy.onValueChange = function(widget, value)
        local total = itemPrice * value
        createdWindow.quantidadeLabel:setText(value .. " x")
        createdWindow.precoItem:setText("Preco: " .. total)
        quantidade_items = value
    end

    createdWindow.sellButton.onClick = function()
        local quantidade = createdWindow.quantidadeBuy:getValue()
        if quantidade > maxQuantity then
            quantidade = maxQuantity
        end
        local total = itemPrice * quantidade
        quantidade_items = quantidade
        sendBuffer(id, category)
        createdWindow:destroy()
    end
end

function destroyWindow()
    if createdWindow then
        createdWindow:destroy()
        createdWindow = nil
        quantidade_items = 1
    end
end

function changeQuantidade(value)
    if not itemPrice then return end
    quantidade_items = value
    local newItemPrice = itemPrice * quantidade_items
    if createdWindow then
        createdWindow.quantidadeLabel:setText(value .. " x")
        createdWindow.precoItem:setText("Preco:" .. newItemPrice)
    end
end

function forceLoadShop()
    modules.game_request.sendRequest("shop")

    local attempts = 0
    local function checkData()
        if not mainWindow then return end

        attempts = attempts + 1
        if attempts > 20 then
            return
        end

        if cachedBuyData and cachedBuyData.ORDEM and #cachedBuyData.ORDEM > 0 then
            cachedData = cachedBuyData
            loaded = true

            if mainWindow and mainWindow:isVisible() then
                generateShop()
                if CATEGORY_FOCUSED then
                    generateShopCategory(CATEGORY_FOCUSED)
                end
            end
        else
            scheduleEvent(checkData, 100)
        end
    end
    scheduleEvent(checkData, 100)
end
