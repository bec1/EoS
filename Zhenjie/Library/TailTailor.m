function nt = TailTailor(n,z,zmin,zmax,varargin)
%fit a linear function to the tail of n(z), and suctract that from n(z).
ifshow=0;
for i=1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case 'ShowPlot'
                ifshow=varargin{i+1};
        end
    end
end

nf=n;zf=z; % get the data points on tail
N=length(zf);
for i=1:N
    if (zf(i)<zmax) && (zf(i)>zmin)
        zf(i)=-1;
        nf(i)=-1;
    end
end
nf(zf==-1)=[];
zf(zf==-1)=[];

p=polyfit(zf,nf,1);
nc=polyval(p,z);
nt=n-nc;

if ifshow
    d=figure();
    subplot(1,2,1);
    scatter(z,n,'r.');
    hold on
    title('Untailored');
    plot(z,nc);
    scatter(zf,nf,'b.')
    hold off
    subplot(1,2,2);
    scatter(z,nt,'r.');
    title('tailored');
end

end

