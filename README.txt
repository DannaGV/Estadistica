MELATE OBSERVATORIO 6/56 — 24 COMBINACIONES — CLOUDFLARE PAGES ESTÁTICO + SUPABASE

PUBLICACIÓN
1. Crea un proyecto Supabase.
2. En Supabase > SQL Editor, ejecuta TODO el archivo supabase_schema.sql.
3. En Supabase > Project Settings / Connect, copia Project URL y Publishable key.
4. Abre supabase-config.js y pega ambos valores en SUPABASE_URL y SUPABASE_PUBLISHABLE_KEY. No uses service_role ni secret key.
5. Guarda todos los archivos y comprime/sube el contenido de esta carpeta directamente en Cloudflare Pages > Direct Upload. Este paquete NO contiene wrangler.toml, functions ni proceso de build.
6. En index.html, crea una cuenta con correo/contraseña (mínimo 8 caracteres), inicia sesión. Si tienes confirmación de email activada, confirma el correo antes de iniciar sesión.
7. Captura 24 combinaciones distintas, seis números cada una, valida, introduce fecha y resultado, y pulsa Evaluar y guardar registro.
8. Abre stats.html con la sesión iniciada para revisar el histórico.

ARCHIVOS
- index.html: visualizador WebGL2, captura 24 combinaciones, resultado observado, evaluación individual/grupal y almacenamiento.
- stats.html: panel histórico independiente.
- basedatos.csv: histórico local R1..R6 para colorear puntos.
- supabase-config.js: configuración pública del cliente (Project URL y Publishable key).
- supabase_schema.sql: tablas, índices, permisos y políticas RLS.

MATEMÁTICA
Cada combinación es un conjunto de seis números, equivalente a un vector binario de 56 posiciones con seis unos. El orden no afecta identidad. Índice combinatorio 1..32,468,436. Aciertos h=|A∩B|; sustituciones=6-h; Hamming=2(6-h); Hamming normalizada=Hamming/12; score individual=100h/6; score global=promedio ponderado con peso 1 inicial.
Monte Carlo: 20,000 grupos aleatorios de 24 combinaciones distintas para referencia del score global. No representa probabilidad futura.

SEGURIDAD
La app exige cuenta autenticada. Las tablas tienen RLS y cada usuario solo puede consultar/insertar/borrar sus propios registros. En el navegador solo se expone la Publishable key. NUNCA pegues una service_role/secret key en supabase-config.js.

LIMITACIONES DE VALIDACIÓN
Se conserva el motor WebGL2 existente. El código local puede validarse sintácticamente, pero la persistencia solo se puede comprobar tras crear el proyecto Supabase, ejecutar el SQL y configurar URL/Publishable key. Cloudflare Pages Direct Upload acepta este sitio porque es estático y no incluye Wrangler ni Functions. El navegador debe tener WebGL2 habilitado.


MEJORA VISUAL 3D — EDICIÓN 360
- Se conserva la función matemática de cada punto y sus coordenadas deterministas.
- Se añadió sombreado radial por fragmento para dar volumen aparente, núcleo luminoso y halo suave.
- Se añadió variación de tamaño e iluminación por profundidad.
- Paleta diferenciada: universo azul, histórico turquesa, predicción violeta y observado ámbar.
- Se añadió pulso visual sutil por punto y giro automático continuo en varios ejes.
- Controles: botón Giro 360° para pausar/reanudar; arrastrar para orbitar; rueda para zoom; botón derecho o Shift+arrastrar para desplazar; Centrar cámara para restaurar.
- La cuarta dimensión no se representa como una coordenada física adicional: se codifica visualmente mediante color/estado y pulso, sin alterar el espacio combinatorio 6/56.
- El renderizado usa sprites circulares con iluminación calculada en el shader, no geometría de esfera individual. Esto evita crear millones de mallas y mantiene viable el nivel de detalle.
VALIDACIÓN ADICIONAL
- JavaScript inline comprobado con node --check.
- No se ha realizado prueba visual WebGL2 en el navegador/GPU del usuario; validar al desplegar.


CAPTURA SECUENCIAL Y REGISTRO MANUAL
- La fecha del sorteo se selecciona una sola vez en la sección de captura.
- Las 24 combinaciones se introducen una por una. Cada fila se valida y se agrega a una lista; se rechazan números repetidos dentro de la combinación y combinaciones duplicadas en el grupo.
- Al completar 24, se habilita "Proyectar las 24 combinaciones".
- La sección del resultado real recibe los seis números oficiales. "Calcular comparación y proyectar" genera una vista previa, resalta predicciones en rojo y el resultado real en amarillo, y dibuja conexiones animadas tipo rayo.
- La vista previa NO escribe en Supabase. Solo "Almacenar en la base de datos" guarda la fecha, resultado real, las 24 combinaciones y métricas.


MÓDULO 05 — CADENAS DE MARKOV Y EVENTOS DISCRETOS
- Se añadió una sección al final del panel lateral.
- Estados categóricos para cada sorteo: A = 0–1 números altos (29–56), B = 2–4, C = 5–6.
- La matriz de transición Markov se estima con frecuencias relativas por fila entre sorteos consecutivos. El CSV se ordena por CONCURSO cuando esa columna existe; si no, se conserva el orden de archivo.
- El módulo de eventos discretos reproduce el histórico mediante una cola ordenada de eventos DRAW. Cada evento actualiza el contador de estados y las transiciones; muestra totales y los últimos 15 eventos procesados.
- El botón Reiniciar limpia los resultados de la reproducción.
- Estos módulos describen la secuencia histórica. No pronostican números ganadores ni convierten la matriz de transición en una ventaja predictiva demostrada.
- CSV de referencia comprobado: 4,181 registros, 4,180 transiciones entre eventos. La clasificación observada fue A=430, B=3,368, C=383.
