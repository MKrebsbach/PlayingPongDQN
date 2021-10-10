% SampleFromMemory.m
function [x1, action1, action2, reward1, reward2, x2, game_end] = SampleFromMemory()
  
  global Memory
  
  game_end_old = true;
  
  % Choose index that does not correspond to a last state
  while game_end_old
    
    M = length(Memory) - 1; 
    
    id = randi(M);
    
    game_end_old = Memory(id).game_end;
    
  end
  
  % Extract relevant Parameters from Memory(index)
  x1       = Memory(id).PongVariables;
  action1  = Memory(id).action1;
  action2  = Memory(id).action2;
  reward1  = Memory(id).reward1;
  reward2  = Memory(id).reward2;
  x2       = Memory(id + 1).PongVariables;
  game_end = Memory(id + 1).game_end;
  
  
end
