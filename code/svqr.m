function [Q, R] = svqr(V)
% Singular value QR
    B = V' * V;
    [~, Sigma, U] = svd(B);
    [~, R] = qr(sqrt(Sigma) * U');
    Q = V * R^-1;
end