# 🧪 Sauce Demo — Suite de Automatización QA

> **Playwright + Cucumber (Gherkin) · Page Object Model · JavaScript**
> Autor: **Luis Puerta Del Aguila** — Consultor QA TI | Senior QA Architect

---

## 📋 Índice

1. [Descripción](#descripción)
2. [Tecnologías y Patrones](#tecnologías-y-patrones)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Requisitos Previos](#requisitos-previos)
5. [Instalación](#instalación)
6. [Ejecución de Tests](#ejecución-de-tests)
7. [Escenarios Cubiertos](#escenarios-cubiertos)
8. [Estrategia de Automatización](#estrategia-de-automatización)
9. [Reportes](#reportes)
10. [Credenciales de Prueba](#credenciales-de-prueba)

---

## Descripción

Suite de pruebas automatizadas end-to-end para la aplicación web **[Sauce Demo](https://www.saucedemo.com/)**, cubriendo los flujos críticos de negocio:

- ✅ Autenticación (login exitoso, usuario bloqueado, credenciales inválidas)
- ✅ Gestión del carrito (agregar productos, verificar cantidad, visualizar carrito)
- ✅ Proceso de compra completo (checkout step 1 → step 2 → confirmación)

---

## Tecnologías y Patrones

| Tecnología | Versión | Propósito |
|---|---|---|
| **Playwright** | ^1.44.0 | Motor de automatización de browser |
| **@cucumber/cucumber** | ^10.3.2 | Framework BDD con sintaxis Gherkin |
| **Node.js** | ^18 | Runtime |
| **multiple-cucumber-html-reporter** | ^3.6.2 | Reportes HTML |

**Patrón de diseño:** [Page Object Model (POM)](https://playwright.dev/docs/pom)
- Cada página de la app tiene su clase correspondiente (`LoginPage`, `InventoryPage`, `CartPage`, `CheckoutPage`)
- Heredan de `BasePage` (interacciones comunes reutilizables)
- Los Step Definitions consumen los Page Objects → **desacoplamiento total**

---

## Estructura del Proyecto

```
saucedemo-playwright-cucumber/
├── features/
│   ├── login.feature             # Escenarios de autenticación
│   ├── cart.feature              # Escenarios de carrito
│   ├── checkout.feature          # Escenarios de compra completa
│   └── step-definitions/
│       ├── login.steps.js
│       ├── cart.steps.js
│       └── checkout.steps.js
├── pages/
│   ├── BasePage.js               # Clase base (POM)
│   ├── LoginPage.js
│   ├── InventoryPage.js
│   ├── CartPage.js
│   └── CheckoutPage.js
├── support/
│   └── hooks.js                  # Before/After hooks (browser lifecycle)
├── reports/
│   └── generate-report.js        # Generador de reporte HTML
├── cucumber.js                   # Configuración de Cucumber
├── package.json
└── README.md
```

---

## Requisitos Previos

- **Node.js** >= 18 ([Descargar](https://nodejs.org/))
- **npm** >= 9
- Conexión a internet (para acceder a https://www.saucedemo.com)

---

## Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU_USUARIO/saucedemo-playwright-cucumber.git
cd saucedemo-playwright-cucumber

# 2. Instalar dependencias
npm install

# 3. Instalar el browser Chromium
npx playwright install chromium
```

---

## Ejecución de Tests

### Ejecutar todos los tests (headless)
```bash
npm test
```

### Ejecutar con browser visible
```bash
npm run test:headed
```

### Ejecutar con reporte HTML
```bash
npm run test:report
# Reporte en: reports/html/index.html
```

### Ejecutar por tag
```bash
# Solo tests de login
npx cucumber-js --tags "@login"

# Solo smoke tests
npx cucumber-js --tags "@smoke"

# Solo flujo E2E completo
npx cucumber-js --tags "@e2e"

# Solo tests de carrito
npx cucumber-js --tags "@carrito"

# Excluir tests fallidos esperados
npx cucumber-js --tags "not @login-fallido"
```

### Tags disponibles

| Tag | Descripción |
|---|---|
| `@smoke` | Tests críticos de humo |
| `@e2e` | Flujo completo end-to-end |
| `@login` | Todos los escenarios de login |
| `@login-exitoso` | Login con éxito |
| `@login-fallido` | Login fallido (usuario bloqueado, credenciales inválidas) |
| `@carrito` | Escenarios de carrito |
| `@checkout` | Escenarios de checkout |

---

## Escenarios Cubiertos

### 🔐 Login (`login.feature`)
| Escenario | Usuario | Resultado Esperado |
|---|---|---|
| Login exitoso | `standard_user` | Redirigido a `/inventory.html` |
| Usuario bloqueado | `locked_out_user` | Mensaje de error "locked out" |
| Credenciales inválidas | varios | Mensaje de error visible |
| Login con usuario glitch | `performance_glitch_user` | Redirigido (con latencia) |

### 🛒 Carrito (`cart.feature`)
| Escenario | Descripción |
|---|---|
| Agregar un producto | Contador muestra 1, botón cambia a Remove |
| Agregar múltiples productos | Contador muestra N productos |
| Ver carrito | Producto aparece en `/cart.html` |
| Carrito con varios items | Conteo correcto en la página del carrito |

### 💳 Checkout (`checkout.feature`)
| Escenario | Descripción |
|---|---|
| Compra completa exitosa | Step 1 → Step 2 → Confirmación con "Thank you for your order!" |
| Checkout con múltiples datos | Outline con 3 sets de datos personales |
| Cancelar en Step 1 | Regresa al carrito |
| Compra con múltiples productos | Verifica todos los productos en el resumen |

---

## Estrategia de Automatización

### Pirámide de Testing
```
        /\
       /  \
      / E2E \        ← Checkout completo, flujos críticos
     /--------\
    /Integration\    ← Login + Carrito combinados
   /------------\
  /  Unit (POM)  \   ← Page Objects testeados individualmente
 /________________\
```

### Decisiones de Diseño

**1. Page Object Model (POM)**
Cada pantalla tiene su clase propia. Los selectores están centralizados en constantes `SELECTORS` dentro de cada page, evitando duplicación y facilitando el mantenimiento ante cambios de UI.

**2. BasePage como abstracción**
Métodos comunes (`click`, `fill`, `getText`, `isVisible`) definidos una sola vez. Los page objects se concentran en la lógica de negocio de cada pantalla.

**3. Custom World**
El `World` de Cucumber gestiona el ciclo de vida del browser (Before/After hooks). El `page` se inyecta al World para que todos los steps compartan la misma instancia.

**4. Screenshots en fallos**
El hook `After` captura screenshot automático cuando un escenario falla, adjuntándolo al reporte Cucumber.

**5. Tags para segmentación**
Los escenarios están etiquetados (`@smoke`, `@e2e`, `@login`, etc.) para ejecución selectiva en pipelines CI/CD.

### Flujo CI/CD recomendado
```
PR abierto → @smoke (2 min)
Merge a develop → @smoke + @e2e (5 min)
Release → suite completa (10 min)
```

---

## Reportes

Después de ejecutar `npm run test:report`:

- **JSON:** `reports/cucumber-report.json`
- **HTML:** `reports/html/index.html`
- **Inline HTML:** `reports/cucumber-report.html`

Los reportes incluyen: resultado por escenario, duración, screenshots de fallos y metadata del entorno.

---

## Credenciales de Prueba

| Usuario | Contraseña | Tipo |
|---|---|---|
| `standard_user` | `secret_sauce` | Usuario estándar ✅ |
| `locked_out_user` | `secret_sauce` | Usuario bloqueado 🔒 |
| `performance_glitch_user` | `secret_sauce` | Usuario lento ⏱ |
| `error_user` | `secret_sauce` | Usuario con errores ⚠️ |

---

## Autor

**Luis Puerta Del Aguila**
Consultor QA TI | Gobierno QA | Estrategia de Calidad
Senior QA Architect

---

*Suite desarrollada siguiendo buenas prácticas de QA: mantenibilidad, legibilidad y escalabilidad.*
