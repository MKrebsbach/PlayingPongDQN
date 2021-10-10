% InitializePong.m
function PongVariables = InitializePong()
  
  PongVariables = [randi([5 28]);     ...  % PongBallPos X
                   32;                ...  % PongBallPos Y
                   rand([1,])*3-1.5;  ...  % PongBallVel X
                   randi(2)*3-4.5;    ...  % PongBallVel Y 
                   randi([5 28]);     ...  % PongBlockCenter 1 (Lower)
                   randi([5 28])      ...  % PongBlockCenter 2 (Upper)
                   ];
                   
end
