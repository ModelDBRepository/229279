function a_doc_multi = comparisonReport(r_bundle, props)

% comparisonReport - OBSOLETE - Generates a report by comparing r_bundle with the given match criteria, crit_db from crit_bundle.
%
% Usage:
% a_doc_multi = comparisonReport(r_bundle, crit_bundle, crit_db, props)
%
% Description:
%   Generates a LaTeX document with:
%	- (optional) Raw traces compared with some best matches at different distances
%	- Values of some top matching a_db rows and match errors in a floating table.
%	- colored-plot of measure errors for some top matches.
%	- Parameter distributions of 50 best matches as a bar graph.
%
%   Parameters:
%	r_bundle: A dataset_db_bundle object that contains the DB to compare rows from.
%	crit_bundle: A dataset_db_bundle object that contains the criterion dataset.
%	crit_db: A tests_db object holding the match criterion tests and STDs
%		 which can be created with matchingRow.
%	props: A structure with any optional properties.
%		caption: Identification of the criterion db (not needed/used?).
%		num_matches: Number of best matches to display (default=10).
%		rotate: Rotation angle for best matches table (default=90).
%
%   Returns:
%	tex_string: LaTeX document string.
%
% See also: displayRowsTeX
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

a_ranked_db = r_bundle.ranked_db
ranked_num_rows = dbsize(a_ranked_db, 1);

% adjust labels for LaTeX
a_db_id = lower(properTeXLabel(get(a_ranked_db.orig_db, 'id')));
crit_db_id = lower(properTeXLabel(get(a_ranked_db.crit_db, 'id')));

