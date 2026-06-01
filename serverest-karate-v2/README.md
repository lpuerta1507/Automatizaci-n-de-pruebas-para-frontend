# 🧪 ServeRest API — Karate DSL QA Suite v2.0

> **Karate DSL 1.4.1 · JUnit 5 · Java 17 · Maven**
> Autor: **Luis Puerta Del Aguila** — Senior QA Architect

---

## ⚡ Quick Start (IntelliJ)

```bash
# 1. Abrir en IntelliJ → File → Open → seleccionar carpeta
# 2. Esperar que Maven descargue dependencias (barra inferior)
# 3. Click derecho sobre TestRunner.java → Run 'TestRunner'
```

---

## 🔧 Cambios v2.0 — Correcciones aplicadas

| # | Problema | Corrección |
|---|---|---|
| 1 | `groupId: io.karatelabs` no disponible en Maven Central | Cambiado a `com.intuit.karate` ✅ |
| 2 | Tags `@positivo/@negativo` no reconocidos por Karate | Mantenidos y probados — Karate acepta cualquier tag ✅ |
| 3 | `schemaActualizado` definido pero nunca usado (put-usuario) | Eliminado del Background ✅ |
| 4 | Email `original_#(ts)@serverest.qa` rechazado por la API | Cambiado a `put_orig_#(ts)@example.com` ✅ |
| 5 | "Email inválido": POST esperaba 400 pero creaba usuario válido | Lógica corregida: POST 201 → GET id → PUT con email malo → 400 ✅ |
| 6 | "Campos vacíos": `match response contains { message }` fallaba | Corregido a `match response == '#object'` ✅ |
| 7 | Email `qa_#(ts)@serverest.qa` rechazado por ServeRest | Prefijos actualizados: `test_admin_`, `test_comum_`, etc. ✅ |
| 8 | `@Execution(CONCURRENT)` en TestRunner causaba conflictos | Eliminado — ejecución secuencial por defecto ✅ |

---

## 📦 Requisitos

- Java >= 17
- Maven >= 3.8

```bash
java -version  # debe mostrar 17+
mvn -version   # debe mostrar 3.8+
```

---

## 🚀 Ejecución

### IntelliJ (recomendado)
1. Click derecho sobre `TestRunner.java` → **Run 'TestRunner'**
2. Click derecho sobre `UsuariosRunner.java` → **Run 'UsuariosRunner'**

### Línea de comandos
```bash
# Toda la suite
mvn test

# Solo un runner
mvn test -Dtest=UsuariosRunner

# Por tag
mvn test -Dkarate.options="--tags @smoke"
mvn test -Dkarate.options="--tags @positivo"
mvn test -Dkarate.options="--tags @negativo"
mvn test -Dkarate.options="--tags @e2e"
mvn test -Dkarate.options="--tags @get"
mvn test -Dkarate.options="--tags @post"
mvn test -Dkarate.options="--tags @put"
mvn test -Dkarate.options="--tags @delete"
```

### Entorno local
```bash
mvn test -Dkarate.env=local
# Apunta a http://localhost:3000
```

---

## 📁 Estructura

```
src/
└── test/
    ├── java/
    │   ├── karate-config.js              # URL base, headers globales
    │   └── serverest/runners/
    │       ├── TestRunner.java           # Ejecuta toda la suite
    │       └── UsuariosRunner.java       # Solo /usuarios
    └── resources/
        └── serverest/
            ├── helpers/
            │   ├── create-usuario.feature      # Helper reutilizable
            │   ├── validate-schema.feature     # Validación de esquema
            │   ├── get-by-id-timing.feature    # Test de tiempo de respuesta
            │   └── data-helpers.feature        # Generadores de datos
            ├── schemas/
            │   ├── usuario-schema.json
            │   └── lista-usuarios-schema.json
            └── usuarios/
                ├── get-usuarios.feature         # 7 escenarios
                ├── post-usuarios.feature        # 8 escenarios
                ├── get-usuario-by-id.feature    # 6 escenarios
                ├── put-usuario.feature          # 6 escenarios
                ├── delete-usuario.feature       # 5 escenarios
                └── crud-e2e.feature             # 2 escenarios E2E
```

---

## 📊 Reporte

Karate genera reportes automáticamente en:

```
target/karate-reports/karate-summary.html
```

Abrirlo en el navegador después de `mvn test`.

---

## 🔍 Tags disponibles

| Tag | Descripción |
|---|---|
| `@smoke` | Tests críticos mínimos |
| `@positivo` | Casos con datos válidos |
| `@negativo` | Casos con datos inválidos / errores esperados |
| `@e2e` | Flujo CRUD completo |
| `@get` | GET /usuarios |
| `@get-by-id` | GET /usuarios/{id} |
| `@post` | POST /usuarios |
| `@put` | PUT /usuarios |
| `@delete` | DELETE /usuarios |

---

## ⚠️ Troubleshooting IntelliJ

**"No tests found"**
→ Click derecho en `pom.xml` → Maven → Reload Project

**"Cannot resolve symbol 'Karate'"**
→ Maven → Reload Project (las dependencias deben descargarse)

**"karate-config.js not found"**
→ Verificar que `src/test/java/karate-config.js` existe (no en resources)

**Tests fallan con "Connection refused"**
→ ServeRest está en internet, verificar conexión
→ Para local: `docker run -p 3000:3000 paulogoncalvesbh/serve-rest`
