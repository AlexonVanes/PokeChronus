-- Configuração PIX - Mercado Pago
local API_URL = nil
local API_AUTH_KEY = nil
local DONATE_OPTIONS = nil
local CHARGE_EXPIRATION = nil
PIX_OPCODE = 74
PIX_CHARGE_EXPIRATION = 900
PIX_CODES = {
    SHOW_MESSAGE = 1,
    CHECK_CREDENTIALS = 2,
    VALID_CREDENTIALS = 3,
    PIX_PAID_SUCCESS = 4,
    GET_PIX_INFO = 5
}
local donateWindow = nil
local qrCodeWindow = nil
local gameMessageWindow = nil
local qrCodeLoc = nil

local nameEntry = nil
local nameEntryPassword = nil
local cpfEntry = nil
local cpfEntryPassword = nil
local priceEntry = nil
local priceComboBox = nil
local nameCheckBox = nil
local cpfCheckBox = nil

function init()
    donateWindow = g_ui.displayUI('game_donate')
    donateWindow:hide()

	getWindowChildrens()
	
	cpfCheckBox:setChecked(false)
	nameCheckBox:setChecked(false)
	
	cpfEntry:hide()
	nameEntry:hide()

    connect(g_game, {
        onGameStart = onLogin,
        onGameEnd = onLogout
    })
end

function getWindowChildrens()
    nameEntry = donateWindow:getChildById('nameEntry')
    nameEntryPassword = donateWindow:getChildById('nameEntryPassword')
    cpfEntry = donateWindow:getChildById('cpfEntry')
    cpfEntryPassword = donateWindow:getChildById('cpfEntryPassword')
    priceEntry = donateWindow:getChildById('valueEntry')
    priceComboBox = donateWindow:getChildById('valueComboBox')
    nameCheckBox = donateWindow:getChildById('nameCheckBox')
    cpfCheckBox = donateWindow:getChildById('cpfCheckBox')
end

function onLogin()
    ProtocolGame.registerExtendedOpcode(PIX_OPCODE, opcodeCallback)
	getPixInfo()
end

function onLogout()
    ProtocolGame.unregisterExtendedOpcode(PIX_OPCODE, opcodeCallback)
    closeWindow()
end

function opcodeCallback(protocol, opcode, buffer)
    if opcode == PIX_OPCODE then
        local ok, data = pcall(function() return json.decode(buffer) end)
        if not ok or type(data) ~= 'table' then
            return
        end
        buffer = data

        if buffer['pix_codes'] ~= nil then
            local code = buffer['pix_codes']

            if code == PIX_CODES.SHOW_MESSAGE then
                showMessage(buffer['msg'])
                return

			elseif code == PIX_CODES.VALID_CREDENTIALS then
				local player = g_game.getLocalPlayer()
                if not player then
                    return
                end
                createCharge(buffer['name'], buffer['cpf'], buffer['price'], buffer['player_id'], player:getName())
                donateWindow:hide()

				if not qrCodeWindow then
					qrCodeWindow = g_ui.loadUI('game_qrcode', g_ui.getRootWidget())
				end
                qrCodeWindow:show()
                qrCodeWindow:focus()

                local qrcodeImage = qrCodeWindow:getChildById('qrcode')
                qrcodeImage:setImageSource('img/loading')
            
            elseif code == PIX_CODES.PIX_PAID_SUCCESS then
                if qrCodeWindow and tonumber(qrCodeLoc) == tonumber(buffer['loc_id']) then
                    local qrcodeImage = qrCodeWindow:getChildById('qrcode')
                    qrcodeImage:setImageSource('img/payment')
					addEvent(function() g_effects.fadeIn(qrcodeImage, 1500) end)
					qrCodeLoc = nil
                    if modules.game_shop and modules.game_shop.requestDiamondBalance then
                        modules.game_shop.requestDiamondBalance()
                    end
                end
			elseif code == PIX_CODES.GET_PIX_INFO then
                if type(buffer['url']) == 'string' and buffer['url']:match('^https://') then
				    API_URL = buffer['url']
                end
                API_AUTH_KEY = type(buffer['api_auth_key']) == 'string' and buffer['api_auth_key'] or nil
				CHARGE_EXPIRATION = tonumber(buffer['charge_expiration']) or PIX_CHARGE_EXPIRATION
				DONATE_OPTIONS = buffer['donate_options']
				if DONATE_OPTIONS ~= nil then
					priceComboBox:clear()
					for i, value in pairs(DONATE_OPTIONS) do
						priceComboBox:addOption(value)
					end
					priceEntry:hide()
					priceComboBox:show()
				else
					priceComboBox:hide()
					priceEntry:show()
				end
            end
        end
    end
