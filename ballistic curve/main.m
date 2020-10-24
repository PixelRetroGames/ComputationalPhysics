% Comment
% Miscarea unui proiectil cu frecare fluida
clear;
close all;
clc;
pause on;

% variable for interactive display
display = false;

dist = input('Target position in meters: ');
err = input('Accepted error in meters: ');
eps = 1e-10;
l = eps; r = 90 - eps;
while abs(r - l) > eps
    d = (r - l) / 3;
    l2 = l + d;
    r2 = r - d;
    pl = Get_position_hit(l2, 0);
    pr = Get_position_hit(r2, 0);
    if pl < pr
        l = l2;
    else
        r = r2;
    end
end
max = (r + l) / 2;
dist_max = Get_position_hit(max, 0);
dist_min = Get_position_hit(eps, 0);

if dist > dist_max || dist < dist_min
    disp('Will never reach!');
    return
end

l = eps; r = max;
mid = 0;
while l < r
    mid = (l + r) / 2;
    pmid = Get_position_hit(mid, display);
    % disp(['mid = ', num2str(mid)]);
    % disp(['pmid = ', num2str(pmid)]);
    % disp(['pmid - dist = ', num2str(pmid - dist)]);
    if abs(pmid - dist) < err
        break
    end
    if pmid > dist
        r = mid;
    else 
        l = mid;
    end
end
alpha = (l + r) / 2;
Get_position_hit(alpha, 1);
afis1 = ['Optimal angle is ', num2str(alpha), ' degrees'];
disp(['Angle for maximum distance is ', num2str(max)]);
disp(['Maximal distance is ', num2str(dist_max)]);
disp(['Minimal distance is ', num2str(dist_min)]);
disp(afis1);
