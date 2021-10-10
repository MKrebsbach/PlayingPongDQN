% DQN.mfunction out = DQN(Agent, PongVariables, IntermediateOutput)    if nargin < 3      IntermediateOutput = false;  end  % Normalize Input  PongVariables = PongVariables ./ [32; 64; 1.5; 1.5; 32; 32];     % Add Bias  PongVariables(end + 1) = 1;     % Layer 1  v1 = Agent.W1 * PongVariables;  y1 = ActivationF(v1);  y1(end + 1) = 1;            % Add Bias    % Layer 2  v2 = Agent.W2 * y1;    if IntermediateOutput    out = struct();    out.y1 = y1;    out.v2 = v2;  else    out = v2;  end  end