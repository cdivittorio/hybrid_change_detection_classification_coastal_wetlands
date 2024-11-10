%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The purpose of this code is to to characterize the changes over the full
% time period of each pixel and create new maps that distinguish between
% temporary and permanent changes and abrupt and gradual
% Courtney Di Vittorio
% Aug 3 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%stack images
%folder with images
cd('G:\My Drive\Research\NASA_OBB_Coastal_Marshes\Personal_Workspace\comparison_3models\ours')

%read in images and stack
for yr = 1982:2021
    tmpfile = ['classMap',num2str(yr),'_projAEA.tif'];
    combImg(:,:,yr-1981) = geotiffread(tmpfile);
end

[~,R] = geotiffread(tmpfile); %georeference for export later

%create empty matrix to store revised maps


%% start with test pixel with data
smoothedImg = NaN(size(combImg,1),size(combImg,2),37);
%number of years for permanent change
permthresh = 3;

for tmpr = 1:size(combImg,1)
    tic
    for tmpc = 1:size(combImg,2)
        
        %make sure values are valid

        %start at 1985
        clear classes classesrelab
        classes(:,1)=combImg(tmpr,tmpc,4:end);
        
        %create change referece array
        clear changeinfo
        changeinfo(1) = 0; %cant have change on 1st yr
        changeinfo(2:length(classes),:) = diff(classes);
        changeinfo(changeinfo ~=0) = 1;
        
        %only relabel if there are changes
        if (sum(changeinfo) > 0) && (sum(abs(classes))>0) %instead of fill values
            %create temp/permanent logic
            clear perminfo
            changeloc = find(changeinfo == 1);
            if changeloc(1) > permthresh %permanent
                perminfo(1:changeloc(1)-1,1) = 1;
            else %temporary
                perminfo(1:changeloc(1)-1,1) = 0;
            end
            for j = 2:length(changeloc)
                if changeloc(j) - changeloc(j-1) >= permthresh %permanent
                     perminfo(length(perminfo)+1:changeloc(j)-1,1) = 1;
                else %temporary
                    perminfo(length(perminfo)+1:changeloc(j)-1,1) = 0;
                end
            end
            %after last change
            if length(classes)-changeloc(end) >= permthresh
                perminfo(length(perminfo)+1:length(classes),1) = 1;
            else 
                perminfo(length(perminfo)+1:length(classes),1) = 0;
            end
            
            %create stable/unstable logic
            stabinfo = zeros(length(classes),1);
            stabinfo(classes < 9) = 1; %stable
            
            %% relabel temporary segments
            
            %first find temp segement start and end points
            tempind = find(perminfo==0);
            if isempty(tempind) == 0
                %make copy and change labels
                classesrelab = classes;
                %number splits between temp segements (with permanent class)
                splitpts = find(diff(tempind) > 0); %end of segments
                numtemps = 1+length(splitpts); 
                %start and end point of segements
                clear tempstarts tempends
                if numtemps >1
                    tempstarts(1) = 1; %have to start at 1
                    for j = 1:numtemps-1
                        tempends(j) = splitpts(j); %end of segment
                        tempstarts(j+1) = splitpts(j)+1; %start of next segment
                    end
                    tempends(j+1) = length(tempind); %end of last segment
                elseif numtemps == 1
                    tempstarts(1) = 1; %have to start at 1
                    tempends(1) = length(tempind); %end of last segment
                end
                for j = 1:numtemps 
                    %find start and end 
                    tempst = tempind(tempstarts(j)); 
                    tempend = tempind(tempends(j));
                    %if not first segement nor last segment
                    if tempst~=1 && tempend~=length(classes)
                        %get perm labels before and after
                        perm1 = classes(tempst-1);
                        perm2 = classes(tempend+1);
                        %if both unstable
                        if perm1 && perm2 > 10
                            %relabel segement as unstable in previous
                            classesrelab(tempst:tempend) = perm1;
                        elseif perm1 > 10 &&  perm2 <9 %later segement stable
                            %relabel as unstable version of class that follows
                            classesrelab(tempst:tempend) = perm2+10;
                        elseif perm2 > 10 && perm1 < 9 %earlier segement is stable
                            %relabel as unstable version of previous class
                            classesrelab(tempst:tempind) = perm1+10;
                        elseif perm1 < 9 && perm2 < 9 %both stable
                            %if two different classes
                            if perm1 ~= perm2
                                %label as unstable version of prev class
                                classesrelab(tempst:tempend) = perm1+10;
                            else %they match - make unstable if change detected
                                classesrelab(tempst:tempend) = perm1+10;
                            end
                        end
                    elseif tempend == length(classes) && tempst ~= 1 %last segement but not full length
                        perm1 = classes(tempst-1);
                        %label as previous segement, but unstable version
                        if perm1 < 9
                            classesrelab(tempst:tempend) = perm1+10;
                        else 
                            classesrelab(tempst:tempend) = perm1;
                        end
                    elseif tempst == 1 && tempend ~= length(classes)% 1s segment but not full segment
                        perm2 = classes(tempend+1);
                        %label as following segement, but unstable version
                        if perm2 < 9
                            classesrelab(tempst:tempend) = perm2+10;
                        else 
                            classesrelab(tempst:tempend) = perm2;
                        end
                    elseif tempst == 1 && tempend == length(classes) %1 long set of temps
                        %label the dominant classification but make sure unstable 
                        classesrelab = ones(length(classes),1).*mode(classes);
                        if classesrelab(1) <10
                            classesrelab = classesrelab+10;
                        end
                    end
                end
                smoothedImg(tmpr,tmpc,:) = classesrelab;
            elseif isempty(tempind)==1
                smoothedImg(tmpr,tmpc,:) = classes;
            end
        elseif (sum(changeinfo) == 0) && (sum(abs(classes)) < 1000) % no changes - keep original
            smoothedImg(tmpr,tmpc,:) = classes;
        end
    end
    toc
end

%% export new maps
%get georeference information
[~,R] = geotiffread('classMap1985_projAEA.tif');
info = geotiffinfo('classMap1985_projAEA.tif');
key = info.GeoTIFFTags.GeoKeyDirectoryTag;
%%
for yr = 1985:2021
    tmpfn = ['classMap',num2str(yr),'_projAEA_smoothed.tif'];
    geotiffwrite(tmpfn,smoothedImg(:,:,yr-1984),R,'GeoKeyDirectoryTag',key)
end