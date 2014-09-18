function [hardCorrectRatio, easyCorrectRatio] = getCorrectRatios(isEasy,isCorrect)


    % break up into hard and easy
    isCorrectHard = isCorrect(isEasy~=1);
    isCorrectEasy = isCorrect(isEasy==1);

    % get count of how many are correct
    hardCorrectRatio = length( find(isCorrectHard) ) / max(1,length(isCorrectHard));
    easyCorrectRatio = length( find(isCorrectEasy) ) / max(1,length(isCorrectEasy));
    
    %TODO if have not seen any, set at .5 ?
    
    
    fprintf('\t%%cor: %.02f hard %.02f easy\n',hardCorrectRatio,easyCorrectRatio);
end