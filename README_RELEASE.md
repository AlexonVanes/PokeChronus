# PKC Release

Pacote montado a partir da base limpa e visual do `PokeChronus`, com conteudo funcional importado de `TESTES`.

## O que foi consolidado

- Estrutura final: `client` e `server`.
- Visual do `PokeChronus` preservado: shaders 4K/PKMD, `game_pkmd_visuals`, `game_healthinfo` e `Tibia.cwm`.
- Conteudo ativo de `TESTES` incorporado: modulos, layouts, tela de login, imagens, bags, scripts, XMLs e dados de servidor.
- Artefatos de desenvolvimento removidos: logs, `.pdb`, `.obj`, `.lib`, backups, `.zip`, `.rar`, mapas backup e `Thumbs.db`.
- `/lua` do servidor desativado e script removido.
- Terminal do client mantido, mas sem execucao Lua arbitraria.

## Validacao local

- XMLs do servidor verificados: 1062 arquivos, 0 erros de parse.
- Referencias ativas de scripts nos XMLs principais: 0 ausentes.
- Scripts declarados em `.otmod`: 0 ausentes.
- Pasta final sem logs/backups/build artifacts detectados.
- Boot curto tentou iniciar o servidor, mas parou na conexao MySQL local indisponivel em `127.0.0.1`.

## Pendencias antes de producao publica

- Trocar `mysqlUser = "root"` e `mysqlPass = ""` por usuario dedicado e senha forte.
- Avaliar migracao de `passwordType = "sha1"`.
- Configurar IP publico/domino em `server/config.lua` e `client/init.lua`.
- Guardar `key.pem` como segredo operacional do servidor.
