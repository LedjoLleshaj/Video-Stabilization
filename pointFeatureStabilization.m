function pointFeatureStabilization(filename)
    % Reset the video source to the beginning of the file.
    %filename = 'shaky_car.avi';
    hVideoSrc = VideoReader(filename);

    %read(hVideoSrc, 1);
                      
    hVPlayer = vision.VideoPlayer; % Create video viewer

    % Process all frames in the video
    imgA = rgb2gray(im2single(readFrame(hVideoSrc))); % Read first frame into imgA
    movMean = imgA;
    originalsrc(:,:,:,1) = imgA;
    imgB = rgb2gray(im2single(readFrame(hVideoSrc))); % Read second frame into imgB
    imgBp = imgB;
    correctedMean = imgBp;
    
    
    ii = 2;

    Hcumulative = eye(3);
    %returns an n-by-n identity matrix with ones on the main diagonal and zeros elsewhere.
    while hasFrame(hVideoSrc)
        % Read in new frame
        imgA = imgB; % z^-1
        imgAp = imgBp; % z^-1
        imgB = rgb2gray(im2single(readFrame(hVideoSrc)));
        originalsrc(:,:,:,ii) = imgB;
        movMean = movMean + imgB;

        % Estimate transform from frame A to frame B, and fit as an s-R-t
        H = cvexEstStabilizationTform(imgA,imgB);
        HsRt = cvexTformToSRT(H);
        Hcumulative = HsRt * Hcumulative;
    
        %A limitation of the affine transform is that it can only alter the imaging plane. 
        %Thus it is ill-suited to finding the general distortion between two frames 
        %taken of a 3-D scene, such as with this video taken from a moving car.
        imgBp = imwarp(imgB,affine2d(Hcumulative),'OutputView',imref2d(size(imgB)));

        % Display as color composite with last corrected frame
        step(hVPlayer, imfuse(imgAp,imgBp,'ColorChannels','red-cyan'));
        correctedMean = correctedMean + imgBp;
        videoOutput(:,:,:,ii) = imgBp; %add stabilized frame to video output
        ii = ii+1;
    end

    correctedMean = correctedMean/(ii-2);
    movMean = movMean/(ii-2);

    release(hVPlayer);
    watchFrames(originalsrc,videoOutput,strcat(hVideoSrc.name,'_pointFeatureStabilized.mp4'));

    figure; imshowpair(movMean, correctedMean, 'montage');
    title(['Raw input mean', repmat(' ',[1 50]), 'Corrected sequence mean']);
end