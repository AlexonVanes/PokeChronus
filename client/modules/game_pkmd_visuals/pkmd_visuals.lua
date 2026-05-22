local registered = {}

local function safeCreate(kind, name, vertex, fragment)
  local ok, err = pcall(function()
    if kind == 'outfit' then
      g_shaders.createOutfitShader(name, vertex, fragment)
    else
      g_shaders.createShader(name, vertex, fragment)
    end
  end)

  if ok then
    registered[name] = true
    print('[PKMD Visuals] shader ready: ' .. name)
  else
    print('[PKMD Visuals] shader skipped: ' .. name .. ' (' .. tostring(err) .. ')')
  end
end

local function safeTexture(name, texture)
  pcall(function()
    g_shaders.addTexture(name, texture)
  end)
end

local function registerPkmdShaders()
  local outlineVertex = '/shaders/outfit_outline_vertex'

  -- Exact PKMD names used by imported modules.
  safeCreate('outfit', 'outfit_dbzblue', '/shaders/dbauravertex', '/shaders/dbaurablue')
  safeCreate('outfit', 'outfit_dbz', '/shaders/dbauravertex', '/shaders/dbaurafrag')
  safeCreate('outfit', 'outfit_red', outlineVertex, '/shaders/outfit_red')
  safeCreate('outfit', 'outfit_blue', outlineVertex, '/shaders/outfit_blue')
  safeCreate('outfit', 'outfit_green', outlineVertex, '/shaders/outfit_green')
  safeCreate('outfit', 'outfit_purple', outlineVertex, '/shaders/outfit_purple')
  safeCreate('outfit', 'outfit_yellow', outlineVertex, '/shaders/outfit_yellow')
  safeCreate('outfit', 'outfit_gray', outlineVertex, '/shaders/outfit_gray')
  safeCreate('outfit', 'outfit_black', outlineVertex, '/shaders/outfit_black')
  safeCreate('outfit', 'outfit_white', outlineVertex, '/shaders/outfit_white')
  safeCreate('outfit', 'outfit_rgb', outlineVertex, '/shaders/outfit_rgb')
  safeCreate('outfit', 'outfit_ultra', '/shaders/outfit_outline_ultra', '/shaders/outfit_ultra')
  safeCreate('outfit', 'outfit_distortion', outlineVertex, '/shaders/outfit_distortion')
  safeCreate('outfit', 'dimensional', '/shaders/outfit_3line_vertex', '/shaders/outfit_3line_fragment')
  safeCreate('outfit', 'circle', '/shaders/outfit_circle_vertex', '/shaders/outfit_circle_fragment')
  safeCreate('outfit', 'rollout', '/shaders/outfit_rolout_vertex', '/shaders/outfit_rolout_fragment')
  safeCreate('outfit', 'infinite', '/shaders/outfit_infinito_vertex', '/shaders/outfit_infinito_fragment')
  safeCreate('outfit', 'outfit_inv', '/shaders/outfit_rolling_vertex', '/shaders/outfit_rolling')
  safeTexture('outfit_inv', '/images/shaders/inv.png')
  safeCreate('outfit', 'outfit_inv10', '/shaders/outfit_rolling_vertex', '/shaders/outfit_rolling')
  safeTexture('outfit_inv10', '/images/shaders/inv10.png')
  safeCreate('outfit', 'outfit_fullblack', '/shaders/outfit_rainbow_vertex', '/shaders/outfit_rainbow_fragment')
  safeTexture('outfit_fullblack', '/images/shaders/rain.png')
  safeCreate('outfit', 'outfit_camu', '/shaders/outfit_rainbow_vertex', '/shaders/outfit_rainbow_fragment')
  safeTexture('outfit_camu', '/images/shaders/blue.png')
  safeCreate('outfit', 'outfit_ball', '/shaders/outfit_rainbow_vertex', '/shaders/outfit_rainbow_fragment')
  safeTexture('outfit_ball', '/images/shaders/red.png')
  safeCreate('outfit', 'outift_gold', '/shaders/outfit_rainbow_vertex', '/shaders/outfit_rainbow_fragment')
  safeTexture('outift_gold', '/images/shaders/gold.png')
  safeCreate('outfit', 'rainbowoutfit', '/shaders/outfitmario', '/shaders/outfit_rainbow_fragment')
  safeTexture('rainbowoutfit', '/images/shaders/rainbow.png')

  -- Friendly aliases for testing/admin tools without breaking PKMD names.
  safeCreate('outfit', 'pkmd_dbz_blue', '/shaders/dbauravertex', '/shaders/dbaurablue')
  safeCreate('outfit', 'pkmd_dbz', '/shaders/dbauravertex', '/shaders/dbaurafrag')
  safeCreate('outfit', 'pkmd_rgb', outlineVertex, '/shaders/outfit_rgb')
  safeCreate('outfit', 'pkmd_ultra', '/shaders/outfit_outline_ultra', '/shaders/outfit_ultra')

  safeCreate('map', 'map_fog', '/shaders/map_fog_vertex', '/shaders/map_fog_fragment')
  safeTexture('map_fog', '/shaders/light_fog.png')
  safeCreate('map', 'map_winter', '/shaders/map_winter_vertex', '/shaders/map_winter_fragment')
  safeTexture('map_winter', '/shaders/heavy_snow.png')
  safeCreate('map', 'map_distor', '/shaders/map_rainbow_vertex', '/shaders/map_distortion_fragment')
  safeCreate('map', 'map_confusion', '/shaders/map_rainbow_vertex', '/shaders/map_confusion')
  safeCreate('map', 'map_sukuna', '/shaders/sukuna_vertex', '/shaders/sukuna_fragment')
  safeTexture('map_sukuna', '/shaders/sukuna.png')
  safeCreate('map', 'map_blur', '/shaders/map_rainbow_vertex', '/shaders/map_blur')
  safeCreate('map', 'map_gaussian', '/shaders/map_default_vertex', '/shaders/map_gaussian_fragment')
  safeCreate('map', 'map_boss_focus', '/shaders/map_default_vertex', '/shaders/map_boss_focus_fragment')
  safeCreate('map', 'map_kamui', '/shaders/map_rainbow_vertex', '/shaders/map_kamui')
  safeCreate('map', 'map_wind', '/shaders/map_default_vertex', '/shaders/wind')
  safeCreate('map', 'map_4k_enhance', '/shaders/map_default_vertex', '/shaders/map_4k_enhance_fragment')
  safeCreate('map', 'map_default', '/shaders/map_default_vertex', '/shaders/map_4k_enhance_fragment')

  safeCreate('map', 'pkmd_map_blur', '/shaders/map_rainbow_vertex', '/shaders/map_blur')
  safeCreate('map', 'pkmd_map_confusion', '/shaders/map_rainbow_vertex', '/shaders/map_confusion')
  safeCreate('map', 'pkmd_map_gaussian', '/shaders/map_default_vertex', '/shaders/map_gaussian_fragment')
  safeCreate('map', 'pkmd_map_boss_focus', '/shaders/map_default_vertex', '/shaders/map_boss_focus_fragment')
