function hh = errorbar1derr_Z( x,y,yerr,varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
LineStyle='-';
Marker='.';
Color='r';
ErrBarColor=Color;
Markersize=5;
MarkerFaceColor='r';
ErrLineWidth=0.5;
MarkerEdgeColor='r';
for i =1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case 'LineStyle'
                LineStyle=varargin{i+1};
            case 'Color'
                Color=varargin{i+1};
            case 'Markersize'
                Markersize=varargin{i+1};
            case 'MarkerFaceColor'
                MarkerFaceColor=varargin{i+1};
            case 'Marker'
                Marker=varargin{i+1};
            case 'ErrLineWidth'
                ErrLineWidth=varargin{i+1};
            case 'MarkerEdgeColor'
                MarkerEdgeColor=varargin{i+1};
            case 'ErrBarColor'
                ErrBarColor=varargin{i+1};
        end
    end
end


for i=1:length(y)
    line([x(i),x(i)],[y(i)-yerr(i),y(i)+yerr(i)],'Color',ErrBarColor,'Linewidth',ErrLineWidth);
end
hold on
hh=plot(x,y,'LineStyle',LineStyle,'color',Color,'MarkerFaceColor',MarkerFaceColor,'Marker',Marker,...
    'Markersize',Markersize,'MarkerEdgeColor',MarkerEdgeColor);

hold off



end
