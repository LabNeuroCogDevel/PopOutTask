% % load test into matlab
% clear test; test=checkPop; 
% % rung single test
% test.testReadEvents
% % or run all
% run(checkPop)
classdef checkPop < matlab.unittest.TestCase

    methods (Test)

        %% read in events
        function testReadEvents(tc)
            expCogRatio=0.75; % how many trials should be congruent?
            fname='optseq/test-001.par';
            rew=1;
            [e, m] = readEvents(fname,rew);
            
            %% test colored square distribution
            % 1 is cong, 0 is incog
            isprb = cellfun(@(x)strcmp(x{3},'Prp'),e);
            prbtype = cellfun(@(x) x{6}, e(isprb) );
            
            cogRatio=length(find(prbtype==1))/length(prbtype);
            % test doesnt do floating point well
            % test that the diff between expected and actual is okay
            tc.verifyLessThanOrEqual(abs(cogRatio-expCogRatio),10^-5,'Cong. Ratio');
            
            %% test left|right cue dist
            % 1 is left, 2 is right
            iscue = cellfun(@(x)strcmp(x{3},'Cue'),e);
            cuedir = cellfun(@(x) x{6}, e(iscue) );
            tc.verifyEqual(length(find(cuedir==1)),length(find(cuedir==2)),...
                'Left and Right cues happen equally');

            
            %% overall distribution of manipulations (left|right + cong|icong)
            [a,b,c]=unique(m.val,'rows'); [d,e]=histc(c,1:length(b)); 
            disp('   count  dir  cong')
            disp([d a])
            
            
        end
    end
end