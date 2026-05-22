local OPCODE = 115
listBonus = nil

function getOpCode(protocol, opcode, json_data)
  local action = json_data['action']
  local data = json_data['data']
  
  if not action or not data then
    return false
  end

  if action == 'updateBanner' then
	local bonusData = data.bonusData or {}
	if bonusData.XpBanner then
		doCreateBonusCooldown(bonusData.XpBanner, true)
	else
		doRemoveBonusCooldown('XpBannerClock')
	end
  elseif action == 'allBonus' then
    for _, child in pairs(listBonus:getChildren()) do
      if child.progressCloseEvent then
        removeEvent(child.progressCloseEvent)
      end
	  child:destroy()
    end

	doCloseXpBannerClockHover()
	doUpdatePanelBonusSize()
	
	doSetupAllBonus(data.bonusData or {})
  end
end

function init()
  playerstatsWindow = g_ui.loadUI('playerstats', modules.game_interface.getRootPanel())
  
  listBonus = playerstatsWindow.listBonus
  
  ProtocolGame.registerExtendedJSONOpcode(OPCODE, getOpCode)
  connect(g_game, { 
  	onGameStart = onPlayerLogin, 
  	onGameEnd = onPlayerLogout 
  })

  -- playerstatsWindow:hide()
  -- g_game.talk('/test')
end

function terminate()
  ProtocolGame.unregisterExtendedJSONOpcode(OPCODE)
  
  for _, child in pairs(listBonus:getChildren()) do
    if child.progressCloseEvent then
      removeEvent(child.progressCloseEvent)
    end
	child:destroy()
  end

  doCloseXpBannerClockHover()
  doUpdatePanelBonusSize()
  
  disconnect(g_game, { 
  	onGameStart = onPlayerLogin, 
  	onGameEnd = onPlayerLogout 
  })
  
  playerstatsWindow:destroy()
end

function onPlayerLogin()
end
function onPlayerLogout()
  for _, child in pairs(listBonus:getChildren()) do
    if child.progressCloseEvent then
      removeEvent(child.progressCloseEvent)
    end
	child:destroy()
  end

  doCloseXpBannerClockHover()
  doUpdatePanelBonusSize()
  
  listBonus:destroyChildren()
end

-- modules.game_playerstats.hide()
function hide()
  playerstatsWindow:hide()
end

function show()
  playerstatsWindow:show()
end

function toggle()
  if playerstatsWindow:isVisible() then
    g_effects.fadeOut(playerstatsWindow, 350)
    scheduleEvent(function() 
      playerstatsWindow:hide()
    end, 400)
  else
    playerstatsWindow:show()
    g_effects.fadeIn(playerstatsWindow, 350)
  end
end
