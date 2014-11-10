function writeCSV
 paren=@(x,varargin) x(varargin{:});

 rootdir='subj';
 prefixes=unique(arrayfun(@(x) paren(strsplit(x.name,'_'),1), dir([rootdir '/*mat'])));
 
 fid=fopen('txt/RewNeutIncong.txt','w');
 %header
 fprintf(fid,'subj type run trial congr correct RT\n');
 for i=1:length(prefixes)
   writeCSVwPrefix(prefixes{i},rootdir,fid)
 end
end

%% find the rew and neutral file that have the same prefix
% write trials into fid
function writeCSVwPrefix(prefix,rootdir,fid)

  paren=@(x,varargin) x(varargin{:});
  filelist=[ dir([rootdir '/*' prefix '*_reward_*mat']); 
             dir([rootdir '/*' prefix '*_neutralIncong_*.mat']) ];
  files=arrayfun(@(x) x.name,filelist,'UniformOutput',0);
  
  % extract "now" time from mat file to get order
  dates=arrayfun(@(x) strrep(paren(fliplr(strsplit(x{1},'_')),1),'.mat',''), files');
  [~,i] = sort(dates);
  
  %header
  %fprintf('subj type run# trial# congr# correct RT\n');
  if  ~isempty(files) && length(files) ~= 2
      warning('skipping %s b/c have %d files',prefix,length(files))
      return
  end
  
  for d=1:length(files)
   file=files{i(d)};
   
   if     ~isempty(regexp(file,'_reward_','ONCE'));  type='reward';
   elseif ~isempty(regexp(file,'_neutralIncong_','ONCE')); type='neutral';
   else                                continue; 
   end
   
   subj=load([rootdir '/' file]);
   subjname=paren(strsplit(file,'_'),1);
   for j=1:length(subj.trialInfo)
     % last trial has only ITI
     if isempty(subj.trialInfo(j).Prp); continue; end
     
     fprintf(fid, '%s %s %d %d %d %d %f\n', subjname{1}, type, d, j, ...
           subj.trialInfo(j).Prp.congr, ... 
           subj.trialInfo(j).Rsp.correct, ...
           subj.trialInfo(j).Rsp.RT);
     
   end
  end
end