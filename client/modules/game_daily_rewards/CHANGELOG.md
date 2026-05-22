# Changelog - Daily Rewards Module

## Versão 1.1.0 - 13/03/2026

### ✨ Novas Funcionalidades
- **Imagens Integradas da PSTORY**: Adicionadas imagens de alta qualidade
  - `banner.png` - Banner do header
  - `corki.png` - Personagem Corki
  - `gift.png` - Ícone de presente
  - `sonia.png` - Personagem Sonia

- **Timer em Tempo Real**: Atualização automática do contador de tempo
  - Timer atualiza a cada 1 segundo quando a janela está visível
  - Mostra horas e minutos até a próxima recompensa

- **Arquivo de Estilos**: Novo arquivo `styles.otui` com estilos adicionais
  - Estados visuais para dias coletados, atuais e futuros
  - Melhor organização de estilos

- **Documentação Expandida**:
  - `SERVER_INTEGRATION.md` - Guia completo de integração com servidor
  - `USAGE_EXAMPLES.md` - Exemplos práticos de uso
  - `CHANGELOG.md` - Este arquivo

### 🎨 Melhorias Visuais
- Interface melhorada com banner no header
- Melhor organização dos elementos
- Cores mais consistentes e visuais
- Tamanho da janela aumentado para melhor visualização

### 🔧 Melhorias Técnicas
- Adicionado gerenciamento de timer para evitar vazamento de memória
- Melhor tratamento de eventos
- Código mais organizado e documentado
- Suporte a atualização periódica de dados

### 📚 Documentação
- README.md atualizado com informações sobre imagens
- Novo arquivo SERVER_INTEGRATION.md com exemplos de código servidor
- Novo arquivo USAGE_EXAMPLES.md com exemplos práticos
- Documentação de protocolo expandida

### 🐛 Correções
- Corrigido vazamento de timer ao fechar janela
- Melhorado tratamento de erros
- Validação de dados mais robusta

---

## Versão 1.0.0 - 29/10/2025

### ✨ Funcionalidades Iniciais
- Sistema de 21 dias de recompensas
- Interface visual com estados (bloqueado/disponível/coletado)
- Comunicação com servidor via protocolo estendido (opcode 2)
- Suporte a JSON para troca de dados
- Cores indicativas para cada estado
- Contador de tempo até próxima recompensa
- 21 recompensas pré-configuradas

### 📁 Arquivos Iniciais
- `game_daily_rewards.lua` - Lógica principal
- `game_daily_rewards.otui` - Interface
- `game_daily_rewards.otmod` - Configuração do módulo
- `README.md` - Documentação básica

---

## Roadmap Futuro

### Versão 1.2.0 (Planejado)
- [ ] Suporte a mais de 21 dias
- [ ] Sistema de bônus por sequência
- [ ] Animações ao coletar recompensa
- [ ] Sons customizáveis
- [ ] Integração com sistema de achievements
- [ ] Histórico de recompensas coletadas

### Versão 1.3.0 (Planejado)
- [ ] Recompensas aleatórias
- [ ] Sistema de multiplicador de recompensas
- [ ] Integração com VIP
- [ ] Recompensas especiais em datas comemorativas
- [ ] Suporte a múltiplos idiomas

### Versão 2.0.0 (Planejado)
- [ ] Redesign completo da interface
- [ ] Novo sistema de animações
- [ ] Suporte a temas customizáveis
- [ ] API pública para extensões
- [ ] Sistema de plugins

---

## Notas de Atualização

### De 1.0.0 para 1.1.0

**Mudanças Obrigatórias:**
- Nenhuma mudança obrigatória no servidor
- Compatível com versão anterior

**Mudanças Recomendadas:**
- Atualizar cliente para versão 1.1.0
- Copiar novas imagens da pasta PSTORY
- Revisar documentação de integração

**Migração:**
1. Fazer backup do módulo antigo
2. Copiar novo módulo
3. Copiar imagens da PSTORY
4. Reiniciar cliente
5. Testar funcionalidades

---

## Contribuidores

- **PokeChronus Team** - Desenvolvimento principal
- **PSTORY** - Recursos de imagens

---

## Licença

Este módulo é parte do projeto PokeChronus e segue a licença do projeto.

---

## Suporte

Para reportar bugs ou sugerir melhorias:
- Website: https://pokechronus.online
- Forum: https://pokechronus.online/forum
- Discord: https://discord.gg/pokechronus

---

## Histórico de Versões

| Versão | Data | Status |
|--------|------|--------|
| 1.1.0 | 13/03/2026 | ✅ Atual |
| 1.0.0 | 29/10/2025 | ✅ Estável |

---

**Última Atualização:** 13/03/2026
**Próxima Revisão:** 13/06/2026
