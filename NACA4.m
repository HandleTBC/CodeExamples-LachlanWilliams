function NACA4(m,p,t,c,close_TE)
%%% Plots the OML (Outer Mold Lines) of a NACA4 airfoil on a graph and
%%% exports file in Solidworks ready format.
%%% e.g. for NACA 2412
%%%  - Max Camber, m = 0.02
%%%  - Max Camber Position, p = 0.4
%%%  - Max Thickness, t = 0.12
%%% Note: input variables taken as percentage of chord, c
%%% Note: Boolean close_TE modifies NACA equations to close TE if true

%% DECLARING VARIABLES
point_sep = 0.001;

x = 0:point_sep:1;
y_camber_line = zeros(size(x));

x_upper_surface = zeros(size(x));
y_upper_surface = zeros(size(x));

x_lower_surface = zeros(size(x));
y_lower_surface = zeros(size(x));

%% CALC y_symmetric FOR SYMMETRIC AIRFOIL
% NOTE: EQUATIONS VALID FOR AIRFOIL WITH NORMALISED c
if close_TE
    % TRAILING EDGE CAN BE CLOSED FOR SAKE OF COMPUTATION, CAD, ETC.
    symmetric_eq = @(x) 5*t * (0.2969*x.^0.5 - 0.1260*x.^1.0 - 0.3516*x.^2 + 0.2843*x.^3 - 0.1036*x.^4);
    y_symmetric = symmetric_eq(x);
    % FORCE TE TO TRUE ZERO
    y_symmetric(end) = 0;
else
    symmetric_eq = @(x) 5*t * (0.2969*x.^0.5 - 0.1260*x.^1.0 - 0.3516*x.^2 + 0.2843*x.^3 - 0.1015*x.^4);
    y_symmetric = symmetric_eq(x);
end

%% CALC CAMBERED AIRFOIL PROPERTIES
for i = 1:length(x)
    % CALC y_camber_line AND NORMAL ANGLE theta FOR EACH x
    if x(i) <= p
        y_camber_line(i) = (m / (p^2)) * (2*p*x(i) - (x(i)^2));
        theta = atan((2*m/p^2)*(p-x(i)));
    else
        y_camber_line(i) = (m / ((1 - p)^2)) * ((1 - 2*p) + 2*p*x(i) - (x(i)^2));
        theta = atan((2*m / (1-p)^2)*(p-x(i)));
    end
    
    % CALC UPPER AND LOWER SURFACE COORDS
    x_upper_surface(i) = x(i) - y_symmetric(i)*sin(theta);
    y_upper_surface(i) = y_camber_line(i) + y_symmetric(i)*cos(theta);
    
    x_lower_surface(i) = x(i) + y_symmetric(i)*sin(theta);
    y_lower_surface(i) = y_camber_line(i) - y_symmetric(i)*cos(theta);
end

%% RESIZE NORMALISED AIRFOIL FOR c PROVIDED
x = x*c;
y_symmetric = y_symmetric*c;
y_camber_line = y_camber_line*c;
x_upper_surface = x_upper_surface*c;
y_upper_surface = y_upper_surface*c;
x_lower_surface = x_lower_surface*c;
y_lower_surface = y_lower_surface*c;


%% PLOT AIRFOIL DATA
plot(x,y_symmetric,x,-y_symmetric,x,y_camber_line,x_upper_surface,y_upper_surface,x_lower_surface,y_lower_surface);
legend('Symmetric Upper', 'Symmetric lower', 'Camber line', 'NACA4 upper', 'NACA4 lower');
grid on
daspect([1 1 1])
airfoil_name = sprintf('NACA%1i%1i%2i',m*100,p*10,t*100);
title(airfoil_name)
xlabel('Chord (c)')
ylabel('Thickness (t)')

%% SAVE AIRFOIL IN SOLIDWORKS READY FORMAT
% Need to separate upper and lower surfaces so Solidworks doesn't auto-join
% TE in spline.

% DEFINE SOLIDWORKS SPACE SEPARATED FORMAT
formatSpec = '%12.6f %12.6f %12.6f\n';

% WRITE UPPER SURFACE TO FILE
filename = fullfile(pwd,strcat(airfoil_name,'_upper.txt'));
fileID = fopen(filename,'w+');
if fileID < 0
    error('error opening file %s\n',filename);
end

upper_surface = [x_upper_surface; y_upper_surface; zeros(size(x_upper_surface))];
fprintf(fileID,formatSpec,upper_surface);

fclose(fileID);

% WRITE LOWER SURFACE TO FILE
filename = fullfile(pwd,strcat(airfoil_name,'_lower.txt'));
fileID = fopen(filename,'w+');
if fileID < 0
    error('error opening file %s\n',filename);
end

lower_surface = [x_lower_surface; y_lower_surface; zeros(size(x_lower_surface))];
fprintf(fileID,formatSpec,lower_surface);

fclose(fileID);