
% easy and hard scale. want both at .85
% diffscale=[hard easy]
function diffScale = calcDifficulty(prevDiff, hardCorrectRatio, easyCorrectRatio)
  persistent f
  
  idealRatio=.85;
  if isempty(f)
      
      % fit doesn't exist in octave! :(
      if exist('OCTAVE_VERSION','builtin')
         f=@(x) 0.000709*exp(7.257*x); % f as reported by matlab with .85
      else
         f=fit([idealRatio-.3;1],[0;1],'exp1');
         %see plot(f) for a visual

      end
  end
  
  diffScale=prevDiff; % default
  % maybe we are initializing
  if isempty(hardCorrectRatio) || isempty(easyCorrectRatio)
      return
  end

  
  % set the scales
  diffScale(1)=f(hardCorrectRatio);
  diffScale(2)=f(easyCorrectRatio);
  fprintf('\tdiff: %.02f hard %.02f easy\n',diffScale(1),diffScale(2));
  
  
end