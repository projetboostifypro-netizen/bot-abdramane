# BotHoster — Site Web (Frontend)

> Ce projet est 100% indépendant de Replit.
> Replit a servi uniquement à générer ce ZIP.
> Déployez ce dossier sur Vercel et votre backend sur votre VPS KataBump.

---

## 🚀 Méthode recommandée — Push GitHub automatique + Vercel

### Étape 1 — Extraire le ZIP et lancer le script

**Linux / Mac :**
```bash
unzip bothoster-site.zip -d bothoster-site
cd bothoster-site
chmod +x push-to-github.sh
./push-to-github.sh
```

**Windows :**
Double-cliquez sur `push-to-github.bat`

Le script demande :
- Votre **token GitHub** (https://github.com/settings/tokens → cochez "repo")
- Le **nom du dépôt** (ex: `bothoster-site`)
- Privé ou public

Il crée le dépôt et y pousse tout le code automatiquement.

### Étape 2 — Connecter à Vercel

1. Allez sur https://vercel.com/new
2. **"Import Git Repository"** → sélectionnez votre dépôt
3. Laissez **Root Directory = ./** (défaut)
4. **Deploy** → site en ligne en ~1 minute

> Le `vercel.json` proxifie automatiquement `/api/*` → VPS (51.83.103.24:20090)
> Aucune variable d'environnement à configurer sur Vercel.

---

## 📤 Méthode alternative — Upload direct sur Vercel

1. https://vercel.com → "Add New Project"
2. Glissez-déposez le dossier extrait → **Deploy**

---

## 💻 Test local

```bash
npm install
cp .env.example .env.local
npm run dev
```

---

## Architecture

```
Navigateur → /api/*  → Vercel Proxy → 51.83.103.24:20090 (VPS KataBump)
Navigateur → /*      → Vercel SPA   → index.html
```

Aucune dépendance vers Replit. Les deux ZIPs (site + serveur) sont autonomes.
