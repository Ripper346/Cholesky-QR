function [Q, R] = caqr(V)
% Communication avoiding QR
    [X, R] = qr(V);
    [Y, R] = qr(R);
    Q = X * Y;
end