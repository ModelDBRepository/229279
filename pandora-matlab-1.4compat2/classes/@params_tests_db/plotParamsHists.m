function a_ps = plotParamsHists(a_db, title_str, props)

% plotParamsHists - Create a horizontal plot_stack of parameter histograms.
%
% Usage:
% a_ps = plotParamsHists(a_db, title_str, props)
%
% Parameters:
%   a_db: A params_tests_db object.
%   title_str: (Optional) A string to be concatanated to the title.
%   props: A structure with any optional properties.
%     quiet: Do not display the DB id on the plot title.
%     barAxisProps: passed to plotEqSpaced for each bar axis.
%     stackAxisLimits: Axis limits for plot_stack (default=[NaN NaN 0 Inf]).
%     (Others passed to paramsHists, plotEqSpaced, and plot_stack)
%		
% Returns:
%   a_ps: A horizontal plot_stack of plots
%
% Description:
%   Skips the 'ItemIndex' test.
%
% See also: plot_stack, paramsHists, plotEqSpaced
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

if ~exist('title_str', 'var')
  title_str = '';
end

if isfield(props, 'barAxisProps')
    barAxisProps = props.barAxisProps;
else
    barAxisProps = struct;
end

if ~ isfield(props, 'quiet') && ~ isfield(get(a_db, 'props'), 'quiet')
  title_str = ['Parameter histograms of ' get(a_db, 'id') title_str ];
end

axis_limits = getFieldDefault(props, 'stackAxisLimits', [NaN NaN 0 Inf]);

% if x-axis limits are defined, remove tightlimits
tight_limits = 1;
if ~ all(isnan(axis_limits(1:2)))
  tight_limits = 0;
end

a_ps = ...
    plot_stack(plotEqSpaced(paramsHists(a_db, props), [], ...
                            mergeStructs(mergeStructs(barAxisProps, props), ...
                                         struct('tightLimits', ...
                                                tight_limits))), ...
               axis_limits, 'x', title_str, ...
               mergeStructs(props, struct('titlesPos', 'none', ...
                                          'yLabelsPos', 'left', ...
                                          'yTicksPos', 'left')));