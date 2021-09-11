//
// Created by aber tian on 2020/6/9.
//

#pragma once

#include <libavformat/avformat.h>

namespace Acgn {   
    /*
     * 专门用于 处理数据读取的线程
     *
     * 主要 执行如下步骤
     * 1.准备阶段：打开文件， 检测Stream， 打开解码器
     * 2.主循环读取数据，解封装： 读取Packet， 存入PacketQueue
     *
     *
     * 准备阶段：
     *      1. avformat_open_input // 用于打开输入文件 这个操作对于网络流也是一样的
     *      2. avformat_find_stream_info //
     *      3. av_find_best_stream
     *      4. stream_component_open
     * avformat_open_input用于打开输入文件，（对于网络流也是一样，在ffmpeg内部都抽象为URLProtocol,
     * 这里描述为文件是为了方便与后续提到的AVStream的流作区分), 读取视频评鉴的基本信息
     *
     */
    class ReadThread {
    private:
        AVFormatContext &ic;
    public:
        ReadThread();
        void read();
    };

} // end namespace Acgn
