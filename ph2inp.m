function phasegen(inpFileName, phases, elem, files2load)
   
    inpFile = fopen(inpFileName,'wt');
    uniPhases = unique(phases);
    
    fprintf(inpFile,'** Load mesh\n*INCLUDE, input=%s\n',files2load{1});
    
    %% element sets for phases
    lin = 9;
    fmt = [repmat('%d, ',1,lin-1) '%d\n'];
    fprintf(inpFile,'**\n**\t--- ELEMENT SETS FOR PHASES ---\n');
    for ii = 1:numel(unique(phases))
        fprintf(inpFile,'**\n*Elset, elset=Phase_%d\n',ii);
        elset = elem(phases==uniPhases(ii))';
        fprintf(inpFile,fmt,elset);
        if rem(numel(elset),lin)~=0
            fprintf(inpFile,'\n');
        end
    end
    
    % create sections for phases
    fprintf(inpFile,'**\n**\t--- SECTIONS FOR PHASES ---\n');
    for ii = 1:numel(uniPhases)
        fprintf(inpFile,'**\n**Section for Phase_%d\n*Solid Section, elset=Phase_%d, material=Phase-%d\n',ii,ii,ii);
    end
    
    fprintf(inpFile,['**\n** Load equations for periodic BCs\n' ...
                     '*INCLUDE, input=%s\n' ...  
                     '**\n** Load materials\n' ...
                     '*INCLUDE, input=%s\n' ...
                     '**\n** Load step, BCs and outputs\n' ...
                     '*INCLUDE, input=%s\n'],files2load{2:end});
    fclose(inpFile); 
end