end

local visualEnhanceEvent = nil
local visualEnhanceLogged = false

local function applyVisualEnhance()
  pcall(function()
    if g_app and g_app.setSmooth then
      g_app.setSmooth(true)
    end
  end)

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel or not panel.setShader then return end

  local current = ''
  pcall(function()
    if panel.getShader then
      current = panel:getShader() or ''
    end
  end)

  if current == '' or current == 'map_default' then
    panel:setShader('map_4k_enhance')
  end

  if not visualEnhanceLogged then
    visualEnhanceLogged = true
    print('[PKMD Visuals] 4K enhance active')
  end
end

local function startVisualEnhance()
  scheduleEvent(applyVisualEnhance, 250)
  scheduleEvent(applyVisualEnhance, 1000)
  scheduleEvent(applyVisualEnhance, 2500)

  if visualEnhanceEvent then
    visualEnhanceEvent:cancel()
  end

  visualEnhanceEvent = cycleEvent(function()
    local panel = modules.game_interface and modules.game_interface.gameMapPanel
    if not panel then return end

    local current = ''
    pcall(function()
      if panel.getShader then
        current = panel:getShader() or ''
      end
    end)

    if current == '' or current == 'map_default' then
      applyVisualEnhance()
    end
  end, 2000)
end

local function stopVisualEnhance()
  if visualEnhanceEvent then
    visualEnhanceEvent:cancel()
    visualEnhanceEvent = nil
  end
end

local function setGlobalFallback(name, fn)
  if rawget(_G, name) == nil then
    rawset(_G, name, fn)
  end
end

