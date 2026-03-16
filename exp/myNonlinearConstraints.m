function [c, ceq] = myNonlinearConstraints(x)
    % Inequality constraints (c(x) <= 0)
    c = x(1:end-1) - x(2:end);  % This gives: x1 - x2 <= 0, x2 - x3 <= 0, ..., x(n-1) - x(n) <= 0
    ceq = [];  % No equality constraints
end