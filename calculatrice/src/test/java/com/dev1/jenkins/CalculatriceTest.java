package com.dev1.jenkins;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CalculatriceTest {

    private Calculatrice calc;

    @BeforeEach
    void setUp() {
        calc = new Calculatrice();
    }

    @Test
    @DisplayName("Addition de deux nombres positifs")
    void testAdditionner() {
        assertEquals(5.0, calc.additionner(2, 3), 0.001);
    }

    @Test
    @DisplayName("Addition avec un nombre négatif")
    void testAdditionnerNegatif() {
        assertEquals(-1.0, calc.additionner(2, -3), 0.001);
    }

    @Test
    @DisplayName("Soustraction de deux nombres")
    void testSoustraire() {
        assertEquals(1.0, calc.soustraire(3, 2), 0.001);
    }

    @Test
    @DisplayName("Multiplication de deux nombres")
    void testMultiplier() {
        assertEquals(6.0, calc.multiplier(2, 3), 0.001);
    }

    @Test
    @DisplayName("Division normale")
    void testDiviser() {
        assertEquals(2.5, calc.diviser(5, 2), 0.001);
    }

    @Test
    @DisplayName("Division par zéro lève une exception")
    void testDiviserParZero() {
        assertThrows(ArithmeticException.class, () -> calc.diviser(5, 0));
    }

    @Test
    @DisplayName("Puissance d'un nombre")
    void testPuissance() {
        assertEquals(8.0, calc.puissance(2, 3), 0.001);
    }
}
