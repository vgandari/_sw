% Example 7.2: Maximum entropy distribution
% Section 7.2, Figures 7.2-7.3
% Boyd & Vandenberghe, "Convex Optimization"
% Originally by Lieven Vandenberghe
% Adapted for CVX by Michael Grant 4/11/06
%
% We consider a probability distribution on 100 equidistant points in the
% interval [-1,1]. We impose the following prior assumptions:
%
%    -0.1 <= E(X) <= +0.1
%    +0.5 <= E(X^2) <= +0.6
%    -0.3 <= E(3*X^3-2*X) <= -0.2
%    +0.3 <= Pr(X<0) <= 0.4
%
% Along with the constraints sum(p) == 1, p >= 0, these constraints
% describe a polyhedron of probability distrubtions. In the first figure,
% the distribution that maximizes entropy is computed. In the second
% figure, we compute upper and lower bounds for Prob(X<=a_i) for each
% point -1 <= a_i <= +1 in the distribution, as well as the maximum
% entropy CDF.

%
% Represent the polyhedron as follows:
%     A * p <= b
%     sum( p ) == 1
%     p >= 0
%

n  = 100;
a  = linspace(-1,1,n);
a2 = a .^ 2;
a3 = 3 * ( a.^ 3 ) - 2 * a;
ap = +( a < 0 );
A  = [ a   ; -a  ; a2 ; -a2  ; a3 ; -a3 ; ap ; -ap ];
b  = [ 0.1 ; 0.1 ;0.5 ; -0.5 ; -0.2 ; 0.3 ; 0.4 ; -0.3 ];

%
% Compute the maximum entropy distribution
%

scp_begin expert
    scp_variables pent(n)
    scp_maximize( sum(entr(pent)) )
    scp_subject to
        sum(pent) == 1;
        A * pent <= b;
scp_end

%
% Compute the bounds on Prob(X<=a_i), i=1,...,n
%

%cvxq = cvx_quiet(true);
Ubnds = zeros(1,n);
Lbnds = zeros(1,n);
for t = 1 : n,
    scp_begin quiet
        scp_variable p( n )
        scp_minimize sum( p(1:t) )
        scp_subject to
            p >= 0; 
            sum( p ) == 1;
            A * p <= b;
    scp_end
    Lbnds(t) = scp_optval;
    scp_begin quiet
        scp_variable p( n )
        scp_maximize sum( p(1:t) )
        scp_subject to
            p >= 0; 
            sum( p ) == 1;
            A * p <= b;
    scp_end
    Ubnds(t) = scp_optval;
    disp( sprintf( '%g <= Prob(x<=%g) <= %g', Lbnds(t), a(t), Ubnds(t) ) );
end
%cvx_quiet(cvxq);

%
% Generate the figures
%

figure( 1 )
stairs( a, pent );
xlabel( 'x' );
ylabel( 'PDF( x )' );

figure( 2 )
stairs( a, cumsum( pent ) );
grid on;
hold on
d = stairs(a, Lbnds,'r-');  set(d,'Color',[0 0.5 0]);
d = stairs(a, Ubnds,'r-');  set(d,'Color',[0 0.5 0]);
d = plot([-1,-1], [Lbnds(1), Ubnds(1)],'r-');
set(d,'Color',[0 0.5 0]);
axis([-1.1 1.1 -0.1 1.1]);
xlabel( 'x' );
ylabel( 'CDF( x )' );
hold off
