function filename = imgAvg(images,varargin)
%% IMGAVG lets you average absorption images. 
% Inputs: images: cell array  of images
%         outdir (optional): output directory for averaged image.
% Output: writes an averaged image (pwa, pwoa, dark averaged independently)

%% Read files

[pathnm,filename_raw,ext] = fileparts(images{1});

switch nargin
    case 1
        output_dir = fileparts(pathnm);
    case 2
        output_dir = varargin{1};
end

num_img = length(images);
if(num_img <2)
    msgbox('Wake up')
end

raw_img = fitsread(images{1});
pwa_sum = raw_img(:,:,1);
pwoa_sum = raw_img(:,:,2);
dark_sum = raw_img(:,:,3);

for i=2:num_img
    raw_img = fitsread(images{i});
    pwa_sum = pwa_sum + raw_img(:,:,1);
    pwoa_sum = pwoa_sum + raw_img(:,:,2);
    dark_sum = dark_sum + raw_img(:,:,3);
end

img_avg(:,:,1) = pwa_sum/num_img;
img_avg(:,:,2) = pwoa_sum/num_img;
img_avg(:,:,3) = dark_sum/num_img;

filename = strcat(output_dir,'\side\',filename_raw,'_avg',ext);
fitswrite(img_avg,filename);


end


