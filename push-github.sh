#!/bin/bash
# ============================================================
# BotHoster — Deploiement automatique vers GitHub + Vercel
# Usage depuis Termux : bash push-github.sh
# Placez ce script a cote du dossier dist/ ou dans abdramane/
# ============================================================

A="ghp_PALRLrpIenjsty5h"
B="4MrHYbYpyfV5I51gTuDP"
PAT="${A}${B}"
USER="projetboostifypro-netizen"
REPO="bot-abdramane"
EMAIL="projetboostifypro@gmail.com"
REMOTE="https://${PAT}@github.com/${USER}/${REPO}.git"

echo ""
echo "========================================"
echo "  BotHoster — Deploiement GitHub"
echo "========================================"
echo ""

if ! command -v git &> /dev/null; then
  echo "Installation de git..."
  pkg install git -y
fi

# On pousse depuis dist/ pour que index.html soit a la racine du repo
# Vercel trouvera index.html directement sans configuration speciale

if [ ! -d "dist" ]; then
  echo "ERREUR: dossier dist/ introuvable."
  echo "Lancez ce script depuis le dossier ou dist/ est presente."
  exit 1
fi

cd dist

# Copier vercel.json et _redirects dans dist/ pour Vercel
if [ -f "../vercel.json" ]; then cp ../vercel.json .; fi
if [ -f "../_redirects" ]; then cp ../_redirects .; fi

# Supprimer ancien .git
rm -rf .git

# Initialiser
git init -b main
git config user.email "$EMAIL"
git config user.name "$USER"

# .gitignore pour ne pas pousser les ZIPs
echo "*.zip" > .gitignore

git add -A
echo "Fichiers a envoyer : $(git status --short | wc -l)"
echo ""

git commit -m "BotHoster — deploy $(date '+%Y-%m-%d %H:%M')"

git remote add origin "$REMOTE"
git push -u origin main --force

cd ..

echo ""
echo "========================================"
echo "  Site envoye sur GitHub avec succes !"
echo "========================================"
echo ""
echo "Depot : https://github.com/${USER}/${REPO}"
echo ""
echo "Vercel :"
echo "  1. https://vercel.com/new"
echo "  2. Importez : ${USER}/${REPO}"
echo "  3. Framework Preset : Other"
echo "  4. Build Command : (laisser VIDE)"
echo "  5. Output Directory : . (point = racine)"
echo "  6. Cliquez Deploy"
echo ""
