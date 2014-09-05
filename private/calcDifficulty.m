
% easy and hard scale. want both at .85
% diffscale=[hard easy]
function diffScale = calcDifficulty(prevDiff, isEasy,isCorrect)
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
  
  diffScale=[0 0]; % default
  % maybe we are initializing
  if isempty(isCorrect) || length(isCorrect) ~= length(isEasy)
      return
  end
  

  % break up into hard and easy
  isCorrectHard = isCorrect(isEasy~=1);
  isCorrectEasy = isCorrect(isEasy==1);
  
  % get count of how many are correct
  hardCorrectRatio = length( find(isCorrectHard) ) / max(1,length(isCorrectHard));
  easyCorrectRatio = length( find(isCorrectEasy) ) / max(1,length(isCorrectEasy));
  fprintf('\t%%cor: %.02f hard %.02f easy\n',hardCorrectRatio,easyCorrectRatio);

  
  % set the scales
  diffScale(1)=f(hardCorrectRatio);
  diffScale(2)=f(easyCorrectRatio);
  fprintf('\tdiff: %.02f hard %.02f easy\n',diffScale(1),diffScale(2));
  
  
end