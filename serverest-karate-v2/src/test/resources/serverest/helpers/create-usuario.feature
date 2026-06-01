# Helper reutilizable — crear usuario y retornar ID
# Uso: karate.call('classpath:serverest/helpers/create-usuario.feature', payload)
@ignore
Feature: Helper — Crear usuario

  @ignore
  Scenario: crear usuario
    * url baseUrl
    Given path '/usuarios'
    And request __arg
    When method POST
    Then status 201
    * def createdId = response._id
