function t=playSnd(varargin)
  persistent snds pahandle;
  
  %% (re-)initialize audio
  if isempty(snds) || isempty(varargin)
    InitializePsychSound;
    try
      pahandle = PsychPortAudio('Open', [], [], 0, [], 2);
    catch
      PsychPortAudio('Close');
      pahandle = PsychPortAudio('Open', [], [], 0, [], 2);
    end

    snds.crt = getwave('snd/cash.wav');
    snds.wrg = getwave('snd/171524__fins__error.wav');
    snds.neu = getwave('snd/178186__snapper4298__camera-click-nikon.wav');
  end
  
  % no input means initializing
  if isempty(varargin)
      return;
  end
  
  %Snd('Play',snds.(varargin{1}));
  PsychPortAudio('FillBuffer', pahandle,snds.(varargin{1}));
  t = PsychPortAudio('Start', pahandle, 1, 0, 1);
end

function wd = getwave(f)
  [y,freq] = wavread(f); %for octave
  %[y,~] = audioread(f);
  
  % we want 2 channels
  if size(y,2) == 1
      wd = [y';y'];
  else
      wd = y';
  end

end