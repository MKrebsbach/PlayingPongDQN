% Pong.m
% This Program lets you play the game "Pong" against a Neural Network
% The code for this environment was copied from Silas Henderson:
% https://de.mathworks.com/matlabcentral/fileexchange/69833-pong/
% and adjusted for these purposes


clc; close all;

if exist("Agent2", "var")
  disp ('Use existing Agent')
else
  Agent2 = load('Agent2_10x10_Competitive_2L_260.txt').Agent2
end

global fieldHeight;
global fieldWidth;

fieldHeight = 64;
fieldWidth  = 32;

global PongBlockCenter1;
TestReward1 = 0;
TestReward2 = 0;


% -------------------------- Setup ----------------------------------------- % 

% Setup Variables
PongVariables = InitializePong();
PongVariables(4) = 1.5; % Initial Movement should go up
PongBallPos = [PongVariables(1) PongVariables(2)];
PongBallVel = [PongVariables(3) PongVariables(4)];
PongBlockCenter1 = PongVariables(5);
PongBlockCenter2 = PongVariables(6);

% Figure
PongFigure = figure('color', [.6 .6 .8],...                   
'KeyPressFcn', @keyboardFunction,...
'units','normalized','position',[.1 .1 .3 .8]);

% Axes
pongAxes   = axes('color', 'black',...
 'XLim', [0 fieldWidth], 'YLim',[-4,fieldHeight+4], 'position', [.05 .05 .9 .9]);
xticklabels([]);
yticklabels([]);

% Ball
PongBall   = line(PongBallPos(1),PongBallPos(2),...
 'marker','.', 'markersize',25, 'color','white');

% Lower Block                                         
PongBlock1 = line([PongBlockCenter1 - 3, PongBlockCenter1 + 3], [0 0],...      
 'linewidth',4,'color','white');
 
% Upper block
PongBlock2 = line([PongBlockCenter2 - 3, PongBlockCenter2 + 3], ...
                  [fieldHeight fieldHeight], 'linewidth',4,'color','white');


% ---------------------- Game Loop ------------------------------------------ %
  
t = 1;
game_end = false;

while not (game_end)
  
  % Agent 2
  out = DQN(Agent2, PongVariables, false);
  [Q2, action2] = max(out);
  
  PongVariables(5) = PongBlockCenter1;
  
  
  % -------------------- Perform one step in Game --------------------------- %
  
  [PongVariables, game_end, reward1, reward2] ...
              = PongNextStep(PongVariables, 1, action2);
              
  PongBallPos = [PongVariables(1) PongVariables(2)];
  PongBallVel = [PongVariables(3) PongVariables(4)];
  PongBlockCenter2 = PongVariables(6); 
  
  PongVariables(5) = PongBlockCenter1;
   
  % Keep Track of Total Reward
  TestReward1 = TestReward1 + reward1;
  TestReward2 = TestReward2 + reward2;
  
  set(PongBall, 'XData', PongBallPos(1), 'YData', PongBallPos(2)) % Update Ball
  
  set(PongBlock1, 'XData', [PongBlockCenter1 - 3, ...     % Update lower block 
                            PongBlockCenter1 + 3])
  
  set(PongBlock2, 'XData', [PongBlockCenter2 - 3, ...     % Update upper block
                            PongBlockCenter2 + 3])
  
  
  pause(.043);
  
  % raise running index
  t = t + 1;
  
end

close;

