stop = 1;

global theta
theta = [60 0.5 40 6 4e4];
[t1,x1] = ode45(@mae283b_hw_p1, [0 stop], [0 10]);
theta(4) = 1.2*theta(4);
[t2,x2] = ode45(@mae283b_hw_p1, [0 stop], [0 10]);
theta(5) = 1.2*theta(5);
[t3,x3] = ode45(@mae283b_hw_p1, [0 stop], [0 10]);
theta(4) = 0.8*theta(4);
[t4,x4] = ode45(@mae283b_hw_p1, [0 stop], [0 10]);
theta(5) = 0.8*theta(5);
[t5,x5] = ode45(@mae283b_hw_p1, [0 stop], [0 10]);

plot(t1,x1(:,1),t1,x1(:,2),...
  t2,x2(:,1),t2,x2(:,2),...
  t3,x3(:,1),t3,x3(:,2),...
  t4,x4(:,1),t4,x4(:,2),...
  t5,x5(:,1),t5,x5(:,2))

plot(t1,x1(:,2),...
  t2,x2(:,2),...
  t3,x3(:,2),...
  t4,x4(:,2),...
  t5,x5(:,2))

legend('\theta_4+20\%', '\theta_5+20\%', '\theta_4-20\%', '\theta_5-20\%')

rSqLim = theta(3)^2*theta(5)/(4*theta(1)*theta(2)*theta(4));

% plot(t, rSqLim - x(2)^2)