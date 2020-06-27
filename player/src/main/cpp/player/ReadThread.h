//
// Created by aber tian on 2020/6/9.
//

#pragma once

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
     */
    class ReadThread {

    };

} // end namespace Acgn
