% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_set_ws - set the value to the workspace options
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function retopt = scp_set_ws( varargin )

% if no input the get default options
dopt = defwsopt;
if nargin == 0, retopt = dopt; return; end

% run global variable declaration procedure.
if ~exist( 'scp_cvx___' ), evalin( 'caller', 'scp_pdata' ); end

% check option field
global scp_cvx___;
if isfield( scp_cvx___ , 'options' )
    if isempty( scp_cvx___.options )
        scp_cvx___.options = dopt; 
    end
else
    scp_cvx___.options = dopt;
end

% check "option".
scp_cvx___.options = chkwsopt( scp_cvx___.options );

% get back the options
dopt = scp_cvx___.options;

% get the option fields
[ fieldname, fieldtype, fieldrange ] = optionfields;
noptfield = length( fieldname );

% scan all inputs
for k=1:2:nargin-1
    name  = varargin{k};
    value = varargin{k+1};
    if ~ischar( name ), 
        error( '[SCP] Name of the field is a string!' );
    end
    for kk=1:noptfield
        if strcmp( lower( fieldname{kk} ) , lower( name ) )
            dopt.(fieldname{kk}) = chkfrange( dopt.(fieldname{kk}), ...
                  value, fieldtype{kk}, fieldrange{kk} );
        end
    end
end

% change the option of CVX solver.
if dopt.TolF < eps^0.5 || dopt.TolX < eps^0.5 || dopt.TolCon < eps^0.5
    dopt.cvxPrecision = 'high';
end
if dopt.TolF < eps^0.75 || dopt.TolX < eps^0.75 || dopt.TolCon < eps^0.75
    dopt.cvxPrecision = 'best';
end

% return the option.
scp_cvx___.options = dopt;
if nargout > 0
    retopt = dopt;
end

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Function: chkfrange - check field type and range
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function opt = chkfrange( opt, value, ftype, frange )

switch( ftype )
    case 'integer',
        if ~isnumeric( value )
            warning( strcat( '[SCP] The value is not numerical!', ... 
                             'It automatically gets default value!' ) );
        else
            if value ~= floor(value)
                warning( strcat( '[SCP] The value is real numerical!',...
                                 'It is automatically rounded!' ) );
                value = floor( value );
            end
            if value >= frange(1) && value <= frange(2)
                opt = value;
            else
                warning( ['[SCP] The value is out of the range!'] );
            end
        end
    case 'real',
        if ~isnumeric( value )
           warning( strcat( '[SCP] The value is not numerical!', ...
                    'It automatically gets default value!' ) );
        else
            if value >= frange(1) && value <= frange(2)
                opt = value;
            else
                warning( ['[SCP] The value is out of the range!'] );
            end
        end 
    case 'char', 
        if ~ischar( value )
            warning( strcat( '[SCP] The value is not a string!', ...
                             'It automatically gets default value!' ) );
        else
            
            if any( strcmp( frange, lower( value ) ) )
                value = frange( strcmp( frange, lower( value ) ) );
                opt = value{1};
            else
                warning( ['[SCP] The value is not in the range! '] );
            end
        end
    case 'logic',
        if ~islogical( value )
            warning( strcat( '[SCP] The value is not logical!', ...
                             'It automatically gets default value!' ) );
        else
            
            if value == frange{1} || value == frange{2}
                opt = value;
            else
                warning([ '[SCP] The value is not in the range! ' ]);
            end
        end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++