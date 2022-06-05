function rotatetraslateStabilization(filename)

ANGLE_MAX  = 0.3;
ANGLE_STEP = 0.1;

hVideoSrc = VideoReader(filename);
frames_nr = hVideoSrc.NumFrames;

fprintf('PROCESSING %d FRAMES\n', frames_nr);

first_frame = hVideoSrc.readFrame();
[r, c, ~] = size(first_frame);

% Used to pad any frame to such a size that allows rotation without any
% cropping
fillpad = resizeAfterCropp(first_frame);

figure;
[template, template_rect] = imcrop(first_frame);
% `template_rect` is a 4-vector like [x y width height]

template_rect = round(template_rect);

offset_initial = findoffset(padarray(first_frame, fillpad), template);

% `template_padded` will be an image with the same size as the first frame
% but will be all black expect for the regione enclosing theselected template
template_padded = zeros(r, c, 'uint8');
template_padded(...
    template_rect(2): template_rect(2) + size(template, 1) - 1, ...
    template_rect(1): template_rect(1) + size(template, 2) - 1  ...
) = rgb2gray(template);

template_fft = fourier(template_padded);

input(:,:,:,1) = first_frame;

for i = 2:frames_nr
    input(:,:,:,i)= hVideoSrc.readFrame();
end

output(:,:,:,1) = first_frame;
parfor i = 2:frames_nr   
    frame = input(:,:,:,i);
    
    frame_fft = fourier(frame);
    
    best_theta = 0;
    best_corr  = -Inf;
    
    for theta = -ANGLE_MAX:ANGLE_STEP:ANGLE_MAX
        corr = corr2(template_fft, imrotate(frame_fft, theta, 'bilinear', 'crop'));
        if corr > best_corr
            best_theta = theta;
            best_corr  = corr;
        end
    end
    
    fprintf('BEST THETA %.1f\n', best_theta);
    
    frame = padarray(frame, fillpad);
    frame = imrotate(frame, best_theta, 'bilinear', 'crop');
    
    offset = findoffset(frame, template);
    
    % findoffset's return value is [dy dx] (as is normxcorr2) but imtranslate
    % wants a [dx dy] matrix, that's why we need to flip.
    shift = flip(offset_initial - offset);
    frame = imtranslate(frame, shift, 'FillValues', 0);
    
    % Revert the padding
    frame = frame(fillpad(1)+1:fillpad(1)+r, fillpad(2)+1:fillpad(2)+c, :);
    output(:,:,:,i) =frame;
    fprintf('COMPLETED FRAME %d\n', i);    
end

fprintf('WRITING\n');

watchFrames(input,output,strcat(hVideoSrc.name(1:end-4),'_rotateTraslateStabilized'));

fprintf('DONE\n');
end

function [racVector] = resizeAfterCropp(image)
    if ndims(image) == 3
        image = rgb2gray(image);
    end
    [m, n] = size(image);
    % Diagonal length
    d = sqrt(m*m+n*n);
    % How much to pad vertically and horizontally to allow crop-free rotations
    racVector = [round((d-m)/2) round((d-n)/2)];
end

function [transformed] = fourier(image)
% https://it.mathworks.com/help/images/fourier-transform.html
    if ndims(image) == 3
        image = rgb2gray(image);
    end
    F = fftshift(fft2(image));
    transformed = abs(F);
    transformed = log10(1+transformed);
end

function offset = findoffset(image, template)
    if ndims(image) == 3
        image = rgb2gray(image);
    end
    
    if ndims(template) == 3
        template = rgb2gray(template);
    end

    % xcorr contains the cross correlation coefficients
    xcorr = normxcorr2(template, image);
    [~, max_ind] = max(xcorr(:));
    
    % These are basically the coords of the bottom right corner of the
    % template
    [y_peak, x_peak] = ind2sub(size(xcorr), max_ind);
    
    % These are basically the coords of the top left corner of the
    % template. Or "how to translate the template (that starts with its top 
    % left corner matching the one of the frame) to match it to the
    % underlying image"
    offset = [y_peak - size(template,1) x_peak - size(template,2)];
end


