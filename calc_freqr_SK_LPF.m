function [gain, phase] = calc_freqr_SK_LPF(input, output, freq)

% fs = 1e6;
offset_r = 0.1;                                                 % Set the first part of the signal discarded (0-1)
up_sml = 100;                                                   % Upsampling rate for CC peak search interpolation
model_name = 'SK_LPFsimulator_2018b';

load_system(model_name);                           % Load Simulink Model
% freq = get_param([model_name,'/Source'],'Frequency');   % Read frequency of input signal
% freq = str2double(freq);

fs_read = get_param([model_name,'/Solver Configuration'],'CompiledSampleTime');   % Read sample time
fs = ceil(1/fs_read{2}(1)); % converting to sampling rate

s_in = input.Data;  s_in = s_in(ceil(length(s_in)*offset_r)+1:end);
s_out = output.Data;  s_out = s_out(ceil(length(s_out)*offset_r)+1:end);

r = xcorr(resample(s_in,up_sml,1), resample(s_out,up_sml,1));
[~,peak_index] = max(r);

delay = (peak_index - (length(r)+1)/2)/up_sml;

gain = 20*log10(std(s_out)/std(s_in));
phase = delay / fs * freq * 2 * pi;
phase = angle(exp(1i*phase));

fprintf('Frequency: %6.2f [Hz]\n',freq);
fprintf('Gain: %3.2f [dB]\n',gain);
fprintf('Phase: %3.2f [rad]\n',phase);