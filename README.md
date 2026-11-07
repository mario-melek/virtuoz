# Virtuoz

Ce dépôt sert à distribuer Virtuoz : les versions à télécharger (onglet **Releases**) et les outils de réparation.

## La fenêtre de Virtuoz reste noire ou vide

Ces commandes ferment Virtuoz et le relancent dans un affichage qui se voit. Vos projets, vos réglages et votre
connexion Skool ne sont pas touchés.

**Windows** : ouvrez PowerShell et collez :

```powershell
irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex
```

Toujours sombre ? Graphismes logiciels (plus lents, s'affichent toujours) :

```powershell
$env:CZ_RESCUE='software'; irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex
```

**Mac** : ouvrez Terminal et collez :

```bash
curl -fsSL https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.sh | bash
```

Après une mise à jour du pilote graphique (ou de macOS), revenez à la pleine vitesse dans Virtuoz :
**Réglages > Système > Graphismes**.
