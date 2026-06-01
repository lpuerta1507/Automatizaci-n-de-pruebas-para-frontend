# ============================================================
# get-usuario-by-id.feature — GET /usuarios/{id}
# ✅ v2: emails válidos, asserts ajustados a respuestas reales
# ============================================================
@usuarios @get-by-id @smoke
Feature: GET /usuarios/{id} — Buscar usuario por ID

  Background:
    * url baseUrl
    * def schemaUsuario = read('classpath:serverest/schemas/usuario-schema.json')

  # ── CASOS POSITIVOS ────────────────────────────────────────

  @positivo
  Scenario: GET /usuarios/{id} - Obtener usuario por ID válido
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "GetById Test #(ts)", "email": "getbyid_#(ts)@example.com", "password": "Senha@123", "administrador": "true" }
    When method POST
    Then status 201
    * def usuarioId = response._id

    Given path '/usuarios', usuarioId
    When method GET
    Then status 200
    And match response._id == usuarioId
    And match response.email == "getbyid_#(ts)@example.com"
    And match response.nome == "GetById Test #(ts)"
    And match response.administrador == 'true'

  @positivo
  Scenario: GET /usuarios/{id} - Respuesta incluye todos los campos del esquema
    * def ts = java.lang.System.currentTimeMillis()
    Given path '/usuarios'
    And request { "nome": "Campos Test #(ts)", "email": "campos_#(ts)@example.com", "password": "Senha@123", "administrador": "false" }
    When method POST
    Then status 201
    * def id = response._id

    Given path '/usuarios', id
    When method GET
    Then status 200
    And match response contains
      """
      {
        "_id":           "#string",
        "nome":          "#string",
        "email":         "#string",
        "password":      "#string",
        "administrador": "#string"
      }
      """

  @positivo
  Scenario: GET /usuarios/{id} - Tiempo de respuesta aceptable
    Given path '/usuarios'
    When method GET
    Then status 200
    * def total = response.quantidade
    * def targetId = total > 0 ? response.usuarios[0]._id : null

    * if (targetId != null) karate.call('classpath:serverest/helpers/get-by-id-timing.feature', { id: targetId })

  # ── CASOS NEGATIVOS ────────────────────────────────────────

  @negativo
  Scenario: GET /usuarios/{id} - ID inexistente retorna 400
    Given path '/usuarios/id_inexistente_xyz999abc'
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @negativo
  Scenario: GET /usuarios/{id} - ID con formato inválido retorna 400
    Given path '/usuarios/id-invalido-formato-999'
    When method GET
    Then status