if ranked_num_rows > 0

  % generate plots for 1, 11, .. 41
  plots = plotCompareRanks(r_bundle, [1 2 ((1:4)*10 + 1)], props);
  joined_db = plots.joined_db;

  % Display raw data traces from dataset
  crit_trace_id = plots.crit_trace_id;
  num_plots = length(plots.trace_d100_plots);

  % Make a full figure with the best matching guy
  short_caption = [ 'Best matching model from ' a_db_id ' to ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' All available raw traces from the criterion cell are shown.' ];
  best_doc = doc_plot(plot_stack([plots.trace_d100_plots{1}, plots.trace_h100_plots{1}], ...
				 [0 3000 -150 80], 'y', ...
				 ['The best match to ' crit_trace_id ], ...
				 struct('xLabelsPos', 'bottom', 'titlesPos', 'none')), ...
		      caption, [crit_db_id  ' - best matching model from ' a_db_id ], ...
		      struct('floatType', 'figure', 'center', 1, ...
			     'height', '.8\textheight', 'shortCaption', short_caption), ...
		      'best match figure', struct('orient', 'tall'));

  % Also include the fI curves for the best
  fIcurve_doc = plotfICurve(r_bundle, 1);

  % Also include spike shape comparisons for the best
  best_trial_num = joined_db(1, 'trial').data;
  short_caption = [ 'Spike shapes of best matching model to ' crit_db_id '.' ];
  caption = [ short_caption ];
  crit_trace_d100 = setProp(plots.crit_trace_d100(1), 'quiet', 1);
  crit_spikes = spikes(crit_trace_d100);
  crit_spont_sshape = setProp(getSpike(crit_trace_d100, crit_spikes, 2), 'quiet', 1);
  crit_pulse_sshape = setProp(getPulseSpike(crit_trace_d100, crit_spikes, 2), 'quiet', 1);
  best_trace = setProp(ctFromRows(r_bundle.m_bundle, best_trial_num, 100), 'quiet', 1);
  best_spikes = spikes(best_trace);
  best_spont_sshape = setProp(getSpike(best_trace, best_spikes, 2), 'quiet', 1);
  best_pulse_sshape = setProp(getPulseSpike(best_trace, best_spikes, 2), 'quiet', 1);
  best_sshape_doc = ...
      doc_plot(plot_stack([superposePlots([plotData(crit_spont_sshape, 'phys.'), ...
					   plotData(best_spont_sshape, 'model')], ...
					  {}, '2nd spont. spike'), ...
			   superposePlots([plotData(crit_pulse_sshape, 'phys.'), ...
					   plotData(best_pulse_sshape, 'model')], ...
					  {}, '2nd pulse spike')], [], 'x', ...
			  'Spike shape comparison of best match'), ...
		      caption, [crit_db_id  ' - spike of best matching model from ' a_db_id ], ...
		      struct('floatType', 'figure', 'center', 1, ...
			     'width', '.9\textwidth', 'shortCaption', short_caption), ...
		      'spont spike comparison', struct);

  % Make a full figure with the 2nd best matching guy
  short_caption = [ 'Second best matching model to ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' All available raw traces from the criterion cell are shown.' ];
  best2_doc = doc_plot(plot_stack([plots.trace_d100_plots{2}, plots.trace_h100_plots{2}], ...
				 [0 3000 -150 80], 'y', ...
				 ['The 2nd best match to ' crit_trace_id ], ...
				 struct('xLabelsPos', 'bottom', 'titlesPos', 'none')), ...
		      caption, [crit_db_id  ' - 2nd best matching model from ' a_db_id ], ...
		      struct('floatType', 'figure', 'center', 1, ...
			     'height', '.9\textheight', 'shortCaption', short_caption), ...
		      '2nd best match figure', struct('orient', 'tall'));
  
  % Stack rest of matches 
  % prepare a landscape figure with two rows
  % original and 5 matching data traces, +/-100pA traces in separate rows
  % TODO: indicate distances of best and furthest matches
  short_caption = ['Raw traces of the ranked for ' crit_db_id ' .' ];
  caption = [ short_caption ...
	     ' Traces are taken from 5 equidistant matches from the best' ...
	     ' 50 ranks from ' a_db_id '.' ...
	     '  Criterion cell trace is superposed with each model trace.'];

  horiz_props = struct('titlesPos', 'all', 'yLabelsPos', 'left', 'xLabelsPos', 'none');
  d100_row_plot = plot_stack([plots.trace_d100_plots{3:num_plots}], [0 3000 -80 80], 'x', '', ... %+100 pA CIP
			      mergeStructs(struct('xLabelsPos', 'none'), horiz_props));
  h100_row_plot = plot_stack([plots.trace_h100_plots{3:num_plots}], [0 3000 -150 80], 'x', '-100 pA CIP', ...
			     mergeStructs(struct('titlesPos', 'none'), horiz_props));
  
  rest_doc = doc_plot(plot_stack({d100_row_plot, h100_row_plot}, [], 'y', ...
				 ['Best matches to ' crit_trace_id ], ...
				 struct('titlesPos', 'none')), ...
		      caption, [ crit_db_id ' - top matching models from ' a_db_id ], ...
		      struct('floatType', 'figure', 'center', 1, ...
			     'rotate', 90, 'height', '.9\textheight', ...
			     'shortCaption', short_caption), ...
		      'rest of matches figure');

  clearpage_doc = doc_generate([ '\clearpage%' sprintf('\n') ], 'LaTeX specific page break');

  % Display values of 10 best matches
  if isfield(props, 'num_matches')
    num_best = props.num_matches;
  else
    num_best = 13;
  end
  top_ranks = onlyRowsTests(a_ranked_db, 1:min(num_best, ranked_num_rows), ':', ':');
  short_caption = [ a_db_id ' ranked for ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches are shown.' ];
  distancetable_doc = doc_generate(displayRowsTeX(top_ranks, caption, ...
						  struct('shortCaption', short_caption, ...
							 'rotate', 0)), ...
				   'table of distances from best matching models');

  % Display colored-plot of top 50 matches
  num_best = min(50, ranked_num_rows);
  % TODO: indicate distances of best and furthest matches
  short_caption = ['Individual measure distances color-coded for top matches of ' ...
		   a_db_id  ' ranked for ' crit_db_id '.'];
  caption = [ short_caption ...
	     ' Increasing distance represented with colors starting from ' ...
	     'blue to red. Dark blue=0 STD; light blue=1xSTD; yellow=2xSTD; ' ...
	     'and red=3xSTD difference.' ];
  coloredplot_doc = ...
      doc_plot(plotRowErrors(a_ranked_db, 1:num_best), ...
	       caption, [crit_db_id ' - colorgraph of top ' num2str(num_best) ...
			 ' from ' a_db_id ], ...
	       struct('floatType', 'figure', 'center', 1, ...
		      'width', '\textwidth', 'shortCaption', short_caption), ...
	       'colored distance error plot', struct('orient', 'tall'));

  % Display sorted colored-plot of top 50 matches
  short_caption = [ 'Sorted individual measure distances color-coded for top matches of ' ...
		   a_db_id  ' ranked for ' crit_db_id '.'];
  caption = [ short_caption ...
	     ' Increasing distance represented with colors starting from ' ...
	     'blue to red. Dark blue=0 STD; light blue=1xSTD; yellow=2xSTD; ' ...
	     'and red=3xSTD difference. Measures sorted with overall match quality. ' ];
  sortedcoloredplot_doc = ...
      doc_plot(plotRowErrors(a_ranked_db, 1:num_best, struct('sortMeasures', 1)), ...
	       caption, [ crit_db_id ' - sorted colorgraph of top ' num2str(num_best) ...
			 ' from ' a_db_id ], ...
	       struct('floatType', 'figure', 'center', 1, ...
		      'width', '\textwidth', 'shortCaption', short_caption), ...
	       'sorted colored distance error plot', struct('orient', 'tall'));
  
  % Display parameter distributions of 50 best matches
  short_caption = [ 'Parameter distributions of the best ranked for ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches from ' a_db_id ...
	     ' are taken.' ];
  num_best = 50;
  top_ranks = onlyRowsTests(joined_db, 1:min(num_best, ranked_num_rows), ':', ':');
  all_param_cols = true(1, get(top_ranks, 'num_params'));
  all_param_cols(tests2cols(top_ranks, 'trial')) = false;
  p_hists = paramsHists(onlyRowsTests(top_ranks, ':', all_param_cols));
  paramshist_doc = ...
      doc_plot(plot_stack(num2cell(plotEqSpaced(p_hists)), [], 'x', ...
			  ['Parameter distribution histograms of ' num2str(num_best) ...
			   ' best matches' ], ...
			  struct('yLabelsPos', 'left', 'titlesPos', 'none')), ...
	       caption, [ crit_db_id ' - params distribution of top 50 matches to ' ...
			 a_db_id ], ...
	       struct('floatType', 'figure', 'center', 1, ...
		      'width', '0.9\textwidth', 'shortCaption', short_caption), ...
	       'parameter histograms for top 50 matches');

  a_doc_multi = ...
      doc_multi({best_doc, best_sshape_doc, fIcurve_doc, rest_doc, clearpage_doc, distancetable_doc, coloredplot_doc, ...
		 sortedcoloredplot_doc, paramshist_doc, clearpage_doc}, ...
		'comparison report');
else
  a_doc_multi = doc_generate;
end
