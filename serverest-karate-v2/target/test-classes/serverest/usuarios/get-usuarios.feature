# ============================================================
# get-usuarios.feature — GET /usuarios
# ✅ v2: tags corregidos @positivo/@negativo (estándar Karate)
# ============================================================
@usuarios @get @smoke
Feature: GET /usuarios — Listar usuarios

  Background:
    * url baseUrl
    * def schemaLista   = read('classpath:serverest/schemas/lista-usuarios-schema.json')
    * def schemaUsuario = read('classpath:serverest/schemas/usuario-schema.json')

  # ── CASOS POSITIVOS ────────────────────────────────────────

  @positivo
  Scenario: GET /usuarios - Listar todos los usuarios exitosamente
    Given path '/usuarios'
    When method GET
    Then status 200
    And match response == schemaLista
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'

  @positivo
  Scenario: GET /usuarios - Respuesta contiene campo quantidade
    Given path '/usuarios'
    When method GET
    Then status 200
    And match response contains { quantidade: '#number' }
    And assert response.quantidade >= 0

  @positivo
  Scenario: GET /usuarios - Filtrar por administrador true
    Given path '/usuarios'
    And param administrador = 'true'
    When method GET
    Then status 200
    And match response.quantidade == '#number'

  @positivo
  Scenario: GET /usuarios - Filtrar por administrador false
    Given path '/usuarios'
    And param administrador = 'false'
    When method GET
    Then status 200
    And match response.quantidade == '#number'

  @positivo
  Scenario: GET /usuarios - Validar estructura de cada usuario en la lista
    Given path '/usuarios'
    When method GET
    Then status 200
    * def usuarios = response.usuarios
    * if (usuarios.length > 0) karate.call('classpath:serverest/helpers/validate-schema.feature', { data: usuarios[0], schema: schemaUsuario })

  @positivo
  Scenario: GET /usuarios - Tiempo de respuesta aceptable (< 5s)
    Given path '/usuarios'
    When method GET
    Then status 200
    And assert responseTime < 5000

  # ── CASOS NEGATIVOS ────────────────────────────────────────

  @negativo
  Scenario: GET /usuarios - Filtrar por email inexistente retorna lista vacía
    Given path '/usuarios'
    And param email = 'nonexistent_xyz_qatest_9999@noexiste.com'
    When method GET
    Then status 200
    And match response.quantidade == 0
    And match response.usuarios == []
