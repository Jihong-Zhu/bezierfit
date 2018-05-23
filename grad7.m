function [p,t, info] = grad7(d,deg, stop)
%
% This function takes a given set of ordered data and returns
% the parameter values (nodes) and control points which determine the
% Bezier curve that fits the data in the total least squares sense.
% Instead of minimizing the vertical distance to the curve we minimize
% both vertical and horizontal distance. The central feature of this
% function is the use of the Gauss-Newton method to estimate the
% nearest point along the Bezier curve from each data point.

if (ishold)
    hold_was_off = 0;
else
    hold_was_off = 1;
end

i = size(d,1);
j = deg + 1;
t = aff_angle(d);

bez_mat = mxbern2(t, deg);
p = bez_mat \ d;

y = bez_mat * p;
t1 = [0 : 1/128 : 1]';
bez_mat_1 = mxbern2(t1, deg);
y1 = bez_mat_1 * p;

plot(y1(:,1), y1(:,2));
hold on
plot(p(:,1), p(:,2), '*');
plot(y(:,1), y(:,2), 'o');
plot(d(:,1), d(:,2), '+');
axis('equal');
legend('-', 'Fitted Curve', '*', 'Control Points', 'o', 'Initial Times', '+','Data Points');
hold off;

iter = 0;
resid_old = 0;
resid_new = bez_mat * p - d;

while norm(resid_new - resid_old)/max(1 , norm(resid_new)) > 10^(stop)
    deriv = deg * mxbern2(t, deg-1) * (p(2 : j, :) - p(1 : j-1,:));
    t = t - (deriv(:,1) .* resid_new(:,1) + deriv(:,2).* resid_new(:,2)) ...
    ./ [deriv(:,1).^2 + deriv(:,2).^2];
    t = -min(t) * ones(i,1) + t;
    t = t/max(t);
    bez_mat = mxbern2(t,deg);
    p = bez_mat \ d;
    
    resid_old = resid_new;
    resid_new = bez_mat * p - d;
    iter = iter + 1;
end

figure(2)
y = bez_mat * p;
y1 = bez_mat_1 * p;
plot(y1(:,1), y1(:,2));
hold on
plot(p(:,1), p(:,2), '*');
plot(y(:,1), y(:,2), 'o');
plot(d(:,1), d(:,2), '+');
axis('equal');
legend('-', 'Fitted Curve', '*', 'Control Points', 'o', 'Initial Times', '+','Data Points');

if (hold_was_off)
    hold off;
end

info = [norm(bez_mat*p-d), iter];