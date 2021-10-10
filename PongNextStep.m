% PongNextStep.m
function [PongVariables, game_end, reward1, reward2] = ...
                PongNextStep(PongVariables, action1, action2)
  
  global fieldHeight
  global fieldWidth
  
  game_end = false;
  reward1 = 0;
  reward2 = 0;
  
  % Extract Pong Parameters 
  pongBallPos = [PongVariables(1) PongVariables(2)];
  pongBallVel = [PongVariables(3) PongVariables(4)];
  pongBlockCenter1 = PongVariables(5);
  pongBlockCenter2 = PongVariables(6);
  
  % Perform action1 and action2
  % 2 = Left, 3 = Right, else = Pause
  switch action1
    case 2
      if pongBlockCenter1 - 1 > 3 + 1
        pongBlockCenter1 = pongBlockCenter1 - 2;
      end
    case 3
      if fieldWidth - pongBlockCenter1 > 3 + 1
        pongBlockCenter1 = pongBlockCenter1 + 2;
      end
  end
  
   switch action2
    case 2
      if pongBlockCenter2 - 1 > 3 + 1
        pongBlockCenter2 = pongBlockCenter2 - 2;
      end
    case 3
      if fieldWidth - pongBlockCenter2 > 3 + 1
        pongBlockCenter2 = pongBlockCenter2 + 2;
      end
  end
  
  % Move Pong Ball
  pongBallPos = pongBallPos + pongBallVel;
    
  % Side Bounce Check Left
  if pongBallPos(1) - 1 <= 3 && pongBallVel(1) < 0
    pongBallVel(1) = - pongBallVel(1);
  end
  
  % Side Bounce Check Right
  if fieldWidth - pongBallPos(1) <= 3 && pongBallVel(1) > 0
    pongBallVel(1) = - pongBallVel(1);
  end
  
  % Lower Block Check
  if pongBallPos(2) - 1 < 2.5 && pongBallVel(2) < 0
    if abs(pongBallPos(1) - pongBlockCenter1) <= 3.5
      pongBallVel(2) = - pongBallVel(2);
      pongBallVel(1) = pongBallVel(1) + (pongBallPos(1) - pongBlockCenter1)/2;
      pongBallVel(1) = sign(pongBallVel(1)) * min(abs(pongBallVel(1)), 1.5);
      reward1 = reward1 + 3 + 1.5 - abs(pongBallPos(1) - pongBlockCenter1)/2;
      reward2 = reward2 + 1;
    else
      game_end = true;
      reward1 = reward1 - (3 + abs(pongBallPos(1) - pongBlockCenter1)/5);
      reward2 = reward2 - 1;
    end
  end
  
  % Upper Block Check
  if fieldHeight - pongBallPos(2) < 2.5 && pongBallVel(2) > 0
    if abs(pongBallPos(1) - pongBlockCenter2) <= 3.5
      pongBallVel(2) = - pongBallVel(2);
      pongBallVel(1) = pongBallVel(1) + (pongBallPos(1) - pongBlockCenter2)/2;
      pongBallVel(1) = sign(pongBallVel(1)) * min(abs(pongBallVel(1)), 1.5);
      reward1 = reward1 + 1;
      reward2 = reward2 + 3 + 1.5 - abs(pongBallPos(1) - pongBlockCenter2)/2;
    else
      game_end = true;
      reward1 = reward1 - 1;
      reward2 = reward2 - (3 + abs(pongBallPos(1) - pongBlockCenter2)/5);
    end
  end
  
  % Update PongVariables
  PongVariables = [pongBallPos(1); pongBallPos(2); pongBallVel(1); pongBallVel(2);pongBlockCenter1; pongBlockCenter2];
  
end
