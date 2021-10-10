% DerActivationF.m
function x = DerActivationF(x)
  
  % ReLU
  x = (x > 0);
  
  % Sigmoid
  % x = x .* (1-x);
end
