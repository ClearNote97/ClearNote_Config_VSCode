# setup.ps1

# Instalar extensiones desde lista
Get-Content extensions.txt | ForEach-Object {
    code --install-extension $_
}

# Copiar settings si se quiere usar en esta máquina
Copy-Item -Path ".\settings.json" -Destination "$env:APPDATA\Code\User\settings.json" -Force

# (Opcional) Copiar keybindings si existe
if (Test-Path ".\keybindings.json") {
    Copy-Item -Path ".\keybindings.json" -Destination "$env:APPDATA\Code\User\keybindings.json" -Force
}

Write-Host "✅ Configuración aplicada correctamente."