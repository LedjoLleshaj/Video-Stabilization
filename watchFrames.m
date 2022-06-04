    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    %   watchFrames Mostra la video in frames                        %
    %                                                               %
    %  INPUT                                                        %
    %   filename: Nome del file del video di frame;                 %
    %  OUTPUT                                                       %
    %   void                                                        %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function watchFrames(filename,new,extension)
    
    % Carico il video di frame con il nome dato
    load(filename, 'frames');
    [~,~,~,nrOfFrames] = size(frames);

    vidObj = VideoWriter(strcat(filename,extension));
    open(vidObj);
    % Scorro tutto il video e mostro ogni frame con il relativo indice
    figure;
    for i=1:nrOfFrames
        subplot(121); imshow(frames(:,:,:,i));
        subplot(122); imshow(new(:,:,:,i));
        currFrame = getframe(gcf);
        writeVideo(vidObj,currFrame);

    end 
    close(vidObj);
    
end