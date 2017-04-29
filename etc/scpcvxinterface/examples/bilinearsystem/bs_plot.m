% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: bs_plot - This function create the figure for our problems.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function bs_plot( X1, YMatrix1, X2, YMatrix2 )

% create figure
figure1 = figure( 'Color',[1 1 1], ...
    'Name', 'System outputs y(.) = Cx(.) and controller outputs u(.). ');

% create subplot
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on');
hold('all');

% create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',subplot1,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[0 0 0], 'Marker', 'o', 'LineWidth', 2, 'Color', ...
    [0.07843 0.1686 0.549]);


% create title
title('System outputs y(.) = Cx(.)','FontWeight','bold',...
    'FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

% create xlabel
xlabel('Prediction horizon Hs','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

% create ylabel
ylabel('System outputs y(.)','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

% create subplot
subplot2 = subplot(2,1,2,'Parent',figure1,'ZColor',[0.03922 0.1412 0.4157],...
    'YGrid','on',...
    'YColor',[0.03922 0.1412 0.4157],...
    'XGrid','on',...
    'XColor',[0.03922 0.1412 0.4157]);

hold('all');

% create multiple lines using matrix input to plot
plot2 = plot(X2, YMatrix2,'Parent',subplot2,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[0 0 0], 'Marker', 'o', 'LineWidth', 2, 'Color', ...
    [0.07843 0.1686 0.549]);


% create title
title('Controller outputs u(.)','FontWeight','bold',...
    'FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

% create xlabel
xlabel('Move horizon Hc','FontName','Lucida Sans Typewriter',...
    'Color',[0.07843 0.1686 0.549]);

% create ylabel
ylabel('Controller outputs u(.)','Color',[0.07843 0.1686 0.549]);

% end of the function.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++