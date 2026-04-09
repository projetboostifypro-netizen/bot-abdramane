# BotHoster — Site Web (Frontend)

> Ce projet est 100% indépendant de Replit.
> Replit a servi uniquement à générer ce ZIP.
> Déployez ce dossier sur Vercel et votre backend sur votre VPS KataBump.

## Déploiement sur Vercel (recommandé)

1. Créez un compte sur https://vercel.com
2. Importez ce projet : "Add New Project" → "Upload" (chargez ce ZIP décompressé, ou via GitHub)
3. **Aucune variable d'environnement à configurer** — le `vercel.json` inclus
   proxifie automatiquement les appels `/api/*` vers votre VPS (51.83.103.24:3001)
4. Si vous avez la clé SoleasPay, ajoutez dans Settings → Environment Variables :

   | Variable               | Valeur              |
   |------------------------|---------------------|
   | VITE_SOLEASPAY_API_KEY | votre_clé_soleaspay |

5. Cliquez **Deploy** — le site sera en ligne en ~1 minute

## Test local (optionnel)

```bash
npm install
cp .env.example .env.local
# Ouvrez .env.local et renseignez votre clé SoleasPay si nécessaire
npm run dev
```

## Architecture

```
Navigateur → /api/*  → Vercel Proxy → 51.83.103.24:20090
Navigateur → /*      → Vercel SPA   → index.html
```

Aucune dépendance vers Replit. Les deux ZIPs (site + serveur) sont autonomes.
