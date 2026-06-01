# ============================================================
# crud-e2e.feature — Flujo CRUD E2E completo
# ✅ v2 FIXES:
#   - Emails con patrón válido (@example.com)
#   - Validaciones ajustadas a respuestas reales de ServeRest
#   - Limpieza final incluida
# ============================================================
@usuarios @e2e @crud
Feature: CRUD Completo — Flujo E2E de Usuarios

  Background:
    * url baseUrl
    * def schemaUsuario = read('classpath:serverest/schemas/usuario-schema.json')

  @positivo @e2e
  Scenario: Flujo CRUD E2E — Crear, Leer, Actualizar y Eliminar
    # ── 1. CREATE ──────────────────────────────────────────
    * def ts = java.lang.System.currentTimeMillis()
    * def emailOrig = 'e2e_orig_' + ts + '@example.com'
    Given path '/usuarios'
    And request { "nome": "E2E User #(ts)", "email": "#(emailOrig)", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    * def id = response._id
    * karate.log('✅ 1. CREATE — id:', id)

    # ── 2. READ ────────────────────────────────────────────
    Given path '/usuarios', id
    When method