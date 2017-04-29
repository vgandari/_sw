function rot_vis_tab_change_Callback(varargin)

global handler

tab=get(get(handler.TabStrip,'SelectedItem'),'Index');

switch tab
    case 1 % Euler Angles
        % Make all uicontrols on Euler Angle tab visible
        toggle_euler_angle_tab('on')
        
        % Make all uicontrols on Direction Cosine Matrix tab invisible
        toggle_dcm_tab('off')
        
        % Make all uicontrols on Quaternion tab invisible
        toggle_quaternion_tab('off')
        
    case 2 % Direction Cosine Matrix
        % Make all uicontrols on Euler Angle tab invisible
        toggle_euler_angle_tab('off')
        
        % Make all uicontrols on Direction Cosine Matrix tab visible
        toggle_dcm_tab('on')
        
        % Make all uicontrols on Quaternion tab invisible
        toggle_quaternion_tab('off')
        
    case 3 % Quaternion
        % Make all uicontrols on Euler Angle tab invisible
        toggle_euler_angle_tab('off')  
        
        % Make all uicontrols on Direction Cosine Matrix tab invisible
        toggle_dcm_tab('off')
        
        % Make all uicontrols on Quaternion tab visible
        toggle_quaternion_tab('on')
end

%==========================================================================
% This subfunction toggles the visibility on the Euler Angle Tab
%==========================================================================
function toggle_euler_angle_tab(on_off)

global handler

set(handler.euler_type_label,'Visible',on_off);
set(handler.euler_type_popup,'Visible',on_off);
set(handler.euler_angle1_edit,'Visible',on_off);
set(handler.euler_angle2_edit,'Visible',on_off);
set(handler.euler_angle3_edit,'Visible',on_off);
set(handler.units_label,'Visible',on_off);
set(handler.units_popup,'Visible',on_off);
if strcmp('on',on_off) == 1
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
else
    set(handler.euler_angle1_text,'Visible',on_off);
    set(handler.euler_angle2_text,'Visible',on_off);
    set(handler.euler_angle3_text,'Visible',on_off);
    set(handler.euler_angle1_popup,'Visible',on_off);
    set(handler.euler_angle2_popup,'Visible',on_off);
    set(handler.euler_angle3_popup,'Visible',on_off);
end

%==========================================================================
% This subfunction toggles the visibility on the Direction Cosine Matrix Tab
%==========================================================================
function toggle_dcm_tab(on_off)

global handler

set(handler.dcm_title,'Visible',on_off);
set(handler.dcm_a11,'Visible',on_off);
set(handler.dcm_a12,'Visible',on_off);
set(handler.dcm_a13,'Visible',on_off);
set(handler.dcm_a21,'Visible',on_off);
set(handler.dcm_a22,'Visible',on_off);
set(handler.dcm_a23,'Visible',on_off);
set(handler.dcm_a31,'Visible',on_off);
set(handler.dcm_a32,'Visible',on_off);
set(handler.dcm_a33,'Visible',on_off);

%==========================================================================
% This subfunction toggles the visibility on the Quaternion Tab
%==========================================================================
function toggle_quaternion_tab(on_off)

global handler

set(handler.quaternion_s_text,'Visible',on_off);
set(handler.quaternion_s_edit,'Visible',on_off);
set(handler.quaternion_x_text,'Visible',on_off);
set(handler.quaternion_x_edit,'Visible',on_off);
set(handler.quaternion_y_text,'Visible',on_off);
set(handler.quaternion_y_edit,'Visible',on_off);
set(handler.quaternion_z_text,'Visible',on_off);
set(handler.quaternion_z_edit,'Visible',on_off);
set(handler.euler_axis_checkbox,'Visible',on_off);
