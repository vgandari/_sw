function [ w, scp_optval ] = fmmc(A)

% Computes fastest mixing Markov chain (FMMC) edge weights
%
% [W,S] = FMMC(A) gives a vector of the fastest mixing Markov chain
% edge weights for a graph described by the incidence matrix A (n x m).
% Here n is the number of nodes and m is the number of edges in the graph;
% each column of A has exactly one +1 and one -1.
%
% The FMMC edge weights are given the SDP:
%
%   minimize    s
%   subject to  -s*I <= I - L - (1/n)11' <= s*I
%               w >= 0,  diag(L) <= 1
%
% where the variables are edge weights w in R^m and s in R.
% Here L is the weighted Laplacian defined by L = A*diag(w)*A'.
% The optimal value is s, and is returned in the second output.
%
% For more details see references:
% "Fastest mixing Markov chain on a graph" by S. Boyd, P. Diaconis, and L. Xiao
% "Convex Optimization of Graph Laplacian Eigenvalues" by S. Boyd
%
% Written for CVX by Almir Mutapcic 08/29/06

[n,m] = size(A);
I = eye(n,n);
J = I - (1/n)*ones(n,n);
scp_begin sdp
    scp_variable w(m,1)   % edge weights
    scp_variable s        % epigraph variable
    scp_variable L(n,n) symmetric
    scp_minimize( s )
    scp_subject to
        L == A * diag(w) * A';
        J - L <= +s * I;
        J - L >= -s * I;
        w >= 0;
        diag(L) <= 1;
scp_end

