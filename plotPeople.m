
for f={'scott','will-retest','julia-retest','david','btc_redo'}
  fl=regexprep(f{1},'-','_');
  pep.(fl)=plotResults(load(f{1})); close all;
end

%%
colors='bgkcmy';
hold on; 
title('Sorted RT  for Incongruent Trials');
xlabel trial
ylabel RT(s)

ci=1;
for fl=fieldnames(pep)';
  a=pep.(fl{1});
  m = [ a.RT(isfinite(a.RT)&~a.easy) a.Rsp(isfinite(a.RT)&~a.easy) ]; [~,i]=sort(m(:,1)); x=m(i,:);
  pep.(fl{1}).incogRT=x;
  incor=find(~x(:,2));
  
  c = ['-' colors(ci)]; 
  h(ci)= plot(x(:,1),c);
  
  ci=mod(ci,length(colors))+1;
  
  plot(incor,x(incor,1),'*r');
end

%legend(h,fieldnames(pep))