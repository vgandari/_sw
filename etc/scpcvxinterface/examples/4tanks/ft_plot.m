% ########################################################################
% Function: ft_plot - Plot the graphs of 4-tanks problem.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ########################################################################
function ft_plot( data, timestep )

% Get the controler.
u1 = data.uk(:,1);
u2 = data.uk(:,2);

% Output value
y1 = data.yk(:,1);
y2 = data.yk(:,2);

% Length of controler and state.
nu = length( u1 );
ny = length( y1 );

% Time step.
timestep_u = timestep;
timestep_x = timestep;

% Time horizon.
tu = 0:timestep_u: (nu-1)*timestep_u;
ty = 0:timestep_x: (ny-1)*timestep_x;

% max cordinate
maxt = (nu-1)*timestep_u;
mint = 0;

% Get maximum and minimum value of controler.
maxu = max( [u1; u2] ); 
minu = min( [u1; u2] );

% Get maximum and minimum value of state
maxy1 = max( y1 ); miny1 = min( y1 );
maxy2 = max( y2 ); miny2 = min( y2 );

% ########################################################################
% Plot the controler.

figure1 = figure( 'Color',[1 1 1], 'Name', ...
    'The controller output u(.) and system output y(t) = Cx(t).');

% title('Input u_1(t)', ...
%     'FontWeight','bold', 'FontName','Lucida Sans Typewriter',...
%     'Color',[0.07843 0.1686 0.549]);

subplot_u1 = subplot(2,2, 1,'Parent',figure1,'YGrid','on','XGrid','on');
box('on');
hold('all');

plot_u1 = plot(tu, u1,'Parent',subplot_u1,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0], 'Marker', 'o', 'MarkerSize', 2, ...
    'LineWidth', 1.5, 'Color', [0.07843 0.91686 0.549]);

xlabel('Time [s]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);
ylabel('u_1(t) [Volt]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

axis([mint, maxt+10, minu-1, maxu+ 0.5]);

% title('Input u_2(t)', ...
%     'FontWeight','bold', 'FontName','Lucida Sans Typewriter',...
%     'Color',[0.07843 0.1686 0.549]);

subplot_u2 = subplot(2,2,2,'Parent',figure1,'ZColor',[0.03922 0.1412 0.4157],...
    'YGrid','on',...
    'YColor',[0.03922 0.1412 0.4157],...
    'XGrid','on',...
    'XColor',[0.03922 0.1412 0.4157]);

box('on');
hold('all');
plot_u2 = plot(tu, u2,'Parent',subplot_u2,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0], 'Marker', 'o', 'MarkerSize', 2, ...
    'LineWidth', 1.5, 'Color', [0.07843 0.91686 0.549]);

xlabel('Time [s]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);
ylabel('u_2(t) [Volt]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

axis([mint, maxt+10, minu-1, maxu+ 0.5]);

% Plot output y1 and y2
% title('Output y_1(t)', ...
%     'FontWeight','bold', 'FontName','Lucida Sans Typewriter',...
%     'Color',[0.07843 0.1686 0.549]);

subplot_y1 = subplot(2,2,3,'Parent',figure1,'YGrid','on','XGrid','on');
box('on');
hold('all');

plot_y1 = plot(ty, y1,'Parent',subplot_y1,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 0], 'Marker', 'o', 'MarkerSize', 2, ...
    'LineWidth', 1.5, 'Color', [0.97843 0.1686 0.549]);

xlabel('Time [s]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);
ylabel('y_1(t) [Volt]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

axis([mint, maxt+10, miny1-2, maxy1 + 1]);

% title('Output y_2(t)', ...
%     'FontWeight','bold', 'FontName','Lucida Sans Typewriter',...
%     'Color',[0.07843 0.1686 0.549]);

subplot_y2 = subplot(2,2,4,'Parent',figure1,'ZColor',[0.03922 0.1412 0.4157],...
    'YGrid','on',...
    'YColor',[0.03922 0.1412 0.4157],...
    'XGrid','on',...
    'XColor',[0.03922 0.1412 0.4157]);
box('on');
hold('all');
plot_y2 = plot(ty, y2,'Parent',subplot_y2,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 0], 'Marker', 'o', 'MarkerSize', 2, ...
    'LineWidth', 1.5, 'Color', [0.97843 0.1686 0.549]);

xlabel('Time [s]','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);
ylabel('y_2(t) [Volt]','FontName', ...
       'Lucida Sans Typewriter', 'Color',[0.07843 0.1686 0.549]);

axis([mint, maxt+10, miny2-2, maxy2 + 1]);

% End of this function.
% ########################################################################
% End of the file.
% ########################################################################