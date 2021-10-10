% keyboardFunction.m
function action1 = keyboardFunction(figure, event)
  global PongBlockCenter1 
  global fieldWidth
  
  switch event.Key
    case 'a'
      if PongBlockCenter1 - 5 > 0
        PongBlockCenter1 = PongBlockCenter1 - 2;
      end
    case 'd'
      if fieldWidth - PongBlockCenter1 - 5 > 0
        PongBlockCenter1 = PongBlockCenter1 + 2;
      end    
  end
end
