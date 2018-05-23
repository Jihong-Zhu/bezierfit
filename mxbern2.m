function [B] = mxbern2(t,d)
[n m] = size(t);

if(m ~=1)
    error('t must be a column vector.')
end

if min(t) < 0 | max(t) > 1
    error('nodes are not within [0,1]')
end

ct = 1 - t;
B = zeros(n, d+1);

for i = 0 : d
    B(:, i + 1) = (t.^i).*(ct.^(d - i));
end

if d < 23
    B = B * diag( [1 cumprod(d:-1:1)./cumprod(1:d)] );
else 
    B = B * diag(diag(fliplr(pascal(d + 1))));
end
