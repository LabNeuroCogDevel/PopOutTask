%%%%%
% do we want to read or generate events
% if read, do we want with or without incongruent trials
% return event list and maniulation matrix
% event list -- event_ITI event_Prp event_Cue event_Rsp event_Fbk 
%[eList, manips] = setupEvents(totalTrl,rewblock);
function [eList, manips] = getEvents(rewblock,quest)
  
  % get settings, used to grab number of trials wanted 
  s=popSettings();
  
  if quest
      [eList, manips] = genEvents(s.ntrials.quest,rewblock);
  else
     if rewblock
       fname=s.seqfile.rew; %'optseq/rew-001.par';
       ntrl=s.ntrials.rew;
     else
   
       fname=s.seqfile.neut; %'optseq/rew-001.par'; % 'optseq/congOnly-001.par';
       ntrl=s.ntrials.neut;
     end
     
     [eList, manips] = readEvents(fname,rewblock);
     
     ntrlRead = length(find(cellfun( @(x) strncmp(x{3},'Prp',3),eList )));
     if ntrlRead ~= ntrl
         warning('read in %d trials but popSettings says we should have %d', ...
             ntrlRead,ntrl);
     end
  end
  
end