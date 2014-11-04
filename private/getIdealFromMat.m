%
% arrayfun(@(x) getIdealFromMat(['mats/' x{1}]),{a.name})
%
function ideal = getIdealFromMat(matfile)
   s=load(matfile);
   ideal=s.idealRTwin;
end
