function measures = measureNames(a_cip_trace)

% measureNames - Returns taxonomy of measurements collected by cip_trace.
%
% Usage:
% measures = measureNames(a_cip_trace)
%
% Description:
%   This is a static method, in the sense that it does not need the object passed as argument.
% Therefore it can be called directly by using the default constructor; e.g., measureNames(cip_trace).
% The measure names are required for merging columns of a database generated by profiling these objects.
%
%   Parameters:
%	a_cip_trace: A cip_trace object. It can be created by the the default constructor 'cip_trace'.
%
%   Returns:
%	measures: A structure with cell arrays of types of measures, and measure names inside.
%
% See also: getResults, getProfileAllSpikes, mergeMultipleCIPsInOne
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

measures = struct;
measures.spont_spike_tests  = ...
    {'SpontSpikeAmplitudeMean', ...
     'SpontSpikeAmplitudeMode', ...
     'SpontSpikeAmplitudeSTD', ...
     'SpontSpikeBaseWidthMean', ...
     'SpontSpikeBaseWidthMode', ...
     'SpontSpikeBaseWidthSTD', ...
     'SpontSpikeFallTimeMean', ...
     'SpontSpikeFallTimeMode', ...
     'SpontSpikeFallTimeSTD', ...
     'SpontSpikeHalfWidthMean', ...
     'SpontSpikeHalfWidthMode', ...
     'SpontSpikeHalfWidthSTD', ...
     'SpontSpikeInitVmBySlopeMean', ...
     'SpontSpikeInitVmBySlopeMode', ...
     'SpontSpikeInitVmBySlopeSTD', ...
     'SpontSpikeInitVmMean', ...
     'SpontSpikeInitVmMode', ...
     'SpontSpikeInitVmSTD', ...
     'SpontSpikeMaxAHPMean', ...
     'SpontSpikeMaxAHPMode', ...
     'SpontSpikeMaxAHPSTD', ...
     'SpontSpikeMaxVmSlopeMean', ...
     'SpontSpikeMaxVmSlopeMode', ...
     'SpontSpikeMaxVmSlopeSTD', ...
     'SpontSpikeMinTimeMean', ...
     'SpontSpikeMinTimeMode', ...
     'SpontSpikeMinTimeSTD', ...
     'SpontSpikeRiseTimeMean', ...
     'SpontSpikeRiseTimeMode', ...
     'SpontSpikeRiseTimeSTD'};

measures.pulse_spike_tests  = ...
    {'PulseSpikeAmplitudeMean', ...
     'PulseSpikeAmplitudeMode', ...
     'PulseSpikeAmplitudeSTD', ...
     'PulseSpikeBaseWidthMean', ...
     'PulseSpikeBaseWidthMode', ...
     'PulseSpikeBaseWidthSTD', ...
     'PulseSpikeFallTimeMean', ...
     'PulseSpikeFallTimeMode', ...
     'PulseSpikeFallTimeSTD', ...
     'PulseSpikeHalfWidthMean', ...
     'PulseSpikeHalfWidthMode', ...
     'PulseSpikeHalfWidthSTD', ...
     'PulseSpikeInitVmBySlopeMean', ...
     'PulseSpikeInitVmBySlopeMode', ...
     'PulseSpikeInitVmBySlopeSTD', ...
     'PulseSpikeInitVmMean', ...
     'PulseSpikeInitVmMode', ...
     'PulseSpikeInitVmSTD', ...
     'PulseSpikeMaxAHPMean', ...
     'PulseSpikeMaxAHPMode', ...
     'PulseSpikeMaxAHPSTD', ...
     'PulseSpikeMaxVmSlopeMean', ...
     'PulseSpikeMaxVmSlopeMode', ...
     'PulseSpikeMaxVmSlopeSTD', ...
     'PulseSpikeMinTimeMean', ...
     'PulseSpikeMinTimeMode', ...
     'PulseSpikeMinTimeSTD', ...
     'PulseSpikeRiseTimeMean', ...
     'PulseSpikeRiseTimeMode', ...
     'PulseSpikeRiseTimeSTD'};

measures.recov_spike_tests  = ...
    {'RecovSpikeAmplitudeMean', ...
     'RecovSpikeAmplitudeMode', ...
     'RecovSpikeAmplitudeSTD', ...
     'RecovSpikeBaseWidthMean', ...
     'RecovSpikeBaseWidthMode', ...
     'RecovSpikeBaseWidthSTD', ...
     'RecovSpikeFallTimeMean', ...
     'RecovSpikeFallTimeMode', ...
     'RecovSpikeFallTimeSTD', ...
     'RecovSpikeHalfWidthMean', ...
     'RecovSpikeHalfWidthMode', ...
     'RecovSpikeHalfWidthSTD', ...
     'RecovSpikeInitVmBySlopeMean', ...
     'RecovSpikeInitVmBySlopeMode', ...
     'RecovSpikeInitVmBySlopeSTD', ...
     'RecovSpikeInitVmMean', ...
     'RecovSpikeInitVmMode', ...
     'RecovSpikeInitVmSTD', ...
     'RecovSpikeMaxAHPMean', ...
     'RecovSpikeMaxAHPMode', ...
     'RecovSpikeMaxAHPSTD', ...
     'RecovSpikeMaxVmSlopeMean', ...
     'RecovSpikeMaxVmSlopeMode', ...
     'RecovSpikeMaxVmSlopeSTD', ...
     'RecovSpikeMinTimeMean', ...
     'RecovSpikeMinTimeMode', ...
     'RecovSpikeMinTimeSTD', ...
     'RecovSpikeRiseTimeMean', ...
     'RecovSpikeRiseTimeMode', ...
     'RecovSpikeRiseTimeSTD'};

measures.ini_spont_tests = ...
    {'IniSpontISICV', ...
     'IniSpontPotAvg', ...
     'IniSpontSpikeRate', ...
     'IniSpontSpikeRateISI'};

measures.pulse_rate_tests = ...
    {'PulseISICV', ...
     'PulseSFA', ...
     'PulseIni100msISICV', ...
     'PulseIni100msRest1SpikeRate', ...
     'PulseIni100msRest2SpikeRate', ...
     'PulseIni100msRest1SpikeRateISI', ...
     'PulseIni100msRest2SpikeRateISI', ...
     'PulseIni100msSpikeRate', ...
     'PulseIni100msSpikeRateISI', ...
     'PulsePotAvg', ...
     'PulseSpikeAmpDecayTau', ...
     'PulseSpikeAmpDecayDelta', ...
     'PulseSpontAmpRatio'};

measures.pulse_hyper_pot_tests = ...
    {'PulsePotMin', ...
     'PulsePotMinTime', ...
     'PulsePotSag', ...
     'PulsePotTau'};

measures.recov_rate_tests = ...
    {'RecIniSpontPotRatio', ...
     'RecIniSpontRateRatio', ...
     'RecSpont1SpikeRate', ...
     'RecSpont2SpikeRate', ...
     'RecSpont1SpikeRateISI', ...
     'RecSpont2SpikeRateISI', ...
     'RecSpontFirstISI', ...
     'RecSpontFirstSpikeTime', ...
     'RecSpontISICV', ...
     'RecSpontPotAvg'};

% spike tests: [ 0:5 9:11 15:17 21:35 42:44 ]

% Common for 40, 100, 200pA
measures.depol_pulse_tests = ...
    { measures.pulse_rate_tests{:}, measures.recov_rate_tests{:}, measures.pulse_spike_tests{:}};