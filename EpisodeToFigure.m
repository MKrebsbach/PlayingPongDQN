% EpisodeToFigure.m
function EpisodeToFigure(Episode)
 
  % -------------------------- Setup ----------------------------------------- % 
  global fieldHeight
  global fieldWidth
  
  fieldHeight = 64;
  fieldWidth = 32;
  
  PongVariables = Episode(1).PongVariables;
  
  % figure
  pongFigure = figure('color', [.6 .6 .8],...                     
  'units','normalized','position',[.1 .1 .3 .8]);
  
  % axes
  pongAxes   = axes('color', 'black', 'XLim', [0, fieldWidth],... 
      'YLim',[-4,fieldHeight+4], 'position', [.05 .05 .9 .9]);
  xticklabels([]);
  yticklabels([]);
  
  % ball
  pongBall    = line(PongVariables(1), PongVariables(2),...       
   'marker','.', 'markersize',25, 'color','white');
  
  % lower block  
  pongBlock1 = line([PongVariables(5) - 3, PongVariables(5) + 3], [0 0],...      
   'linewidth',4,'color','white');
   
  % upper block
  pongBlock2 = line([PongVariables(6) - 3, PongVariables(6) + 3],...
                    [fieldHeight fieldHeight], 'linewidth',4,'color','white');


  for eps = 2:length(Episode)
    PongVariables = Episode(eps).PongVariables;
    
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

