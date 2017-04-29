% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SCPCVX: The extended functions for CVX using in SCPCVX interface.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
%   These functions are redifned to adapt to the functions in CVX that can 
%   be used in the SCPCVX interface.
%
%   A number of Matlab's built-in functions have been extended to provide
%   CVX support; for example,
%     abs, exp(*), log (*), max, min, norm, prod, sqrt
%   For a full list, type "help scpcvxinterface/functions".
%
%   berhu             - Reverse Huber penalty function.
%   det_inv           - Determinant of the inverse of an SPD matrix.
%   det_root2n        - 2nth-root of the determinant of an SPD matrix.
%   det_rootn         - nth-root of the determinant of an SPD matrix.
%   entr              - Scalar entropy. (*)
%   geo_mean          - Geometric mean. (*)
%   huber             - Huber penalty function.
%   huber_circ        - Circularly symmetric version of the Huber penalty.
%   huber_pos         - Monotonic Huber-style function.
%   inv_pos           - Reciprocal of a positive quantity.
%   kl_div            - Scalar Kullback-Leibler distance. (*)
%   lambda_max        - Maximum eigenvalue of a symmetric matrix.
%   lambda_min        - Minimum eigenvalue of a symmetric matrix.
%   log_det           - Logarithm of the determinant. (*)
%   log_normcdf       - Logarithm of the normal CDF. (approximation)
%   log_sum_exp       - log(sum(exp(x))). (*)
%   logsumexp_sdp     - SDP-based approximation of log(sum(exp(x))).
%   matrix_frac       - Matrix fractional function.
%   norm_largest      - Sum of the k largest magnitudes of a vector.
%   norm_nuc          - Nuclear norm of a matrix.
%   norms             - Computation of multiple vector norms.
%   norms_largest     - Computation of multiple norm_largest() norms.
%   poly_env          - Convex or concave envelope of a polynomial.
%   polyval_trig      - Evaluate a trigonometric polynomial.
%   pos               - Positive part.
%   pow_p             - Nonnegative branches of the power function.
%   pow_pos           - Convex/concave branches of the power function.
%   pow_abs           - Absolute value raised to a fixed power.
%   quad_form         - Quadratic form.
%   quad_over_lin     - Sum of squares over linear.
%   quad_pos_over_lin - Sum of squares of positives over linear.
%   rel_entr          - Scalar relative entropy. (*)
%   sigma_max         - Maximum singular value.
%   square            - Square.
%   square_abs        - Square of absolute value.
%   square_pos        - Square of positive part.
%   sum_largest       - Sum of the largest k values of a vector.
%   sum_smallest      - Sum of the smallest k elements of a vector.
%   sum_square        - Sum of squares.
%   sum_square_abs    - sum of squares of absolute values.
%   sum_square_pos    - Sum of squares of positive parts.
%   trace_inv         - Trace of the inverse of a PSD matrix.
%   trace_sqrtm       - Trace of the square root of a PSD matrix.
%   vec               - Vectorize.

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++