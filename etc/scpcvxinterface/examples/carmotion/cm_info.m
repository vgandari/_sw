%**************************************************************************
% Purpose: Give information for car motion problem
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
function cm_info()

fprintf('%s\n', repmat('=', 1, 105 ) );
fprintf('                               CAR MOTION PROBLEM\n');
fprintf('  Purpose: Modelling the motion of a car along given trajectory\n');
fprintf('  Parameters: To change trajectory: options.prob = given value\n');
fprintf('              Set options.prob = 7, plot the road by hand ... \n');
fprintf('%s\n', repmat('=', 1, 105 ) );

%**************************************************************************
% end of function
%**************************************************************************