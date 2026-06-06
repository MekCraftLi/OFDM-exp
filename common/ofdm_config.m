function params = ofdm_config()
params.modLevel = 2;
params.modOrder = 2^params.modLevel;
params.normFactor = sqrt(2/3*(params.modLevel.^2 - 1));

params.fftLen = 64;
params.cpLen = 16;
params.blockLen = params.fftLen + params.cpLen;
params.sampleRate = 20e6;
params.cfoHz = 0.2 * params.sampleRate / params.fftLen;

params.numShortTrainBlks = 10;
params.shortTrainBlockLen = 16;
params.numLongTrainBlks = 2;
params.longCpLen = 32;

params.usedSubcIdx = [7:32 34:59].';
params.reorder = [33:64 1:32].';

params.dataSubcPatt = [1:5 7:19 21:26 27:32 34:46 48:52].';
params.dataSubcIdx = [7:11 13:25 27:32 34:39 41:53 55:59].';
params.pilotSubcPatt = [6 20 33 47].';
params.pilotSubcIdx = [12 26 40 54].';

params.threshold = 0.75;
params.searchWin = 700;
params.packetDelayLen = 16;
params.packetAvgLen = 32;

params.pktDetOffset = 10;
params.fineSearchStart = 150;
params.fineSearchEnd = 200;

params.snrModuleDb = 0:5:25;
params.snrCompleteDb = 10:5:30;
params.numPackets = 50;

params.channel = zeros(params.cpLen, 1);
params.channel(1) = 1;
params.channel(5) = 0.5;
params.channel(10) = 0.3;
end

