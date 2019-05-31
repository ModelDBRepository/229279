function a_db = minus(left_obj, right_obj)

% minus - Subtracts a DB from another or from a scalar.
%
% Usage:
% a_db = minus(left_obj, right_obj)
%
% Description:
%   If DBs have mismatching columns only the common columns will be kept.
% In any case, the resulting DB columns will be sorted in the order of the
% left-hand-side DB.
%
%   Parameters:
%	left_obj, right_obj: Operands of the subtraction. One must be of type tests_db
%		and the other can be a scalar.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: minus
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db = rop(left_obj, right_obj, @minus, '-');
