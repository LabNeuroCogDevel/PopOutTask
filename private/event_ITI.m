
function t=event_ITI(w,when,color)
  DrawFormattedText(w,'+','center','center',color);
  [v,t] = Screen('Flip',w,when);
end
