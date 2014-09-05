% uses imresize, requires image pkg in octave

% octave> pkg install -forge general control signal image
% pkg load image

function textures = getTextures(w)
  % need right,wrong, and neutral circle and center figures
  
  imagenames = ...
   { { 'cnt','crt','img/check.png' }, ...
     { 'cnt','wrg','img/red-cross.png' }, ...
     { 'cnt','neu','img/square.png' }, ...
     { 'rng','crt','img/coin_up.png' }, ...
     { 'rng','wrg','img/warning.png' }, ...
     { 'rng','neu','img/square.png' } };
 
  for i=1:length(imagenames)
      [pos, type, filename] =imagenames{i}{:};
      
      [imdata, colormap, alpha]=imread(filename);
      
      % resize here -- we dont use the full size anyway, so way store it
      % this step is uncessary though. we later scale with DrawTexture
      scaleby=.5;
      imdata=imresize(imdata,scaleby);
      alpha=imresize(alpha,scaleby);

      imdata(:, :, 4) = alpha(:, :); 
      
      textures.(pos).(type) = Screen('MakeTexture', w, imdata);
  end
end