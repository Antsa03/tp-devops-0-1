package com.dev1.jenkins;

public class Calculatrice {

    public double additionner(double a, double b) {
        return a + b;
    }

    public double soustraire(double a, double b) {
        return a - b;
    }

    public double multiplier(double a, double b) {
        return a * b;
    }

    public double diviser(double a, double b) {
        if (b == 0) {
            throw new ArithmeticException("Division par zéro interdite");
        }
        return a / b;
    }

    public double puissance(double base, int exposant) {
        return Math.pow(base, exposant);
    }
}
