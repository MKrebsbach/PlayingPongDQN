% MemoryToFigure.m
function MemoryToFigure(idx)
 
  global Memory
 
  start_eps = 1;
  while not (Memory(idx-start_eps-1).game_end) && (idx - start_eps > 2)
    start_eps = start_eps + 1;
  end
 start_eps
 

  % -------------------------- Setup ----------------------------------------- % 
    
  fieldHeight = 64;
  fieldWidth = 32;
  
  PongVariables = Memory(idx-start_eps-1).PongVariables;
  
  pongFigure = figure('color', [.6 .6 .8],...                       % figure
  'units','normalized','position',[.1 .1 .3 .8]);
  
  pongAxes   = axes('color', 'black',...                            % axes
   'XLim', [0, fieldWidth], 'YLim',[-4,fieldHeight+4], 'position', [.05 .05 .9 .9]);
  xticklabels([]);
  yticklabels([]);
  
      
  pongBall    = line(PongVariables(1), PongVariables(2),...
   'marker','.', 'markersize',25, 'color','white');
  
   % lower block  
  pongBlock1 = line([PongVariables(5) - 3, PongVariables(5) + 3], [0 0],...      
   'linewidth',4,'color','white');
   
   % upper block
  pongBlock2 = line([PongVariables(6) - 3, PongVariables(6) + 3],...
                    [fieldHeight fieldHeight], 'linewidth',4,'color','white');



  for eps = start_eps-1:-1:0
    PongVariables = Memory(idx - eps - 1).PongVariables;
    
    set(pongBall, 'XData', PongVariables(1), 'YData', PongVariables(2))
    
    set(pongBlock1, 'XData', [PongVariables(5) - 3, ...      % update lower block 
                            PongVariables(5) + 3])
    
    set(pongBlock2, 'XData', [PongVariables(6) - 3, ...      % update upper block
                            PongVariables(6) + 3])
                
    pause(.03);
    
  end
  pause(0.1)
  close
end

