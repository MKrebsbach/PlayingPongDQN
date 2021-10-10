% RandomAgent.m
function [idx, t, R1, R2] = RandomAgent(idx, MaxMemory, MaxRuntime)
  
  global Memory
  
  % Initialize Pong
  Memory(idx).PongVariables = InitializePong();
  Memory(idx).game_end = false;
  
  t = 1;
  while t < MaxRuntime && not (Memory(idx).game_end)
    
    % Choose Random Action
    Memory(idx).action1 = randi(3);
    Memory(idx).action2 = randi(3);
    
    [Memory(mod(idx, MaxMemory) + 1).PongVariables, ...
     Memory(mod(idx, MaxMemory) + 1).game_end, ...
     Memory(idx).reward1, ...
     Memory(idx).reward2] = PongNextStep(Memory(idx).PongVariables, ...
                                         Memory(idx).action1, ...
                                         Memory(idx).action2);
    
    % raise running indices
    t = t + 1;
    idx = mod(idx, MaxMemory) + 1; 
    
  end
  R1 = Memory(idx-1).reward1;
  R2 = Memory(idx-1).reward2;
  idx = mod(idx, MaxMemory) + 1;
  
end

