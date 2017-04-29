function [p n s] = bt212(C)
    
    n = acosd(C(2,2));
%     p = atan2(C(1, 2), C(3, 2))*180/pi;
%     s = atan2(C(2,1), (-C(2,3)))*180/pi;
    
    if C(3,2)/sind(n) > 0 && C(1,2)/sind(n) > 0 % quadrant 1
        p = asind(C(1,2)/sind(n));
    elseif C(3,2)/sind(n) > 0 && C(1,2)/sind(n) == 0
        p = 0;
    elseif C(3,2)/sind(n) == 0 && C(1,2)/sind(n) > 0
        p = 90;
    elseif C(3,2)/sind(n) < 0 && C(1,2)/sind(n) > 0 % quadrant 2
        p = 180 - asind(C(1,2)/sind(n));
    elseif C(3,2)/sind(n) < 0 && C(1,2)/sind(n) == 0
        p = 180;
    elseif C(3,2)/sind(n) < 0 && C(1,2)/sind(n) > 0
        p = 270;
    elseif C(3,2)/sind(n) < 0 && C(1,2)/sind(n) < 0 % quadrant 3
        p = 180 - asind(C(1,2)/sind(n));
    elseif C(3,2)/sind(n) > 0 && C(1,2)/sind(n) < 0 % quadrant 4
        p = asind(C(1,2)/sind(n)) + 360;
    else
        p = 0;
    end
    
    if imag(p) ~= 0
%         error('p imaginary/complex');
        p = 0;
    end
    
    if -C(2,3)/sind(n) > 0 && C(2,1)/sind(n) > 0 % quadrant 1
        s = asind(C(2,1)/sind(n));
    elseif -C(2,3)/sind(n) > 0 && C(1,2)/sind(n) == 0
        s = 0;
    elseif -C(2,3)/sind(n) == 0 && C(1,2)/sind(n) > 0
        s = 90;
    elseif -C(2,3)/sind(n) < 0 && C(2,1)/sind(n) > 0 % quadrant 2
        s = 180 - asind(C(2,1)/sind(n));
    elseif -C(2,3)/sind(n) < 0 && C(1,2)/sind(n) == 0
        s = 180;
    elseif -C(2,3)/sind(n) == 0 && C(2,1)/sind(n) < 0
        s = 270;
    elseif -C(2,3)/sind(n) < 0 && C(2,1)/sind(n) < 0 % quadrant 3
        s = 180 - asind(C(2,1)/sind(n));
    elseif -C(2,3)/sind(n) > 0 && C(2,1)/sind(n) < 0 % quadrant 4
        s = asind(C(2,1)/sind(n)) + 360;
    else
        s = 0;
    end
    
    if imag(s) ~= 0
%         error('s imaginary/complex');
        s = 0;
    end
    
end

% 
% function [p, n, s] = bt212(C)
%     % Returns Body-two 2-1-2 rotation sequence angles in degrees
%     
%     n = acos(C(2, 2));
%     a = C(1, 2)/sin(n);
%     b = C(3, 2)/sin(n);
%     
%     th1s = asin(a);
%     th1c = acos(C(3, 2)/sin(n));
%     
%     th2s = pi - th1s;
%     th2c = 2*pi - th1c;
%     
%     if n == 0
%         p = 0;
%     else
%         if abs(th1s-th1c) < pi/180*0.001
%             p = th1c;
%             th = b;
%         elseif abs(th1s-th2c) < pi/180*0.001
%             p = th2c;
%             th = b;
%         elseif abs(th2s-th1c) < pi/180*0.001
%             p = th1c;
%             th = b;
%         elseif abs(th2s-th2c) < pi/180*0.001
%             p = th2c;
%             th = b;
%         elseif (C(1, 2)/sin(n) == 0 && C(3, 2)/sin(n) == 1)
%             p = 0;
%             th = 0;
%         elseif (C(1, 2)/sin(n) == 0 && C(3, 2)/sin(n) == -1)
%             p = pi;
%             th = 0;
%         elseif (C(1, 2)/sin(n) == 1 && C(3, 2)/sin(n) == 0)
%             p = pi/2;
%             th = 0;
%         elseif (C(1, 2)/sin(n) == -1 && C(3, 2)/sin(n) == 0)
%             p = 3*pi/2;
%             th = 0;
%         else
%             p = 0;
%             th = 0;
%         end
%     end
%     
%     if imag(p) ~= 0
%         error('p imaginary');
%     end
%     
% %     th1s = asin(C(2, 1)/sin(n));
% %     th1c = acos(-C(2, 3)/sin(n));
% % 
% %     th2s = pi - th1s;
% %     th2c = 2*pi - th1c;
% % 
% %     if abs(th1s-th1c) < pi/180*0.001
% %         s = th1c;
% %     elseif abs(th1s-th2c) < pi/180*0.001
% %         s = th2c;
% %     elseif abs(th2s-th1c) < pi/180*0.001
% %         s = th1c;
% %     elseif abs(th2s-th2c) < pi/180
% %         s = th2c;
% %     elseif (C(2, 1)/sin(n) == 0 && -C(2, 3)/sin(n) == 1)
% %         s = 0;
% %     elseif (C(2, 1)/sin(n) == 0 && -C(2, 3)/sin(n) == -1)
% %         s = pi;
% %     elseif (C(2, 1)/sin(n) == 1 && -C(2, 3)/sin(n) == 0)
% %         s = pi/2;
% %     elseif (C(2, 1)/sin(n) == -1 && -C(2, 3)/sin(n) == 0)
% %         s = 3*pi/2;
% %     else
% %         s = 0;
% %     end
% %     
% %     if imag(s) ~= 0
% %         error('s imaginary');
% %     end
%     s = 0;
%     n = n*180/pi;
%     p = p*180/pi;
% %     s = s*180/pi;
% end
% 
