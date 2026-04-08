# BotHoster — Site Web (Frontend)

> Ce projet est 100% indépendant de Replit.
> Replit a servi uniquement à générer ce ZIP.
> Déployez ce dossier sur Vercel et votre backend sur votre VPS KataBump.

## Déploiement sur Vercel (recommandé)

1. Créez un compte sur https://vercel.com
2. Importez ce projet : "Add New Project" → "Upload ZIP" (ou via GitHub)
3. Dans **Settings → Environment Variables**, ajoutez :

   | Variable              | Valeur                              |
   |-----------------------|-------------------------------------|
   | VITE_API_URL          | http://VOTRE_IP_VPS:3001            |
   | VITE_SOLEASPAY_API_KEY| votre_clé_soleaspay                 |

4. Cliquez **Deploy** — le site sera en ligne en ~1 minute

## Test local (optionnel)

```bash
npm install
cp .env.example .env.local
# Ouvrez .env.local et renseignez votre IP VPS + clé SoleasPay
npm run dev
```

## Architecture

```
[Vercel] bothoster-site → VITE_API_URL → [KataBump VPS :3001]
```

Aucune dépendance vers Replit. Les deux ZIPs (site + serveur) sont autonomes.
