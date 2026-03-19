import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';



// Configurar __dirname para ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Cargar variables de entorno desde la raíz del proyecto
dotenv.config({ path: join(__dirname, '../../.env') });

// Tomar la URL y la KEY de tu .env
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

console.log('=== Configuración de Supabase ===');
console.log('URL Configurada:', supabaseUrl ? '✓ Sí' : '✗ No');
console.log('Key Configurada:', supabaseKey ? '✓ Sí' : '✗ No');
console.log('================================');

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Error: Faltan variables de entorno de Supabase');
  console.error('Asegúrate de que el archivo .env existe en:', join(__dirname, '../../.env'));
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

console.log("URL:", process.env.SUPABASE_URL);
export default supabase;