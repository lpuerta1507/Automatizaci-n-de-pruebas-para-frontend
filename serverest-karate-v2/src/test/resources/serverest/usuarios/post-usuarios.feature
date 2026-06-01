# ============================================================
# post-usuarios.feature — POST /usuarios
# ✅ v2 FIXES:
#   - Prefijos de email actualizados (qa_ → test_admin_ etc.)
#   - Campos vacíos: assert correcto sobre objeto de errores
#   - Scenario Outline: emails claramente inválidos
# ============================================================
@usuarios @post @smoke
Feature: POST /usuarios — Registrar usuario

  Background:
    * url baseUrl
    * def schemaCreado =
      """
      {
        "message": "#string",
        "_id":     "#string"
      }
      """

  # ── CASOS POSITIVOS ────────────────────────────────────────

  @positivo
  Scenario: POST /usuarios - Registrar usuario administrador exitosamente
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Admin Tester #(ts)", "email": "test_admin_#(ts)@example.com", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    And match response == schemaCreado
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#string'

  @positivo
  Scenario: POST /usuarios - Registrar usuario NO administrador
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "User Comum #(ts)", "email": "test_comum_#(ts)@example.com", "password": "Senha@123", "administrador": "false" }
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#notnull'

  @positivo
  Scenario: POST /usuarios - IDs generados son únicos
    * def ts1 = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Unique A #(ts1)", "email": "unique_a_#(ts1)@example.com", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    * def id1 = response._id

    * def ts2 = java.lang.System.currentTimeMillis() + 1
    Given path '/usuarios'
    And request { "nome": "Unique B #(ts2)", "email": "unique_b_#(ts2)@example.com", "password": "Senha@123", "administrador": "false" }
    When method POST
    Then status 201
    * def id2 = response._id
    And assert id1 != id2

  # ── CASOS NEGATIVOS ────────────────────────────────────────

  @negativo
  Scenario: POST /usuarios - Email duplicado retorna 400
    * def ts = java.lang.System.currentTimeMillis()
    * def emailDup = 'dup_test_' + ts + '@example.com'
    Given path '/usuarios'
    And request { "nome": "Primer User", "email": "#(emailDup)", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201

    Given path '/usuarios'
    And request { "nome": "Segundo User", "email": "#(emailDup)", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  @negativo
  Scenario: POST /usuarios - Cuerpo vacío retorna 400 con errores por campo
    Given path '/usuarios'
    And request {}
    When method POST
    Then status 400
    And match response == '#object'
    And match response != {}

  @negativo
  Scenario: POST /usuarios - Email sin formato válido retorna 400
    Given path '/usuarios'
    And request { "nome": "Test User", "email": "email-invalido-sin-arroba", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 400
    And match response.email == '#string'

  @negativo
  Scenario: POST /usuarios - Sin campo password retorna 400
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "No Password #(ts)", "email": "nopwd_#(ts)@example.com", "administrador": "true" }
    When method POST
    Then status 400
    And match response == '#object'

  @negativo
  Scenario Outline: POST /usuarios - Campos inválidos retornan 400
    Given path '/usuarios'
    And request { "nome": "<nome>", "email": "<email>", "password": "<pwd>", "administrador": "<admin>" }
    When method POST
    Then status 400

    Examples:
      | nome | email             | pwd     | admin |
      |      | vacio@example.com | Senha@1 | true  |
      | Test | not-an-email      | Senha@1 | true  |
      | Test | nopasswd@ex.com   |         | true  |
