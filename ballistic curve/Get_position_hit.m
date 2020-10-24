function [position] = Get_position_hit(a0, draw)
    g = 9.80665; % m/s^2
    m = 1.2; % kg
    v0 = 950; % m/s
    N = 2500; % nr elemente
    t0 = 0;
    b1 = m * g / v0; b2 = m * g / v0^2; % estimare coef de frecare

    tf = 2 * v0 / g * sind(a0); % supraestimarea
    t = linspace(t0, tf, N); % progresia aritmetica
    % sau asa t = t0 : (tf - t0) / N : tf;
    dt = t(2) - t(1); % pasul de timp
    vx = zeros(1, N);
    vy = zeros(1, N);
    x = zeros(1, N);
    y = zeros(1, N);

    vx(1) = v0 * cosd(a0);
    vy(1) = v0 * sind(a0);
    for i = 1 : N - 1 % i = inceput : pas : final
       ct = 1 - dt / m * (b1 + b2 * sqrt(vx(i) ^ 2 + vy(i) ^ 2));
       vx(i + 1) = vx(i) * ct;
       vy(i + 1) = vy(i) * ct - g * dt;
       x(i + 1) = x(i) + vx(i) * dt;
       y(i + 1) = y(i) + vy(i) * dt;
       if y(i + 1) <= 0
           break;
       end
    end

    indici = (1 : i);
    t = t(indici);
    vx = vx(indici);
    vy = vy(indici);
    x = x(indici);
    y = y(indici);
    tf = t(i);
    b = x(i); % bataia
    ymax = max(y); % altitudinea maxima
    position = b;
    if draw == true
        clf();
        figure(1);
        plot(x/1e3, y/1e3, '-k', 'LineWidth', 1);
        xlabel('x (km)'); ylabel('y (km)');
        title('Projectile trajectory');
        angle_disp = ['alpha = ', num2str(a0)];
        annotation('textbox',[0.4 0.7 0.3 0.3],'String', angle_disp,'EdgeColor','none')
        grid; axis equal; axis([0 b/1e3 0 1.1*ymax/1e3]); 
        afis1 = ['Flight time ', num2str(tf), 's'];
        %afis2 = ['Bataia este: ', num2str(b), 'm'];
        afis3 = ['Maximum altitude ', num2str(ymax), 'm'];
        disp(afis1);
        %disp(afis2);
        disp(afis3);
        pause(1);
    end
end