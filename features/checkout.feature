@checkout
Feature: Proceso de compra completo

  Como cliente de Sauce Demo
  Quiero completar el proceso de compra
  Para adquirir los productos que necesito

  Background:
    Given que he iniciado sesión como "standard_user"
    And he agregado el producto "Sauce Labs Backpack" al carrito desde inventario
    And he navegado al carrito de compras

  @compra-completa @smoke @e2e
  Scenario: Completar una compra exitosamente
    When inicio el proceso de checkout
    And ingreso mis datos personales con nombre "Luis", apellido "Puerta" y código postal "15001"
    And hago clic en continuar
    Then debo ver el resumen de mi orden
    And debo ver el producto "Sauce Labs Backpack" en el resumen
    When confirmo la compra haciendo clic en Finish
    Then debo ver la confirmación de compra exitosa
    And debo ver el mensaje "Thank you for your order!"

  @checkout-datos
  Scenario Outline: Checkout con diferentes datos personales
    When inicio el proceso de checkout
    And ingreso mis datos personales con nombre "<nombre>", apellido "<apellido>" y código postal "<cp>"
    And hago clic en continuar
    Then debo ver el resumen de mi orden

    Examples:
      | nombre | apellido | cp    |
      | Ana    | García   | 28001 |
      | Carlos | López    | 10001 |
      | María  | Ruiz     | 33000 |

  @checkout-cancelar
  Scenario: Cancelar el proceso de checkout en Step 1
    When inicio el proceso de checkout
    And cancelo el checkout
    Then debo regresar al carrito de compras

  @compra-completa @e2e
  Scenario: Compra con múltiples productos
    Given he agregado también el producto "Sauce Labs Bike Light" al carrito
    When inicio el proceso de checkout
    And ingreso mis datos personales con nombre "Test", apellido "User" y código postal "00001"
    And hago clic en continuar
    Then debo ver el resumen de mi orden
    When confirmo la compra haciendo clic en Finish
    Then debo ver la confirmación de compra exitosa
