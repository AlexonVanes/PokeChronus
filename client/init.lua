APP_NAME = "PokeChronus"  
APP_VERSION = 1098
APP_SECURITY_VERSION = 2  -- Versão da proteção anti-bot (separada do protocolo)

Services = {
  website = "", 
  updater = "",
  stats = "",
  crash = "",
  feedback = "",
  status = ""
}

Servers = {
    Oficial = "127.0.0.1:7171:1098",
}

g_app.setName(APP_NAME)


g_logger.info(os.date("== application started at %b %d %Y %X"))
--g_logger.info(g_app.getName() .. ' ' .. g_app.getVersion() .. ' rev ' .. g_app.getBuildRevision() .. ' (' .. g_app.getBuildCommit() .. ') made by ' .. g_app.getAuthor() .. ' built on ' .. g_app.getBuildDate() .. ' for arch ' .. g_app.getBuildArch())

if not g_resources.directoryExists("/data") then
  g_logger.fatal("Data dir doesn't exist.")
end

if not g_resources.directoryExists("/modules") then
  g_logger.fatal("Modules dir doesn't exist.")
end

-- PROTEÇÃO: Bloquear carregamento de mods externos
if g_resources.directoryExists("/mods") then
  g_logger.fatal("ERRO DE SEGURANÇA: Diretório /mods detectado!\n" ..
                 "Por motivos de segurança, módulos externos não são permitidos.\n" ..
                 "Remova o diretório /mods para continuar.\n" ..
                 "Contate o suporte se isso é um erro.")
end

g_configs.loadSettings("/config.otml")

local settings = g_configs.getSettings()
local layout = DEFAULT_LAYOUT
if g_app.isMobile() then
  layout = "mobile"
elseif settings:exists('layout') then
  layout = settings:getValue('layout')
end
g_resources.setLayout(layout)

-- load mods
g_modules.discoverModules()

-- CARREGAR SISTEMA DE SEGURANÇA PRIMEIRO
g_logger.info("=== CARREGANDO SISTEMA DE PROTEÇÃO ANTI-BOT ===")
g_logger.info("=== SISTEMA DE PROTEÇÃO ATIVADO ===")

g_modules.ensureModuleLoaded("corelib")
  
local function loadModules()
  -- libraries modules 0-99
  g_modules.autoLoadModules(99)
  g_modules.ensureModuleLoaded("gamelib")

  -- client modules 100-499
  g_modules.autoLoadModules(499)
  g_modules.ensureModuleLoaded("client")

  -- game modules 500-999
  g_modules.autoLoadModules(999)
  g_modules.ensureModuleLoaded("game_interface")
  g_modules.ensureModuleLoaded("game_minimap")

  -- mods 1000-9999
  g_modules.autoLoadModules(9999)

  if g_modules.getModule("game_healthinfo") then
    g_modules.ensureModuleLoaded("game_healthinfo")
  end

  if g_modules.getModule("game_pkmd_visuals") then
    g_modules.ensureModuleLoaded("game_pkmd_visuals")
  end
end

-- report crash
if type(Services.crash) == 'string' and Services.crash:len() > 4 and g_modules.getModule("crash_reporter") then
  g_modules.ensureModuleLoaded("crash_reporter")
end

-- run updater, must use data.zip
if type(Services.updater) == 'string' and Services.updater:len() > 4 
  and g_resources.isLoadedFromArchive() and g_modules.getModule("updater") then
  g_modules.ensureModuleLoaded("updater")
  return Updater.init(loadModules)
end


loadModules()
