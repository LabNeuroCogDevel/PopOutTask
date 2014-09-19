function s = plotResults(r)

   % truncate manips if too long
   totalTrl = length(r.trialInfo);
   r.manips.val = r.manips.val(1:totalTrl,:);
   
   easy    = r.manips.val(:,r.manips.easyIdx);
   Rsp     = cellfun(@(x) x.correct, {r.trialInfo.Rsp})';
   RT      = cellfun(@(x) x.RT,      {r.trialInfo.Rsp})';
   
   RT(~isfinite(RT)) = NaN;

   %ratio   = reshape([NaN NaN r.trialInfo.ratios],length(r.trialInfo),2);
   RTshift = [NaN r.trialInfo.RTshift];
   
%    RspColor= [ 256 0   0  ; ... -1 -> wrong
%                0   0   256; ...  0 -> tooslow
%                0   256 0  ];...  1 -> correct
%    
%    subplot(3,1,1);
%       %plot(ratio);
%       hold on
%       scatter(1:totalTrl, Rsp+.2, 10, RspColor((Rsp+2),:));
%       %scatter(1:totalTrl,easy,3,easy);

%       legend ({'rH','rE'});

  corIdx=find(Rsp==1);
  errIdx=find(Rsp==0);
  misIdx=find(Rsp==-1);
  
  hardIdx=find(~easy);
   subplot(2,1,1);
      title RTshift;
      ylabel shift(s);
      xlabel trial;
      hold on;
      plot(RTshift);
      plot(corIdx,RTshift(corIdx),'g*');
      plot(errIdx,RTshift(errIdx),'r*');
      plot(misIdx,RTshift(misIdx),'m*');
      
      plot(hardIdx,RTshift(hardIdx),'ko');

      legend({'RTwindow', 'Correct','Incorrect','Missed','incong'});
      
   subplot(2,1,2);
      title RT;
      ylabel RT(s);
      xlabel trial;
      hold on;
      plot(RT);
      
      plot(corIdx,RT(corIdx),'g*');
      plot(errIdx,RT(errIdx),'r*');
      plot(misIdx,RT(misIdx),'m*');
      
      plot(hardIdx,RT(hardIdx),'ko');

      legend RT Correct Incorrect Missed incong;

      acc = sum(Rsp(~easy)==1)/length(find(~easy));
      fprintf('Accuracy: %.3f\n', acc )
      
  
   s.RT = RT; s.Rsp=Rsp; s.easy = easy;
   s.inc_acc=acc;
   
end