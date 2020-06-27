//
// Created by aber tian on 2020/5/1.
//

#include "FrameQueue.h"
#include <cerrno>
/*
 * 主要是内存初始化，锁初始化，其中参数max_size是最大允许存储节点个
 * 数，但不能超过FRAME_QUEUE_SIZE,
 * FRAME_QUEUE_SIZE 是通过预处理指令定义的
 * 实际是不超过16
 * keepLast 表示是否在环形缓冲区的读写过程中保留最后一个节点不被复写
 * 最后为queue数组中的每个元素动态分配AVFrame对象
 * */
namespace Acgn {


    FrameQueue::~FrameQueue() {
        destory();
    }

    FrameQueue::FrameQueue(PacketQueue *packetQueue, int maxSize, bool keepLast) {
        int i = 0;
        mutex = new Mutex();
        cond = new Cond();
        this->pktq = packetQueue;
        this->max_size = maxSize;
        // this is c style convert keepLast to 0/1
        // in c++ we have bool type so we don't need this style, just keep itself
//    this->keepLast = !!keepLast;
        this->keep_last = keepLast;
        for (i = 0; i < maxSize; i++) {
            if (!(queue[i].frame = av_frame_alloc()))
                throw AVERROR(ENOMEM);
        }
    }

/* 这里比较重要的是queue元素的释放， 分两步
 * 首先是unref_item 然后是 av_frame_free
 * 其中av_frame_free与初始化中的av_frame_alloc对应
 * 用于释放AVFrame*/
    void FrameQueue::destory() {
        int i;
        for (i = 0; i < max_size; ++i) {
            Frame *p = &queue[i];
            unref_item(p);
            av_frame_free(&p->frame);
        }
        delete mutex;
        delete cond;
    }

// 此方法都是释放关联的对象的内存 而不是类本身的内存
/* 在AVFrame内部有许多AVBufferRef类型的字段，而AVBufferRef只是
 * AVBuffer的引用，AVBuffer通过引用计数自动管理内存(简易的垃圾回收)
 * 因此AVFrame在不需要的时候，需要通过av_frame_unref来减少引用计数
 * 关于AVBufferRef的内存还礼机制，可以参考这篇文章
 * https://blog.csdn.net/muyuyuzhong/article/details/79381152
 * */
    void FrameQueue::unref_item(Acgn::Frame *frame) {
        av_frame_unref(frame->frame); // frame 计数减1
        avsubtitle_free(&frame->sub); // 释放sub关联的内存
    }



} // end namespace Acgn