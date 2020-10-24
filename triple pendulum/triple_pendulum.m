% Simularea dinamica a pendulului gravitational dublu
clear;
close all;
clc;
pause on;

N = 1000;
g = 9.8067;
m = [1 6 2]; % kg; masele corpurilor
l = [4 2 3]; % m; lungimile tijelor
% Unghiurile initiale pot lua orice valoare intre -pi si +pi
theta = zeros(N, 3);
omega = theta;
theta(1, :) = [-pi / 6 pi / 2 -pi / 3]; % rad; unghiurile initiale facute de tije cu axa verticala
v = [0 0 0]; % rad/s; vitezele unghiulare initiale (la momentul t0)
puls = [sqrt(g / l(1)) sqrt(g / l(2)) sqrt(g / l(3))]; % pulsatii proprii individuale
T = [2 * pi / puls(1) 2 * pi / puls(2) 2 * pi / puls(3)]; % perioade proprii individuale
Tmax = max(T); % timpul "caracteristic" al miscarii pendulului dublu
t0 = 0; tf = 5 * Tmax; t = linspace(t0, tf, N); dt = t(2) - t(1); % definitia discretizarii temporale
kt = zeros(4, 3); ko = kt;

for i = 1 : (N - 1)
    ko(1, :) = oed(theta(i, :), omega(i, :), m, l, g);
    kt(1, :) = omega(i, :);

    ko(2, :) = oed(theta(i, :) + kt(1, :) * dt / 2, omega(i, :) + ko(1, :) * dt / 2, m, l, g);
    kt(2, :) = omega(i, :) + ko(1, :) * dt / 2;

    ko(3, :) = oed(theta(i, :) + kt(2, :) * dt / 2, omega(i, :) + ko(2, :) * dt / 2, m, l, g);
    kt(3, :) = omega(i, :) + ko(2, :)  * dt / 2;

    ko(4, :) = oed(theta(i, :) + kt(3, :) * dt, omega(i, :) + ko(3, :) * dt, m, l, g);
    kt(4, :) = omega(i, :) + ko(3, :) * dt;
    
    omega(i + 1, :) = rk4(omega(i, :), ko, dt, 1 / 6);
    theta(i + 1, :) = rk4(theta(i, :), kt, dt, 1 / 6);
end

% coordonatele carteziene ale corpurilor 1 si 2:
x1 = l(1) * sin(theta(:, 1)); y1 = +l(1) * cos(theta(:, 1));
x2 = x1 + l(2) * sin(theta(:, 2)); y2 = y1 + l(2) * cos(theta(:, 2));
x3 = x2 + l(3) * sin(theta(:, 3)); y3 = y2 + l(3) * cos(theta(:, 3));

figure('doublebuffer', 'on', 'Visible', 'on'); % vizualizarea miscarii in timpul de calcul
Ltot = l(1) + l(2) + l(3);
limits = [-Ltot Ltot -Ltot Ltot];
for i = 1 : N
    hold off;
    plot([0 x1(i)], [0 y1(i)], '-k', 'LineWidth', 2); % tija 1
    hold on;
    plot(x1(i), y1(i), '.r', 'MarkerSize', 30); % corpul 1
    plot([x1(i) x2(i)], [y1(i) y2(i)], '-k', 'LineWidth', 2); % tija 2
    plot(x2(i), y2(i), '.c', 'MarkerSize', 30); % corpul 2
    plot([x2(i) x3(i)], [y2(i) y3(i)], '-k', 'LineWidth', 2); % tija 3
    plot(x3(i), y3(i), '.b', 'MarkerSize', 30); % corpul 3
    axis square; grid;
    axis(limits); % [xmin xmax ymin ymax]
    plot(x1(max(i - 200, 1):1:i), y1(max(i - 200, 1):1:i), '.r', 'MarkerSize', 1);
    plot(x2(max(i - 200, 1):1:i), y2(max(i - 200, 1):1:i), '.c', 'MarkerSize', 1);
    plot(x3(max(i - 200, 1):1:i), y3(max(i - 200, 1):1:i), '.b', 'MarkerSize', 1);
    Film(i) = getframe(); % getframe();
end

figure(2);
movie(Film, 1, round(N / (tf - t0)));