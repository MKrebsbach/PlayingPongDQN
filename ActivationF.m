% ActivationF.m
function x = ActivationF(x)
  
  % ReLU
  x = max(0, x);
  
  % Sigmoid
  % x = 1 ./ (1 + exp(-x)) 
end
