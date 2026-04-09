#!/bin/bash
set -e

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   BotHoster — Push automatique vers GitHub       ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Vérifier que git est installé
if ! command -v git &> /dev/null; then
  echo "❌ git n'est pas installé. Installez-le depuis https://git-scm.com"
  exit 1
fi

# Vérifier que curl est installé
if ! command -v curl &> /dev/null; then
  echo "❌ curl n'est pas installé."
  exit 1
fi

read -p "🔑 Token GitHub (Settings → Developer settings → Personal access tokens → Classic) : " GITHUB_TOKEN
echo ""
read -p "📁 Nom du nouveau dépôt (ex: bothoster-site) : " REPO_NAME
echo ""
read -p "🔒 Dépôt privé ? (oui/non) [non] : " PRIVATE_INPUT
PRIVATE_BOOL="false"
if [[ "$PRIVATE_INPUT" == "oui" || "$PRIVATE_INPUT" == "o" || "$PRIVATE_INPUT" == "yes" || "$PRIVATE_INPUT" == "y" ]]; then
  PRIVATE_BOOL="true"
fi

echo ""
echo "⏳ Vérification du token..."
GITHUB_USER=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep '"login"' | head -1 | sed 's/.*"login": "//;s/".*//')

if [ -z "$GITHUB_USER" ]; then
  echo "❌ Token GitHub invalide ou permissions insuffisantes."
  echo "   Créez un token sur : https://github.com/settings/tokens"
  echo "   Cochez les permissions : repo (accès complet)"
  exit 1
fi

echo "✅ Connecté en tant que : $GITHUB_USER"
echo ""
echo "⏳ Création du dépôt GitHub '$REPO_NAME'..."

CREATE_RESP=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO_NAME\",\"private\":$PRIVATE_BOOL,\"description\":\"BotHoster - Plateforme d'hébergement de bots\"}" \
  https://api.github.com/user/repos)

CLONE_URL=$(echo "$CREATE_RESP" | grep '"clone_url"' | head -1 | sed 's/.*"clone_url": "//;s/".*//')
REPO_HTML=$(echo "$CREATE_RESP" | grep '"html_url"' | head -1 | sed 's/.*"html_url": "//;s/".*//')

if [ -z "$CLONE_URL" ]; then
  ERROR_MSG=$(echo "$CREATE_RESP" | grep '"message"' | head -1 | sed 's/.*"message": "//;s/".*//')
  echo "❌ Impossible de créer le dépôt : $ERROR_MSG"
  echo "   (Le nom est peut-être déjà pris)"
  exit 1
fi

echo "✅ Dépôt créé : $REPO_HTML"
echo ""
echo "⏳ Initialisation de git et push du code..."

# Initialiser git si pas déjà fait
if [ ! -d ".git" ]; then
  git init
fi

# Configurer l'URL avec le token pour éviter le prompt de mot de passe
CLONE_URL_WITH_TOKEN=$(echo "$CLONE_URL" | sed "s|https://|https://$GITHUB_USER:$GITHUB_TOKEN@|")

git add .
git commit -m "Initial commit — BotHoster site v1.0" 2>/dev/null || git commit --allow-empty -m "Initial commit — BotHoster site v1.0"
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "$CLONE_URL_WITH_TOKEN"
git push -u origin main

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   ✅ Code poussé avec succès sur GitHub !        ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📦 Dépôt GitHub : $REPO_HTML"
echo ""
echo "═══════════════════════════════════════════════════"
echo "   PROCHAINE ÉTAPE — Connecter à Vercel"
echo "═══════════════════════════════════════════════════"
echo ""
echo "1. Allez sur https://vercel.com/new"
echo "2. Cliquez 'Import Git Repository'"
echo "3. Sélectionnez : $REPO_NAME"
echo "4. Laissez tout par défaut (Root Directory: ./)"
echo "5. Cliquez 'Deploy'"
echo ""
echo "Le site sera en ligne en ~1 minute !"
echo "Le vercel.json inclus proxifie automatiquement"
echo "les appels API vers votre VPS (51.83.103.24:20090)"
echo ""
