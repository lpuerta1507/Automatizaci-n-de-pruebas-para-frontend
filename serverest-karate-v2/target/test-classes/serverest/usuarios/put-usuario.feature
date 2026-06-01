# ============================================================
# put-usuario.feature — PUT /usuarios/{id}
# ✅ v2 FIXES:
#   - schemaActualizado eliminado (nunca fue usado)
#   - emails con prefijos válidos (@example.com)
#   - "Email inválido": crea usuario válido PRIMERO, luego PUT con email malo
#   - "Campos vacíos": assert correcto sobre objeto de errores
# ============================================================
@usuarios @put @smoke
Feature: PUT /usuarios/{id} — Actualizar usuario

  Background:
    * url baseUrl

  # ── CASOS POSITIVOS ────────────────────────────────────────

  @positivo
  Scenario: PUT /usuarios/{id} - Actualizar todos los campos de un usuario
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Put Original #(ts)", "email": "put_orig_#(ts)@example.com", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    * def id = response._id

    * def ts2 = java.lang.System.currentTimeMillis()
    Given path '/usuarios', id
    And request { "nome": "Put Updated