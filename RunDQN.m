% RunDQN.m
clear; clc; close all;
tic;

% First specify if you use Octave (true) or Matlab (false)
Octave = false;

% Set State for Random Generator
if Octave
  rand('state', 895647); % 895647
else
  rng(895647);
end

global fieldHeight
global fieldWidth
global Memory

% Fix size of the Pong Field
fieldHeight = 64;
fieldWidth  = 32;

% ---------------------- Step 1: Initializazion ------------------------ %
% ---------------------- 1. Setup Learning Parameters ------------------ %

if Octave
  StartLearning  = 1600 ;      % # of Random Episodes before Learning starts
  NEpisodes      = 20000;      % Octave is much slower but this works as well (at least on Windows?)
  LearningRate   = 6e-1 ;
  MaxMemory      = 1e4  ;      % Size of the Memory (Again smaller for Octave)
  UpdateTarget   = 4001 ;      % Periode with which Target is updated
else
  StartLearning  = 5000 ;     % # of Random Episodes before Learning starts
  NEpisodes      = 46000; 
  LearningRate   = 4e-1 ;
  MaxMemory      = 1e5  ;     % Size of the Memory
  UpdateTarget   = 10001;     % Periode with which Target is updated
end

Discount       = 0.95 ;      % Discount in Bellman Equation
MinibatchSize  = 64   ;
MaxRuntime     = 400  ;      % Maximal Runtime of Pong
Regularization = 0e-5 ;


% Setup Epsilon Greedy
Epsilon        = 1;
EpsilonDel     = 1e-4;
EpsilonMin     = 0.05;

% Setup Memory
Memory         = struct();
idx            = 1;        % Memory index


% ---------------------- 2 . Initialize Agents and Targets ------------- %

NHidden = 21;

Agent1  = InitializeAgent(NHidden); 
Agent2  = InitializeAgent(NHidden); 

Target1 = Agent1; %InitializeTarget(NHidden); 
Target2 = Agent2; %InitializeTarget(NHidden);


% ---------------------- 3. Fill Memory with Random Games -------------- % 

disp ('**********************************************************************')
disp ('********************     Random Phase     ****************************')
disp ('**********************************************************************')

TRandom  = [];
R1Random = [];
R2Random = [];
for RandomEpisode = 1:StartLearning
  
  % RandomAgent plays one round of pong
  % All Actions are chosen randomly
  % Everything is saved into Memory
  
  [idx, t, R1, R2] = RandomAgent(idx, MaxMemory, MaxRuntime);
  TRandom(RandomEpisode)  = t;
  R1Random(RandomEpisode) = R1;
  R2Random(RandomEpisode) = R2;
  
  if mod(RandomEpisode, 100) == 0
    disp ('############################')
    RandomEpisode
    meanTime = mean(TRandom(end-99:end))
  end
  
end


% ---------------------- Step 2: Training ------------------------------ %

disp ('**********************************************************************')
disp ('********************    Training Phase    ****************************')
disp ('**********************************************************************')

% Some Variables and Lists for later
Looser     = 2;
Winner     = [];
Time       = [];
WinnerStat = [];
MaxReward1 = -10;
MaxReward2 = -10;
DevTime    = [];
DevReward1 = [];
DevReward2 = [];


% ---------------------- 1. Main Training Loop ------------------------- %

