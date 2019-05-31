function params_row = getItemParams(fileset, index)

% getItemParams - Get the parameter values of a fileset item.
%
% Usage:
% params_row = getItemParams(fileset, index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	index: Index of item in fileset.
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/03

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = get(fileset, 'props');
params_row = [];

filename = getItem(fileset, index);
fullname = fullfile(fileset.path, filename);

% if given, use the regular expression to parse parameters
if isfield(props, 'fileParamsRegexp')
  try 
    param_regexp = regexp(fullname, props.fileParamsRegexp, 'names');
  
    num_params = length(param_regexp);
    
    % convert the regexp sturcture into cell array
    for param_num = 1:num_params
      names_vals{param_num, 1} = param_regexp(param_num).name;
      names_vals{param_num, 2} = str2num(param_regexp(param_num).val);
    end
    
    params_row = [ names_vals{1:num_params, 2} ];
  catch me
    error('pandora:fileset:regexpError', ...
        [me.message ': props.fileParamsRegexp must be a regular expression ' ...
         'with named captures for variables "name" and "val". See ' ...
         '"names" option to regexp.']);
  end
  
% if props.num_params ~= 0 then parse file names
elseif ~ isfield(props, 'num_params') || props.num_params ~= 0
  
  names_vals = parseFilenameNamesVals(fullname, props);

  if isfield(props, 'num_params')
    num_params = props.num_params;
  else
    num_params = size(names_vals, 1);
  end

  params_row = [ names_vals{1:num_params, 2} ];
end

if isfield(props, 'param_rows')
  % Take parameter values from the specified parameter file,
  % in addition to the ones specified on data filenames.
  if ~ isfield(props, 'param_trial_name')
    props.param_trial_name = 'trial';
  end

  % Skip the "trial" value from the rows file
  str_index = strmatch(props.param_trial_name, props.param_names);
    
  trues = true(1, length(props.param_names));
    
  if ~ isempty(str_index)
    % If found, ignore the parameter "trial" from the list of parameters 
    % coming from the param rows file
    trues(str_index) = false;
  end

  % look up trial numbers if there is more than one row
  if size(props.param_rows, 1) > 1
    str_index = strmatch(props.param_trial_name, {names_vals{1:num_params, 1}});
    
    if length(str_index) < 1
      disp('Names found:');
      names_vals
      error(['Parameter lookup from rows is requested, but cannot find ' ...
             'the "' props.param_trial_name '" parameter in the data filename ' fullname ]);
    end
    
    trial_num = names_vals{str_index, 2};

    % if the trials are not integers, there must be a hashtable
    if isfield(props, 'trial_hash')
      % replace with integer index
      trial_num = ...
          props.trial_hash.(feval(props.trialHashFunc, trial_num, ...
                                          getFieldDefault(props, 'precision', 6)));
    else
      if trial_num > size(props.param_rows, 1)
        error([ 'Trial number ' num2str(trial_num) ' is larger than trials available in the ' ...
                'specified param_rows (' num2str(size(props.param_rows, 1)) ').'] );
      end
    end
    params_row = [props.param_rows(trial_num, trues) params_row];
  else
    % if only one row, just use it
    params_row = [props.param_rows(1, trues) params_row];
  end
end
