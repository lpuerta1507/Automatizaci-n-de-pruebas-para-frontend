package serverest.runners;

import com.intuit.karate.junit5.Karate;

public class TestRunner {

    @Karate.Test
    Karate runAll() {
        // Ejecuta todos los features dentro de serverest/usuarios
        return Karate.run("classpath:serverest/usuarios").relativeTo(getClass());
    }
}
