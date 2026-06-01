# 🛠 Fix Definitivo — Karate DSL en IntelliJ con Java 17

## El error
```
com.oracle.truffle.api.library.LibraryFactory — NoSuchMethodError
```
**Causa:** Karate 1.3.x y 1.4.x usan GraalJS internamente.
GraalJS requiere GraalVM. Con OpenJDK 17 estándar → crash.

**Solución aplicada:** Karate **1.2.1** (última versión con Nashorn puro,
compatible con OpenJDK 17, sin GraalVM ni Truffle).

---

## Pasos obligatorios tras descomprimir

### 1. Limpiar todo
En **Terminal de IntelliJ** (Alt+F12):
```bash
mvn clean -U
```

### 2. Forzar descarga de Karate 1.2.1
```bash
mvn dependency:resolve -U
```
Debe aparecer: `com.intuit.karate:karate-junit5:jar:1.2.1`

### 3. Reload Maven
```
Click derecho en pom.xml → Maven → Reload Project
```

### 4. Agregar VM Options en IntelliJ (IMPORTANTE)
```
Run → Edit Configurations → TestRunner
→ VM Options:
--add-opens java.base/java.lang=ALL-UNNAMED
--add-opens java.base/java.util=ALL-UNNAMED
--add-opens java.base/java.io=ALL-UNNAMED
```

### 5. Ejecutar
```
Click derecho en TestRunner.java → Run 'TestRunner'
```

---

## Si Maven no descarga (proxy/firewall corporativo)

Descargar manualmente desde el navegador:
```
https://repo1.maven.org/maven2/com/intuit/karate/karate-junit5/1.2.1/karate-junit5-1.2.1.jar
```

Luego instalar localmente:
```bash
mvn install:install-file \
  -Dfile=karate-junit5-1.2.1.jar \
  -DgroupId=com.intuit.karate \
  -DartifactId=karate-junit5 \
  -Dversion=1.2.1 \
  -Dpackaging=jar
```

---

## Verificar qué JDK usa Maven

```bash
mvn -version
```
Debe decir: `Java version: 17` y **NO** mencionar GraalVM.
Si dice GraalVM → cambiar en:
`File → Project Structure → Project → SDK → seleccionar Temurin/Corretto 17`

---

## Ejecución por tags

```bash
mvn test "-Dkarate.options=--tags @smoke"
mvn test "-Dkarate.options=--tags @positivo"
mvn test "-Dkarate.options=--tags @negativo"
mvn test "-Dkarate.options=--tags @e2e"
mvn test -Dtest=UsuariosRunner
```

## Reporte HTML
Tras `mvn test`, abrir:
```
target/karate-reports/karate-summary.html
```
