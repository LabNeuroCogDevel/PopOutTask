function plotResults(r)

   % truncate manips if too long
   totalTrl = length(r.trialInfo);
   r.manips.val = r.manips.val(1:totalTrl,:);
   
   easy    = r.manips.val(:,r.manips.easyIdx);
   Rsp     = cellfun(@(x) x.correct, {r.trialInfo.Rsp})';
   RT      = cellfun(@(x) x.RT,      {r.trialInfo.Rsp})';
   
   RT(~isfinite(RT)) = NaN;

   ratio   = reshape([NaN NaN r.trialInfo.ratios],length(r.trialInfo),2);
   RTshift = reshape([NaN NaN r.trialInfo.RTshift],length(r.trialInfo),2);
   
   subplot(3,1,1);
      plot(ratio);
      hold on
      scatter(1:totalTrl,easy,3,easy)
      legend ({'rH','rE','easy'});
   subplot(3,1,2);
      plot(RTshift);
      legend({'tH','tE'});
      
   subplot(3,1,3);
      plot([Rsp RT]);
      hold on;
      scatter(1:totalTrl,easy,3,easy)
      legend Rsp RT easy;

end