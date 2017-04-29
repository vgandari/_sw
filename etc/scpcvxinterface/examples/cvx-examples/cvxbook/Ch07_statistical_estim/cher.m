function prob = cher( A, b, Sigma );

% Computes Chernoff upper bounds on probability
%
% Computes a bound on the probability that a Gaussian random vector
% N(0,Sigma) satisfies A x <= b, by solving a QP
%

[ m, n ] = size( A );
scp_begin
    scp_variable u( m )
    scp_minimize( b' * u + 0.5 * sum_square( chol( Sigma ) * A' * u ) )
    scp_subject to
        u >= 0;
scp_end
prob = exp( scp_optval );
