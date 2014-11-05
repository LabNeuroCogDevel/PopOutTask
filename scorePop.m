function scores=scorePop(matfile)
  subj=load(matfile);
  congr  =arrayfun(@(x) x.congr,   [subj.trialInfo.Prp] );
  correct=arrayfun(@(x) x.correct, [subj.trialInfo.Rsp] );
  RTvec  =arrayfun(@(x) x.RT,      [subj.trialInfo.Rsp] );

  RT=inf(4,3);
  RT(:,1)=[Inf -1 0 1];
  RT(1,:)=[Inf 0 1];
  counts=RT;
  for cortype=[-1 0 1]; 
      for iscong=[0 1];
          idxs=correct==cortype&congr==iscong;
          counts(cortype+3,iscong+2) = nnz(idxs);
          RT(cortype+3,iscong+2)     = mean(RTvec(idxs));
      end
  end
  
  
  scores.RT=RT;
  scores.counts=counts;
  scores.RTwin       = subj.idealRTwin;
  scores.overallPrct = nnz(correct==1)/length(correct)*100;
  scores.incongPrct  = nnz(correct(congr==0)==1)/nnz(congr==0)*100; 
  scores.congPrct    = nnz(correct(congr==1)==1)/nnz(congr==1)*100; 
  
  scores.overallRT   = mean(RTvec(correct~=-1));
  scores.incongRT    = mean(RTvec(correct~=-1&congr==0));
  scores.congRT      = mean(RTvec(correct~=-1&congr==1));
  
  scores.incongMis      = nnz(RTvec(correct==-1&congr==0));
  scores.congMis      = nnz(RTvec(correct==-1&congr==1));

end
