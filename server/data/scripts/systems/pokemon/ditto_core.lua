print("[DITTO CORE] Loaded")

Ditto = {}


function Ditto.normalizeName(name)
    if not name then return "" end
    name = name:lower()
    name = name:gsub("_", " ")
    name = name:gsub("%s+", " ")
    return name
end

-- ==========================================
-- CONFIG
-- ==========================================
Ditto.COPY_DURATION = 24 * 60 * 60

Ditto.NAMES = {
    ["ditto"] = true,
    ["shiny ditto"] = true
}

Ditto.MULTIPLIER = {
    ["ditto"] = 0.75,
    ["shiny ditto"] = 0.85
}

Ditto.ICONS = {
    ["ditto"] = {
        image = "ditto_tag",
        x = -24,
        y = -32
    },
    ["shiny ditto"] = {
        image = "shiny_ditto_tag",
        x = -37,
        y = -32
    }
}

-- ==========================================
-- HELPERS
-- ==========================================

function Ditto.getBallPokeName(ball)
    if not ball then return "" end

    -- tenta special primeiro
    local name = ball:getSpecialAttribute("pokeName")

    -- fallback pro custom
    if not name or name == "" then
        name = ball:getCustomAttribute("pokeName")
    end

    return Ditto.normalizeName(name or "")
end

function Ditto.isDittoBall(ball)
    if not ball then return false end
    local name = Ditto.getBallPokeName(ball)
    return name == "ditto" or name == "shiny ditto"
end

function Ditto.isShinyDittoBall(ball)
    if not ball then return false end
    return Ditto.getBallPokeName(ball) == "shiny ditto"
end

function Ditto.isDitto(creature)
    if not creature then
        return false
    end

    local creatureName = Ditto.normalizeName(creature:getName())
    if Ditto.NAMES[creatureName] then
        return true
    end

    local master = creature:getMaster()
    if master and master:isPlayer() then
        local ball = master:getUsingBall()
        if ball and Ditto.isDittoBall(ball) then
            return true
        end
    end

    return false
end

function Player:getDittoBall()
    local ball = self:getUsingBall()
    if ball and Ditto.isDittoBall(ball) then
        return ball
    end

    ball = self:getSlotItem(CONST_SLOT_AMMO)
    if ball and Ditto.isDittoBall(ball) then
        return ball
    end

    return nil
end

function Ditto.getMultiplier(ball)
    if not ball then return 1 end

    local name = Ditto.getBallPokeName(ball)

    if name == "shiny ditto" then
        return 0.85
    elseif name == "ditto" then
        return 0.75
    end

    return 1
end

function Ditto.getBallBaseName(ball)
    if not ball then return nil end

    local name = Ditto.getBallPokeName(ball)

    if Ditto.NAMES[name] then
        return name
    end

    return nil
end

function Ditto.getCustomIcon(ball)
    local baseName = Ditto.getBallBaseName(ball)
    if not baseName then
        return nil
    end

    return Ditto.ICONS[baseName]
end

function Ditto.applyCustomIcon(creature, ball)
    if not creature or not creature:isMonster() or not ball then
        return false
    end

    local icon = Ditto.getCustomIcon(ball)
    if not icon then
        return false
    end

    creature:addCustomIcon(icon.image, icon.x, icon.y)
    return true
end

function Ditto.applyStoredShader(player, ball)
    if not player or not ball then
        return false
    end

    local particle = tonumber(ball:getSpecialAttribute("shader")) or 0
    if particle <= 0 or not SHADERSLIST or not SHADER_NAMES_TO_IDS then
        return false
    end

    local shader = SHADERSLIST[particle]
    if not shader or SHADER_NAMES_TO_IDS[shader] == nil then
        return false
    end

    return player:modifierPokemon(0, 0, SHADER_NAMES_TO_IDS[shader], -1)
end

function Ditto.getEffectiveMonsterType(creature)
    if not creature then
        return nil
    end

    local currentType = MonsterType(creature:getName())
    if not Ditto.isDitto(creature) then
        return currentType
    end

    local master = creature:getMaster()
    if not master or not master:isPlayer() then
        return currentType
    end

    local ball = master:getUsingBall()
    if not ball then
        return currentType
    end

    local tf = Ditto.getTransform(ball)
    if tf and tf.name then
        local transformedType = MonsterType(tf.name)
        if transformedType then
            return transformedType
        end
    end

    return currentType
