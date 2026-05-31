@login
Feature: Autenticacion de usuarios en Sauce Demo
  Como cliente de Sauce Demo
  Quiero poder iniciar sesión con mis credenciales
  Para acceder a los productos disponibles

  Background:
    Given que estoy en la página de login

  @login-exitoso @smoke
  Scenario: Login exitoso con usuario estándar
    When ingreso el usuario "standard_user" y la contraseña "secret_sauce"
    And hago clic en el botón de login
    Then debo ser redirigido a la página de productos
    And debo ver el título "Products"

  @login-fallido
  Scenario: Login fallido con usuario bloqueado
    When ingreso el usuario "locked_out_user" y la contraseña "secret_sauce"
    And hago clic en el botón de login
    Then debo ver un mensaje de error que indica que el usuario está bloqueado
    And debo permanecer en la página de login

  @login-fallido
  Scenario Outline: Login con credenciales inválidas
    When ingreso el usuario "<usuario>" y la contraseña "<contraseña>"
    And hago clic en el botón de login
    Then debo ver un mensaje de error de credenciales incorrectas

    Examples:
      | usuario          | contraseña     |
      | usuario_invalido | secret_sauce   |
      | standard_user    | password_wrong |

  @login-exitoso
  Scenario: Login con usuario de rendimiento
    When ingreso el usuario "performance_glitch_user" y la contraseña "secret_sauce"
    And hago clic en el botón de login
    Then debo ser redirigido a la página de productos