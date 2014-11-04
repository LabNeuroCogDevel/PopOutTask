function set=popSettings()

persistent s;
if isempty(s)
     
     %% number of trials
     s.ntrials.quest    = 200;
     s.ntrials.test     = 96;
     s.ntrials.congonly = 96;

     %% screen info
     s.screen.res       = [1600 1200];
     s.screen.bgColor=256/2*[1 1 1];

     %% keys -- what keys can we use
     KbName('UnifyKeyNames');
     s.keys = KbName({'1!','0)','escape'});
     
     %% timing
     s.order={'ITI','Prp','Cue','Fbk'};
     s.timing.ITI=1.0;
     s.timing.Prp=0.5;
     s.timing.Cue=0.5;
     s.timing.Fbk=0.5;
end

set = s;

end