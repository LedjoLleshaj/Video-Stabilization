    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    %   SelectFrames Ritaglia un video di frame in un intervallo di indici e lo  salva.     %
    %                                                                                       %
    %   INPUT                                                                               %
    %   input: Nome del video di frame da tagliare;                                         %
    %   output: Nome del video di frame in cui verrà salvato                                %
    %                     risultato ritagliato;                                             %
    %   from: indice dal quale tagliare (inclusivo);                                        %
    %   to: indice fino al quale tagliare (esclusivo);                                      %
    %   OUTPUT                                                                              %
    %   void(solo frame dentro intervallo indicato)                                         %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function SelectFrames(input, output, from, to)
      
% Check from <= to
if from > to
    return
end
    
% Carico il video di frame con il nome dato
load(input, 'frames')
figure;
    
tt=0;
    
% Scorro i frame e se l'indice è compreso tra from e to, allora memorizzo
% il video e lo mostro. Altrimenti se ho superato to, termino il ciclo.
for t=1:size(frames, 4)
         
     if t>=from && t<to
        tt=tt+1;
        vidFrame(:,:,:,tt) = frames(:,:,:,t);
        imshow(vidFrame(:,:,:,tt)); title(strcat('Frame number: ', num2str(t)));
    elseif t>=to
        break
            
    end
end
    
% Salvo il video di frame con il nome dato
frames = vidFrame;
save(output, 'frames');
    
end
    
    