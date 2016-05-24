function Xc = CMass1d( vector,X )
%get the center of mass of the vector
X(isnan(vector))=[];
vector(isnan(vector))=[];

X(vector==inf)=[];
vector(vector==inf)=[];

X(vector==-inf)=[];
vector(vector==-inf)=[];

Xc=sum(X.*vector)/sum(vector);
end

