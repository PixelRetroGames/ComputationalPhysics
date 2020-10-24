function [E] = oed(theta, omega, m, l, g)
    M = sum(m);
    A = [1, (m(2) + m(3)) * cos(theta(1) - theta(2)) * l(2) / (l(1) * M), m(3) * cos(theta(1) - theta(3)) * l(3) / (l(1) * M);
         l(1) * cos(theta(2) - theta(1)) / l(2), 1, m(3) * cos(theta(2) - theta(3)) * l(3) / (l(2) * (m(2) + m(3)));
         l(1) * cos(theta(3) - theta(1)) / l(3), l(2) * cos(theta(3) - theta(2)) / l(3), 1];
    Q = [0 , -(m(2) + m(3)) * sin(theta(1) - theta(2)) * l(2) / (l(1) * M),  -m(3) * sin(theta(1) - theta(3)) * l(3) / (l(1) * M); 
         -l(1) * sin(theta(2) - theta(1)) / l(2),  0,  -m(3) * sin(theta(2) - theta(3)) * l(3) / (l(2) * (m(2) + m(3)));
         -l(1) * sin(theta(3) - theta(1)) / l(3) , -l(2) * sin(theta(3) - theta(2)) / l(3), 0];
    W = [omega(1)^2; omega(2)^2; omega(3)^2];
    SQ = [sin(theta(1)) / l(1);
          sin(theta(2)) / l(2);
          sin(theta(3)) / l(3)];
    B = Q * W + g * SQ;
    E = A \ B;
end