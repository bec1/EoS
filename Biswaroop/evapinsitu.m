function [clouds,profiles,fitresult,rads] = evapinsitu(images)

crop = [200    60    150   400];

data = loadDataset(images);
clouds = getClouds(data,crop);
profiles = getProfiles(clouds);
%profiles = normalizeProfiles(profiles);

[fitresult,rads] = fitTF(profiles);



end

function [fitresult,rads] = fitTF(profiles)

    for i=1:size(profiles,2)
       profile = profiles(:,i);
       points = 13/9 * (1:length(profile));
        ft = fittype( 'a*max((1-(x-x0)^2 / R^2),0) ^(3/2) +c', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.StartPoint = [65 0.3 0 232];
        [fitresult{i}, ~] = fit( points', profile, ft, opts );
        rads(i) = fitresult{i}.R;
        
        plot(points,profile,'.','DisplayName',num2str(i))
        hold all
        plot(fitresult{i})
    end


end

function profiles = getProfiles(clouds)
    for i=1:size(clouds,3)
        profiles(:,i) = sum(clouds(:,:,i),2);
        profiles(:,i) = profiles(:,i) - mean(profiles(1:10,i));
    end
    
end


function clouds = getClouds(data,crop)
%% Get 1D axial profiles
    for i=1:length(data)
        clouds(:,:,i) = imcrop(data(i).img,crop);
    end

end


function data = loadDataset(img_list)
%% LOAD_DATASET loads the raw images as OD arrays
    % Initialize data struct
    data(1:length(img_list)) = struct('name','','img',[]);
    % Load the images from the filenames
    fprintf('\n');
    for i =1:length(img_list)
        if ~isempty(img_list{i})
            fprintf('.');
            data(i).name = img_list{i};
            data(i).img=loadFitsimage(data(i).name);
        end
    end
    fprintf('\n');
end

function img = loadFitsimage(filename)
 data=fitsread(filename);
    absimg=(data(:,:,2)-data(:,:,3))./(data(:,:,1)-data(:,:,3));

%     % Identify "burned pixels" and make sure they will come out zero.
%     burnedpoints = absimg < 0;
%     absimg(burnedpoints) = 1;
% 
%     % Same thing for points which should be accidentally equal to zero
%     % (withatoms == background) or infinity (withoutatoms == background)
%     zeropoints = absimg == 0;
%     absimg(zeropoints) = 1;
% 
%     infpoints = abs(absimg) == Inf;
%     absimg(infpoints) = 1;
% 
%     nanpoints = isnan(absimg);
%     absimg(nanpoints) = 1;

%replace the pixels with a value of negtive number,0 or inf or nan by the
%average of nearset site.
    ny=size(absimg,1);
    nx=size(absimg,2);
    burnedpoints = absimg <= 0;
    infpoints = abs(absimg) == Inf;
    nanpoints = isnan(absimg);
    Change=or(or(burnedpoints,infpoints),nanpoints);
    NChange=not(Change);
    for i=2:(ny-1)
        for j=2:(nx-1)
            if Change(i,j)
                n=0;
                rp=0;
                if NChange(i-1,j)
                    rp=rp+absimg(i-1,j);
                    n=n+1;
                end
                if NChange(i+1,j)
                    rp=rp+absimg(i+1,j);
                    n=n+1;
                end
                if NChange(i,j-1)
                    rp=rp+absimg(i,j-1);
                    n=n+1;
                end
                if NChange(i,j+1)
                    rp=rp+absimg(i,j+1);
                    n=n+1;
                end
                if (n>0)
                    absimg(i,j)=(rp/n);
                    Change(i,j)=0;
                end
            end
        end
    end
    absimg(Change)=1;
    img = log(absimg);
end