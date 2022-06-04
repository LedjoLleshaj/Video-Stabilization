    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    %   watchFrames Mostra la video in frames                       %
    %                                                               %
    %  INPUT                                                        %
    %   filename: frames of the original video;                     %
    %        new: frames of the stabilized video;                   %
    %       name: name of the video to be created;                  %
    %  OUTPUT                                                       %
    %   void  (the video created in the current directory)                                                      %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function watchFrames(filename,new,name)
    
    % Carico il video di frame con il nome dato
    %load(filename, 'frames');
    [~,~,~,nrOfFrames] = size(filename);

    vidObj = VideoWriter(name);
    open(vidObj);
    % Scorro tutto il video e mostro ogni frame con il relativo indice
    figure;
    for i=1:nrOfFrames
        subplot(121); imshow(filename(:,:,:,i));
        subplot(122); imshow(new(:,:,:,i));
        currFrame = getframe(gcf);
        writeVideo(vidObj,currFrame);

    end 
    close(vidObj);
    fprintf("Video created\n")
end