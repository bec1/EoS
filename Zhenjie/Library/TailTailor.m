function nt = TailTailor(n,z,zmin,zmax)
%fit a linear function to the tail of n(z), and suctract that from n(z).
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
end

