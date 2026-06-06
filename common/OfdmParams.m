classdef OfdmParams
    properties
        mod_level (1,1) double {mustBeInteger, mustBePositive} = 2
        mod_order (1,1) double {mustBeInteger, mustBePositive} = 4
        norm_factor (1,1) double = 1

        fft_len (1,1) double {mustBeInteger, mustBePositive} = 64
        cp_len (1,1) double {mustBeInteger, mustBeNonnegative} = 16
        block_len (1,1) double {mustBeInteger, mustBePositive} = 80
        sample_rate (1,1) double {mustBePositive} = 20e6
        cfo_hz (1,1) double = 62500

        num_short_train_blks (1,1) double {mustBeInteger, mustBePositive} = 10
        short_train_block_len (1,1) double {mustBeInteger, mustBePositive} = 16
        num_long_train_blks (1,1) double {mustBeInteger, mustBePositive} = 2
        long_cp_len (1,1) double {mustBeInteger, mustBeNonnegative} = 32

        used_subc_idx (:,1) double {mustBeInteger, mustBePositive} = [7:32 34:59].'
        reorder (:,1) double {mustBeInteger, mustBePositive} = [33:64 1:32].'

        data_subc_patt (:,1) double {mustBeInteger, mustBePositive} = [1:5 7:19 21:26 27:32 34:46 48:52].'
        data_subc_idx (:,1) double {mustBeInteger, mustBePositive} = [7:11 13:25 27:32 34:39 41:53 55:59].'
        pilot_subc_patt (:,1) double {mustBeInteger, mustBePositive} = [6 20 33 47].'
        pilot_subc_idx (:,1) double {mustBeInteger, mustBePositive} = [12 26 40 54].'

        threshold (1,1) double {mustBeNonnegative} = 0.75
        search_win (1,1) double {mustBeInteger, mustBePositive} = 700
        packet_delay_len (1,1) double {mustBeInteger, mustBePositive} = 16
        packet_avg_len (1,1) double {mustBeInteger, mustBePositive} = 32

        pkt_det_offset (1,1) double {mustBeInteger, mustBeNonnegative} = 10
        fine_search_start (1,1) double {mustBeInteger, mustBePositive} = 150
        fine_search_end (1,1) double {mustBeInteger, mustBePositive} = 200

        snr_module_db (1,:) double = 0:5:25
        snr_complete_db (1,:) double = 10:5:30
        num_packets (1,1) double {mustBeInteger, mustBePositive} = 50

        channel (:,1) double = zeros(16, 1)

        short_freq (:,1) double = zeros(0, 1)
        long_freq (:,1) double = zeros(0, 1)
        short_symbol (:,1) double = zeros(0, 1)
        short_block (:,1) double = zeros(0, 1)
        long_symbol (:,1) double = zeros(0, 1)
        preamble (:,1) double = zeros(0, 1)
    end

    methods
        function obj = OfdmParams()
            obj.mod_order = 2^obj.mod_level;
            obj.norm_factor = sqrt(2/3*(obj.mod_level.^2 - 1));
            obj.block_len = obj.fft_len + obj.cp_len;
            obj.cfo_hz = 0.2 * obj.sample_rate / obj.fft_len;

            obj.channel = zeros(obj.cp_len, 1);
            obj.channel(1) = 1;
            obj.channel(5) = 0.5;
            obj.channel(10) = 0.3;
        end
    end
end

