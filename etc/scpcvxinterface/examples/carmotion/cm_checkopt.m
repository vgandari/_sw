%**************************************************************************
% Purpose: Check parameters
% -------  
% 
% Date: 27/01/2008
% Quoc Tran Dinh, OPTEC-SCD, ESAT, KULeuven, Belgium.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%**************************************************************************
function opt = cm_checkopt( opt )
        
    % get default parameters.
    defvar = cm_defopt();
    
    % check optional parameters
    opt = checkfield( opt, 'started', defvar );
    opt = checkfield( opt, 'maxiter', defvar );
    opt = checkfield( opt, 'maxLsiter', defvar );
    opt = checkfield( opt, 'TolX', defvar );
    opt = checkfield( opt, 'TolF', defvar );
    opt = checkfield( opt, 'alphamin', defvar );
    opt = checkfield( opt, 'alphamax', defvar );
    opt = checkfield( opt, 'c1par', defvar );
    opt = checkfield( opt, 'beta', defvar );
    opt = checkfield( opt, 'mufactor', defvar );
    opt = checkfield( opt, 'muincrease', defvar );
    opt = checkfield( opt, 'rho', defvar );
    opt = checkfield( opt, 'mu0', defvar );
    opt = checkfield( opt, 'isplot', defvar );
    opt = checkfield( opt, 'isprint', defvar );
    opt = checkfield( opt, 'solver', defvar );
    opt = checkfield( opt, 'verbose', defvar );
    opt = checkfield( opt, 'isvisual', defvar );
    opt = checkfield( opt, 'nsize', defvar );
    opt = checkfield( opt, 'prob', defvar );
    opt = checkfield( opt, 'amin', defvar );
    opt = checkfield( opt, 'amax', defvar );
    opt = checkfield( opt, 'bmin', defvar );
    opt = checkfield( opt, 'bmax', defvar );
    opt = checkfield( opt, 'rhoa', defvar );
    opt = checkfield( opt, 'rhou', defvar );
    opt = checkfield( opt, 'rhoe', defvar );
    
% return
%**************************************************************************
% checkfield function
%**************************************************************************
function opt = checkfield( opt, fieldname, defvar )
    
    fieldvalue = getfield( defvar, fieldname );
    
    if isfield( opt, fieldname )
        optfieldval = getfield( opt, fieldname );
        if isempty( optfieldval )
            opt = setfield( opt, fieldname, fieldvalue );
        end;
    else
        opt = setfield( opt, fieldname, fieldvalue );
    end;
%**************************************************************************
% End of this file
%**************************************************************************
