% TestRun.m 
% If there is currently no variable Agent1/2 then load it from a file
if exist("Agent1", "var")
  disp ('Use Agent1 from Workspace/Variable editor')
else
  disp ('No Agent1 was found in the Workspace/Variable editor');
end

if exist("Agent2", "var")
  disp ('Use Agent2 from Workspace/Variable editor')
else
  disp ('No Agent2 was found in the Workspace/variable editor');
end

% Switch between Random Game and NN-Game
Random = false;

% Initialize lists to save performance
TTest = [];
Winner = [];

global fieldHeight
global fieldWidth

fieldHeight = 64;
fieldWidth = 32;


 % ------------------------------- Main Loop -------------------------------- %
 
for i = 1:5
  TestMemory = struct();
  PongVariables = InitializePong();
  TestMemory(i).PongVariables = PongVariables;
  t = 1;
  game_end = false;
  
  
  % ------------------------------ Game Loop -------------------------------- %
  
  while t < 400 && not (game_end)
    [Q1, action1] = max(DQN(Agent1, PongVariables));
    [Q2, action2] = max(DQN(Agent2, PongVariables));
    
    if Random
      action1 = randi(3);
      action2 = randi(3);
    end
    
    [PongVariables, game_end, reward1, reward2] = PongNextStep(PongVariables, action1, action2);
    TestMemory(t).PongVariables = PongVariables;
    
    t = t + 1;
  end
  
  
  EpisodeToFigure(TestMemory)
  
  if t ~= 400
    if reward1 > reward2
      Winner(end+1) = 1;
    else 
      Winner(end+1) = 2;
    end
  end
  
  TTest(i) = t;
  if mod(i, 100) == 0
    disp ('######### ### Test Episode'), disp (i)
    t
  end
end

TTest
Winner
