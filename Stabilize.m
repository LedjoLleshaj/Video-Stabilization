% Video stabilizzazione
clear all
close all
load frames; 
[nr,nc,ns,nt] = size(frames);
Res = 0.5; 

% Eseguo per tutti i frame una operazione di resize utilizzando il valore
% di scala Res sopra definito e salvo in una nuova variabile temporanea, sempre 4D, che
% chiameremo sub
for i = 1:nt
    sub(:,:,:,i) = imresize(frames(:,:,:,i),Res);
end

frames = sub;
clear sub;
[nR,nC,nS,nT] = size(frames);

% Eseguo operazione di crop nel frame n.10 per trovare una zona di ancoraggio e salvo il risultato in una
% variabile chiamata template. Converto template in scala di grigi 
figure; template = imcrop(frames(:,:,:,10));
template = rgb2gray(template);
[A,B] = size(template);

figure;
for i=1:nT
    % Prendo il frame e lo salvo in una variabile temporanea comp, che
    % converto poi in scala di grigi (compg)
    comp  = frames(:,:,:,i);
    compg = rgb2gray(comp);
    
    % Eseguo la cross-correlazione normalizzata tra questa e il template.
    % Individuo il punto di massima cross-correlazione e relativo offset
    % (corr_offset)
    cc = normxcorr2(template,compg);
    [max_cc, imax] = max((cc(:)));
    [ypeak, xpeak] = ind2sub(size(cc),imax(1));
    corr_offset = [(ypeak-A+1) (xpeak-B+1)];
   
    % Capire cosa viene eseguito in queste righe
    offset = [-(corr_offset(2)-round(nC/2)-1) -(corr_offset(1)-round(nR/2)-1)];
    new(:,:,:,i) = imtranslate(frames(:,:,:,i),offset,'FillValues',0);
    ccs(:,:,i) = cc;
    
    % Ad ogni ciclo, quindi per ogni frame, definire quattro subplot e visualizzare:
    % 1. template, 2. compg, 3. ccs con evidenziata in sovrapposizione la posizione del picco,
    % 4. new
    subplot(221); imagesc(template); axis image; title('Template scelto');
    subplot(222); imagesc(compg); axis image;  title(strcat('Immagine originale: ', num2str(i)));
    subplot(223); imagesc(ccs(:,:,i)); colorbar; title('Mappa di cross-correlazione 2D');
    hold on;      scatter(xpeak, ypeak,'rX');
    subplot(224); imshow(new(:,:,:,i)); title('Immagine stabilizzata');
    disp (['Frame numero ', num2str(i)])
    pause(0.1)
end
%%
% Codice che mi permette di visualizzare affiancati il video originale e
% quello stabilizzato, e infine di salvare in un .mp4 il risultato
vidObj = VideoWriter('Stabilized_video.mp4');
open(vidObj);
figure;
for i=1:nT
    subplot(121); imshow(frames(:,:,:,i));
    subplot(122); imshow(new(:,:,:,i));
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);

end 
close(vidObj);