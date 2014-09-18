function RTshift   = calcRTshift(RTshift, hardratio,easyratio)
  persistent f
  
  % 1   correct:  -.3 sec  % as quicks 
  % 0 in    "     +.4 sec  % out to .9s to resond
  %maxShift=.4;
  %minShift=-.3;
  % f=fit([1;0],[minShift; maxShift, 'poly1')
  
  if isempty(f)
    f=@(x) -0.7*x +0.4; 
  end
  
  % maybe we are initializing
  if isempty(easyratio) || isempty(hardratio)
      return
  end
  
  RTshift(1)=f(hardratio);
  RTshift(2)=f(easyratio);
  fprintf('\tRTshift: %.02fs hard %.02fs easy\n',RTshift(1),RTshift(2));


end