#!/bin/bash
# Réparation de Virtuoz (Mac) : ferme Virtuoz et le relance en graphismes logiciels, qui s'affichent toujours.
# Usage : curl -fsSL https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.sh | bash
# Vos projets, vos réglages et votre connexion Skool ne sont pas touchés.
set -u
app=""
for a in "/Applications/Virtuoz.app" "$HOME/Applications/Virtuoz.app"; do
  [ -d "$a" ] && app="$a" && break
done
if [ -z "$app" ]; then
  echo "Virtuoz n'est pas installé sur ce Mac (Virtuoz.app introuvable dans Applications)."
  echo "Réinstallez-le depuis https://github.com/mario-melek/virtuoz/releases"
  exit 1
fi
echo "Virtuoz trouvé : $app"

if pgrep -f "$app/Contents/MacOS/" >/dev/null; then
  echo "Fermeture de Virtuoz..."
  osascript -e 'quit app "Virtuoz"' >/dev/null 2>&1
  for _ in $(seq 1 30); do pgrep -f "$app/Contents/MacOS/" >/dev/null || break; sleep 0.5; done
  pkill -f "$app/Contents/MacOS/" 2>/dev/null
fi

# Virtuoz vide ses caches graphiques et garde ce mode quand il démarre avec --graphics-mode.
open -a "$app" --args --graphics-mode=software
echo "Virtuoz redémarre en graphismes logiciels (plus lent, s'affiche toujours)."
echo "Après une mise à jour de macOS : Réglages > Système > Graphismes pour revenir à la carte graphique."
