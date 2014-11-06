% go through all the possible screens (taking a screenshot)
function fakeRunThrough
 clear all % clear persistant img counter in takepic
 s=popSettings();
 w=setupScreen( s.screen.bgColor, [400 300]);
 waittime=.3;
 
 %junk picture, need to initilze take pic?
 takepic(w,0,'junk',1)
 WaitSecs(waittime);
 
 event_ITI(w,GetSecs(),s.color.fix);
 WaitSecs(waittime);
 takepic(w,0,'fix',1)
 
 % congru
 event_Prp(w,GetSecs(),1); 
 WaitSecs(waittime);
 takepic(w,0,'Prp_cong',1)
 
 
 % incongru
 event_Prp(w,GetSecs(),0); 
 WaitSecs(waittime);
 takepic(w,0,'Prp_incong',1)
 
 % left=1 cue
 event_Cue(w,GetSecs(),1);
 WaitSecs(waittime);
 takepic(w,0,'cue_left',1)
 
 % right=2 cue
 event_Cue(w,GetSecs(),2);
 WaitSecs(waittime);
 takepic(w,0,'cue_right',1)
 
 % wait for response makes no sense here, nothing to take a picture of
 % % maxtime is current time, so we dont wait for key presses
 % % correctkey and allowed keys are empty
 %event_Rsp(w,GetSecs(),[],[]);
 %WaitSecs(waittime);
 %takepic(w,0,'Rsp',1)
 
 %event_Fbk(w,when,rewblock,rewtype, correct)
 % correct on reward block
 event_Fbk(w,GetSecs(),1,1,1,'nosnd');
 WaitSecs(waittime);
 takepic(w,0,'correctRewardFbk',1)

 
 % incorrect on reward block
 event_Fbk(w,GetSecs(),1,1,0,'nosnd');
 WaitSecs(waittime);
 takepic(w,0,'incorrectRewardFbk',1)

 
 % quest mode correct
 event_Fbk(w,GetSecs(),1,0,1,'nosnd');
 WaitSecs(waittime);
 takepic(w,0,'correctQuestFbk',1)

 
 % neutral block
 event_Fbk(w,GetSecs(),0,1,0,'nosnd');
 WaitSecs(waittime);
 takepic(w,0,'neutralFbk',1)
 
 closedown();
end