for Episode = 1:NEpisodes

  % Setup Epsilon
  Epsilon = max( EpsilonMin, Epsilon - EpsilonDel);
  
  % Initialize Pong Parameters
  Memory(idx).PongVariables = InitializePong();
  Memory(idx).game_end = false;
  
  % Game Loop;
  t = 1;
  TotalReward1 = 0;
  TotalReward2 = 0;
  
  
  % -------------------- Step 3: Game Loop ----------------------------- %
  
  while t < MaxRuntime && not (Memory(idx).game_end)
    
    % Agent 1
    % With Probability Epislon choose Random Action
    % Otherwise Agent1 chooses Action
    if rand([1,]) < Epsilon 
      Memory(idx).action1 = randi(3);
    else
      out = DQN(Agent1, Memory(idx).PongVariables, false);
      [Q1, Memory(idx).action1] = max(out);
      Memory(idx).Q1 = Q1;
    end
    
    % Agent 2
    % With Probability Epislon choose Random Action
    % Otherwise Agent2 chooses Action
    if rand([1,]) < Epsilon
      Memory(idx).action2 = randi(3);
    else
      out = DQN(Agent2, Memory(idx).PongVariables, false);
      [Q2, Memory(idx).action2] = max(out);
      Memory(idx).Q2 = Q2;
    end
    
    
    % ------------------ Perform one step in Game ---------------------- %
    % Save new game parameters and rewards in Memory
    [Memory(mod(idx, MaxMemory) + 1).PongVariables, ...
     Memory(mod(idx, MaxMemory) + 1).game_end, ...
     Memory(idx).reward1, ...
     Memory(idx).reward2] = PongNextStep(Memory(idx).PongVariables, ...
                                         Memory(idx).action1, ...
                                         Memory(idx).action2);
     
    % Keep Track of Total Reward
    TotalReward1 = TotalReward1 + Memory(idx).reward1;
    TotalReward2 = TotalReward2 + Memory(idx).reward2;
     
    % The looser of this round is trained next round
    if Memory(mod(idx, MaxMemory) + 1).game_end
      if Memory(idx).reward1 < Memory(idx).reward2
        Looser = 1;
        Winner(end+1) = 2;
        Time(end+1) = t+1;
      else
        Looser = 2;
        Winner(end+1) = 1;
        Time(end+1) = t+1;
      end
      WinnerStat(end+1) = Winner(end);
    end    
    
    % raise running indices
    t = t + 1;
    idx = mod(idx, MaxMemory) + 1;
    
  end
  
  idx = mod(idx, MaxMemory) + 1;
  
  % If new Reward record save this Weights for next Target update
  if TotalReward1 >= MaxReward1
    MaxReward1 = TotalReward1;
    NextTarget1 = Agent1;
  end
  if TotalReward2 >= MaxReward2
    MaxReward2 = TotalReward2;
    NextTarget2 = Agent2;
  end
  
  if mod(Episode, UpdateTarget) == 0
    disp ('*****************************************************')
    disp ('****************** UPDATE TARGETS *******************')
    disp ('*****************************************************')
    Target1 = NextTarget1;
    Target2 = NextTarget2;
  end
  
  % ------------------ Minibatch Training ------------------------------ %
  if Looser == 1
    Agent1 = MinibatchSGD(Agent1, 1, Target1, LearningRate, Discount, ...
                          MinibatchSize, Regularization);
  else
    Agent2 = MinibatchSGD(Agent2, 2, Target2, LearningRate, Discount, ...
                          MinibatchSize, Regularization);
  end
  
  
  if mod(Episode, 100) == 0
    TestTime = [];
    TestReward1 = [];
    TestReward2 = [];
    for i = 1:5
      [TestTime(i), TestReward1(i), TestReward2(i)] = RunOneGame(NextTarget1, NextTarget2, MaxRuntime);
    end
    disp ('############################################')
    meanTestTime   = mean(TestTime)
    meanDevReward1 = mean(TestReward1)
    meanDevReward2 = mean(TestReward2)
    Episode
    DevTime(end +1)    = meanTestTime;
    DevReward1(end +1) = meanDevReward1;
    DevReward2(end +1) = meanDevReward2;
    Epsilon
    meanWinner = mean(WinnerStat)
    WinnerStat = [];
  end
  
end
  

% ---------------------- Step 4: Test Phase ---------------------------- % 

disp ('**********************************************************************')
disp ('********************     Test Phase     ******************************')
disp ('**********************************************************************')

TTest = [];
R1Test = [];
R2Test = [];

% Target is often better than Agent
Agent1 = NextTarget1;
Agent2 = NextTarget2;

for i = 1:StartLearning
  
  % Initialize Pong parameters
  PongVariables = InitializePong();
  game_end = false;
  
  t = 1;
  TotalReward1 = 0;
  TotalReward2 = 0;
  % -------------------- One Game Loop -------------------------------------- %
  while t<MaxRuntime && not (game_end)
    [Q1, action1] = max(DQN(Agent1, PongVariables));
    [Q2, action2] = max(DQN(Agent2, PongVariables));
    
    [PongVariables, game_end, reward1, reward2] ...
                      = PongNextStep(PongVariables, action1, action2);
    
    TotalReward1 = TotalReward1 + reward1;
    TotalReward2 = TotalReward2 + reward2;
    % Raise running Indices
    t = t + 1;
    
  end
  R1Test(i) = TotalReward1;
  R2Test(i) = TotalReward2;
  TTest(i) = t;
  if mod(i, 100) == 0
    disp ('############ Test Episode'), disp (i)
    meanTest = mean(TTest(end-99:end))
  end
end

% Compare mean Game Time of Random Loop with Test Loop
disp ('#################################################')
disp ('Random vs DQN Agents:')
meanRandom   = mean(TRandom)
meanTest     = mean(TTest)
meanR1Random = mean(R1Random)
meanR2Random = mean(R2Random)
meanR1Test   = mean(R1Test)
meanR2Test   = mean(R2Test)

figure(1)
plot(DevTime)
xlabel('Episode/100')
ylabel('Time steps')
title('Performance evaluation: Game duration')
axis;
grid on

figure(2)
plot(DevReward1)
hold on
plot(DevReward2)
xlabel('Episode/100')
ylabel('Score')
title('Performance evaluation: Final score')
axis;
grid on

% Print total time used for training
toc;