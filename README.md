# Makeup Flow

React + Vite + Supabase + Cloudflare Pages.

## Set up Supabase

1. Create an SQL query in **Supabase → SQL Editor**, paste and execute `supabase/schema.sql`.
2. In **Authentication → Providers → Email**, enable email/password sign-in. Email confirmations may be required depending on your Auth settings.
3. In **Authentication → URL Configuration**, set the deployed site URL and add the Cloudflare Pages URLs to Redirect URLs.

## Run

```bash
npm install
npm run dev
npm run build
```

The provided `.env.example` uses the supplied *publishable* key, which is designed for frontend use. Copy it to `.env` for local development. Never put a service_role or secret key in frontend environment variables.

## Deploy on Cloudflare Pages

- Framework preset: **Vite**
- Build command: `npm run build`
- Build output directory: `dist`
- Production environment variables:
  - `VITE_SUPABASE_URL` = `https://icdfblosbrqlvfocungu.supabase.co`
  - `VITE_SUPABASE_PUBLISHABLE_KEY` = your publishable key in `.env.example`
- Create a GitHub repository, upload all files **including `src` and `supabase`**, and connect it to Cloudflare Pages.

## Data, backups & limitations

- Each account has one JSONB document protected by Supabase RLS.
- Legacy data from the prototype can be exported as JSON from its Settings, then imported from Makeup Flow Settings. **Import replaces the current account's Makeup Flow data. Back up first.**
- Uploaded images are resized to at most 720 px on the long side and JPEG quality 65%, then stored inside the JSON document. Very large collections may hit limits. Future production scaling should use a private Supabase Storage bucket with user-scoped RLS, not JSON-embedded images.
- Current approach is a single-document last-write-wins sync. Do not edit the same account simultaneously on multiple devices; future production work should add per-record tables and conflict resolution.
- Existing live Supabase tables are not dropped or cleared; `schema.sql` creates only `public.makeup_flow_data` and its RLS policies.
- Browser UI end-to-end validation and production build have not yet been performed in this environment because dependency installation was unavailable.
