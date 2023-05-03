clear
freqList = [15.625 31.75 62.5 125 250 500 1000 2000 4000 8000 16000 32000 64000];
gain = zeros(1,length(freqList));
phase = zeros(1,length(freqList));
for  i = 1:length(freqList)
   freqParam = freqList(i);
   sim('SK_LPFsimulator_2018b.slx', 0.1);
   [gain(i), phase(i)] = calc_freqr_SK_LPF(input, output, freqParam);
   fprintf('\n')
   clear input
   clear output
end