end

function getPixInfo()
	buffer = {
		['pix_codes'] = PIX_CODES.GET_PIX_INFO
	}
	local protocol = g_game.getProtocolGame()
	protocol:sendExtendedOpcode(PIX_OPCODE, json.encode(buffer))
end

function showMessage(message)
    if not gameMessageWindow then
        gameMessageWindow = g_ui.loadUI('game_message_window', g_ui.getRootWidget())
    end

    local label = gameMessageWindow:getChildById('label')
    label:setText(message)

    gameMessageWindow:show()
    gameMessageWindow:focus()
end

function submitButtonCallback()
    local protocol = g_game.getProtocolGame()
    if not protocol then
        return
    end
    
    local name = nil
    local cpf = nil
    local price = nil
	
	if DONATE_OPTIONS ~= nil then
		price = priceComboBox:getText()
	else
		price = priceEntry:getText()
	end
	
	if cpfCheckBox:isChecked() then
		cpf = cpfEntry:getText()
	else
		cpf = cpfEntryPassword:getText()
	end
	
	if nameCheckBox:isChecked() then
		name = nameEntry:getText()
	else
		name = nameEntryPassword:getText()
	end

    local priceNumber = math.max(tonumber(price) or 0, 0)
    if priceNumber <= 0 then
        showMessage("Valor invalido.")
        return
    end

    local buffer = {
        ['pix_codes'] = PIX_CODES.CHECK_CREDENTIALS,
        ['name'] = tostring(name or ""),
        ['cpf'] = string.gsub(tostring(cpf or ""), "[%a,%p]", ""),
        ['price'] = string.gsub(tostring(priceNumber), "[^%d%.]+", "")
	}
    protocol:sendExtendedOpcode(PIX_OPCODE, json.encode(buffer))
end

function createCharge(name, cpf, price, player_id, player_name)
    if not API_URL then
        showMessage("Servico de PIX indisponivel.")
        closeWindow()
        return
    end

    -- Usar API do Mercado Pago diretamente
    local data = {
        ['action'] = 'create_pix',
        ['name'] = name,
        ['cpf'] = cpf,
        ['amount'] = price,
        ['player_id'] = player_id,
        ['player_name'] = player_name,
        ['email'] = 'player@pokechronus.com'
    }
    
    -- Chamar API PHP do Mercado Pago
    HTTP.postJSON(API_URL .. 'mercadopago_api.php', data, createChargeCallback)
end

function createChargeCallback(data, err)
    if err then
        print("[PIX] Erro HTTP:", err)
        showMessage("Erro de conexão com servidor.")
        closeWindow()
        return
    end

    if type(data) ~= 'table' then
        showMessage("Resposta invalida do servidor PIX.")
        closeWindow()
        return
    end

    -- Resposta da API do Mercado Pago
    if not data['success'] then
        local errorMsg = data['error'] or "Erro desconhecido"
        print("[PIX] Erro API:", errorMsg)
        
        if errorMsg:find("CPF") or errorMsg:find("identification") then
            showMessage("CPF inválido.")
        else
            showMessage("Erro ao gerar PIX: " .. errorMsg)
        end
        closeWindow()
        return
    end

    -- Sucesso - tem QR Code
    if data['qr_code_base64'] then
        displayQrCode(data['qr_code_base64'], data['payment_id'])
    else
        showMessage("Erro: QR Code não recebido.")
        closeWindow()
    end
end

function displayQrCode(qrCodeBase64, paymentId)
    if qrCodeWindow then
        local qrcodeImage = qrCodeWindow:getChildById('qrcode')
        local qrcodeEntry = qrCodeWindow:getChildById('qrcodeEntry')

        qrcodeEntry:setText(tostring(paymentId))
        qrcodeImage:setImageSourceBase64(qrCodeBase64)
    end
end

