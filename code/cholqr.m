function [Q, R] = cholqr(V)
% Cholesky-QR algorithm 
    % Gram matrix computation
    B = V' * V;
    % Cholesky
    R = chol(B);
    % QR
    Q = V * R^-1;
end