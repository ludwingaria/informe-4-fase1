import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import supabase from './config/supabase.js';

// Configurar __dirname para ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Cargar variables de entorno
dotenv.config({ path: join(__dirname, '../.env') });

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Verificación inicial
console.log('=== VERIFICACIÓN DE CONFIGURACIÓN ===');
console.log('PUERTO:', port);
console.log('SUPABASE_URL:', process.env.SUPABASE_URL ? '✓ Configurado' : '✗ No configurado');
console.log('SUPABASE_ANON_KEY:', process.env.SUPABASE_ANON_KEY ? '✓ Configurado' : '✗ No configurado');
console.log('=====================================');

// Ruta raíz
app.get('/', (req, res) => {
  res.json({ 
    message: 'API funcionando',
    status: 'ok',
    timestamp: new Date().toISOString()
  });
});

// Ruta para probar consulta
app.get('/api/test', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('usuario') // ⚠️ Asegúrate que el nombre de la tabla es EXACTO
    
      .select('*')
      .limit(5);

    if (error) throw error;

    res.json({
      success: true,
      registros_encontrados: data.length,
      data
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Error al consultar Supabase',
      error: err.message
    });
  }
});

 
 // Cursos
app.get('/api/curso', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('curso')  // Tabla 'curso' en Supabase
      .select('*')    // Selecciona todos los campos
      .limit(5);      // Limita a 5 registros

    if (error) throw error;

    res.json({
      success: true,
      registros_encontrados: data.length,
      data
    });
    //Manejo de errores (500 Internal Server Error)
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Error al consultar cursos',
      error: err.message
    });
  }
});

// Iniciar servidor
app.listen(port, () => {
  console.log(`\n✅ Servidor corriendo en http://localhost:3000`);
  console.log(`📝 Rutas disponibles:`);
  console.log(`   - GET  http://localhost:3000/`);
  console.log(`   - GET  http://localhost:3000/api/test`);
  console.log(`   - GET  http://localhost:3000/api/curso`);
  
  
});