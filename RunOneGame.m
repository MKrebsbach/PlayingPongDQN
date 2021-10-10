% RunOneGame.m
function [t, TestReward1, TestReward2] = RunOneGame(Agent1, Agent2, MaxRuntime)
  global fieldHeight
  global fieldWidth
    
  % Initialize Pong Parameters
  PongVariables = InitializePong();
  game_end = false;
  
  % Game Loop;
  t = 1;
  TestReward1 = 0;
  TestReward2 = 0;
  
  
  % -------------------- Game Loop ------------------------------------------ %
  
  while t < MaxRuntime && not (game_end)
    
    % Agent 1
    out = DQN(Agent1, PongVariables, false);
    [Q1, action1] = max(out);
    
    % Agent 2
    out = DQN(Agent2, PongVariables, false);
    [Q2, action2] = max(out);
    
    
    % ------------------ Perform one step in Game --------------------------- %
    
    [PongVariables, game_end, reward1, reward2] ...
                = PongNextStep(PongVariables, action1, action2);
     
    % Keep Track of Total Reward
    TestReward1 = TestReward1 + reward1;
    TestReward2 = TestReward2 + reward2;
     
    % Save Winner
    if game_end
      if reward1 < reward2
        Winner = 2;
      else
        Winner = 1;
      end
    end    
    
    % raise running index
    t = t + 1;
    
  end
    
