% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: penupd - this function update the penalty parameters 
% which guarantees muk > |lambda|.
% Date: 18/06/2009
% Created by: Quoc Tran Dinh - ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [muk, dphi0] = penupd( lambda, oldmuk, df0, gval, wspars, trymore )

% if only one dimension then update for the same muk.
if size( oldmuk ) == [1, 1]
    
    maxlb = max( abs( lambda ) );
    if oldmuk < maxlb, muk = maxlb + 2*wspars.PenaltyIncrease;
    else muk = oldmuk; end;
    dphi0 = df0 - muk*sum( abs( gval ) );
    
else
    
    if size( oldmuk ) ~= size( lambda )
        error( 'ERROR: The size of "lambda" differs from the size of muk!' );
    else
        abslb = abs( lambda );
        %ltindex = (oldmuk < abslb ); geindex = (oldmuk >= abslb );
        %muk = oldmuk.*geindex + (abslb + 2*wspars.PenaltyIncrease).*ltindex;
        muk = max( abslb, 0.5*( abslb + oldmuk ) );
        dphi0 = df0 - sum( muk.*abs( gval ) );
    end
    
    if trymore
        % try to find a good "muk" such that "dphi0" is a descent direction
        absgval = abs( gval );
        dphi0 = df0 - sum( muk.*absgval );
        infdphi0 = -1e2;
        supdphi0 = -1e-2;
        maxiter = 20;
        dscale = 0.5; iscale = 10;

        % if dphi0 is too small, increase it
        iter = 0;
        while dphi0 < infdphi0,
            muk = dscale*muk;
            dphi0 = df0 - sum( muk.*absgval );
            iter = iter + 1;
            if iter > maxiter, break; end
        end

        % if dphi0 is positive, decrease it
        iter = 0;
        while dphi0 > supdphi0
            muk = iscale*muk;
            dphi0 = df0 - sum( muk.*absgval );
            iter = iter + 1;
            if iter > maxiter, break; end
        end
    end
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++