//
// Created by aber tian on 2020/3/21.
//

#pragma once

#ifdef __cplusplus
extern "C"{
#endif
#include "libavcodec/avcodec.h"
#ifdef __cplusplus
};
#endif

#include "Mutex.h"
#include "Cond.h"


namespace Acgn {
    /*
     * 队列中的一个节点
     * */
    struct Node {
        // 揭开容器封装后的数据包
        AVPacket pkt;
        // 指向下一个节点
        Node *next;
        // 序号 这个字段用于记录当前节点的序列号,  一般用于
        // 区分是否连续数据
        int serial;
    };

    static AVPacket flush_pkt;
    /*
     * PacketQueue memory overview:
     * +-----------------------------------------------+
     * |      Node                  Node               |
     * |  +----------+         +-------------+         |
     * |  |      next+-------> |         next+-------> |
     * |  |  AVPacket|         |     AVPacket|         |
     * |  +----------+         +-------------+         |
     * +-----------------------------------------------+
     *              |                      |
     *            data                   data
     *
     *  Node 内存分两块 一部分是Node结构体的内存, 另一部分是Node的pkt字段中指向的data内存
     *  Node结构体内存通过 释放结构体本身即可释放，但是释放前需要先使用av_packet_unref()函数
     *  释放掉pkt字段指向的data内存之后才能安全释放。 一般情况是 调用者负责用av_packet_unref()
     *  函数释放掉data内存，特殊情况当 遇到 flush操作活着put操作失败时，需要队列自己处理
     *
     *
     *  serial变化过程:
     *  PacketQueue
     *  serial:   1              1               2                 2                 2
     *  +-------------------------------------------------------------------------------+
     *  |       Node           Node            Node              Node              Node
     *  |  +--------+     +--------+      +--------+        +--------+        +--------+
     *  |  |serial:1+----->serial:1+------>serial:2+-------->serial:2+-------->serial:2|
     *  |  +--------+     +--------+      +----^---+        +--------+        +--------+
     *  |                                      |                                       |
     *  +------------------------------------------------------------------------------+
     *                                         +
     *                                     flush_pkt
     *
     *  如上图所示， 左边是队头， 右边是队尾， 从左到右标柱了5个节点的serial， 以及放入对应节点时
     *  queue的serial变化过程
     *  可以看到当放入flush_pkt后，serial增加了1
     *  主要区分的是上图虽然看起来queue的serial和节点的serial保持一致了，但这是指放入时是相等的，在
     *  取出时不一定相等。 假设，现在要从队头取出一个节点，那么取出的节点的serial是1，而PacketQueue
     *  本身的serial此时已经增长到2了
     *
     *  其设计逻辑是：
     *  1. 设计一个多线程安全的队列，保存AVPacket，同时统计队列内已经缓存的数据大小(这个统计数据
     *  会用来设置需要缓存的数据量)
     *  2. 引入serial概念，区别前后数据包是否连续
     *  3. 设计了两个特殊的packet： flush_pkt以及nullpkt， 用于更细致的控制(类似于多线程编程的
     *  事件模型---往队列中放入flush事件，放入null事件）
     * */
    class PacketQueue {
        // 队首队未
        Node *first, *last;
        // 队列中有多少个节点， PacketNode的个数
        int nb_packets;
        // 队列所有节点的字节数 用于计算cache大小
        unsigned long size;
        // 队列所有节点的合计时长
        int64_t duration;
        // 是否终止队列操作, 同于安全快速退出播放
        bool abort_request;
        // 序列号 和Node作用相同 但改变的时序稍微有点不同
        int serial;
        // 维持多线程安全的锁
        Mutex *mutex;
        // 多线程通知
        Cond *cond;

    public:
        PacketQueue();
        ~PacketQueue();
        // 启动
        void start();
        // 终止
        int abort();
        // 获取一个节点
        int get(AVPacket *pkt, int block, int *_serial);
        // 存入一个节点
        int put(AVPacket *pkt);
        // 存入一个空点
        int putnull(int stream_index);
        // 清楚所有节点
        void flush();

    private:
        int private_put(AVPacket *pkt);
    };
} // end namespace Acgn
