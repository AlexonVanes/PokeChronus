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
- `vcpkg_installed/`, `client/sources/vcpkg_dynamic/` e `client/sources/vcpkg_static/`.

## Compilacao Release

As dependencias locais nao sao enviadas ao Git. Para restaurar as versoes fixadas,
compilar os dois executaveis e copiar as DLLs distribuiveis do servidor, rode:

```bat
COMPILAR_RELEASE.bat
```

Requisitos da maquina que compila:

- Visual Studio 2022 Build Tools com Desktop development with C++ e toolset `v143`;
- `vcpkg` em `C:\vcpkg`, ou a variavel `VCPKG_ROOT` apontando para sua instalacao;
- unidade `P:` livre durante a compilacao.

O script usa temporariamente `P:` para impedir falhas em ferramentas que nao lidam
corretamente com caminhos acentuados. O servidor e compilado em `Release|x64` com
DLLs e runtime VC143 locais. O cliente `OpenGL|x64` liga suas dependencias
estaticamente, usando Boost 1.91 e LuaJIT legado fixados no manifesto para manter a
inicializacao estavel. Executaveis e DLLs finais seguem no Git LFS.

## Teste de clone funcional

1. Clone em outra pasta ou maquina.
2. Rode `git lfs pull`.
3. Rode `VERIFICAR_AMBIENTE.bat`.
4. Abra `INICIAR_SERVIDOR.bat`.
5. Abra `INICIAR_CLIENT.bat`.

Se o Git LFS baixar apenas ponteiros, rode:

```bat
git lfs install
git lfs fetch --all
git lfs pull
git lfs checkout
```

## Erro de DLL do servidor no Windows

Se o servidor pedir `VCRUNTIME140D.dll`, `MSVCP140D.dll` ou `ucrtbased.dll`, algum binario recebido (`.exe` ou `.dll`) foi compilado em modo `Debug`. Essas DLLs sao de desenvolvimento e nao devem ser distribuidas com o servidor. Um executavel Release tambem falhara se carregar, por exemplo, `libmariadb.dll`, `lua.dll` ou `pugixml.dll` em versao Debug.

Para corrigir uma copia que recebeu o executavel errado:

```bat
git pull
git lfs pull
git restore --source=HEAD -- server
git lfs checkout -- server
VERIFICAR_AMBIENTE.bat
```

O executavel do servidor e suas DLLs distribuidas devem ser `Release|x64` e depender de `VCRUNTIME140.dll`/`MSVCP140.dll`, sem a letra `D`. O pacote inclui localmente o runtime Release `Microsoft.VC143.CRT` necessario para iniciar o servidor em uma maquina limpa. O executavel principal do cliente e estatico e nao exige essas DLLs.

## Trabalho em dupla

Fluxo recomendado:

1. `ATUALIZAR.bat` (baixa via Git LFS e valida o pacote Release recebido)
2. editar
3. testar
4. `ENVIAR.bat`

Regra principal: uma pessoa nao deve editar arquivos grandes ao mesmo tempo que a outra.

Arquivos binarios como `Tibia.spr`, `Tibia.dat`, `Tibia.cwm`, `map2.otbm`, `items.otb`, executaveis e DLLs nao fazem merge bem. Combine antes quem vai mexer neles.

## Observacoes

- Nao usar `git reset --hard` nem `git clean -fd` nos scripts do socio.
- Nao fazer `git push` automatico sem revisar quando estiver preparando mudancas estruturais.
- Revisar `server/config.lua` antes de publicar, porque ele pode conter senha real de banco.