end
-- ==========================================
-- BLOQUEIOS
-- ==========================================
function Ditto.canCopy(player, target)
    if not target or not target:isMonster() then
        return false, "Invalid target."
    end

    if target:getMaster() == player then
        return false, "You cannot copy your own Pokémon."
    end

    local ball = player:getDittoBall()
    if not ball then
        return false, "You need a Ditto active."
    end

    local activeTransform = ball:getCustomAttribute("ditto_transform")
    if activeTransform and activeTransform ~= "" then
        return false, "Use !revert antes de copiar novamente!"
    end

    local targetName = target:getName():lower()
    local dittoName = Ditto.getBallPokeName(ball)

    if targetName:find("mega") then
        return false, "Ditto cannot copy Mega Pokémon."
    end

    if targetName:find("boss") then
        return false, "Ditto cannot copy Boss Pokémon."
    end

    if dittoName == "ditto" and targetName:find("shiny") then
        return false, "Only Shiny Ditto can copy Shiny Pokémon."
    end

    return true
end

-- ==========================================
-- TRANSFORM SAVE
-- ==========================================
function Ditto.setTransform(ball, name, lookType, level)
    lookType = lookType or 0
    level = level or 1

    local value = name .. "|" .. lookType .. "|" .. level

    ball:setCustomAttribute("ditto_transform", value)
    ball:setCustomAttribute("ditto_expire", os.time() + Ditto.COPY_DURATION)

    ball:resetMoves()

end

function Ditto.getTransform(ball)

    local raw = ball:getCustomAttribute("ditto_transform")

    if not raw or raw == "" then
        return nil
    end

    local expire = tonumber(ball:getCustomAttribute("ditto_expire")) or 0

    if os.time() >= expire then
        ball:removeCustomAttribute("ditto_transform")
        ball:setCustomAttribute("ditto_expire", 0)
        ball:resetMoves()
        return nil
    end

    local parts = string.split(raw, "|")

    if #parts ~= 3 then
        return nil
    end

    return {
        name = parts[1],
        lookType = tonumber(parts[2]),
        level = tonumber(parts[3])
    }
end

-- ==========================================
-- FIX: salvar HP corretamente
-- ==========================================
function Ditto.saveHealth(player)

    local ball = player:getDittoBall()
    if not ball then return end

    local summon = player:getSummon()
    if not summon then return end

    local tf = Ditto.getTransform(ball)

    -- se estiver transformado salva HP real
    if tf then
        ball:setSpecialAttribute("pokeHealth", summon:getHealth())
        return
    end

    -- se não estiver transformado usa sistema normal
    ball:setSpecialAttribute("pokeHealth", summon:getHealth())
    ball:setCustomAttribute("ditto_max_health", summon:getMaxHealth())

end

-- ==========================================
-- APLICA TRANSFORMAÇÃO
-- ==========================================
function Ditto.applyToSummon(creature)
    if not creature or not creature:isMonster() then return end

    local master = creature:getMaster()
    if not master then return end

    local ball = master:getUsingBall()
    if not ball then return end

    if not Ditto.isDittoBall(ball) then return end

    -- 🔥 REMOVE ícones antigos (IMPORTANTE)
    creature:removeCustomIcon("ditto_tag")
    creature:removeCustomIcon("shiny_ditto_tag")

    -- 🔥 REAPLICA SEMPRE
    Ditto.applyCustomIcon(creature, ball)

    local tf = Ditto.getTransform(ball)
    if not tf then return end

    creature:setOutfit({lookType = tf.lookType})

    local maxHp = ball:getCustomAttribute("ditto_max_health") or creature:getMaxHealth()
    local hp = ball:getSpecialAttribute("pokeHealth") or maxHp

    creature:setMaxHealth(maxHp)
    creature:setHealth(hp)
    Ditto.applyStoredShader(master, ball)

    creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
end

-- ==========================================
-- FIX: reaplicar sempre que spawnar (instantâneo, sem delay)
-- ==========================================
function Ditto.onSummonSpawn(creature)
    -- Aplicação imediata do ícone, sem atrasos
    if not creature then return end

    local master = creature:getMaster()
    if not master then return end

    local ball = master:getUsingBall()
    if not ball then return end

    if Ditto.isDittoBall(ball) then
        Ditto.applyCustomIcon(creature, ball)
    end
end

