# Réparation de Virtuoz (Windows) : ferme Virtuoz et le relance dans un affichage qui se voit.
# Usage : irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex
# Graphismes logiciels (plus lent, s'affiche toujours) : $env:CZ_RESCUE='software'; irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex
# Vos projets, vos réglages et votre connexion Skool ne sont pas touchés.
& {
  $mode = if ($env:CZ_RESCUE -eq 'software') { 'software' } else { 'safe' }

  # Où Virtuoz est installé : d'abord l'inscription de Windows, puis les dossiers habituels.
  $keys = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
  $dirs = @(Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like 'Virtuoz*' -and $_.DisplayName -notlike '*Launcher*' -and $_.InstallLocation } | ForEach-Object { $_.InstallLocation })
  $dirs += Join-Path $env:LOCALAPPDATA 'Programs\virtuoz'
  $dirs += Join-Path $env:LOCALAPPDATA 'Programs\Virtuoz'
  $exe = $dirs | ForEach-Object { Join-Path $_ 'Virtuoz.exe' } | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
  if (-not $exe) {
    Write-Host "Virtuoz n'est pas installé sur cet ordinateur (Virtuoz.exe introuvable)." -ForegroundColor Red
    Write-Host "Réinstallez-le depuis https://github.com/mario-melek/virtuoz/releases"
    return
  }
  Write-Host "Virtuoz trouvé : $exe"

  # Fermer seulement ce Virtuoz-là.
  $running = @(Get-Process -Name Virtuoz -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe })
  if ($running.Count) {
    Write-Host 'Fermeture de Virtuoz...'
    $running | ForEach-Object { $_.CloseMainWindow() | Out-Null }
    $deadline = (Get-Date).AddSeconds(15)
    while ((Get-Process -Name Virtuoz -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe }) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 500 }
    Get-Process -Name Virtuoz -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe } | Stop-Process -Force -ErrorAction SilentlyContinue
  }

  # Virtuoz vide ses caches graphiques et garde ce mode quand il démarre avec --graphics-mode.
  Start-Process -FilePath $exe -ArgumentList "--graphics-mode=$mode"
  if ($mode -eq 'safe') {
    Write-Host "Virtuoz redémarre en affichage sûr (la 3D reste sur la carte graphique)." -ForegroundColor Green
    Write-Host "Toujours sombre ? Fermez-le et lancez : `$env:CZ_RESCUE='software'; irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex"
  } else {
    Write-Host "Virtuoz redémarre en graphismes logiciels (plus lent, s'affiche toujours)." -ForegroundColor Green
  }
  Write-Host "Après une mise à jour du pilote graphique : Réglages > Système > Graphismes pour revenir à la pleine vitesse."
}
