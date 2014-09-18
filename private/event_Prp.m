
function t=event_Prp(w,when,congr)

  
  width=20;  % How big is the box?
  [cx,cy] = RectCenter(Screen('Rect',w));
  rect=CenterRectOnPoint([0 0 width width],cx,cy);
  
  if(congr)
      Screen('FillRect',w,[ 0 255 0],rect);
  else
      Screen('FillRect',w,[ 255 0 0],rect);
  end
  [v,t] = Screen('Flip',w,when);
end

