// La sección "data" especifica la estructura de los datos.
data {
  int<lower=0> N; // Número de casos en los datos
  int<lower=0> K; // Número de variables predictoras
  matrix[N, K] x; // Matriz de variables predictoras
  int<lower=0, upper=1> y[N]; // Vector de valores de la variable respuesta
}

// Parámetros del modelo.
parameters {
  real alpha;     // Intersección del modelo
  vector[K] beta; // Coeficientes de regresión
}

// Especificación del modelo a estimar. La variable `y` se distribuye según
//   Bernoulli con probabilidad dada por la combinación lineal de las variables
//   `x` y la intersección (`alpha`).
model {
  beta  ~ normal(0, 2);
  alpha ~ normal(0, 2);
  y ~ bernoulli_logit(alpha + x * beta);
}

generated quantities {

  // TODO: Completar con los valores al cuadrado de `alpha` y `beta`
}
