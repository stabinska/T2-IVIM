function [ Sequenzen ] = DicomDatenLaden( folderraw )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% folderraw: Angabe des letzten Ordners, in dem viele Subordner sind
% Beispiel: folderraw =
% 'C:\Users\LutzAn\UserData\BETTINA\TEST\BS167\DICOM\0000A628\AAC90853\AA80BB63';

Sequenzen = changenames(folderraw);

end

function [Sequenzen] = changenames(dirName)
    % Matlab-Routine zum Umbenennen von Bilddaten-Ordnern nach dem DICOM-Export
    % aus PACS
    % neuer Ordner-Suffix: Sequenz-Beschreibung
    % Header-Info: Series Description
    % Header-Adresse: 0008-103E

    % function changeDirNames(dirName) % Funktionsname mit Ordnername als Funktionsvariable

    %dirName = uigetdir('C:\');
    dirResult = dir(dirName); % Lesen der Pfadinformationen
    allDirs = dirResult([dirResult.isdir]); % Auswahl der Unterordner
    allSubDirs = allDirs(3:end); % Aussortieren der Ordnerbefehle '.' und '..'   
    counter = 0;

    for i = 1:length(allSubDirs) % Schleifenlänge gleich Anzahl der Unterordner
        counter = counter +1;
        if counter == 9
            stop = 1;
        end
        thisDir = allSubDirs(i); % Aufruf des i-ten Ordners
        thisDirName = thisDir.name; % Aufruf des zugehörigen Ordnernamens
        d = fullfile(dirName,thisDirName, '*.dcm');
        dcmDirResult = dir(fullfile(dirName,thisDirName)); % Einlesen der DICOM-Dateien
        [a,b] = size(dcmDirResult);
        if a >= 3
        for n = 3:a
            dcmFile = dcmDirResult(n).name; % Lesen des ersten Dateinamens
            fullfile(dirName,thisDirName,dcmFile);
            dcmInfo = dicominfo(fullfile(dirName,thisDirName,dcmFile)); % Auslesen des zugehörigen Headers
            SerDescr = dcmInfo.SeriesDescription; % Auslesen des Sequenznamens
             SerInst = dcmInfo.SeriesInstanceUID;
             SerInst_I = min(strfind(SerInst,'.0.0'));
             SerInst = SerInst((SerInst_I-5):(SerInst_I-1));

            sn = isfield(dcmInfo, 'SequenceName');
            
            if sn == 1
                SeqName = dcmInfo.SequenceName;
            else
                SeqName = 'WIP';
            end

       
            Star_index = strfind(SeqName,'*');
            if  Star_index == 1
                SeqName = erase(SeqName, '*');
            end
       
            GradDir_index = strfind(SeqName, '#');
        
        if (isempty(GradDir_index) == 0) && (isempty(Star_index) == 1)
            GradDir = str2num(SeqName(GradDir_index + 1:end));
            SeqName = SeqName(1:GradDir_index-1);
        elseif (isempty(GradDir_index) == 0) && (isempty(Star_index) == 0)
            GradDir = str2num(SeqName(GradDir_index + 1:end));
            SeqName = SeqName(1:GradDir_index-1);
        elseif (sn == 1) && (isempty(GradDir_index) == 1) && (isempty(Star_index) == 1) 
            GradDir = '';
            SeqName = 'WIP_b0';
        elseif(sn == 1) && (isempty(GradDir_index) == 1) && (isempty(Star_index) == 0)
            GradDir = '';
            SeqName = 'ep_b0';
        else
            GradDir = '';
            SeqName = 'WIP_b0';
        end
            
            tf = isfield(dcmInfo,'AcquisitionNumber');
            if tf == 1
                AcqNr = dcmInfo.AcquisitionNumber;
            else
                AcqNr = 0;
             end
%             bfield = isfield(dcmInfo, 'Private_0019_100c');
%             
%             if bfield == 1
%                bval = dcmInfo.Private_0019_100c;
%             else
%                 bval = -1;
%             end
            
             InsNr = dcmInfo.InstanceNumber;
             SerDescr=strrep(SerDescr,':','');
             SerDescr = [SerDescr '_' SerInst];
             
            oldname = fullfile(dirName,thisDir.name); % Struktur des alten Ordnernamens
            ImType = dcmInfo.ImageType;
            old_filename = [oldname,'\',dcmFile];
            nname = [dirName '\' SerDescr '_b' num2str(bval) '_ins_' num2str(InsNr) '_acq_' num2str(AcqNr)];
          %nname = [dirName '\' SerDescr '_' SeqName '_ins_' num2str(InsNr) '_acq_' num2str(AcqNr)];
  % nname = [dirName '\' SerDescr '_' SeqName '_' num2str(GradDir) '_' num2str(AcqNr) '_' num2str(InsNr)];
  % nname = [dirName '\' SerDescr '_' SeqName '_' num2str(GradDir) '_' num2str(AcqNr) '_' num2str(InsNr) '_' SerInst '.dcm'];
   
            if strcmp(oldname, nname) == 0
                copyfile(old_filename, nname);
            end                           
        end
        end
        
    end
    
    for i = 1:length(allSubDirs)
        thisDir = allSubDirs(i); % Aufruf des i-ten Ordners
        thisDirName = thisDir.name; % Aufruf des zugehörigen Ordnernamens
        %folderumbenennen = [dirName,'\',thisDirName];
        dcmDirResult = dir(fullfile(dirName,thisDirName));
        dcmFile = dcmDirResult(3).name;
        
            fullfile(dirName,thisDirName,dcmFile);
            dcmInfo = dicominfo(fullfile(dirName,thisDirName,dcmFile)); % Auslesen des zugehörigen Headers
            SerDescr = dcmInfo.SeriesDescription; % Auslesen des Sequenznamens    
            SerDescr=strrep(SerDescr,':','');
            
            SerInst = dcmInfo.SeriesInstanceUID;
            SerInst_I = min(strfind(SerInst,'.0.0'));
            SerInst = SerInst((SerInst_I-5):(SerInst_I-1));   
            SerDescr = [SerDescr '_' SerInst];
            
            
            oldname = fullfile(dirName,thisDir.name); % Struktur des alten Ordnernamens
            newname = fullfile(dirName,SerDescr);
            
            if strcmp(oldname,newname) == 0
                rmdir(oldname,'s');
                mkdir(newname);
            end      
    end
    
    dcmDirResult = dir(fullfile(dirName)); % Einlesen der DICOM-Dateien
    
        [a,b] = size(dcmDirResult);
        counter_ordner = 0;
        if a >= 3
            for n = 3:a
                if dcmDirResult(n).isdir == 0
                    dcmFile = dcmDirResult(n).name;
                    sfind = strfind(dcmFile,'_WIP');
                    if isempty(sfind) == 1
                        sfind = strfind(dcmFile, '_ep_');
                    end
                    FNAME = dcmFile(1:sfind(1)-1);
                    FFILE = fullfile(dirName,dcmFile)
                    FNFILE = fullfile(dirName,FNAME,dcmFile)
                    movefile(FFILE,FNFILE);
                else
                    counter_ordner  = counter_ordner +1;
                    OrdnerName = dcmDirResult(n).name;
                    Sequenzen{counter_ordner,1} = OrdnerName;
                    
                end
            end
        end
        
    
end

  
