
for f={'scott','will-retest','julia-retest','david','btc_redo','bart-retest','sam-retest','r-retest-ACTUAL'}
  fl=regexprep(f{1},'-','_');
  pep.(fl)=plotResults(load(['mats/' f{1}])); close all;
end

%%
colors='bgkcmy';
lt    ={'-',':','-.','--'};
hold on; 
title('Sorted RT for Incongruent Trials');
xlabel trial
ylabel RT(s)


 fl=fieldnames(pep)';
for i=1:length(fl)
  a=pep.(fl{i});
  m = [ a.RT(isfinite(a.RT)&~a.easy) a.Rsp(isfinite(a.RT)&~a.easy) ]; [~,si]=sort(m(:,1)); x=m(si,:);
  pep.(fl{i}).incogRT=x;
  incor=find(~x(:,2));
  
  ci=mod(i-1,length(colors))+1;
  lti=mod(i-1,length(lt))+1;
  c = [lt{lti} colors(ci)]; 
  h(i)= plot(x(:,1),c);
  
  
  plot(incor,x(incor,1),'*r');
  
  
  res(i,:) = [ length(find(a.Rsp(~~a.easy)==1))/length(find(~~a.easy))
          max(a.RT(isfinite(a.RT)&~a.easy))
          mean(a.RT(isfinite(a.RT)&~a.easy))
          length(find(~isfinite(a.RT)&~a.easy))
          length(find(~a.easy)) 
          ]';
   disp(fl{i});
   disp(res(i,:));        
end

legend(h,fieldnames(pep))


