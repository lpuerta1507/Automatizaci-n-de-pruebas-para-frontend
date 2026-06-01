# ============================================================
# delete-usuario.feature — DELETE /usuarios/{id}
# ✅ v2 corregido: emails válidos y DELETE sin body
# ============================================================
@usuarios @delete @smoke
Feature: DELETE /usuarios/{id} — Eliminar usuario

  Background:
    * url baseUrl

  # ── CASOS POSITIVOS ────────────────────────────────────────

  @positivo
  Scenario: DELETE /usuarios/{id} - Eliminar usuario existente exitosamente
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Del User #(ts)", "email": "del_#(ts)@example.com", "password": "Senha@123", "administrador": "false" }
    When method POST
    Then status 201
    * def id = response._id

    Given path '/usuarios', id
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

  @positivo
  Scenario: DELETE /usuarios/{id} - Usuario eliminado ya no existe (GET → 400)
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Del Verify #(ts)", "email": "delverify_#(ts)@example.com", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    * def id = response._id

    Given path '/usuarios', id
    When method DELETE
    Then status 200

    Given path '/usuarios', id
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @positivo
  Scenario: DELETE /usuarios/{id} - Contador de usuarios disminuye al eliminar
    Given path '/usuarios'
    When method GET
    Then status 200
    * def cantidadInicial = response.quantidade

    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Count Test #(ts)", "email": "count_#(ts)@example.com", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    * def id = response._id

    Given path '/usuarios', id
    When method DELETE
    Then status 200

    Given path '/usuarios'
    When method GET
    Then status 200
    And assert response.quantidade == cantidadInicial

  # ── CASOS NEGATIVOS ────────────────────────────────────────

  @negativo
  Scenario: DELETE /usuarios/{id} - ID inexistente retorna