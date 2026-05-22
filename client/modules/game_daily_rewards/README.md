# 🎁 Daily Login Rewards - OTClient Module

Sistema de recompensas diárias com 21 dias de prêmios progressivos.

## 📦 Instalação

1. Copie a pasta `game_daily_rewards` para `/modules/` do seu OTClient
2. Reinicie o cliente
3. O módulo será carregado automaticamente

## 🎮 Como Usar

### Abrir Janela:
```lua
modules.game_daily_rewards.show()
```

### Fechar Janela:
```lua
modules.game_daily_rewards.hide()
```

### Ativar Botão no Topo:
Descomente a linha 27 no arquivo `game_daily_rewards.lua`

## ⚙️ Configuração

- **Opcode:** 2 (0x2)
- **Formato:** JSON
- **AutoShow:** true (mostra automaticamente ao logar)

## 📊 Protocolo

**Cliente → Servidor:**
- `{"action": "claim"}` - Coletar recompensa
- `{"action": "refresh"}` - Atualizar dados

**Servidor → Cliente:**
```json
{
  "rewards": {...},
  "currentDay": 5,
  "canClaim": true,
  "nextClaim": 1730246400,
  "autoShow": true
}
```

## 🎨 Personalização

Edite `game_daily_rewards.otui` para customizar:
- Cores
- Tamanhos
- Posições
- Fontes

## 📝 Arquivos

- `game_daily_rewards.otmod` - Definição do módulo
- `game_daily_rewards.lua` - Lógica do cliente
- `game_daily_rewards.otui` - Interface visual
- `styles.otui` - Estilos adicionais
- `images/` - Imagens integradas da PSTORY:
  - `banner.png` - Banner do header
  - `corki.png` - Personagem Corki
  - `gift.png` - Ícone de presente
  - `sonia.png` - Personagem Sonia

## ✅ Features

- ✅ 21 dias de recompensas
- ✅ Estados visuais (bloqueado/disponível/coletado)
- ✅ Atualização automática
- ✅ Feedback em tempo real
- ✅ Contador de tempo
- ✅ Reset diário
- ✅ Imagens integradas da PSTORY
- ✅ Timer em tempo real

## 🐛 Debug

```lua
-- Ver dados
print(modules.game_daily_rewards)

-- Forçar update
modules.game_daily_rewards.requestRewardsData()

-- Ver widgets
print(#modules.game_daily_rewards.rewardWidgets)
```

## 📞 Suporte

Documentação completa: `/home/MODULO_OTCLIENT_DAILY_REWARDS.md`

---

**Versão:** 1.1.0  
**Autor:** PokeChronus Team  
**Data:** 13/03/2026
**Atualização:** Imagens integradas da PSTORY + Timer em tempo real
