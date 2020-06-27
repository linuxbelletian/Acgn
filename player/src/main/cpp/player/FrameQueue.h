//
// Created by aber tian on 2020/5/1.
//

#pragma once

#ifdef __cplusplus
extern "C"{
#endif
#include "libavcodec/avcodec.h"
#ifdef __cplusplus
};
#endif

#include "math.h"
//#include "stdint.h"
#include <cstdint>
#include "Mutex.h"
#include "Cond.h"
#include "PacketQueue.h"


#define VIDEO_PICTURE_QUEUE_SIZE 3
#define SUBPICTURE_QUEUE_SIZE 16
#define SAMPLE_QUEUE_SIZE 9
#define FRAME_QUEUE_SIZE FFMAX(SAMPLE_QUEUE_SIZE, FFMAX(VIDEO_PICTURE_QUEUE_SIZE, SUBPICTURE_QUEUE_SIZE))

/*用于保存解码后的数据*/
namespace Acgn {

    // 用于保存一帧视频画面，音频或者字幕
    /*Frame的设计思路是 试图用一个结构体融合三种数据
     * 视频，音频，字幕， 虽然AVFrame既可以表述视频又可以表示
     * 音频，但是在融合字幕时又需要引入AVSubtitle，以及一些其他
     * 字段， 比如 width height 等来补充AVSubtitle，所以
     * 整个结构体看起来很拼凑（甚至还有视频专用的flip_v字段）
     * 这里先关注frame 和 sub字段即可*/
    struct Frame {
        // 视频或者音频的解码数据
        AVFrame *frame;
        // 解码的字幕数据
        AVSubtitle sub;
        // @see PacketQueue.serial
        int serial;
        // presentation timestamp for the frame
        double pts;
        // estimated duration of the frame
        double duration;
        // byte position of the frame in the input file
        int64_t pos;

        int width;
        int height;
        int format;
        AVRational sar;
        int uploaded;
        int flip_v;
    };

    /*
     * 用于表示这个帧队列
     * 这里与PacketQueue区别在于，FrameQueue使用数组而不是链表来实现
     * 使用数组实现环形缓冲区
     * */
    /**
     * 先给出其设计理念:
     * 1. 高效率的读写模型(回顾PacketQueue的设计， 每次访问都需要加锁整个队列，锁的范围很大)
     * 2. 高效率的内存模型(节点内存以数组形式预分配，无需动态分配)
     * 3. 环形缓冲区设计， 同时可以访问上一读节点
     * */
    class FrameQueue {
        // 队列元素，用数组模拟队列
        Frame queue[FRAME_QUEUE_SIZE];
        // 读指针
        int rindex;
        // 写指针
        int windex;
        // 当前存储的节点个数(或者说当前已经写入的节点个数)
        int size;
        // 最大允许存储节点个数
        int max_size;
        // 当前是否保留最后一个读节点
        bool keep_last;
        // 当前节点是否已经显示
        bool rindex_shown;

        Mutex *mutex;

        Cond *cond;
        // 关联的PacketQueue
        PacketQueue *pktq;

    public:
        // 初始化队列
        FrameQueue(PacketQueue *packetQueue, int maxSize, bool keepLast);

        ~FrameQueue();
        // 销毁
        void destory();

        void unref_item(Frame *frame);

    };
} // end namespace Acgn
