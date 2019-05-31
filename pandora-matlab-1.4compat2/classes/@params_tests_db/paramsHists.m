function p_hists = paramsHists(a_db, props)

% paramsHists - Calculates histograms for all parameters and returns in a 
%		cell array.
%
% Usage:
% p_hists = paramsHists(a_db, props)
%
% Parameters:
%   a_db: A tests_db object.
%   props: A structure with any optional properties.
%     paramVals: Array of histogram bins to use as parameter values.
%		
% Returns:
%   p_hists: An array of histograms for each parameter in a_db.
%
% Description:
%   Useful for looking at subset databases and find out what parameter
% values are used most. Skips the 'ItemIndex' column(s). Finds unique values
% of each parameter to make histograms.
%
% See also: params_tests_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/20

% Copyright (c) 2007-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

% TODO: use regexp column matching here
colnames = fieldnames(get(a_db, 'col_idx'));

itemsFound = strfind(colnames, 'Index');

itemIndices = false(1, length(itemsFound));
for i=1:length(itemsFound)
  if length(itemsFound{i}) > 0
    itemIndices(i) = true(1);
  end
end

% Strip out the NeuronId columns from parameters 
colnames = setdiff(colnames(1:a_db.num_params), {'NeuronId', colnames{find(itemIndices)}});

% Preserve original column order
cols = sort(tests2cols(a_db, colnames));

% Filter relevant columns
reduced_db = onlyRowsTests(a_db, ':', cols);
num_params = reduced_db.num_params;

[p_hists(1:num_params)] = deal(histogram_db);
for param_num=1:num_params
  % First find all unique values of the parameter
  param_cols = sortrows(get(onlyRowsTests(reduced_db, ':', param_num), 'data'));
  param_vals = ...
      getFieldDefault(props, 'paramVals', ...
                             sortedUniqueValues(param_cols));
  % Give the param_vals as bin centers
  if length(param_vals) == 1
    param_vals = 1; % A single histogram bin
  end
  p_hists(param_num) = histogram(reduced_db, param_num, param_vals');
end
