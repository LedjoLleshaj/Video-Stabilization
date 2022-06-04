function rotatetraslateStabilization(filename) 
    % Reset the video source to the beginning of the file.
    %filename = 'shaky_car.avi';
    hVideoSrc = VideoReader(filename);
    
    % Prendiamo l'ancora dall'immagine
    figure; 
    anchor = imcrop(rgb2gray(im2single(readFrame(hVideoSrc))););
    close;
    [R,C,~] = size(anchor);
    %Check risoluzione
    res = R*C; 
    tipo = 3;% res > 1280*720
    if( res < 640*480) 
        tipo = 1; 
    end
    if( res >= 640*480 && res < 1280*720) 
        tipo = 2; 
    end    
        
    R = round(R/2);
    C = round(C/2);
    %Inizio stabilizzazione dei frame
    
    ang = 0;
    for i = 1:hVideoSrc.NumFrames-1        
        frame = hVideoSrc.readFrame();
        [offset,ang] = CrossCorr(R,C,anchor,rgb2gray(frame),ang,tipo);
        stabilizedFrame = imtranslate(imrotate(frame,ang,'bilinear','crop'),offset,'FillValues',0);
        
        videoOutput(:,:,:,i) = stabilizedFrame; %add stabilized frame to video output  
    end
    watchFrames(hVideoSrc,videoOutput,'_rotateTraslateStabilized.mp4')
    
 end