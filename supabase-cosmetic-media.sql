-- Cosmetic Flow: private compressed photos (run once in Supabase SQL Editor)
-- Existing makeup_flow_data and cosmetic-skill-photos are untouched.
INSERT INTO storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
VALUES ('cosmetic-media','cosmetic-media',false,5242880,ARRAY['image/jpeg'])
ON CONFLICT (id) DO UPDATE SET
  public=false,
  file_size_limit=5242880,
  allowed_mime_types=EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Cosmetic media select own" ON storage.objects;
DROP POLICY IF EXISTS "Cosmetic media insert own" ON storage.objects;
DROP POLICY IF EXISTS "Cosmetic media delete own" ON storage.objects;

CREATE POLICY "Cosmetic media select own"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id='cosmetic-media' AND (storage.foldername(name))[1]=(SELECT auth.uid())::text);

CREATE POLICY "Cosmetic media insert own"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id='cosmetic-media' AND (storage.foldername(name))[1]=(SELECT auth.uid())::text);

CREATE POLICY "Cosmetic media delete own"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id='cosmetic-media' AND (storage.foldername(name))[1]=(SELECT auth.uid())::text);
