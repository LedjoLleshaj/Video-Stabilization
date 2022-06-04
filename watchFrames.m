    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    %   watchFrames Mostra la video in frames                        %
    %                                                               %
    %  INPUT                                                        %
    %   filename: Nome del file del video di frame;                 %
    %  OUTPUT                                                       %
    %   void                                                        %
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
    
end