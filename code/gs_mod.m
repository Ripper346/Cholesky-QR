function [Q, R] = gs_mod(X)
% Modified Gram-Schmidt orthonormalization
[d, n] = size(X);
m = min(d, n);
R = zeros(m, n, class(X));
Q = zeros(d, m, class(X));
for i = 1:m
    v = X(:, i);
    for j = 1:i-1
        R(j, i) = Q(:, j)' * v;
        v = v - R(j, i) * Q(:, j);
    end
    R(i, i) = norm(v);
    Q(:, i) = v / R(i, i);
end
R(:, m+1:n) = Q' * X(:, m+1:n);
