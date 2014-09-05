
function t=event_Prp(w,when,rect,congr)
  if(congr)
      Screen('FillRect',w,[ 0 255 0],rect);
  else
      Screen('FillRect',w,[ 255 0 0],rect);
  end
  [v,t] = Screen('Flip',w,when);
end

