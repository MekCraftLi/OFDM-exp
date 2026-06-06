% 函数名：packet_detect
% 功能：检测接收信号中的数据包起始位置

function [start_idx, metric] = packet_detect(rx_signal, params)
arguments
    rx_signal (:,1) double
    params (1,1) OfdmParams
end

delay_len = params.packet_delay_len; % 包延迟长度
search_win = params.search_win; % 搜索窗口长度
avg_len = params.packet_avg_len; % 平均长度
threshold = params.threshold; % 检测阈值

error('packet_detect:NotImplemented', '下一步实现延迟相关、移动平均和阈值检测。');
end
