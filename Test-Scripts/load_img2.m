function [ output ] = load_img2( file_path, roirect)
%% Copy file to desktop to it contains '('
if ~isempty(strfind(file_path,'('))
    temp_path = fileparts(userpath);
    copyfile(file_path,temp_path,'f');
else
    temp_path = fileparts(file_path);
end
[~,filename,format] = fileparts(file_path); filename = [filename,format]; format = format(2:end);

%% Load .fits image
data=fitsread(fullfile(temp_path,filename));
absimg=(data(:,:,2)-data(:,:,3))./(data(:,:,1)-data(:,:,3));

%% Delete the temporary desktop file
if ~isempty(strfind(file_path,'('))
    delete(fullfile(temp_path,filename));
end

%% Replace "bad" pixels with the average of surrounding
if 1
    ny=size(absimg,1); nx=size(absimg,2);
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
end

absimg = log(absimg) + (data(:,:,2)-data(:,:,1))/(630);

%% Setup bg rect
width = 20;
bgrect = [roirect(1)-width, roirect(2) - width, roirect(3) + 2*width, roirect(4) + 2*width];


%% Get cropped image and correct bg
t1 = imcrop(absimg,roirect);
t2 = imcrop(absimg,bgrect);

bgpixels = bgrect(3) * bgrect(4) - roirect(3) * roirect(4);
bgvalue = ( sum(t2(:)) - sum(t1(:)) ) / bgpixels;

absimg = absimg - bgvalue;
t1 = imcrop(absimg,roirect);
t2 = imcrop(absimg,bgrect);


output = t1;


%% Make disps
% disp(['BGvalue subtracted: ', num2str(bgvalue)]);
% disp(['After subtracting: ', num2str(sum(t2(:)) - sum(t1(:)))]);

% %% figures
% figure; ax = subplot(1,1,1); hold on;
% imshow(absimg); 
% imrect(ax, roirect);
% imrect(ax, bgrect);
% hold off;

end

