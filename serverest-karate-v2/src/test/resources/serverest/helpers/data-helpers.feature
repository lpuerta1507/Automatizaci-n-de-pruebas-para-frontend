# ============================================================
# data-helpers.feature
# Utilidades para generación de datos de prueba dinámicos.
# Se invoca con karate.call() desde los feature files.
# ============================================================
@ignore
Feature: Helpers de datos de prueba

  # ── Generar usuario válido con datos únicos ─────────────────
  @ignore
  Scenario: generarUsuarioValido
    * def timestamp = java.lang.System.currentTimeMillis()
    * def usuario =
      """
      {
        "nome":     "QA Tester #timestamp",
        "email":    "qa_#timestamp@serverest.qa",
        "password": "Senha@123",
        "administrador": "true"
      }
      """
    * replace usuario.#timestamp = timestamp

  # ── Generar usuario NO administrador ────────────────────────
  @ignore
  Scenario: generarUsuarioComum
    * def timestamp = java.lang.System.currentTimeMillis()
    * def usuario =
      """
      {
        "nome":     "Usuario Comum #timestamp",
        "email":    "comum_#timestamp@serverest.qa",
        "password": "Senha@123",
        "administrador": "false"
      }
      """
    * replace usuario.#timestamp = timestamp

  # ── Generar datos de actualización ──────────────────────────
  @ignore
  Scenario: generarDatosActualizacion
    * def timestamp = java.lang.System.currentTimeMillis()
    * def usuarioActualizado =
      """
      {
        "nome":     "Usuario Actualizado #timestamp",
        "email":    "updated_#timestamp@serverest.qa",
        "password": "NuevaSenha@456",
        "administrador": "true"
      }
      """
    * replace usuarioActualizado.#timestamp = timestamp
