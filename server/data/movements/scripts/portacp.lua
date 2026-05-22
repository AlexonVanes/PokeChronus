-- CONFIGURAÇÃO
local DOOR_IDS = {34096, 34095, 34094, 34093}
local DOOR_POS = Position(2609, 2528, 7)

local AREA_FROM = Position(2606, 2527, 7) --Position(2606, 2527, 7)
local AREA_TO   = Position(2609, 2529, 7) --Position(2609, 2529, 7)

local STEP_DELAY = 200 -- ms

-- CONTROLE DE ESTADO
local doorState = {
    opening = false,
    closing = false,
    open = false
}

-- FUNÇÕES AUXILIARES
local function areaHasCreatures()
    for x = AREA_FROM.x, AREA_TO.x do
        for y = AREA_FROM.y, AREA_TO.y do
            local tile = Tile(Position(x, y, AREA_FROM.z))
            if tile then
                local creatures = tile:getCreatures()
                if creatures then
                    for _, c in ipairs(creatures) do
                        if c:isPlayer() or c:isMonster() then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function transformDoor(fromId, toId)
    local tile = Tile(DOOR_POS)
    if not tile then return end

    local item = tile:getItemById(fromId)
    if item then
        item:transform(toId)
    end
end

-- ABRIR PORTA
local function openDoor()
    if doorState.open or doorState.opening then return end

    doorState.opening = true
    doorState.closing = false

    for i = 1, #DOOR_IDS - 1 do
        addEvent(function()
            transformDoor(DOOR_IDS[i], DOOR_IDS[i + 1])
            if i == #DOOR_IDS - 1 then
                doorState.opening = false
                doorState.open = true
            end
        end, i * STEP_DELAY)
    end
end

-- FECHAR PORTA
local function closeDoor()
    if not doorState.open or doorState.closing then return end

    doorState.closing = true
    doorState.opening = false

    for i = 1, #DOOR_IDS - 1 do
        addEvent(function()
            transformDoor(
                DOOR_IDS[#DOOR_IDS - i + 1],
                DOOR_IDS[#DOOR_IDS - i]
            )

            if i == #DOOR_IDS - 1 then
                doorState.closing = false
                doorState.open = false
            end
        end, i * STEP_DELAY)
    end
end

-- LOOP DE VERIFICAÇÃO
local function doorWatcher()
    if areaHasCreatures() then
        openDoor()
    else
        closeDoor()
    end

    addEvent(doorWatcher, 500)
end

-- EVENTO
function onStepIn(creature, item, position, fromPosition)
    if not doorState.open and not doorState.opening then
        openDoor()
        addEvent(doorWatcher, 500)
    end
    return true
end
