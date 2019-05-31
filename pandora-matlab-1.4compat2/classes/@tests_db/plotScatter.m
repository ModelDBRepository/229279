function a_p = plotScatter(a_db, test1, test2, title_str, short_title, props)

% plotScatter - Create a scatter plot of the given two tests.
%
% Usage:
% a_p = plotScatter(a_db, test1, test2, title_str, short_title, props)
%
% Parameters:
%   a_db: A tests_db object.
%   test1, test2: X & Y variables.
%   title_str: (Optional) A string to be concatanated to the title.
%   short_title: (Optional) Few words that may appear in legends of multiplot.
%   props: A structure with any optional properties.
%     LineStyle: Plot line style to use. (default: 'x')
%     Regress: If exists, use these props for plotting the linear regression.
%     colorTest: Use this column as index into colormap.
%     colormap: Colormap vector, function name or handle to colormap (e.g., 'jet').
%     numColors: Number of colors desired in colormap (default: 50).
%     quiet: If 1, don't include database name on title.
%     markerArea: Passed as the 'area' argument to scatter (default=36).
%     (Others passed to plotColormap and plot_abstract).
%		
% Returns:
%   a_p: A plot_abstract.
%
% Description:
%   If 'warning on verbose' is issued before this, it will display
% regression statistics: R^2, F, p, and the error variance.
%
% See also: plotScatter3D, plotImage
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/29

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

col1 = tests2cols(a_db, test1);
col2 = tests2cols(a_db, test2);

col1_db = onlyRowsTests(a_db, ':', col1);
col2_db = onlyRowsTests(a_db, ':', col2);

% skip NaN value rows
non_nans_rows = ~(isnan(col1_db) | isnan(col2_db));
col1_db = onlyRowsTests(col1_db, non_nans_rows, ':');
col2_db = onlyRowsTests(col2_db, non_nans_rows, ':');

test_names = fieldnames(get(a_db, 'col_idx'));

if ~ exist('short_title', 'var') || isempty(short_title)
  short_title = [ strrep(test_names{col1}, '_', ' ') ' vs. ' ...
		 strrep(test_names{col2}, '_', ' ') ];
end

if ~ isfield(props, 'quiet')
  all_title = [ strrep(get(a_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end


if isfield(props, 'LineStyle')
  line_style = {props.LineStyle};
else
  line_style = {};
  props.LineStyleOrder = {'x', '+', 'd', 'o', '*', 's'};
end

if isfield(props, 'Regress')
  nonnan_db = noNaNRows(onlyRowsTests(a_db, ':', [col1 col2]));
  [b,bint,r,rint,stats] = ...
      regress(get(onlyRowsTests(nonnan_db, ':', 2), 'data'), ...
              [ones(dbsize(nonnan_db, 1), 1), ...
               get(onlyRowsTests(nonnan_db, ':', 1), 'data')]);
  if verbose, disp(['regress stats=' num2str(stats)]), end
  if ~isempty(all_title)
    all_title = [ all_title, '; '];
  end
  all_title = [ all_title, 'regress p=' sprintf('%.4f', stats(3)) ];
end

% diplay points with colors?
% TODO: modularize these color calculations and share among plotImage, etc.
if isfield(props, 'colorTest')
  color_test_db = a_db(:, props.colorTest);
  color_test_name = getColNames(color_test_db);
  color_test = get(color_test_db, 'data');
  num_colors = getFieldDefault(props, 'numColors', 50);
  a_colormap = getFieldDefault(props, 'colormap', @parula);
  if isa(a_colormap, 'function_handle') || ischar(a_colormap)
    a_colormap = feval(a_colormap, num_colors);
  end
  val_extrema = [min(color_test), max(color_test)];
  color_idx = round((color_test - val_extrema(1)) .* (num_colors - 1) ...
                    ./ diff(val_extrema)) + 1;
  if any(isnan(color_test))
    nan_color = [0 0 0]; % add black for nans at end
    color_idx(isnan(color_idx)) = num_colors + 1;
  else
    nan_color = [];
  end
  a_colormap = [a_colormap; nan_color];
  color = a_colormap(color_idx, :);
  colormap_props = ...
      mergeStructsRecursive(struct('colorbar', 1, 'colorbarLabel', color_test_name{1}, ...
                                   'minValue', min(color_test), ...
                                   'maxValue', max(color_test)), ...
                            props);

else
  color = [0 0 1];
  a_colormap = color;
  num_colors = 1;
  colormap_props = props;
end

area = getFieldDefault(props, 'markerArea', 36); % default
col_labels = strrep({test_names{[col1 col2]}}, '_', ' ');
a_p = plot_abstract({{get(col1_db, 'data'), get(col2_db, 'data'), area, color, line_style{:}}, ...
                    a_colormap, num_colors, ...
                    mergeStructs(struct('command', 'scatter'), colormap_props)}, ...
		    { col_labels{:} }, ...
		    all_title, { short_title }, @plotColormap, ...
		    props); 

if isfield(props, 'Regress')
  regress_props = struct;
  if isstruct(props.Regress)
    regress_props = props.Regress;
  end
  x_lims = [min(get(col1_db, 'data')) max(get(col1_db, 'data'))];
  regress_props_props = ...
      mergeStructs(regress_props, ...
                   struct('LineStyle', 'm-'));
  a_p = plot_superpose({a_p, plot_abstract({x_lims, x_lims * b(2) + b(1)}, ...
					   { }, '', { 'regression' }, ...
                                           'plot', regress_props)}, {}, '');
end