function loadQrCode(loc)
    if not API_URL or not API_AUTH_KEY then
        showMessage("Servico de PIX indisponivel.")
        closeWindow()
        return
    end

    qrCodeLoc = loc
    local url = string.format(API_URL..'qrcode/%s/%s', qrCodeLoc, API_AUTH_KEY)
    HTTP.getJSON(url, loadQrCodeCallback)
end

function loadQrCodeCallback(data, err)
    if err then
		-- print(err)
        showMessage("Servi�o indispon�vel temporariamente.")
        closeWindow()
        return
    end

    if type(data) ~= 'table' then
        showMessage("Resposta invalida do servidor PIX.")
        closeWindow()
        return
    end

    if data['mensagem'] ~= nil then
        showMessage(data['mensagem'])
        closeWindow()
        return
    end

    if qrCodeWindow and data['qrcode'] ~= nil and type(data['imagemQrcode']) == 'string' then
        local qrcodeImage = qrCodeWindow:getChildById('qrcode')
        local qrcodeEntry = qrCodeWindow:getChildById('qrcodeEntry')

        qrcodeEntry:setText(tostring(data['qrcode']))
        local qrcodeImageParts = data['imagemQrcode']:split(',')
        local qrcodeImageBase64 = qrcodeImageParts and qrcodeImageParts[2]
        if not qrcodeImageBase64 then
            showMessage("QR Code invalido.")
            closeWindow()
            return
        end
        qrcodeImage:setImageSourceBase64(qrcodeImageBase64)
		
		local seconds = CHARGE_EXPIRATION * 1000
		scheduleEvent(function()
			if qrCodeLoc ~= nil then
				closeWindow()
				showMessage("O tempo para pagar o Qr Code expirou.")
			end
		end, seconds) 
    end
end

function checkBoxCallback(checkbox)
	if checkbox == 'cpf' then
		if cpfCheckBox:isChecked() then
			cpfEntryPassword:hide()
			cpfEntry:setText(cpfEntryPassword:getText())
			cpfEntry:show()
			cpfEntry:focus()
		else
			cpfEntry:hide()
			cpfEntryPassword:setText(cpfEntry:getText())
			cpfEntryPassword:show()
			cpfEntryPassword:focus()
		end
	elseif checkbox == 'name' then
		if nameCheckBox:isChecked() then
			nameEntryPassword:hide()
			nameEntry:setText(nameEntryPassword:getText())
			nameEntry:show()
			nameEntry:focus()
		else
			nameEntry:hide()
			nameEntryPassword:setText(nameEntry:getText())
			nameEntryPassword:show()
			nameEntryPassword:focus()
		end
	end
end

function clearTextEntries()
	nameEntry:clearText()
	nameEntryPassword:clearText()
	cpfEntry:clearText()
	cpfEntryPassword:clearText()
	priceEntry:clearText()
end

function toggle()
    if donateWindow:isVisible() then
        closeWindow()
    else
        if not qrCodeWindow or not qrCodeWindow:isVisible() then
			if nameCheckBox:isChecked() then
				nameEntry:focus()
			else
				nameEntryPassword:focus()
			end
			clearTextEntries()
            openWindow()
        end
    end
end

function openWindow()
    if donateWindow then
        donateWindow:show()
        donateWindow:raise()
        donateWindow:focus()
    end
end

function openRechargeWindow()
    if not donateWindow then
        return
    end

    if qrCodeWindow and qrCodeWindow:isVisible() then
        qrCodeWindow:raise()
        qrCodeWindow:focus()
        return
    end

    clearTextEntries()
    openWindow()

    if nameCheckBox and nameCheckBox:isChecked() then
        nameEntry:focus()
    elseif nameEntryPassword then
        nameEntryPassword:focus()
    end
end

function destroyMessageWindow()
    if gameMessageWindow then
        gameMessageWindow:hide()
        gameMessageWindow:destroy()
        gameMessageWindow = nil
    end
end

function closeWindow()
    if donateWindow then
        donateWindow:hide()
    end

    if qrCodeWindow then
        qrCodeWindow:hide()
        qrCodeWindow:destroy()
        qrCodeWindow = nil
    end

    qrCodeLoc = nil
end

function terminate()
    disconnect(g_game, {
        onGameStart = onLogin,
        onGameEnd = onLogout
    })
    ProtocolGame.unregisterExtendedOpcode(PIX_OPCODE, opcodeCallback)
    closeWindow()
end
