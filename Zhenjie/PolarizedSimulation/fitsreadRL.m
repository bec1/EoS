function img = fitsreadRL( filename )
%FITSREADRL Summary of this function goes here
%   Detailed explanation goes here
username=getenv('USERNAME');
tempfolder=pwd;

ex=exist(tempfolder,'dir');
if (ex~=7)
    try
        mkdir(tempfolder);
    catch
        msgbox('Cannot find or create the default folder');
        set(handles.OutFolder,'String','C:\');
    end
end

copyfile(filename,[tempfolder,'temp.fits']);
img=fitsread([tempfolder,'temp.fits']);
delete([tempfolder,'temp.fits']);
end

