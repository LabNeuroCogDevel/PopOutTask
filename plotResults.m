function plotResults(r)

   % truncate manips if too long
   totalTrl = length(r.trialInfo);
   r.manips.val = r.manips.val(1:totalTrl,:);
   
   easy    = r.manips.val(:,r.manips.easyIdx);
   Rsp     = cellfun(@(x) x.correct, {r.trialInfo.Rsp})';
   RT      = cellfun(@(x) x.RT,      {r.trialInfo.Rsp})';
   
   RT(~isfinite(RT)) = NaN;

   %ratio   = reshape([NaN NaN r.trialInfo.ratios],length(r.trialInfo),2);
   RTshift = [r.trialInfo.RTshift];
   
   RspColor= [ 256 0   0  ; ... -1 -> wrong
               0   0   256; ...  0 -> tooslow
               0   256 0  ];...  1 -> correct
   
%    subplot(3,1,1);
%       %plot(ratio);
%       hold on
%       scatter(1:totalTrl, Rsp+.2, 10, RspColor((Rsp+2),:));
%       %scatter(1:totalTrl,easy,3,easy);

%       legend ({'rH','rE'});
   subplot(2,1,1);
      plot(RTshift);
      legend({'tH','tE'});
      
   subplot(2,1,2);
      plot(RT);
      hold on;
      plot(Rsp,'m*');
      scatter(1:totalTrl,easy,3,easy);
      legend Rsp RT Rsp easy;

end