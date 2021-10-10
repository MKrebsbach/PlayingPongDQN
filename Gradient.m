% Gradient.m
function [dW1, dW2] = Gradient(Agent, Target, ...
                               x1, action, reward, x2, ...
                               game_end, Discount)
  
  % ----------------- Calculate y from Bellman Equation ---------------- %

  if game_end
    y       = reward;
  else
    out     = DQN(Target, x2, false);
    QTarget = max(out);
    y       = reward + Discount * QTarget;
  end
  
  % Agent's estimate of Q (and intermediate steps out.y1, out,v2)
  out         = DQN(Agent, x1, true);
  
  
  % ------------------- Backpropagation -------------------------------- %
  
  e2         = zeros([3,1]);
  e2(action) = y - out.v2(action);
  delta2     = e2;

  e1         = Agent.W2(:,1:end-1)' * delta2;
  delta1     = DerActivationF(out.y1(1:end-1)) .* e1;
  
  % Normalize Input like in DQN
  x1         = x1 ./ [32; 64; 1.5; 1.5; 32; 32]; 
  
  % Add Bias like in DQN. 
  x1(end +1) = 1;
  
  % Gradients
  dW1        = delta1 * x1';
  dW2        = delta2 * out.y1';
  
  
end
