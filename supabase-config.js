/* Configuración pública del cliente Supabase. No coloques aquí service_role ni secret keys. */
(() => {
  const SUPABASE_URL = "PEGA_AQUI_TU_PROJECT_URL";
  const SUPABASE_PUBLISHABLE_KEY = "PEGA_AQUI_TU_PUBLISHABLE_KEY";
  if (!window.supabase || SUPABASE_URL.startsWith("PEGA_") || SUPABASE_PUBLISHABLE_KEY.startsWith("PEGA_")) {
    window.supabaseClient = null;
    return;
  }
  window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);
})();
