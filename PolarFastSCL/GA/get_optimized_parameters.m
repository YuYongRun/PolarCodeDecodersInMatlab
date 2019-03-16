xdata = 1:10;
ydata = zeros(1, length(xdata));
for i = 1 : length(xdata)
    ydata(i) = accurate_phi(xdata(i));
end
% p = lsqcurvefit(@(p, xdata) exp(p(1) .* xdata.^p(2) + p(3)), [2 7], xdata, ydata);
fun = @(p) exp(p(1) .* xdata .^ p(2)  + p(3)) - ydata;
p0 = [1 0.5 1];
options = optimoptions('lsqnonlin', 'Display', 'iter');
p = lsqnonlin(fun, p0, [], [], options);
pl = plot(xdata, [ydata;  exp(p(1) .* xdata .^ p(2) + p(3))]);
pl(1).Marker = 'd';
p1(2).Marker = '^';