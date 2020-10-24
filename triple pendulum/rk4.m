function [next] = rk4(curr, k, dt, b)
    p = zeros(4, 3);
    p(1, :) = k(1, :) * b * dt;
    p(2, :) = k(2, :) * 2 * b * dt;
    p(3, :) = k(3, :) * 2 * b * dt;
    p(4, :) = k(4, :) * b * dt;
    next = curr + p(1, :) + p(2, :) + p(3, :) + p(4, :);
end