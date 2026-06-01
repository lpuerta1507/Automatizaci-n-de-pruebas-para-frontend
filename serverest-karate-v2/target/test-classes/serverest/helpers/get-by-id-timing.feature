@ignore
Feature: Helper — GET por ID y verificar tiempo

  @ignore
  Scenario: timing
    * url baseUrl
    Given path '/usuarios', __arg.id
    When method GET
    Then status 200
    And assert responseTime < 5000
