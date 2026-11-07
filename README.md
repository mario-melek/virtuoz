# Virtuoz

Créez des vidéos faceless dans de nombreux styles, ou dans votre propre style, en montrant la vidéo du doigt et en
demandant à Claude. Une seule commande installe tout : l'application et chaque outil dont elle a besoin.

## L'installer avec Claude Code

Claude Code est installé et connecté ? Collez-lui cette phrase entière, pas seulement le lien, et il fait toute
l'installation pour vous. Il doit tourner sur votre propre ordinateur : dans l'application Claude, ouvrez l'onglet
**Code** et réglez l'environnement sous la zone de message sur **This computer** (pas un environnement cloud).

```
Installe Virtuoz pour moi : https://github.com/mario-melek/virtuoz
```

Virtuoz est déjà installé et vous voulez la dernière version ? Collez ceci. Claude installe la mise à jour, vérifie
qu'elle démarre et laisse Virtuoz ouvert. Vos projets et vos réglages restent :

```
Mets à jour Virtuoz pour moi : https://github.com/mario-melek/virtuoz
```

Virtuoz est installé mais ne marche plus (ne s'ouvre pas, reste noir, une mise à jour ou un export échoue toujours) ?
Collez plutôt ceci :

```
Répare Virtuoz pour moi : https://github.com/mario-melek/virtuoz
```

**Claude : tes instructions sont dans [AGENTS.md](AGENTS.md). Si le membre n'a collé que ce lien, il veut
l'installation. Lis-le en entier avant de lancer quoi que ce soit.** Télécharge-le comme fichier et lis chaque ligne (un
résumé de page web perd les commandes exactes) :
`curl -fsSL -o virtuoz-AGENTS.md https://raw.githubusercontent.com/mario-melek/virtuoz/main/AGENTS.md`
(dans Windows PowerShell, tape `curl.exe`).

## Installer

### Windows 10 / 11

Ouvrez **PowerShell** (menu Démarrer, tapez `PowerShell`, appuyez sur Entrée) et collez :

```powershell
irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/install.ps1 | iex
```

### Mac (macOS 12 ou plus récent, Apple Silicon ou Intel)

Ouvrez **Terminal** (Cmd + Espace, tapez `Terminal`, appuyez sur Entrée) et collez :

```bash
curl -fsSL https://raw.githubusercontent.com/mario-melek/virtuoz/main/install.sh | bash
```

Sur un Mac sans Homebrew, il demande une fois le mot de passe de votre session Mac. Rien ne s'affiche pendant que vous
le tapez : c'est normal.

Quand l'installation est terminée, Virtuoz s'ouvre. Connectez-vous avec votre compte Skool, puis cliquez sur
**Se connecter** dans l'Accueil pour relier votre compte Claude.

## Virtuoz Launcher

L'installateur met aussi le **Virtuoz Launcher** sur votre ordinateur (Windows : menu Démarrer > Virtuoz Launcher ;
Mac : Applications). Vous n'avez
pas besoin de l'ouvrir : à chaque démarrage de Virtuoz, il vérifie de l'extérieur que sa fenêtre s'affiche vraiment. Si
elle reste noire, il vous pose la question une fois et relance Virtuoz dans un mode qui s'affiche, sans commande à taper
ni réglage à chercher.

