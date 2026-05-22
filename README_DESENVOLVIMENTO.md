# Desenvolvimento PKC

## Estrutura

- `client/`: client jogavel, modulos, interface, dados e fontes em `client/sources/`.
- `server/`: servidor jogavel, `data/`, configs, SQLs e fontes em `server/src/`.
- Executavel do client: `client/-=otclient_gl.exe`.
- Executavel do servidor: `server/- theforgottenserver-x64.exe`.

## Git normal

Devem ir para Git normal:

- fontes do client e servidor (`.cpp`, `.h`, `.hpp`);
- scripts Lua;
- XMLs;
- `modules/`;
- arquivos `.otui` e `.otmod`;
- arquivos de projeto (`.sln`, `.vcxproj`, `.vcxproj.filters`, `CMakeLists.txt`, props);
- configs de exemplo, como `config.lua.dist`;
- imagens pequenas e arquivos de interface do projeto.

## Git LFS

Devem ir para Git LFS:

- `*.spr`, incluindo `client/data/things/1098/Tibia.spr`;
- `*.dat`, incluindo `client/data/things/1098/Tibia.dat`;
- `*.cwm`, incluindo `client/data/things/1098/Tibia.cwm`;
- `*.otb`, incluindo `server/data/items/items.otb`;
- `*.otbm`, incluindo `server/data/world/map2.otbm`;
- `*.exe` e `*.dll` necessarios para rodar;
- `*.ogg`, `*.wav`, `*.psd`, `*.aseprite`;
- imagens grandes.

Para adicionar um novo tipo de arquivo grande:

```bat
git lfs track "*.extensao"
git add .gitattributes
git add caminho\do\arquivo.extensao
git commit -m "Adiciona arquivo grande no LFS"
```

## Ignorados

O `.gitignore` ignora lixo de build, cache e arquivos locais:

- `.vs/`, `Debug/`, `Release/`, `x64/`, `x86/`, `build/`, `out/`, `bin/`, `obj/`;
- intermediarios como `.obj`, `.iobj`, `.ipdb`, `.pdb`, `.ilk`, `.idb`, `.tlog`, `.lastbuildstate`, `.VC.db`;
- logs, cache e crashlogs;
- compactados de trabalho `.zip`, `.rar`, `.7z`;
- `vcpkg_installed/` e `client/sources/vcpkg_dynamic/`.

## Teste de clone funcional

1. Clone em outra pasta ou maquina.
2. Rode `git lfs pull`.
3. Abra `VERIFICAR_AMBIENTE.bat`.
4. Abra `INICIAR_SERVIDOR.bat`.
5. Abra `INICIAR_CLIENT.bat`.

Se o Git LFS baixar apenas ponteiros, rode:

```bat
git lfs install
git lfs fetch --all
git lfs pull
git lfs checkout
```

## Trabalho em dupla

Fluxo recomendado:

1. `ATUALIZAR.bat`
2. editar
3. testar
4. `ENVIAR.bat`

Regra principal: uma pessoa nao deve editar arquivos grandes ao mesmo tempo que a outra.

Arquivos binarios como `Tibia.spr`, `Tibia.dat`, `Tibia.cwm`, `map2.otbm`, `items.otb`, executaveis e DLLs nao fazem merge bem. Combine antes quem vai mexer neles.

## Observacoes

- Nao usar `git reset --hard` nem `git clean -fd` nos scripts do socio.
- Nao fazer `git push` automatico sem revisar quando estiver preparando mudancas estruturais.
- Revisar `server/config.lua` antes de publicar, porque ele pode conter senha real de banco.
