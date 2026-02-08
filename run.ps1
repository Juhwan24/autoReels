$global:__AUTO_VENV_ACTIVE = $null

function Find-VenvInParents {
    param(
        [string]$StartDir
    )

    $dir = Resolve-Path $StartDir
    while ($dir -ne $null) {
        foreach ($name in @(".venv")) {
            $candidate = Join-Path $dir $name
            $activate = Join-Path $candidate "Scripts\Activate.ps1"
            if (Test-Path $activate) {
                return $activate
            }
        }

        $parent = Split-Path $dir -Parent
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    return $null
}

function Auto-Venv {
    $activatePath = Find-VenvInParents -StartDir (Get-Location).Path

    if ($activatePath) {
        $venvRoot = Split-Path $activatePath -Parent | Split-Path -Parent
        if ($global:__AUTO_VENV_ACTIVE -ne $venvRoot) {
            if ($env:VIRTUAL_ENV) {
                try { deactivate } catch {}
            }
            . $activatePath
            $global:__AUTO_VENV_ACTIVE = $venvRoot
        }
        return
    }
    if ($env:VIRTUAL_ENV) {
        try { deactivate } catch {}
    }
    $global:__AUTO_VENV_ACTIVE = $null
}
if (-not (Get-Command __orig_set_location -ErrorAction SilentlyContinue)) {
    Set-Alias __orig_set_location Set-Location
}

function Set-Location {
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string]$Path
    )
    __orig_set_location @PSBoundParameters
    Auto-Venv
}

Auto-Venv