-- ==========================================
-- TRANSFORM (rápido, sem delay)
-- ==========================================
function Ditto.transform(player, copyData)
    local ball = player:getDittoBall()
    if not ball then return end

    local summon = player:getSummon()
    if not summon then return end

    local targetName = copyData.name

    -- Salva transformação
    Ditto.setTransform(ball, targetName, copyData.lookType, copyData.level)

    local copiedMT = MonsterType(targetName)
    local maxHp = 1000

    if copiedMT then
        local baseHp = copiedMT:getTotalHealth(ball, player)
        local multiplier = Ditto.getMultiplier(ball)
        maxHp = math.floor(baseHp * multiplier)
    else
        print("[Ditto Core] Warning: Failed to find MonsterType for " .. targetName)
    end

    ball:setCustomAttribute("ditto_max_health", maxHp)
    ball:setSpecialAttribute("pokeHealth", maxHp)

    -- Salva a posição atual do summon
    local pos = summon:getPosition()

    -- Cria imediatamente o novo summon (sem addEvent)
    local newSummon = Game.createMonster(
        targetName,
        pos,
        true,
        true,
        copyData.level or ball:getSpecialAttribute("pokeLevel") or 1,
        ball:getSpecialAttribute("pokeBoost") or 0,
        player
    )

    if newSummon then
        -- Remove o summon atual apenas se o novo foi criado
        summon:remove()
        
        player:addSummon(newSummon)
        player:setUsingPokeball(ball)

        -- Aplica ícone imediatamente
        Ditto.applyCustomIcon(newSummon, ball)

        newSummon:setMaxHealth(ball:getCustomAttribute("ditto_max_health"))
        newSummon:setHealth(ball:getSpecialAttribute("pokeHealth"))

        Ditto.applyStoredShader(player, ball)

        pos:sendMagicEffect(CONST_ME_TELEPORT)

        if player.sendSummonMoves then
            player:sendSummonMoves()
        end
    else
        -- Se falhar em criar, limpa a transformação para não bugar
        print("[Ditto Core] Error: Failed to create summon " .. targetName)
        ball:removeCustomAttribute("ditto_transform")
        ball:removeCustomAttribute("ditto_expire")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Failed to transform. The target might be invalid or there is no space.")
    end
end

function Ditto.saveCurrentHealth(player)
    local summon = player:getSummon()
    if not summon then return end

    local ball = player:getUsingBall()
    if not ball then return end

    ball:setSpecialAttribute("pokeHealth", summon:getHealth())
end

function Ditto.preserveOnRemove(player, ball)
    if not player or not ball or not Ditto.isDittoBall(ball) then
        return false
    end

    local summon = player:getSummon()
    if summon then
        ball:setSpecialAttribute("pokeHealth", summon:getHealth())
        ball:setCustomAttribute("ditto_max_health", summon:getMaxHealth())
    end

    return true
end

-- ==========================================
-- REVERT (rápido, mantém posição do summon)
-- ==========================================
function Ditto.revert(player)
    local ball = player:getDittoBall()
    if not ball then return false end

    ball:removeCustomAttribute("ditto_transform")
    ball:removeCustomAttribute("ditto_max_health")
    ball:setCustomAttribute("ditto_expire", 0)

    ball:resetMoves()

    -- Salva a posição atual do summon antes de remover
    local summon = player:getSummon()
    local pos = nil
    if summon then
        pos = summon:getPosition()
    else
        pos = player:getPosition() -- fallback, mas normalmente não acontecerá
    end

    -- Cria o Ditto original imediatamente na posição guardada
    local originalName = Ditto.getBallPokeName(ball)
    if originalName == "" then 
        originalName = "Ditto" 
        print("[Ditto Core] Warning: originalName empty in revert, using fallback 'Ditto'")
    end

    local newSummon = Game.createMonster(
        originalName,
        pos,
        true,
        true,
        ball:getSpecialAttribute("pokeLevel") or 1,
        ball:getSpecialAttribute("pokeBoost") or 0,
        player
    )

    if newSummon then
        -- Remove o summon atual apenas depois do novo criado com sucesso
        if summon then
            summon:remove()
        else
            if #player:getSummons() > 0 then
                doRemoveSummon(player:getId(), false)
            end
        end

        player:addSummon(newSummon)
        player:setUsingPokeball(ball)

        -- Ícone aplicado imediatamente
        Ditto.applyCustomIcon(newSummon, ball)

        local lookType = 0
        local mt = MonsterType(originalName)
        if mt then
            local ok, outfit = pcall(function()
                return mt:getOutfit()
            end)
            if ok and outfit then
                lookType = outfit.lookType or 0
            end
        end

        player:sendExtendedOpcode(90, "transformation=none,0," .. lookType)

        Ditto.applyStoredShader(player, ball)

        pos:sendMagicEffect(CONST_ME_TELEPORT)

        if player.sendSummonMoves then
            player:sendSummonMoves()
        end
        return true
    else
        print("[Ditto Core] Error: Failed to recreate original summon " .. originalName)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Failed to revert transformation. No space available.")
        return false
    end
end
