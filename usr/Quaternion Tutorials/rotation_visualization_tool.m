function rotation_visualization_tool
% This program is designed to assist in the visualization of angle
% rotations, direction cosine matrices, and quaternions. 

%==========================================================================
% Written by: 
% Ryan Stillwater
% NASA Dryden Flight Research Center
% Code RC - Dynamics and Controls Branch
% ryan.a.stillwater@nasa.gov
% (661)276-3591
%
% Version History
% Version 1.0
% Version Created: 16 March 2009
% Last Modified: 18 March 2009
%
% Version 1.0.1
% Version Created: 18 March 2009
% Last Modified: 18 March 2009
%
% Corrected a miscalculation in the Euler axis projection.
%
% Version 1.1
% Version Created: 25 March 2009
% Last Modified: 1 April 2009
%
% Corrected Alpha/Beta/Bank from a 3-2-1 rotation to a 2-3-1 rotation with 
% a negative beta angle.
% Corrected the quaternion calculation for special cases.
% Corrected rotations on cloned axes.
%
% Version 1.2
% Version Created: 6 April 2009
% Last Modified: 14 April 2009
%
% General code clean up and separation into subfunctions
% Corrected DCM to quaternion calculation
% Corrected quaternion rotations on cloned axes
% Added menubar back to visualization axes so that the static image can be
% caputred
% Added functionality to export data to workspace
% Added functionality to record animation to avi file
% Updated Euler angle units callback to convert units when changed
%
%==========================================================================

global handler

% Only allow one rotation visualization gui
if isfield(handler,'vis_gui') == 1
    % Change Focus to GUI window
    figure(handler.vis_gui)
