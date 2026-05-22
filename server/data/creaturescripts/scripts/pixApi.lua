local CPF_CARACTERS_SIZE = 11
local MIN_NAME_CARACTERS_SIZE = 4
local MAX_NAME_CARACTERS_SIZE = 100
local MIN_DONATE_VALUE = '1.00'
local ONLY_INTEGER_PRICE = true
local DONATE_OPTIONS = {'10', '20', '30', '50', '100', '150', '200', '300', '400'}

function onExtendedOpcode(player, opcode, buffer)
    if opcode == PIX_OPCODE then
        local ok, data = pcall(function() return json.decode(buffer) end)
        if not ok or type(data) ~= "table" then
            return
        end
        buffer = data

        if buffer['pix_codes'] ~= nil then
            local code = buffer['pix_codes']
            if code == PIX_CODES.CHECK_CREDENTIALS then
                local retBuffer = checkCredentials(buffer['name'], buffer['cpf'], buffer['price'])
                if retBuffer['pix_codes'] == PIX_CODES.VALID_CREDENTIALS then
                    retBuffer['player_id'] = player:getGuid()
                end
                player:sendExtendedOpcode(PIX_OPCODE, json.encode(retBuffer))
                
            elseif code == PIX_CODES.GET_PIX_INFO then
                local retBuffer = {
                    ['pix_codes'] = PIX_CODES.GET_PIX_INFO,
                    ['url'] = PIX_API_URL,
                    ['api_auth_key'] = API_AUTH_KEY,
                    ['charge_expiration'] = PIX_CHARGE_EXPIRATION,                    
                    ['donate_options'] = DONATE_OPTIONS
                }
                player:sendExtendedOpcode(PIX_OPCODE, json.encode(retBuffer))
            end
        end
    end
end

function checkCredentials(name, cpf, price)
    local buffer = {}
    name = tostring(name or "")
    cpf = tostring(cpf or "")
    price = tostring(price or "")
    local priceNumber = tonumber(price)
    
    if string.len(name) < MIN_NAME_CARACTERS_SIZE then
        buffer['pix_codes'] = PIX_CODES.SHOW_MESSAGE
        buffer['msg'] = 'Nome inválido. Por favor, forneça seu nome completo.'
        
    elseif string.len(name) > MAX_NAME_CARACTERS_SIZE then
        buffer['pix_codes'] = PIX_CODES.SHOW_MESSAGE
        buffer['msg'] = 'O nome não pode ultrapassar o limite máximo de ' .. MAX_NAME_CARACTERS_SIZE .. 'caracteres.'

    elseif string.len(cpf) ~= CPF_CARACTERS_SIZE then
        buffer['pix_codes'] = PIX_CODES.SHOW_MESSAGE
        buffer['msg'] = 'CPF inválido.'

    elseif string.len(price) <= 0 or not priceNumber or priceNumber <= 0 then
        buffer['pix_codes'] = PIX_CODES.SHOW_MESSAGE
        buffer['msg'] = 'Insira uma quantidade numérica válida.'
        
    elseif priceNumber < tonumber(MIN_DONATE_VALUE) then
        buffer['pix_codes'] = PIX_CODES.SHOW_MESSAGE
        buffer['msg'] = 'O valor mínimo para doação é de R$ ' .. MIN_DONATE_VALUE
    
    elseif ONLY_INTEGER_PRICE and string.find(tostring(price), '%.') ~= nil then
        buffer['pix_codes'] = PIX_CODES.SHOW_MESSAGE
        buffer['msg'] = 'Insira um número inteiro como valor de doação.'
        
    else
        buffer['pix_codes'] = PIX_CODES.VALID_CREDENTIALS
        buffer['name'] = name
        buffer['cpf'] = cpf
        buffer['price'] = price
    end
    return buffer
end