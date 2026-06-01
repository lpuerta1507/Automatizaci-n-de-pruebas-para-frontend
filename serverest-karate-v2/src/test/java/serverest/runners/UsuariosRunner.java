package serverest.runners;

import com.intuit.karate.junit5.Karate;

/**
 * UsuariosRunner — Solo ejecuta los tests de /usuarios.
 *
 * ▶ IntelliJ: click derecho → Run 'UsuariosRunner'
 * ▶ Maven:    mvn test -Dtest=UsuariosRunner
 */
class UsuariosRunner {

    @Karate.Test
    Karate runUsuarios() {
        return Karate.run("classpath:serverest/usuarios")
                     .relativeTo(getClass());
    }
}