local function installPkmdCompatibility()
  setGlobalFallback('FreakyTypes', {})
  setGlobalFallback('ShiniesTypes', {})
  setGlobalFallback('ParadoxTypes', {})
  setGlobalFallback('ElderTypes', {})
  setGlobalFallback('MegaTypes', {})
  setGlobalFallback('AlolaTypes', {})
  setGlobalFallback('UndeadsTypes', {})
  setGlobalFallback('GodTypes', {})
  setGlobalFallback('UntalkableNPCType', {})

  setGlobalFallback('playEffectSound', function() end)
  setGlobalFallback('isPlayerOnPacman', function() return false end)
  setGlobalFallback('LoopAutoWalkPacman', function() end)
  setGlobalFallback('playerInPartyRecallRange', function() end)
  setGlobalFallback('doCheckShibaBotinPC', function() end)
  setGlobalFallback('isMacroOnline', function() return false end)
  setGlobalFallback('obterReset', function() return 0 end)

  if modules.game_interface then
    if not modules.game_interface.updatePlayerInformations then
      modules.game_interface.updatePlayerInformations = function() end
    end
    if not modules.game_interface.removeTagFromName then
      modules.game_interface.removeTagFromName = function(name) return name or '' end
    end
    if not modules.game_interface.getPlayerInfoWidget then
      modules.game_interface.getPlayerInfoWidget = function()
        if modules.game_interface.getBottomActionPanel then
          return modules.game_interface.getBottomActionPanel()
        end
        if modules.game_interface.getBottomPanel then
          return modules.game_interface.getBottomPanel()
        end
        return nil
      end
    end
  end

  if modules.game_inventory then
    if not modules.game_inventory.updateDamageGraphic then
      modules.game_inventory.updateDamageGraphic = function() end
    end
    if not modules.game_inventory.testShopSell then
      modules.game_inventory.testShopSell = function() end
    end
  end

  if not modules.game_castle then
    modules.game_castle = {}
  end
  if not modules.game_castle.getFormattedMoney then
    modules.game_castle.getFormattedMoney = function(value)
      local amount = tonumber(value) or 0
      local sign = amount < 0 and '-' or ''
      amount = math.floor(math.abs(amount))
      local text = tostring(amount)
      while true do
        local formatted, count = text:gsub('^(-?%d+)(%d%d%d)', '%1.%2')
        text = formatted
        if count == 0 then break end
      end
      return sign .. text
    end
  end

  if modules.client_background and not modules.client_background.getPKMDGuildMembers then
    modules.client_background.getPKMDGuildMembers = function() end
  end

  if modules.client_topmenu and not modules.client_topmenu.sendNotficationTopMenu then
    modules.client_topmenu.sendNotficationTopMenu = function(...)
      if modules.client_topmenu.sendNotificationTopMenu then
        return modules.client_topmenu.sendNotificationTopMenu(...)
      end
    end
  end

  if UIMinimap then
    if not UIMinimap.FlagBannerReset then
      function UIMinimap:FlagBannerReset()
        if not self.flags then return end
        for i = #self.flags, 1, -1 do
          local flag = self.flags[i]
          if flag and flag.icon == 19 then
            flag:destroy()
          end
        end
      end
    end
    if not UIMinimap.FlagSetReset then
      function UIMinimap:FlagSetReset()
        if not self.flags then return end
        for i = #self.flags, 1, -1 do
          local flag = self.flags[i]
          if flag and flag.icon == 18 then
            flag:destroy()
          end
        end
      end
    end
    if not UIMinimap.FlagBlackZoneReset then
      function UIMinimap:FlagBlackZoneReset()
        if not self.flags then return end
        for i = #self.flags, 1, -1 do
          local flag = self.flags[i]
          if flag and flag.icon == 16 then
            flag:destroy()
          end
        end
      end
    end
  end
end

BossFocus = {
  FADE_DURATION = 0.4,
  _active = false,
  _fadeT = 0.0,
  _fadeIn = false,
  _creature = nil,
  _radius = 0.18,
  _event = nil,
  _shader = nil,
}

function BossFocus._getShader()
  if not BossFocus._shader then
    BossFocus._shader = g_shaders.getShader('map_boss_focus')
  end
  return BossFocus._shader
end

function BossFocus._calcTexSize(drawW, drawH, ts)
  local maxSize = math.max(drawW * ts, drawH * ts)
  local scaling = 1.0
  while maxSize > 2048 do
    maxSize = math.floor(maxSize / 2)
    scaling = scaling * 0.5
  end
  if scaling < 0.99 then
    return 2048, 2048
  end
  return drawW * ts, drawH * ts
end

function BossFocus._calcScaling(drawW, drawH, ts)
  local maxSize = math.max(drawW * ts, drawH * ts)
  local scale = 1.0
  while maxSize > 2048 do
    maxSize = math.floor(maxSize / 2)
    scale = scale * 0.5
  end
  return scale
end

