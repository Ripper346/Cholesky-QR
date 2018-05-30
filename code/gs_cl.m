function [Q, R] = gs_cl(V)
% Classical Gram-Schmidt orthonormalization
[d, n] = size(V);
m = min(d, n);
R = zeros(m, n, class(V));
Q = zeros(d, m, class(V));
for i = 1:m
    R(1:i-1, i) = Q(:, 1:i-1)' * V(:, i);
    v = V(:, i) - Q(:, 1:i-1) * R(1:i-1, i);
    R(i, i) = norm(v);
    Q(:, i) = v / R(i, i);
end
R(:, m+1:n) = Q' * V(:, m+1:n);