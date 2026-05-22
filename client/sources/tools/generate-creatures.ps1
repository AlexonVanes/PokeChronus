Param(
    [Parameter(Mandatory=$true)]
    [string]$MonsterDir,
    [Parameter(Mandatory=$true)]
    [string]$OutputFile,
    [switch]$Overwrite
)

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$ts][$Level] $Message"
}

if (-not (Test-Path -Path $MonsterDir)) {
    Write-Log "Pasta de monsters não encontrada: $MonsterDir" 'ERROR'
    exit 1
}

$outDir = Split-Path -Parent $OutputFile
if ($outDir -and -not (Test-Path -Path $outDir)) {
    Write-Log "Criando pasta de saída: $outDir" 'INFO'
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

if ((Test-Path -Path $OutputFile) -and (-not $Overwrite)) {
    Write-Log "Arquivo já existe: $OutputFile (use -Overwrite para substituir)" 'ERROR'
    exit 1
}

Write-Log "Varredura dos arquivos em: $MonsterDir" 'INFO'
$files = Get-ChildItem -Path $MonsterDir -Recurse -Include *.xml,*.lua -ErrorAction Stop
Write-Log "Total de arquivos encontrados: $($files.Count)" 'INFO'

$creatures = @()

foreach ($f in $files) {
    if ($f.Extension -eq '.xml') {
        try {
            $xmlText = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop
            [xml]$doc = $xmlText
        } catch {
            Write-Log "Falha ao ler XML: $($f.FullName) — $($_.Exception.Message)" 'WARN'
            continue
        }

        $root = $doc.DocumentElement
        if (-not $root) { continue }
        $rootName = $root.Name.ToLower()
        if ($rootName -ne 'monster' -and $rootName -ne 'npc') { continue }

        $name = $root.GetAttribute('name')
        if (-not $name) { $name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }

        # Procura nó <look>
        $lookNode = $root.SelectSingleNode('//look')
        if (-not $lookNode) { continue }

        # Alguns servidores usam 'type' (OTClient) e outros 'looktype' (variações)
        $lookTypeAttr = $lookNode.Attributes['type']
        if (-not $lookTypeAttr) { $lookTypeAttr = $lookNode.Attributes['looktype'] }
        if (-not $lookTypeAttr) { continue }

        $lookTypeStr = $lookTypeAttr.Value
        [int]$lookType = 0
        [void][int]::TryParse($lookTypeStr, [ref]$lookType)
        if ($lookType -le 0) { continue }

        $creatures += [pscustomobject]@{
            Name = $name
            LookType = $lookType
            Source = $f.FullName
        }
    } elseif ($f.Extension -eq '.lua') {
        try {
            $luaText = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop
        } catch {
            Write-Log "Falha ao ler Lua: $($f.FullName) — $($_.Exception.Message)" 'WARN'
            continue
        }

        $name = $null
        $m = [regex]::Match($luaText, 'createMonsterType\s*\(\s*"([^"]+)"\s*\)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if (-not $m.Success) { $m = [regex]::Match($luaText, "createMonsterType\s*\(\s*'([^']+)'\s*\)", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) }
        if ($m.Success) { $name = $m.Groups[1].Value }
        if (-not $name) { $name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }

        $lm = [regex]::Match($luaText, '(?i)looktype\s*[:=]\s*(\d+)')
        if (-not $lm.Success) { $lm = [regex]::Match($luaText, '(?i)lookType\s*[:=]\s*(\d+)') }
        if (-not $lm.Success) {
            # tentar dentro de outfit = { ... lookType = N ... }
            $lm = [regex]::Match($luaText, '(?is)outfit\s*=\s*\{[^\}]*?(looktype|lookType)\s*=\s*(\d+)[^\}]*\}')
            if ($lm.Success -and $lm.Groups.Count -ge 3) {
                $lookTypeStr = $lm.Groups[2].Value
            } else {
                $lookTypeStr = $null
            }
        } else {
            $lookTypeStr = $lm.Groups[1].Value
        }

        if (-not $lookTypeStr) { continue }
        [int]$lookType = 0
        [void][int]::TryParse($lookTypeStr, [ref]$lookType)
        if ($lookType -le 0) { continue }

        $creatures += [pscustomobject]@{
            Name = $name
            LookType = $lookType
            Source = $f.FullName
        }
    }
}

# Remover duplicatas por LookType, priorizando primeiro encontrado
$unique = @{}
foreach ($c in $creatures) {
    if (-not $unique.ContainsKey($c.LookType)) { $unique[$c.LookType] = $c }
}

Write-Log "Creatures válidos (únicos por looktype): $($unique.Count)" 'INFO'

# Gerar creatures.xml simples
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<creatures>')

foreach ($kv in $unique.GetEnumerator() | Sort-Object Key) {
    $c = $kv.Value
    # Normaliza nome: Trim e primeira letra maiúscula por palavra
    $norm = ($c.Name).Trim()
    $norm = -join ($norm.ToLower().Split(' ') | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) })
    # Usa operador -f para evitar subexpressão $() dentro de aspas
    $line = '  <creature name="{0}" looktype="{1}" />' -f $norm, $c.LookType
    [void]$sb.AppendLine($line)
}

[void]$sb.AppendLine('</creatures>')

Set-Content -LiteralPath $OutputFile -Value $sb.ToString() -Encoding UTF8
Write-Log "Arquivo gerado: $OutputFile" 'INFO'
Write-Log "Concluído." 'INFO'