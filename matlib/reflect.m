function w = reflect(x, u)
% computes vector w normal to the plane of reflection where x is reflected
% about the plane to a vector u
% vectors x and u must be linearly independent
% u must be a unit vector

v = sign(x(1))*norm(x);
w = (x + v*u);
w = w/norm(w);