Ouvrez-le vous-même quand Virtuoz ne démarre plus, ou pour :
- **mettre à jour** Virtuoz ;
- **revenir à une version précédente** si une nouvelle vous pose problème (vos réglages et vos projets de cette version
  reviennent, et les mises à jour se mettent en pause jusqu'à ce que vous les relanciez) ;
- **réparer** tout ce dont Virtuoz a besoin (il relance ce même installateur pour vous) ;
- **copier un diagnostic** ou **signaler un problème** quand l'application elle-même ne s'ouvre pas.

## La fenêtre reste noire ou vide ?

Le Launcher s'en occupe tout seul. Sans le Launcher, ou s'il n'y arrive pas : sur certaines cartes graphiques, la
fenêtre de Virtuoz s'ouvre mais reste noire. Cette commande ferme Virtuoz, le met à jour et le relance dans un mode qui
s'affiche sur ces ordinateurs. Vos projets, vos réglages et votre connexion Skool ne sont pas touchés.

Windows (PowerShell) :

```powershell
irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex
```

Mac (Terminal) :

```bash
curl -fsSL https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.sh | bash
```

Sur Windows, Virtuoz démarre alors en **affichage sûr** (la 3D reste sur la carte graphique, à pleine vitesse). Toujours
noir ? Fermez-le et lancez `$env:CZ_RESCUE='software'; irm https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.ps1 | iex`
(graphismes logiciels : plus lents, s'affichent toujours). Sur Mac, la réparation démarre en graphismes logiciels. Vous
pouvez revenir en arrière à tout moment dans Réglages > Système > Graphismes.

## Ce qui est installé

Ce que vous avez déjà est ignoré.

| | Windows | Mac |
|---|---|---|
| Gestionnaire de paquets | winget (intégré à Windows) | Homebrew |
| git (l'historique des modifications, pour pouvoir tout annuler) | ✓ | ✓ |
| ffmpeg (export avec le son) | ✓ | ✓ |
| Python 3 + numpy, scipy, pillow, stable-ts (le traitement du son) | ✓ | ✓ (dans l'environnement Python propre à l'application) |
| Le ffmpeg et le Python 3.12 de l'application (elle les télécharge et les vérifie elle-même au premier lancement) | ✓ | ✓ |
| Node.js (le rendu des intros animées que Claude modifie) | ✓ | ✓ |
| Claude Code (l'IA qui modifie vos vidéos, avec votre abonnement Claude) | ✓ | ✓ |
| Virtuoz | ✓ | ✓ |
| Virtuoz Launcher (répare une fenêtre qui ne s'affiche pas ; mise à jour, retour en arrière, réparation) | ✓ | ✓ |

Comptez 5 à 20 minutes, surtout pour les téléchargements. Les outils audio apportent PyTorch, quelques centaines de Mo.

## Mettre à jour ou réparer

Relancez la même commande. Elle met Virtuoz à jour si une nouvelle version est sortie et remet ce qui manque : chaque
fichier de l'application installée est vérifié, et s'il en manque un ou qu'il a changé, la même version est réinstallée.
Fermez Virtuoz avant. Si vous êtes revenu à une version précédente dans le Virtuoz Launcher, cette version reste.
Sur Windows, Virtuoz se met aussi à jour tout seul. Sur Mac, il affiche **Mise à jour disponible** quand une nouvelle
version sort.

Quand quelque chose ne peut pas être fait (par exemple claude.ai est injoignable pour l'instant), tout le reste est quand
même installé, et la fin de l'installation liste ce qui reste à faire et comment. Derrière un proxy qui demande un
identifiant, réglez `HTTPS_PROXY` sur `http://<utilisateur>:<mot de passe>@<hôte>:<port>` avant la commande.

## Téléchargement manuel

- Windows : [dernière version](https://github.com/mario-melek/virtuoz-releases/releases/latest). Windows peut afficher
  « Windows a protégé votre ordinateur » : cliquez sur **Informations complémentaires**, puis **Exécuter quand même**.
- Mac : [dernière version](https://github.com/mario-melek/virtuoz-mac-releases/releases/latest) (`Mac-arm64` pour
  Apple Silicon, `Mac-x64` pour Intel). L'application n'est pas encore signée par Apple. Après l'avoir glissée dans
  Applications, lancez une fois cette commande dans Terminal :
  `xattr -dr com.apple.quarantine /Applications/Virtuoz.app`

## Vos données

Vos projets sont dans `Documents/Virtuoz` sur votre ordinateur. Claude passe par votre propre connexion Claude Code.
Les vidéos Vox, les styles personnalisés et les miniatures créent leurs images sur votre propre compte Higgsfield ou
Fal.ai, avec votre propre clé API (environ un centime par image) : ces services reçoivent les descriptions des images et
les images de référence. Rien d'autre n'est envoyé.
