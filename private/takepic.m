function takepic(w,trl,name,takepic)
    % do we actually want to run?
    if(~takepic)
        return
    end
    
    %number the images we are taking
    persistent count
    if isempty(count)
        count=0;
    else
        count=count+1;
    end
    
    % where to save
    dir='screenshots/';
    
    if ~ exist(dir,'dir')
        mkdir(dir)
    end
    % what to name the file
    name=[ dir  sprintf('%02d',count) '_' sprintf('%02d',trl) '_' name '.png' ];
    
    % write if we haven't
    if ~ exist(name,'file')
        imwrite(Screen('GetImage', w),name)
    end
end