else
    % Initialize the GUI window
    figure
    handler.vis_axes = gcf;
    background_gui_color = [0.925490196078431   0.913725490196078   0.847058823529412];   
    axes_position = get(handler.vis_axes,'Position');    
    set(handler.vis_axes,'Position',[axes_position(1)+220 axes_position(2) axes_position(3) axes_position(4)],...
        'Color',background_gui_color,...
        'Name','Rotation Visualization Tool Display');
    
    handler.guiaxes=axes('OuterPosition',[0 0 1 1], ...
        'Position',[-0.18 -0.18 1.36 1.36], ...
        'Visible','off', ...
        'NextPlot','add');
    
    rotate3d on
    
    figure
    handler.vis_gui = gcf;
   
    % Set Initial Conditions
    handler.axes1_orient.eaxis = [1 0 0];
    handler.axes1_orient.eangle = 0;
    handler.axes1_orient.center = [0 1.1 0];
    handler.axes2_orient.eaxis = [1 0 0];
    handler.axes2_orient.eangle = 0;
    handler.axes2_orient.center = [0 -1.1 0];
    
    % Enlarge window to proper size and color
    gui_position = get(handler.vis_gui,'Position');
    set(handler.vis_gui,'Position',[gui_position(1) gui_position(2) 210 430],...
        'Menubar','none', ...
        'Color',background_gui_color,...
        'Name','Rotation Visualization Tool GUI');

    % Ensure that the globals are cleared when the figure is requested to
    % close
    set(handler.vis_gui,'CloseRequestFcn','delete(gcf); clear global')
    
    % Dynamically load GUI controls, axes, and diagrams
    % Title
    handler.title = uicontrol('Style','text',...
        'Position',[10 405 200 20],...
        'HorizontalAlignment','center',...
        'FontSize',10,...
        'FontWeight','bold',...
        'BackgroundColor',background_gui_color,...
        'String','Rotation Visualization Tool 1.2');

    % Create tab strip for GUI controls
    handler.TabStrip = actxcontrol('MSComctlLib.TabStrip.2',[10 237 190 163],gcf,{'Click','rot_vis_tab_change_Callback'});
    hTabCollection = get(handler.TabStrip,'Tabs');
    TabText = {'Euler Angle';'DCM';'Quaternion'};
    hTab = cell(3,1);
    invoke(hTabCollection,'Clear');
    hTab{1} = invoke(hTabCollection,'Add');
    hTab{2} = invoke(hTabCollection,'Add');
    hTab{3} = invoke(hTabCollection,'Add');
    set(hTab{1},'Caption',TabText{1});
    set(hTab{2},'Caption',TabText{2});
    set(hTab{3},'Caption',TabText{3});
    
    % Create Euler angles tab *********************************************
    % Static text and popup menu for Euler angle type
    handler.euler_type_label = uicontrol('Style','text',...
        'Position',[20 348 40 20], ...
        'String','Type', ...
        'HorizontalAlignment','Left');
    
    handler.euler_type_popup = uicontrol('style','popup',...
        'Position',[65 350 120 20], ...
        'String',{'Generic';'Yaw/Pitch/Roll';'Alpha/Beta/Bank'}, ...
        'Value',1,...
        'BackgroundColor',[1 1 1], ...
        'Callback',@euler_angle_type);
    
    % Static Text Labels, Popup Menu Labels, and edit boxes for euler angles
    handler.euler_angle1_text = uicontrol('Style','text',...
        'Position',[20 323 40 20], ...
        'String','', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.euler_angle2_text = uicontrol('Style','text',...
        'Position',[20 298 40 20], ...
        'String','', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.euler_angle3_text = uicontrol('Style','text',...
        'Position',[20 273 40 20], ...
        'String','', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.euler_angle1_popup = uicontrol('Style','popup',...
        'Position',[20 323 40 20], ...
        'String',{'1';'2';'3'}, ...
        'Value',3,...
        'BackgroundColor',[1 1 1],...
        'Callback',@euler_angle_calculation);
    
    handler.euler_angle2_popup = uicontrol('Style','popup',...
        'Position',[20 298 40 20], ...
        'String',{'1';'2';'3'}, ...
        'Value',2,...
        'BackgroundColor',[1 1 1],...
        'Callback',@euler_angle_calculation);
    
    handler.euler_angle3_popup = uicontrol('Style','popup',...
        'Position',[20 273 40 20], ...
        'String',{'1';'2';'3'}, ...
        'Value',1,...
        'BackgroundColor',[1 1 1],...
        'Callback',@euler_angle_calculation);
    
    handler.euler_angle1_edit = uicontrol('Style','edit',...
        'Position',[65 323 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1],...
        'Callback',@euler_angle_calculation);
    
    handler.euler_angle2_edit = uicontrol('Style','edit',...
        'Position',[65 298 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1],...
        'Callback',@euler_angle_calculation);
    
    handler.euler_angle3_edit = uicontrol('Style','edit',...
        'Position',[65 273 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1],...
        'Callback',@euler_angle_calculation);
    
    % Create units popup menu and static text
    handler.units_label = uicontrol('Style','text',...
        'Position',[20 246 40 20], ...
        'String','Units', ...
        'HorizontalAlignment','Left');
    
    handler.units_popup = uicontrol('style','popup',...
        'Position',[65 248 120 20], ...
        'String',{'Degrees';'Radians'}, ...
        'Value',1,...
        'BackgroundColor',[1 1 1], ...
        'Callback',@euler_angle_units);
    
    % Create direction cosine matrix tab **********************************
    % Create Title String
    handler.dcm_title = uicontrol('Style','text',...
        'Position',[20 350 160 20], ...
        'String','Direction Cosine Matrix', ...
        'HorizontalAlignment','Center', ...
        'Visible','off');
    
    % Create edit boxes for matrix
    handler.dcm_a11 = uicontrol('Style','edit',...
        'Position',[20 323 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a12 = uicontrol('Style','edit',...
        'Position',[75 323 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a13 = uicontrol('Style','edit',...
        'Position',[130 323 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a21 = uicontrol('Style','edit',...
        'Position',[20 298 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a22 = uicontrol('Style','edit',...
        'Position',[75 298 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a23 = uicontrol('Style','edit',...
        'Position',[130 298 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a31 = uicontrol('Style','edit',...
        'Position',[20 273 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a32 = uicontrol('Style','edit',...
        'Position',[75 273 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    handler.dcm_a33 = uicontrol('Style','edit',...
        'Position',[130 273 50 20], ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','Left', ...
        'Visible','off', ...
        'Callback',@dcm_calculation);
    
    % Create quaternion tab ***********************************************
    % Create static text and edit boxes for quaternion
    handler.quaternion_s_text = uicontrol('Style','text',...
        'Position',[20 346 40 20], ...
        'String','Scalar', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.quaternion_s_edit = uicontrol('Style','edit',...
        'Position',[65 348 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1], ...
        'Visible','off', ...
        'Callback',@quaternion_calculation);
    
    handler.quaternion_x_text = uicontrol('Style','text',...
        'Position',[20 321 40 20], ...
        'String','X', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.quaternion_x_edit = uicontrol('Style','edit',...
        'Position',[65 323 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1], ...
        'Visible','off', ...
        'Callback',@quaternion_calculation);
    
    handler.quaternion_y_text = uicontrol('Style','text',...
        'Position',[20 296 40 20], ...
        'String','Y', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.quaternion_y_edit = uicontrol('Style','edit',...
        'Position',[65 298 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1], ...
        'Visible','off', ...
        'Callback',@quaternion_calculation);
    
    handler.quaternion_z_text = uicontrol('Style','text',...
        'Position',[20 271 40 20], ...
        'String','Z', ...
        'HorizontalAlignment','Left', ...
        'Visible','off');
    
    handler.quaternion_z_edit = uicontrol('Style','edit',...
        'Position',[65 273 120 20], ...
        'HorizontalAlignment','Left', ...
        'BackgroundColor',[1 1 1], ...
        'Visible','off', ...
        'Callback',@quaternion_calculation);
    
    % Create checkbox for projection of the euler axis
    handler.euler_axis_checkbox = uicontrol('Style','checkbox',...
        'Position',[20 247 160 20], ...
        'HorizontalAlignment','Left', ...
        'String','Project Euler Axis', ...
        'Visible','off', ...
        'Value',0, ...
        'Callback',@project_euler_axis);
    
    % Create universal contols ********************************************
    % Create panel for universal controls
    handler.universal_panel = uipanel('Units','pixels',...
        'Position',[10 10 190 217]);
    
    % Create Rotation button
    handler.rotate_button = uicontrol('Style','pushbutton',...
        'Position',[20 192 80 25],...
        'String','Rotate',...
        'Callback',@rotate_axes2);
    
    % Create Reset Button
    handler.reset_button = uicontrol('Style','pushbutton',...
        'Position',[110 192 80 25],...
        'String','Reset',...
        'Callback',@initialize_axes);
    
    % Create Rotation Speed slider and static text
    handler.rotation_speed_text = uicontrol('Style','text',...
        'Position',[20 162 170 20], ...
        'String','Rotation Speed', ...
        'HorizontalAlignment','center');
    
    handler.rotation_speed_slider=uicontrol('Style','slider', ...
        'Position',[20 150 170 15], ...
        'Max',100, ...
        'Min',-100,...
        'Value',0, ...
        'SliderStep',[0.010 0.025], ...
        'BackgroundColor',[0.5 0.5 0.6]);
    
    handler.slower_text = uicontrol('Style','text',...
        'Position',[20 124 40 20], ...
        'String','Slower', ...
        'HorizontalAlignment','left');
    
    handler.faster_text = uicontrol('Style','text',...
        'Position',[150 124 40 20], ...
        'String','Faster', ...
        'HorizontalAlignment','right');
    
    % Create Export Data Button
    handler.export_data_button = uicontrol('Style','pushbutton',...
        'Position',[20 100 80 25],...
        'String','Export Data',...
        'Callback',@export_data);
    
    % Create Save Movie Button
    handler.save_movie_button = uicontrol('Style','pushbutton',...
        'Position',[110 100 80 25],...
        'String','Save Movie', ...
        'Callback',@save_movie);
    
    % Set initial save movie flag to 0
    handler.save_movie_flag = 0;
    
    % Create Co-locate Origin checkbox
    handler.colocate_origin_checkbox = uicontrol('Style','checkbox',...
        'Position',[20 78 160 20], ...
        'HorizontalAlignment','Left', ...
        'String','Co-locate Axes Origins', ...
        'Value',0, ...
        'Callback',@colocate_origins);
    
    % Create Clone Axis 2 Orientation Button
    handler.clone_button = uicontrol('Style','pushbutton',...
        'Position',[20 50 170 25],...
        'String','Clone Axes 2 to Axes 1',...
        'Callback',@clone_axes);
    
    % Create Start Over Button
    handler.start_over_button = uicontrol('Style','pushbutton',...
        'Position',[20 20 80 25],...
        'String','Start Over',...
        'Callback',@start_over);
    
    % Create Close Button
    handler.close_button = uicontrol('Style','pushbutton',...
        'Position',[110 20 80 25],...
        'String','Close', ...
        'Callback',@close_gui);
    
    % Create Axes objects
    initialize_axes(110,110)
end 

%==========================================================================
% This subfunction changes the labels for the inputs on the Euler Angle Tab
%==========================================================================
function euler_angle_type(hObject,EventData)

global handler

euler_angle_popup_value = get(handler.euler_type_popup,'Value');

switch euler_angle_popup_value
    case 1 % Generic Euler Angle Rotations. Make Popup menus visible
        set(handler.euler_angle1_popup,'Visible','on');
        set(handler.euler_angle2_popup,'Visible','on');
        set(handler.euler_angle3_popup,'Visible','on');
        set(handler.euler_angle1_text,'Visible','off');
        set(handler.euler_angle2_text,'Visible','off');
        set(handler.euler_angle3_text,'Visible','off');
    case 2 % Yaw Pitch Roll. Make Static Text visible and change string
        set(handler.euler_angle1_popup,'Visible','off');
        set(handler.euler_angle2_popup,'Visible','off');
        set(handler.euler_angle3_popup,'Visible','off');
        set(handler.euler_angle1_text,'Visible','on','String','Yaw');
        set(handler.euler_angle2_text,'Visible','on','String','Pitch');
        set(handler.euler_angle3_text,'Visible','on','String','Roll');
    case 3 % Alpha Beta Bank. Make Static Text visible and change string
        set(handler.euler_angle1_popup,'Visible','off');
        set(handler.euler_angle2_popup,'Visible','off');
        set(handler.euler_angle3_popup,'Visible','off');
        set(handler.euler_angle1_text,'Visible','on','String','Alpha');
        set(handler.euler_angle2_text,'Visible','on','String','Beta');
        set(handler.euler_angle3_text,'Visible','on','String','Bank');
end


%==========================================================================
% This subfunction converts the units of the angles in the  Euler Angle Tab
%==========================================================================
function euler_angle_units(hObject,EventData)

global handler

% Determine the type of Euler angle units
units = get(handler.units_popup,'Value');
if units == 1
    conv_factor = 180/pi;
else
    conv_factor = pi/180;
end

% Reset error coloring
set(handler.euler_angle1_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.euler_angle2_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.euler_angle3_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');

% Load in Euler angles
euler1 = get(handler.euler_angle1_edit,'String');
euler2 = get(handler.euler_angle2_edit,'String');
euler3 = get(handler.euler_angle3_edit,'String');

% Check inputs to verify validity
euler = zeros(1,3);

if isempty(euler1) == 1
    set(handler.euler_angle1_edit,'String','0');
else
    euler(1) = str2double(euler1)*conv_factor;
    if isnan(euler(1)) == 1
       set(handler.euler_angle1_edit,'String','0','ForegroundColor',[1 0 0],'FontWeight','bold');
    end
    set(handler.euler_angle1_edit,'String',num2str(euler(1),'%12.11f'));
end

if isempty(euler2) == 1
    set(handler.euler_angle2_edit,'String','0');
else
    euler(2) = str2double(euler2)*conv_factor;
    if isnan(euler(2)) == 1
       set(handler.euler_angle2_edit,'String','0','ForegroundColor',[1 0 0],'FontWeight','bold');
    end
    set(handler.euler_angle2_edit,'String',num2str(euler(2),'%12.11f'));
end

if isempty(euler3) == 1
    set(handler.euler_angle3_edit,'String','0');
else
    euler(3) = str2double(euler3)*conv_factor;
    if isnan(euler(3)) == 1
       euler(3) = 0;
       set(handler.euler_angle3_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
    set(handler.euler_angle3_edit,'String',num2str(euler(3),'%12.11f'));
end

%==========================================================================
% This subfunction checks if the euler axis should be projected or not
%==========================================================================
function project_euler_axis(hObject,EventData)

global handler


euler_axis_setting = get(handler.euler_axis_checkbox,'Value');

if isfield(handler,'euler_axis') && ishandle(handler.euler_axis)
    delete(handler.euler_axis);
    delete(handler.euler_axis_label);
end

if euler_axis_setting == 1
    
    figure(handler.vis_axes)
    % Load in quaternion
    [Qs Qx Qy Qz] = get_quaternion;
    
    % Calculate ending euler angle and euler axis
    eangle=acos(Qs)*2;
    if eangle ~= 0
        % Determine Euler Quaternian Axis
        eaxis=[Qx/sin(eangle/2); Qy/sin(eangle/2); Qz/sin(eangle/2)];
    else
        eaxis=[1 0 0];
    end
    
    % Set up Z axis
    angle = linspace(-pi,pi);
    
    euler_axis.X(:,1) = ones(100,1)*-0.03;
    euler_axis.Y(:,1) = 0.04 * cos(angle);
    euler_axis.Z(:,1) = 0.04 * sin(angle);

    euler_axis.X(:,2) = ones(100,1)*0.83;
    euler_axis.Y(:,2) = 0.04 * cos(angle);
    euler_axis.Z(:,2) = 0.04 * sin(angle);

    euler_axis.X(:,3) = ones(100,1)*0.85;
    euler_axis.Y(:,3) = 0.06 * cos(angle);
    euler_axis.Z(:,3) = 0.06 * sin(angle);

    euler_axis.X(:,4) = ones(100,1);
    euler_axis.Y(:,4) = 0.001 * cos(angle);
    euler_axis.Z(:,4) = 0.001 * sin(angle);

    euler_axis_coloring(:,:,1) = ones(100,4)*0.6;
    euler_axis_coloring(:,:,2) = zeros(100,4);
    euler_axis_coloring(:,:,3) = ones(100,4)*0.6;
    
    euler_axis_coloring(1:10,:,:) = 1;
    euler_axis_coloring(33:43,:,:) = 1;
    euler_axis_coloring(66:76,:,:) = 1;

    handler.euler_axis = surf(handler.guiaxes,euler_axis.X+handler.axes2_orient.center(1),...
        euler_axis.Y+handler.axes2_orient.center(2), ...
        euler_axis.Z+handler.axes2_orient.center(3), euler_axis_coloring);
    
    % Rotate into position
    z_angle = atan2(eaxis(2),eaxis(1))*180/pi;
    x_angle = atan2(eaxis(3),sqrt(eaxis(1)^2+eaxis(2)^2))*180/pi;
    
    rotate(handler.euler_axis,[0 0 1],z_angle,handler.axes2_orient.center);
    rotate(handler.euler_axis,[eaxis(2)/sqrt(eaxis(1)^2+eaxis(2)^2) -eaxis(1)/sqrt(eaxis(1)^2+eaxis(2)^2) 0], ...
        x_angle,handler.axes2_orient.center);
    
    % Label Euler Axis
    handler.euler_axis_label = text(1.1*eaxis(1)+handler.axes2_orient.center(1),...
    1.1*eaxis(2)+handler.axes2_orient.center(2), ...
    1.1*eaxis(3)+handler.axes2_orient.center(3), 'Euler Axis', 'Color',[0.6 0 0.6]);
    
    Ambstr=1.0;
    Spcstr=1.0;
    Difstr=1.0;

    set(handler.euler_axis,'AmbientStrength',Ambstr)
    set(handler.euler_axis,'SpecularStrength',Spcstr)
    set(handler.euler_axis,'DiffuseStrength',Difstr)

    set(handler.euler_axis,...
        'EdgeColor','none',...
        'FaceLighting','phong',...
        'BackFaceLighting','reverselit');
    material metal;
    
    figure(handler.vis_gui)
end


%==========================================================================
% This subfunction initializes the axes objects
%==========================================================================
function initialize_axes(hObject,EventData)

global handler

figure(handler.vis_axes)

cla

Lpos=[3 -10 0];
Ambstr=1.0;
Spcstr=1.0;
Difstr=1.0;

angle = linspace(-pi,pi);

% Set up X axis
X_axis.X(:,1) = ones(100,1)*-0.03;
X_axis.Y(:,1) = 0.04 * sin(angle);
X_axis.Z(:,1) = 0.04 * cos(angle);

X_axis.X(:,2) = ones(100,1)*0.83;
X_axis.Y(:,2) = 0.04 * sin(angle);
X_axis.Z(:,2) = 0.04 * cos(angle);

X_axis.X(:,3) = ones(100,1)*0.85;
X_axis.Y(:,3) = 0.06 * sin(angle);
X_axis.Z(:,3) = 0.06 * cos(angle);

X_axis.X(:,4) = ones(100,1);
X_axis.Y(:,4) = 0.001 * sin(angle);
X_axis.Z(:,4) = 0.001 * cos(angle);

Axis_1_X_coloring(:,:,1) = ones(100,4);
Axis_1_X_coloring(:,:,2) = zeros(100,4);
Axis_1_X_coloring(:,:,3) = ones(100,4)*0.2;

handler.axes1x = surf(handler.guiaxes,X_axis.X+handler.axes1_orient.center(1),...
    X_axis.Y+handler.axes1_orient.center(2), ...
    X_axis.Z+handler.axes1_orient.center(3), Axis_1_X_coloring);

% Set up Y axis
Y_axis.X(:,1) = 0.04 * sin(angle);
Y_axis.Y(:,1) = ones(100,1)*-0.03;
Y_axis.Z(:,1) = 0.04 * cos(angle);

Y_axis.X(:,2) = 0.04 * sin(angle);
Y_axis.Y(:,2) = ones(100,1)*0.83;
Y_axis.Z(:,2) = 0.04 * cos(angle);

Y_axis.X(:,3) = 0.06 * sin(angle);
Y_axis.Y(:,3) = ones(100,1)*0.85;
Y_axis.Z(:,3) = 0.06 * cos(angle);

Y_axis.X(:,4) = 0.001 * sin(angle);
Y_axis.Y(:,4) = ones(100,1);
Y_axis.Z(:,4) = 0.001 * cos(angle);

Axis_1_Y_coloring(:,:,1) = zeros(100,4);
Axis_1_Y_coloring(:,:,2) = ones(100,4)*0.2;
Axis_1_Y_coloring(:,:,3) = ones(100,4);

handler.axes1y = surf(handler.guiaxes,Y_axis.X+handler.axes1_orient.center(1),...
    Y_axis.Y+handler.axes1_orient.center(2), ...
    Y_axis.Z+handler.axes1_orient.center(3), Axis_1_Y_coloring);

% Set up Z axis
Z_axis.X(:,1) = 0.04 * sin(angle);
Z_axis.Y(:,1) = 0.04 * cos(angle);
Z_axis.Z(:,1) = ones(100,1)*-0.03;

Z_axis.X(:,2) = 0.04 * sin(angle);
Z_axis.Y(:,2) = 0.04 * cos(angle);
Z_axis.Z(:,2) = ones(100,1)*0.83;

Z_axis.X(:,3) = 0.06 * sin(angle);
Z_axis.Y(:,3) = 0.06 * cos(angle);
Z_axis.Z(:,3) = ones(100,1)*0.85;

Z_axis.X(:,4) = 0.001 * sin(angle);
Z_axis.Y(:,4) = 0.001 * cos(angle);
Z_axis.Z(:,4) = ones(100,1);

Axis_1_Z_coloring(:,:,1) = ones(100,4)*0.05;
Axis_1_Z_coloring(:,:,2) = ones(100,4)*0.6;
Axis_1_Z_coloring(:,:,3) = zeros(100,4);

handler.axes1z = surf(handler.guiaxes,Z_axis.X+handler.axes1_orient.center(1),...
    Z_axis.Y+handler.axes1_orient.center(2), ...
    Z_axis.Z+handler.axes1_orient.center(3), Axis_1_Z_coloring);

% Plot axes labels
handler.axes1xlabel = text(1.05+handler.axes1_orient.center(1),...
    0+handler.axes1_orient.center(2), ...
    0+handler.axes1_orient.center(3), 'X1', 'Color',[1 0 0.2]);

handler.axes1ylabel = text(0+handler.axes1_orient.center(1),...
    1.05+handler.axes1_orient.center(2), ...
    0+handler.axes1_orient.center(3), 'Y1', 'Color',[0 0.2 1]);

handler.axes1zlabel = text(0+handler.axes1_orient.center(1),...
    0+handler.axes1_orient.center(2), ...
    1.05+handler.axes1_orient.center(3), 'Z1', 'Color',[0.05 0.6 0]);

handler.axes1=[handler.axes1x handler.axes1y handler.axes1z];
light('Position',Lpos)
set(handler.axes1,'AmbientStrength',Ambstr)
set(handler.axes1,'SpecularStrength',Spcstr)
set(handler.axes1,'DiffuseStrength',Difstr)

set(handler.axes1,...
    'EdgeColor','none',...
    'FaceLighting','phong',...
    'BackFaceLighting','reverselit');
material metal;

handler.axes1=[handler.axes1 handler.axes1xlabel handler.axes1ylabel handler.axes1zlabel];
rotate(handler.axes1,handler.axes1_orient.eaxis,handler.axes1_orient.eangle*180/pi,handler.axes1_orient.center); 

% Set up X axis
Axis_2_X_coloring(:,:,1) = ones(100,4);
Axis_2_X_coloring(:,:,2) = zeros(100,4);
Axis_2_X_coloring(:,:,3) = ones(100,4)*0.2;

Axis_2_X_coloring(1:10,:,:) = 1;
Axis_2_X_coloring(33:43,:,:) = 1;
Axis_2_X_coloring(66:76,:,:) = 1;

handler.axes2x = surf(handler.guiaxes,X_axis.X+handler.axes2_orient.center(1), ...
    X_axis.Y+handler.axes2_orient.center(2), ...
    X_axis.Z+handler.axes2_orient.center(3), Axis_2_X_coloring);

% Set up Y axis
Axis_2_Y_coloring(:,:,1) = zeros(100,4);
Axis_2_Y_coloring(:,:,2) = ones(100,4)*0.2;
Axis_2_Y_coloring(:,:,3) = ones(100,4);

Axis_2_Y_coloring(1:10,:,:) = 1;
Axis_2_Y_coloring(33:43,:,:) = 1;
Axis_2_Y_coloring(66:76,:,:) = 1;

handler.axes2y = surf(handler.guiaxes,Y_axis.X+handler.axes2_orient.center(1), ...
    Y_axis.Y+handler.axes2_orient.center(2), ...
    Y_axis.Z+handler.axes2_orient.center(3),Axis_2_Y_coloring);

% Set up Z axis
Axis_2_Z_coloring(:,:,1) = ones(100,4)*0.05;
Axis_2_Z_coloring(:,:,2) = ones(100,4)*0.6;
Axis_2_Z_coloring(:,:,3) = zeros(100,4);

Axis_2_Z_coloring(1:10,:,:) = 1;
Axis_2_Z_coloring(33:43,:,:) = 1;
Axis_2_Z_coloring(66:76,:,:) = 1;

handler.axes2z = surf(handler.guiaxes,Z_axis.X+handler.axes2_orient.center(1), ...
    Z_axis.Y+handler.axes2_orient.center(2), ...
    Z_axis.Z+handler.axes2_orient.center(3),Axis_2_Z_coloring);

% Plot axes labels
handler.axes2xlabel = text(1.05+handler.axes2_orient.center(1),...
    0+handler.axes2_orient.center(2), ...
    0+handler.axes2_orient.center(3), 'X2', 'Color',[1 0 0.2]);

handler.axes2ylabel = text(0+handler.axes2_orient.center(1),...
    1.05+handler.axes2_orient.center(2), ...
    0+handler.axes2_orient.center(3), 'Y2', 'Color',[0 0.2 1]);

handler.axes2zlabel = text(0+handler.axes2_orient.center(1),...
    0+handler.axes2_orient.center(2), ...
    1.05+handler.axes2_orient.center(3), 'Z2', 'Color',[0.05 0.6 0]);

handler.axes2=[handler.axes2x handler.axes2y handler.axes2z];
light('Position',Lpos)
set(handler.axes2,'AmbientStrength',Ambstr)
set(handler.axes2,'SpecularStrength',Spcstr)
set(handler.axes2,'DiffuseStrength',Difstr)

set(handler.axes2,...
    'EdgeColor','none',...
    'FaceLighting','phong',...
    'BackFaceLighting','reverselit');
material metal;

handler.axes2=[handler.axes2 handler.axes2xlabel handler.axes2ylabel handler.axes2zlabel];

rotate(handler.axes2,handler.axes2_orient.eaxis,handler.axes2_orient.eangle*180/pi,handler.axes2_orient.center);

axis equal

max_offset = max(abs(handler.axes2_orient.center));
axis([-1.1-max_offset 1.1+max_offset -1.1-max_offset 1.1+max_offset -1.1-max_offset 1.1+max_offset])

project_euler_axis(hObject,EventData)

figure(handler.vis_axes)

view(50,22)



%==========================================================================
% This subfunction closes the GUI and clears the globals
%==========================================================================
function close_gui(hObject,EventData)

global handler

close(handler.vis_axes)
close(handler.vis_gui)

clear handler


%==========================================================================
% This subfunction resets the axes to initial conditions
%==========================================================================
function start_over(hObject,EventData)

global handler

% Reset Initial Conditions
handler.axes1_orient.eaxis = [1 0 0];
handler.axes1_orient.eangle = 0;
handler.axes1_orient.center = [0 1.1 0];
handler.axes2_orient.eaxis = [1 0 0];
handler.axes2_orient.eangle = 0;
handler.axes2_orient.center = [0 -1.1 0];

initialize_axes(hObject,EventData)

%==========================================================================
% This subfunction colocates the origins of the axes
%==========================================================================
function colocate_origins(hObject,EventData)

global handler

% Check if axes should have co-located origins
colocate_check = get(handler.colocate_origin_checkbox,'Value');
if colocate_check == 1
    handler.axes1_orient.center = [0 0 0];
    handler.axes2_orient.center = [0 0 0];
else
    handler.axes1_orient.center = [0 1.1 0];
    handler.axes2_orient.center = [0 -1.1 0];
end

initialize_axes(hObject,EventData)


%==========================================================================
% This subfunction clones the orientation of axes 2 to axes 1
%==========================================================================
function clone_axes(hObject,EventData)

global handler

% Load in quaternion
[Qs Qx Qy Qz] = get_quaternion;

% Calculate ending euler angle and euler axis
eangle=acos(Qs)*2;
if eangle ~= 0
    % Determine Euler Quaternian Axis
    eaxis=[Qx/sin(eangle/2); Qy/sin(eangle/2); Qz/sin(eangle/2)];
else
    eaxis=[1 0 0];
end
    
% Clone Axes 1 to Axes 2 quaternion and replot
handler.axes1_orient.eaxis = eaxis;
handler.axes1_orient.eangle = eangle;
handler.axes2_orient.eaxis = eaxis;
handler.axes2_orient.eangle = eangle;

initialize_axes(hObject,EventData)

%==========================================================================
% This subfunction rotates axes 2 in animation format
%==========================================================================
function rotate_axes2(hObject,EventData)

global handler

% Reset from the starting point
figure(handler.vis_axes)
[az el] = view;
initialize_axes(hObject,EventData)
view(az,el)

% Load in the axes 1 initial conditions
Qs1 = cos(handler.axes1_orient.eangle/2);
Qx1 = handler.axes1_orient.eaxis(1)*sin(handler.axes1_orient.eangle/2);
Qy1 = handler.axes1_orient.eaxis(2)*sin(handler.axes1_orient.eangle/2);
Qz1 = handler.axes1_orient.eaxis(3)*sin(handler.axes1_orient.eangle/2);

% Calculate the direction cosine matrix
dcm_axes1 = quaternion2dcm(Qs1, Qx1, Qy1, Qz1);

% Check the current tab
tab=get(get(handler.TabStrip,'SelectedItem'),'Index');

% Check the rotation speed requested
speed_val = get(handler.rotation_speed_slider,'Value');

% Determine frames to use
if speed_val >= 0
    max_frames = round(250 - 2.2*speed_val);
else
    max_frames = round(250 - 5*speed_val);
end

% Initialize frame number
frame_store.count = 0;

if tab == 1 % Direction Cosine Matrix so three rotations
    % Load in the Direction Cosine Angles
    [sequence euler] = get_euler_angles;

    % Rotate about each axis by euler angle in animation form
    dcm = dcm_axes1;
    for j = 1:3
        % Calculate axis to rotate around
        eaxis = zeros(3,1);
        eaxis(sequence(j)) = 1;
        eaxis = dcm' * eaxis;
        
        % Calculate angle step and number of frames
        frames = abs(round(euler(j)/(2*pi)*max_frames));
        angle_step = euler(j)/frames;
        
        % Rotate axes 2
        for i = 1:frames
            rotate(handler.axes2,eaxis,angle_step*180/pi,handler.axes2_orient.center);
            pause(0.05)
            % Save Frame for movie if option is selected
            if handler.save_movie_flag == 1
                frame_store.count=frame_store.count+1;
                frame_store.frame(frame_store.count)=getframe(handler.vis_axes);
            end
        end

        % Calculate the direction cosine matrix for next time around
        switch sequence(j)
            case 1 % X rotation
                dcm = [1 0 0; 0 cos(euler(j)) sin(euler(j)); 0 -sin(euler(j)) cos(euler(j))]*dcm;
            case 2 % Y Rotation
                dcm = [cos(euler(j)) 0 -sin(euler(j)); 0 1 0; sin(euler(j)) 0 cos(euler(j))]*dcm;
            case 3 % Z Rotation
                dcm = [cos(euler(j)) sin(euler(j)) 0; -sin(euler(j)) cos(euler(j)) 0; 0 0 1]*dcm;
        end
    end
    
else % One rotation
    
    % Determine if Euler Axis is projected
    euler_axis_setting = get(handler.euler_axis_checkbox,'Value');

    % Load in quaternion
    [Qs Qx Qy Qz] = get_quaternion;
    
    % Calculate ending euler angle and euler axis
    eangle = acos(Qs)*2;
    if eangle ~= 0
        % Determine Euler Quaternian Axis
        eaxis = dcm_axes1 * [Qx/sin(eangle/2); Qy/sin(eangle/2); Qz/sin(eangle/2)];
    else
        eaxis = dcm_axes1 * [1; 0; 0];
    end
    
    % Rotate about euler axis by the euler angle in animation form
    % Calculate angle step and number of frames
    frames = abs(round(eangle/(2*pi)*max_frames));
    angle_step = eangle/frames;

    % Rotate axes 2
    for i = 1:frames
        if euler_axis_setting == 1
            rotate([handler.axes2 handler.euler_axis],eaxis,angle_step*180/pi,handler.axes2_orient.center);
        else
            rotate(handler.axes2,eaxis,angle_step*180/pi,handler.axes2_orient.center);
        end
        pause(0.05)
        % Save Frame for movie if option is selected
        if handler.save_movie_flag == 1
            frame_store.count=frame_store.count+1;
            frame_store.frame(frame_store.count)=getframe(handler.vis_axes);
        end
    end
end

if handler.save_movie_flag == 1
    [infile inpath] = uiputfile('*.avi','Save Movie As');
    inpathfile = [inpath infile];
    movie2avi(frame_store.frame,inpathfile,'FPS',10,'Compression','Cinepak');
    handler.save_movie_flag = 0;
end  % Save movie data if option is selected

%==========================================================================
% This subfunction reads in the Euler angles and calculates the direction
% cosine matrix and quaternion
%==========================================================================
function euler_angle_calculation(hObject,EventData)

global handler

% Load in the Direction Cosine Angles
[sequence euler] = get_euler_angles;

% Calculate the direction cosine matrix
dcm = euler2dcm(sequence, euler);

% Fill in direction cosine matrix into GUI
set(handler.dcm_a11,'String',num2str(dcm(1,1),'%7.6f'));
set(handler.dcm_a12,'String',num2str(dcm(1,2),'%7.6f'));
set(handler.dcm_a13,'String',num2str(dcm(1,3),'%7.6f'));
set(handler.dcm_a21,'String',num2str(dcm(2,1),'%7.6f'));
set(handler.dcm_a22,'String',num2str(dcm(2,2),'%7.6f'));
set(handler.dcm_a23,'String',num2str(dcm(2,3),'%7.6f'));
set(handler.dcm_a31,'String',num2str(dcm(3,1),'%7.6f'));
set(handler.dcm_a32,'String',num2str(dcm(3,2),'%7.6f'));
set(handler.dcm_a33,'String',num2str(dcm(3,3),'%7.6f'));

% Calculate the quaternion for this direction cosine matrix
[Qs Qx Qy Qz] = dcm2quaternion(dcm);

% Fill in the quaternion into the GUI
set(handler.quaternion_s_edit,'String',num2str(Qs,'%12.11f'));
set(handler.quaternion_x_edit,'String',num2str(Qx,'%12.11f'));
set(handler.quaternion_y_edit,'String',num2str(Qy,'%12.11f'));
set(handler.quaternion_z_edit,'String',num2str(Qz,'%12.11f'));

project_euler_axis(hObject,EventData)

%==========================================================================
% This subfunction reads in the direction cosine matrix and calculates the 
% Euler angles and quaternion
%==========================================================================
function dcm_calculation(hObject,EventData)

global handler

% Load in the direction cosine matrix
[dcm] = get_dcm;

% Calculate the quaternion for this direction cosine matrix
[Qs Qx Qy Qz] = dcm2quaternion(dcm);

% Fill in the quaternion into the GUI
set(handler.quaternion_s_edit,'String',num2str(Qs,'%12.11f'));
set(handler.quaternion_x_edit,'String',num2str(Qx,'%12.11f'));
set(handler.quaternion_y_edit,'String',num2str(Qy,'%12.11f'));
set(handler.quaternion_z_edit,'String',num2str(Qz,'%12.11f'));

% Calculate the Euler Angles
[sequence euler] = dcm2euler(dcm);

% Fill in direction cosine matrix into GUI
set(handler.euler_type_popup,'Value',1);
set(handler.euler_angle1_popup,'Value',sequence(1));
set(handler.euler_angle2_popup,'Value',sequence(2));
set(handler.euler_angle3_popup,'Value',sequence(3));
set(handler.euler_angle1_edit,'String',num2str(euler(1),'%12.11f'));
set(handler.euler_angle2_edit,'String',num2str(euler(2),'%12.11f'));
set(handler.euler_angle3_edit,'String',num2str(euler(3),'%12.11f'));

project_euler_axis(hObject,EventData)

%==========================================================================
% This subfunction reads in the quaternion and calculates the 
% Euler angles and direction cosine matrix
%==========================================================================
function quaternion_calculation(hObject,EventData)

global handler

% Load in quaternion
[Qs Qx Qy Qz] = get_quaternion;

% Calculate the direction cosine matrix
dcm = quaternion2dcm(Qs, Qx, Qy, Qz);

% Fill in direction cosine matrix into GUI
set(handler.dcm_a11,'String',num2str(dcm(1,1),'%7.6f'));
set(handler.dcm_a12,'String',num2str(dcm(1,2),'%7.6f'));
set(handler.dcm_a13,'String',num2str(dcm(1,3),'%7.6f'));
set(handler.dcm_a21,'String',num2str(dcm(2,1),'%7.6f'));
set(handler.dcm_a22,'String',num2str(dcm(2,2),'%7.6f'));
set(handler.dcm_a23,'String',num2str(dcm(2,3),'%7.6f'));
set(handler.dcm_a31,'String',num2str(dcm(3,1),'%7.6f'));
set(handler.dcm_a32,'String',num2str(dcm(3,2),'%7.6f'));
set(handler.dcm_a33,'String',num2str(dcm(3,3),'%7.6f'));

% Calculate the Euler Angles
[sequence euler] = dcm2euler(dcm);

% Fill in direction cosine matrix into GUI
set(handler.euler_type_popup,'Value',1);
set(handler.euler_angle1_popup,'Value',sequence(1));
set(handler.euler_angle2_popup,'Value',sequence(2));
set(handler.euler_angle3_popup,'Value',sequence(3));
set(handler.euler_angle1_edit,'String',num2str(euler(1),'%12.11f'));
set(handler.euler_angle2_edit,'String',num2str(euler(2),'%12.11f'));
set(handler.euler_angle3_edit,'String',num2str(euler(3),'%12.11f'));

project_euler_axis(hObject,EventData)

%==========================================================================
% This subfunction accepts a direction cosine matrix and outputs the
% quaternion.
%==========================================================================
function [Qs Qx Qy Qz] = dcm2quaternion(dcm)

% Limit all elements of the DCM to 1 (round off error)
for i = 1:3
    for j = 1:3
        if dcm(i,j) > 1
            dcm(i,j) = 1;
        elseif dcm(i,j) < -1
            dcm(i,j) = -1;
        end
    end
end

% Calculate the quaternion for this direction cosine matrix
Qs = 0.5*sqrt(1+trace(dcm));

% Check if Qs equals 0
if Qs < 0.0001
    if dcm(1,1) == 1 || dcm(2,2) == 1 || dcm(3,3) == 1
        % 180 degree rotation about an already defined axis
        euler_axis_logical = logical([dcm(1,1) dcm(2,2) dcm(3,3)] == 1);
        Qx = euler_axis_logical(1);
        Qy = euler_axis_logical(2);
        Qz = euler_axis_logical(3);
    elseif dcm(2,2)+dcm(3,3) < 0 || dcm(1,1)+dcm(3,3) < 0 || dcm(1,1)+dcm(2,2) < 0
        % Determine the strongest component
        [min_val min_index] = min([dcm(2,2)+dcm(3,3) dcm(1,1)+dcm(3,3) dcm(1,1)+dcm(2,2)]);
        switch min_index
            case 1 % Qx is strongest
                Qx = sqrt((dcm(2,2)+dcm(3,3))/-2);
                Qy = dcm(1,2)/2/Qx;
                Qz = dcm(1,3)/2/Qx;
            case 2 % Qy is strongest
                Qy = sqrt((dcm(1,1)+dcm(3,3))/-2);
                Qx = dcm(1,2)/2/Qy;
                Qz = dcm(2,3)/2/Qy;
            case 3 % Qz is strongest
                Qz = sqrt((dcm(1,1)+dcm(2,2))/-2);
                Qx = dcm(1,3)/2/Qz;
                Qy = dcm(2,3)/2/Qz;
        end
    else
        % Determine largest denominator
        [max_val max_index] = max(abs([dcm(2,3) dcm(1,3) dcm(1,2)]));
        switch max_index
            case 1 % Calculate Qx first
                Qx = sqrt(dcm(1,2)*dcm(1,3)/dcm(2,3)/4);
                Qy = dcm(1,2)/2/Qx;
                Qz = dcm(1,3)/2/Qx;
            case 2 % Calculate Qy first
                Qy = sqrt(dcm(1,2)*dcm(2,3)/dcm(1,3)/4);
                Qx = dcm(1,2)/2/Qy;
                Qz = dcm(2,3)/2/Qy;
            case 3 % Calculate Qz first
                Qz = sqrt(dcm(1,3)*dcm(2,3)/dcm(1,2)/4);
                Qx = dcm(1,3)/2/Qz;
                Qy = dcm(2,3)/2/Qz;
        end

    end
else
    Qx = 0.25/Qs*(dcm(2,3)-dcm(3,2));
    Qy = 0.25/Qs*(dcm(3,1)-dcm(1,3));
    Qz = 0.25/Qs*(dcm(1,2)-dcm(2,1));
end

%==========================================================================
% This subfunction accepts a direction cosine matrix and outputs the
% Euler angles.
%==========================================================================
function [sequence euler] = dcm2euler(dcm)

global handler

% Determine the type of Euler angle units
units = get(handler.units_popup,'Value');
if units == 1
    conv_factor = pi/180;
else
    conv_factor = 1;
end

% Calculate the 3-2-1 Euler Angles
euler = zeros(3,1);
sequence = [3 2 1];

% Limit to +/- 1 to correct roundoff error
for i = 1:3
    for j = 1:3
        if abs(dcm(i,j)) > 1
            dcm(i,j) = sign(dcm(i,j));
        end
    end
end

euler(2) = asin(-dcm(1,3));
if abs(euler(2)) == pi/2
    euler(3) = atan2(dcm(2,1),dcm(2,2));
    euler(1) = 0;
%     % Verify quadrant
%     if dcm(1,2)/sin(euler(3)) < 0
%         euler(2) = pi-euler(2);
%     end

else
    euler(3) = atan2(dcm(2,3),dcm(3,3));
    euler(1) = atan2(dcm(1,2),dcm(1,1));
    % Verify quadrant
%     if dcm(1,2)/sin(euler(3)) < 0
%         euler(2) = pi-euler(2);
%     end
end
euler = euler/conv_factor;

%==========================================================================
% This subfunction reads in the quaternion and performs error checking
%==========================================================================
function [Qs Qx Qy Qz] = get_quaternion

global handler

% Reset error coloring
set(handler.quaternion_s_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.quaternion_x_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.quaternion_y_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.quaternion_z_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');

% Load in quaternion
Qs = get(handler.quaternion_s_edit,'String');
Qx = get(handler.quaternion_x_edit,'String');
Qy = get(handler.quaternion_y_edit,'String');
Qz = get(handler.quaternion_z_edit,'String');

% Check inputs to verify validity
if isempty(Qs) == 1
    Qs = 0;
    set(handler.quaternion_s_edit,'String','0');
else
    Qs = str2double(Qs);
    if isnan(Qs) == 1
        Qs = 0;
        set(handler.quaternion_s_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

if isempty(Qx) == 1
    Qx = 0;
    set(handler.quaternion_x_edit,'String','0');
else
    Qx = str2double(Qx);
    if isnan(Qx) == 1
        Qx = 0;
        set(handler.quaternion_x_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

if isempty(Qy) == 1
    Qy = 0;
    set(handler.quaternion_y_edit,'String','0');
else
    Qy = str2double(Qy);
    if isnan(Qy) == 1
        Qy = 0;
        set(handler.quaternion_y_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

if isempty(Qz) == 1
    Qz = 0;
    set(handler.quaternion_z_edit,'String','0');
else
    Qz = str2double(Qz);
    if isnan(Qz) == 1
        Qz = 0;
        set(handler.quaternion_z_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

%==========================================================================
% This subfunction reads in the Euler angles and performs error checking
%==========================================================================
function [sequence euler] = get_euler_angles

global handler

% Determine the type of Euler angles entered: Generic Rotation,
% Yaw/Pitch/Roll, or Alpha/Beta/Bank and the units
euler_type = get(handler.euler_type_popup,'Value');
units = get(handler.units_popup,'Value');
if units == 1
    conv_factor = pi/180;
else
    conv_factor = 1;
end

% Reset error coloring
set(handler.euler_angle1_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.euler_angle2_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');
set(handler.euler_angle3_edit,'ForegroundColor',[0 0 0],'FontWeight','normal');

% Calculate the direction cosine matrix and quaternion based on the euler
% angle type
switch euler_type
    case 1 % Generic Rotation
        euler1 = get(handler.euler_angle1_edit,'String');
        euler2 = get(handler.euler_angle2_edit,'String');
        euler3 = get(handler.euler_angle3_edit,'String');
        sequence = [get(handler.euler_angle1_popup,'Value') ...
            get(handler.euler_angle2_popup,'Value') ... 
            get(handler.euler_angle3_popup,'Value')];        
    case 2 % Yaw/Pitch/Roll
        euler1 = get(handler.euler_angle1_edit,'String');
        euler2 = get(handler.euler_angle2_edit,'String');
        euler3 = get(handler.euler_angle3_edit,'String');
        sequence = [3 2 1];
    case 3 % Alpha/Beta/Bank
        euler1 = get(handler.euler_angle1_edit,'String');
        euler2 = get(handler.euler_angle2_edit,'String');
                
        % Beta is a negative Y rotation
        euler2 = num2str(-1*str2double(euler2));
        
        euler3 = get(handler.euler_angle3_edit,'String');
        sequence = [2 3 1];
end

% Check inputs to verify validity
euler = zeros(1,3);

if isempty(euler1) == 1
    euler(1) = 0;
    set(handler.euler_angle1_edit,'String','0');
else
    euler(1) = str2double(euler1)*conv_factor;
    if isnan(euler(1)) == 1
       euler(1) = 0;
       set(handler.euler_angle1_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

if isempty(euler2) == 1
    euler(2) = 0;
    set(handler.euler_angle2_edit,'String','0');
else
    euler(2) = str2double(euler2)*conv_factor;
    if isnan(euler(2)) == 1
       euler(2) = 0;
       set(handler.euler_angle2_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

if isempty(euler3) == 1
    euler(3) = 0;
    set(handler.euler_angle3_edit,'String','0');
else
    euler(3) = str2double(euler3)*conv_factor;
    if isnan(euler(3)) == 1
       euler(3) = 0;
       set(handler.euler_angle3_edit,'ForegroundColor',[1 0 0],'FontWeight','bold');
    end
end

%==========================================================================
% This subfunction reads in the DCM and performs error checking
%==========================================================================
function [dcm] = get_dcm

global handler

% Load in the direction cosine matrix
dcm = zeros(3,3);
for i = 1:3
    for j = 1:3
        % Reset error coloring
        eval(['set(handler.dcm_a' num2str(i) num2str(j) ',''ForegroundColor'',[0 0 0],''FontWeight'',''normal'');']);
        
        % Load Data
        eval(['dcmload = get(handler.dcm_a' num2str(i) num2str(j) ',''String'');']);
        
        % Check inputs to verify validity
        if isempty(dcmload) == 1
            dcm(i,j) = 0;
            eval(['set(handler.dcm_a' num2str(i) num2str(j) ',''String'',''0'');']);
        else
            dcm(i,j) = str2double(dcmload);
            if isnan(dcmload) == 1
                dcm(i,j) = 0;
                eval(['set(handler.dcm_a' num2str(i) num2str(j) ',''ForegroundColor'',[1 0 0],''FontWeight'',''bold'');']);
            end
        end
    end
end

%==========================================================================
% This subfunction reads in the Euler angles and outputs the DCM
%==========================================================================
function output_dcm = euler2dcm(sequence, euler)

% Calculate the direction cosine matrix
dcm = zeros(3,3,3);
for i = 1:3
    switch sequence(i)
        case 1 % X rotation
            dcm(:,:,i) = [1 0 0; 0 cos(euler(i)) sin(euler(i)); 0 -sin(euler(i)) cos(euler(i))];
        case 2 % Y Rotation
            dcm(:,:,i) = [cos(euler(i)) 0 -sin(euler(i)); 0 1 0; sin(euler(i)) 0 cos(euler(i))];
        case 3 % Z Rotation
            dcm(:,:,i) = [cos(euler(i)) sin(euler(i)) 0;-sin(euler(i)) cos(euler(i)) 0; 0 0 1];
    end
    
end

output_dcm = dcm(:,:,3)*dcm(:,:,2)*dcm(:,:,1);

%==========================================================================
% This subfunction reads in the quaternion and outputs the DCM
%==========================================================================
function dcm = quaternion2dcm(Qs, Qx, Qy, Qz)

% Calculate the direction cosine matrix
dcm = [Qs^2+Qx^2-Qy^2-Qz^2, 2*(Qx*Qy+Qs*Qz), 2*(Qx*Qz-Qs*Qy);
    2*(Qx*Qy-Qs*Qz), Qs^2-Qx^2+Qy^2-Qz^2, 2*(Qy*Qz+Qs*Qx); 
    2*(Qx*Qz+Qs*Qy), 2*(Qy*Qz-Qs*Qx), Qs^2-Qx^2-Qy^2+Qz^2];

%==========================================================================
% This subfunction rotates axes 2 in animation format
%==========================================================================
function save_movie(hObject,EventData)

global handler

handler.save_movie_flag = 1;

 rotate_axes2(hObject,EventData)


%==========================================================================
% This subfunction rotates axes 2 in animation format
%==========================================================================
function export_data(hObject,EventData)

global handler

% Load in Euler angles and Euler sequence
[sequence euler] = get_euler_angles;

% Determine the type of Euler angle units
units = get(handler.units_popup,'Value');
if units == 1
    % Degrees
    euler = euler*180/pi;
end

% Load in DCM
[dcm] = get_dcm;

% Load in Quaternion
[Qs Qx Qy Qz] = get_quaternion;

quaternion = [Qs; Qx; Qy; Qz];

% Set up export dialog
checkbox_labels = {'Export Euler angle sequence as:'; 'Export Euler angles as:'; 'Export direction cosine matrix as:'; 'Export quaternion as:'};

default_var_names = {'sequence'; 'euler'; 'dcm'; 'quaternion'};

export2wsdlg(checkbox_labels, default_var_names, {sequence; euler; dcm; quaternion}, 'Export Data to Workspace');
