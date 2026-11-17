# Architecture Decision Record (ADR): Mapa Offline con Caché 

## 1. Contexto (Riesgo Evaluado)
El proyecto `Lircayhub` está enfocado en el turismo local sin conexión a internet en zonas geográficas donde la señal móvil puede ser intermitente o nula. El riesgo técnico crítico radica en la incapacidad de los mapas estándar (como Google Maps SDK tradicional) para cachear grandes extensiones de polígonos y teselas sin depender de una conexión constante a internet, lo que provocaría fallos de usabilidad y ruptura de la experiencia de usuario en terreno.

## 2. Decisión (Librería / Estrategia Adoptada)
Se adopta la librería `flutter_map` (basada en Leaflet) en conjunto con una estrategia de almacenamiento local basada en `flutter_map_tile_caching` (o caché persistente local con SQLite/Hive). 
* **Justificación:** Es una solución open-source altamente personalizable, no requiere claves de API comerciales restrictivas para pruebas básicas, y permite el control total sobre la descarga y lectura de teselas rasterizadas directamente en el almacenamiento interno del dispositivo móvil.

## 3. Consecuencias y Plan de Integración
* **Resultados de la PoC:** La prueba demostró que es posible almacenar y renderizar un mapa offline consumiendo recursos mínimos de memoria y manejando correctamente las excepciones cuando el almacenamiento local está lleno o la red falla.
* **Plan de Integración:** El código de prueba se refactorizará desacoplando la lógica del mapa en un servicio modular (`OfflineMapService`) dentro de la arquitectura de capas del proyecto principal (`main`/`develop`), evitando contaminar las vistas con lógica de red o persistencia directa.