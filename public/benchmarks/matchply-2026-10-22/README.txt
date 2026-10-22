Matchply: comparación de rendimiento / performance comparison
Fecha: 2026-10-22
Referencia: d0dfcc2. Aplicación candidata: cbcab4a.
Código y pruebas: https://github.com/angelporlan/Matchply/tree/codex-rendimiento-matchply

ENTORNO
Node 20.20.2, Next 14.2.35, PostgreSQL 15, Docker aarch64.
VM: 10 CPUs, 8.321.712.128 bytes de RAM. Cada web: 1 GiB, heap 768 MiB,
DATABASE_POOL_MAX=8, DATABASE_STATEMENT_TIMEOUT_MS=15000, PDF_WORKER_POOL_SIZE=2.
Playwright 1.64.1, Chromium 156.0.8078.4, runner Node 26.3.0.
No se ejecutaron builds durante las mediciones. Se conservaron los contenedores
locales ajenos a la prueba, sin modificarlos. No es un host de benchmark dedicado.

DATOS
Base desechable nueva, migraciones existentes, tres usuarios Pro sintéticos:
10/500/5000 candidaturas, 1/20/100 CVs. Hasta 500 empresas.
No hay historiales extensos de conversación ni distribución completa de producción.

PROCEDIMIENTO REPRODUCIBLE
1. Crea dos snapshots con git archive de los commits indicados. Instala y compila
   cada uno con Node 20 (npm ci; npm run build). Construye los workers y arranca
   .next/standalone/server.js con public, .next/static y dist copiados al standalone.
   Consulta docs/specs/rendimiento-matchply/verification.md en la rama candidata.
2. Arranca PostgreSQL 15 con una base local cuyo nombre contenga "test".
   Ejecuta las migraciones y después:
   INTEGRATION_TEST_DATABASE_URL=<URL de la base local desechable> npm run perf:seed
   Nunca uses una base real o un túnel a producción.
3. Copia los scripts .ts.txt/.mjs.txt de este directorio en scripts/ de cada
   snapshot, quitando únicamente el sufijo .txt de cada nombre.
   Ejecuta performance-queries.ts con Node 20 + tsx, el mismo PostgreSQL y pool.
   PERF_BUILD=d0dfcc2 activa el camino anterior de consumo en el snapshot antiguo;
   PERF_BUILD=cbcab4a activa el contexto compartido en el candidato.
   Usa PERF_SAMPLES=100 y orden A, B, B, A. Cada ejecución recorre seis escenarios
   en las tres cuentas. Conserva stdout JSON y une las dos series de cada versión.
4. Expón las dos builds solo en loopback (por ejemplo, puertos 3190/3191).
   Desde la rama candidata, con las dependencias de navegador instaladas:
   PERF_BASELINE_URL=http://127.0.0.1:3190 \
   PERF_CANDIDATE_URL=http://127.0.0.1:3191 \
   PERF_OUTPUT=/tmp/comparison.json node scripts/performance-comparison.mjs
   El script alterna AB/BA, toma 15 muestras por ronda y condición y ejecuta PDF.
   Usa PERF_ONLY_PDF=1 para repetir únicamente PDF con la cuenta pequeña de pruebas.
   Respeta la ventana real de 60 peticiones/minuto por usuario al repetir.
5. Recoge logs de cada contenedor. En PDF comprueba cacheHit=false en los 30
   previews, shared=true en 27 del candidato y tres renders completados. En el
   código antiguo cada miss ejecuta un render; el nuevo comparte su promesa.

EJECUCIÓN PUBLICADA
SQL: dos rondas de 100 muestras, A/B y B/A. Total: 200 por escenario y versión.
Navegación: 30 muestras por condición y versión; cuenta grande; 390x844;
latencia 150 ms, 10 MiBits/s de descarga, CPU x4. Servidor calentado.
Fría = caché HTTP de Chromium vaciada; repetida = assets conservados.
Tiempo = inicio de navegación hasta observación de primera candidatura visible,
incluyendo el coste de observación. No mide LCP, INP ni arranque frío del servidor.
p50 = elemento floor(n*0.5); p95 = elemento ceil(n*0.95)-1, índices desde cero.

PDF: se repitió por separado con PERF_ONLY_PDF=1. Tres ráfagas de 10 peticiones
por versión, mismo cuerpo exacto por par, hash nuevo cada ráfaga, diez páginas,
workers calientes, HTTP local sin red/CPU de navegador simuladas. Se publican las
tres duraciones completas, no un SLO ni un p95 inferido de peticiones correlacionadas.
Validación: 200, cabecera de diez páginas, firma PDF y bytes iguales en el render
compartido. Los renders independientes antiguos pueden llevar IDs/metadatos distintos.
La primera prueba exploratoria de PDF y una aserción de igualdad binaria inapropiada
para renders independientes fueron descartadas; results.json contiene la repetición
con cuerpos emparejados y validación corregida. La navegación y el SQL no dependen
de esas pruebas descartadas.

ALCANCE
El JSON conserva todos los escenarios SQL y las 120 observaciones de navegador,
incluidos resultados más lentos. Las reducciones de consultas/renders corresponden
exclusivamente a los flujos descritos. La latencia SQL no incluye autenticación,
HTTP ni red del usuario. Tres ráfagas son exploratorias, sin intervalos de confianza.
No hubo despliegue de Matchply, tráfico real, prueba sostenida multiusuario ni
mediciones de campo. Los tests de verificación son los de la implementación previa;
no se suman perfiles solapados como casos únicos. El perfil unitario omitía 23
integraciones, que se ejecutaron en los perfiles obligatorios sin omisiones.
