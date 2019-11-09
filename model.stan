data {
    int<lower=1> N;
    int<lower=1> M;

    real x[N];
    int succ_list[M, 2];

    real alpha;
    real rho;
    real sigma;
}

transformed data{
    matrix[N, N] L_K;
    vector[N] mu;
    matrix[N, N] K = cov_exp_quad(x, alpha, rho);

    for (n in 1:N){
        K[n,n] = K[n,n] + 1e-6;
    }
    
    L_K = cholesky_decompose(K);

    mu = rep_vector(0, N);
}

parameters{
    vector[N] y;
}

model{
    y ~ multi_normal_cholesky(mu, L_K);
    
    for (m in 1:M){
        target += log(Phi((y[succ_list[m][1]] - y[succ_list[m][2]])/sqrt(2)/sigma));
    }
}