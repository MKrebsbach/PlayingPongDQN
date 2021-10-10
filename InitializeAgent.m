% InitializeAgent.m
function Agent = InitializeAgent(L1)
  
  if nargin < 1
    L1 = 21;
  end
  
  Agent    = struct();
  Agent.W1 = rand([L1 7])*2 - 1;
  Agent.W2 = rand([3 L1+1])*2 - 1;
  
end
