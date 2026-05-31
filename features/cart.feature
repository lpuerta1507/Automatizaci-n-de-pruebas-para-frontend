@carrito
Feature: Gestión del carrito de compras

Como cliente de Sauce Demo
Quiero poder agregar y ver productos en mi carrito
Para gestionar mis compras antes de finalizar el pedido

Background:
Given que he iniciado sesión como "standard_user"
And estoy en la página de productos

@agregar-producto @smoke
Scenario: Agregar un producto al carrito desde el listado
When agrego el producto "Sauce Labs Backpack" al carrito
Then el contador del carrito debe mostrar "1"
And el botón del producto debe cambiar a "Remove"

@agregar-producto
Scenario: Agregar múltiples productos al carrito
When agrego el producto "Sauce Labs Backpack" al carrito
And agrego el producto "Sauce Labs Bike Light" al carrito
Then el contador del carrito debe mostrar "2"

@ver-carrito @smoke
Scenario: Ver los productos en el carrito
Given he agregado el producto "Sauce Labs Backpack" al carrito
When voy al carrito de compras
Then debo ver el producto "Sauce Labs Backpack" en el carrito
And el título de la página del carrito debe ser "Your Cart"

@ver-carrito
Scenario: Verificar que el carrito mantiene los productos
Given he agregado el producto "Sauce Labs Fleece Jacket" al carrito
And he agregado el producto "Sauce Labs Bolt T-Shirt" al carrito
When voy al carrito de compras
Then debo ver "2" productos en el carrito