function BossFocus._calcUV(creature)
  if not creature or creature:isRemoved() then return nil end
  local mapPanel = modules.game_interface.gameMapPanel
  if not mapPanel then return nil end
  local cameraPos = mapPanel:getCameraPosition()
  local bossPos = creature:getPosition()
  if not cameraPos or not bossPos or bossPos.z ~= cameraPos.z then return nil end

  local drawDim = mapPanel:getDrawDimension()
  local drawW = drawDim.width
  local drawH = drawDim.height
  local vcX = math.floor(drawW / 2) - 1
  local vcY = math.floor(drawH / 2) - 1
  local ts = g_sprites.spriteSize()
  local scale = BossFocus._calcScaling(drawW, drawH, ts)
  local texW, texH = BossFocus._calcTexSize(drawW, drawH, ts)
  local dx = bossPos.x - cameraPos.x
  local dy = bossPos.y - cameraPos.y
  local wo = creature:getWalkOffset()
  local jo = creature:getJumpOffset()
  local woX = wo and wo.x or 0
  local woY = wo and wo.y or 0
  local joX = jo and jo.x or 0
  local joY = jo and jo.y or 0

  local uvX = (vcX + dx + (woX - joX) / ts) * ts * scale / texW
  local uvY = 1.0 - (vcY + dy + (woY - joY) / ts) * ts * scale / texH
  if uvX < -0.05 or uvX > 1.05 or uvY < -0.05 or uvY > 1.05 then
    return nil
  end
  return uvX, uvY
end

function BossFocus._stopEvent()
  if BossFocus._event then
    BossFocus._event:cancel()
    BossFocus._event = nil
  end
end

function BossFocus._tick()
  local shader = BossFocus._getShader()
  if not shader then return end

  local dt = 0.016
  if BossFocus._fadeIn then
    BossFocus._fadeT = math.min(1.0, BossFocus._fadeT + dt / BossFocus.FADE_DURATION)
  else
    BossFocus._fadeT = math.max(0.0, BossFocus._fadeT - dt / BossFocus.FADE_DURATION)
  end
  shader:setCustomUniformFloat('u_FadeT', BossFocus._fadeT)

  if BossFocus._creature and not BossFocus._creature:isRemoved() then
    local mapPanel = modules.game_interface.gameMapPanel
    if mapPanel then
      local drawDim = mapPanel:getDrawDimension()
      local visibleDim = mapPanel:getVisibleDimension()
      local ts = g_sprites.spriteSize()
      local scale = BossFocus._calcScaling(drawDim.width, drawDim.height, ts)
      local texW, texH = BossFocus._calcTexSize(drawDim.width, drawDim.height, ts)
      shader:setCustomUniformVec2('u_TexSize', texW, texH)
      local radiusTiles = BossFocus._radius * visibleDim.height
      shader:setCustomUniformFloat('u_FocusRadius', radiusTiles * ts * scale / texH)
    end

    local uvX, uvY = BossFocus._calcUV(BossFocus._creature)
    if uvX then
      shader:setCustomUniformVec2('u_FocusPos', uvX, uvY)
    else
      BossFocus._fadeIn = false
    end
  end

  if not BossFocus._fadeIn and BossFocus._fadeT <= 0.0 then
    BossFocus._stopEvent()
    BossFocus._active = false
    BossFocus._creature = nil
    local mapPanel = modules.game_interface.gameMapPanel
    if mapPanel then mapPanel:setShader('') end
  end
end

function BossFocus.activate(creature, radius)
  if g_app.isMobile() or not creature then return true end
  local shader = BossFocus._getShader()
  if not shader then
    print('[PKMD Visuals] map_boss_focus not available')
    return
  end

  BossFocus._creature = creature
  BossFocus._radius = radius or 0.18
  BossFocus._fadeT = 0.0
  BossFocus._fadeIn = true
  BossFocus._active = true

  local uvX, uvY = BossFocus._calcUV(creature)
  shader:setCustomUniformVec2('u_FocusPos', uvX or 0.5, uvY or 0.5)
  shader:setCustomUniformFloat('u_FadeT', 0.0)

  local mapPanel = modules.game_interface.gameMapPanel
  if mapPanel then
    mapPanel:setShader('map_boss_focus')
  end

  BossFocus._stopEvent()
  BossFocus._event = cycleEvent(BossFocus._tick, 32)
end

function BossFocus.deactivate()
  if not BossFocus._active then return end
  BossFocus._fadeIn = false
end

function BossFocus.isActive()
  return BossFocus._active
end

function init()
  installPkmdCompatibility()

  if not g_shaders then
    print('[PKMD Visuals] g_shaders unavailable')
    return
  end
  registerPkmdShaders()
  startVisualEnhance()
end

function terminate()
  stopVisualEnhance()

  if BossFocus then
    BossFocus._stopEvent()
  end
  registered = {}
  visualEnhanceLogged = false
end
