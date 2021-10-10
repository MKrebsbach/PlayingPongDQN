% MinibatchSGD.m
function Agent = MinibatchSGD(Agent, AgentName, Target, LearningRate, Discount, MinibatchSize, Regularization)
  
  if nargin < 6
    MinibatchSize = 64;
  end
  
  if nargin < 7
    Regularization = 0;
  end
  
  dW1 = zeros(size(Agent.W1));
  dW2 = zeros(size(Agent.W2));
  
  
  % -------------------- Collect MinibatchSize Gradients -------------------- %
  
  for i = 1:MinibatchSize
    
    % Sample Random instance from Memory
    [x1, action1, action2, reward1, reward2, x2, game_end] = SampleFromMemory();
    
    % Train only one of the agents (specified by Agent Name)
    if AgentName == 1
      action = action1;
      reward = reward1;
    elseif AgentName == 2
      action = action2;
      reward = reward2;
    end
    
    % Calculate Gradient 
    [dW1temp, dW2temp] = Gradient(Agent, Target, ...
                                  x1, action, reward, x2, ...
                                  game_end, Discount);
                                  
    % Add Gradient 
    dW1 = dW1 + dW1temp;
    dW2 = dW2 + dW2temp;
    
  end
  
  
  % -------------------- Update Agent --------------------------------------- %
  
  Agent.W1 = LearningRate / MinibatchSize * dW1 + (1- Regularization) * Agent.W1;
  Agent.W2 = LearningRate / MinibatchSize * dW2 + (1- Regularization) * Agent.W2;
  
end
