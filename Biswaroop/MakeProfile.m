function [clouds,profiles] = MakeProfile(images)

crop = [200    100    150   230];

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

function num = loadFitsimage(filename)
    data=fitsread(filename);
    lambda = 671e-9;
    sigma = 3*lambda^2 / (4*pi);
    Nsat = 630;
    pixelsize = (13e-6/9).^2;
    num = AtomNumber(data,pixelsize,sigma, Nsat);
end

function num = AtomNumber( img,pixelsize,sigma, Nsat )
%img: the imgage
%pixelsize, the actual pixel size of the image (on the atoms), the unit
%should be kept same as cross section
%sigma: absorption cross section of the atom
%Nsat: saturation count.
%thres: ignore the pixels that have a photon counts lower than thres
OD=real(-log((img(:,:,1)-img(:,:,3))./(img(:,:,2)-img(:,:,3))));
IC=(img(:,:,2)-img(:,:,1))/Nsat;
if ~exist('thres','var')
    % third parameter does not exist, so default it to something
    thres = 0;
end
num=(OD+IC)*pixelsize/sigma;
woa=img(:,:,2)-img(:,:,3);
 num(num>50)=0;
end

