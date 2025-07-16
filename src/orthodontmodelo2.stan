// Modelo lineal mixto (2)
data {
  int<lower=1> N;                     // Número total de observaciones
  int<lower=1> J;                     // Número de sujetos
  int<lower=1, upper=J> subject[N];   // Índice del sujeto para cada obs
  vector[N] y;                        // Respuesta (distance)
  int<lower=0, upper=1> sex[N];       // 0 = Female, 1 = Male
  int<lower=1, upper=4> age[N];       // age como factor (niveles 1-4)
}

parameters {
  real<lower=0> beta_0;
  real beta_sex;
  vector[3] beta_age;       // efectos para niveles 2-4 de age
  vector[3] beta_int;       // interacciones sex * age (niveles 2-4)
  real<lower=0> sigma;      // desviación estándar común
  real<lower=0> sigma_u;
  vector[J] u;              // efecto aleatorio por sujeto
}

model {
  vector[N] mu;

  // Priors para efectos fijos
  beta_0 ~ normal(0, 25);
  beta_sex ~ normal(0, 5);
  beta_age ~ normal(0, 5);
  beta_int ~ normal(0, 5);

  // Priors para desviaciones estándar
  sigma ~ student_t(5, 0, 2);
  sigma_u ~ student_t(5, 0, 2);
  u ~ normal(0, sigma_u);

  // Construcción del modelo
  for (i in 1:N) {
    real age_eff = 0;
    real int_eff = 0;

    if (age[i] > 1) {
      age_eff = beta_age[age[i] - 1];
      int_eff = beta_int[age[i] - 1] * sex[i];
    }

    mu[i] = beta_0 + beta_sex * sex[i] + age_eff + int_eff + u[subject[i]];
  }

  y ~ normal(mu, sigma);
}

//Para posteriores operaciones
generated quantities {
  vector[N] y_rep;
  for (i in 1:N) {
    real age_eff = 0;
    real int_eff = 0;

    if (age[i] > 1) {
      age_eff = beta_age[age[i] - 1];
      int_eff = beta_int[age[i] - 1] * sex[i];
    }

    y_rep[i] = beta_0 + beta_sex * sex[i] + age_eff + int_eff + u[subject[i]];
  }
}
