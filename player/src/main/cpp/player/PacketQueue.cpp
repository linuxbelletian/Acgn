//
// Created by aber tian on 2020/3/21.
//



#include "PacketQueue.h"
#include <new>


Acgn::PacketQueue::PacketQueue() {
    mutex = new Mutex();
    cond  = new Cond();
    abort_request = true;
    first = nullptr;
    last = nullptr;
    serial = 0;
    size = 0;
    nb_packets = 0;
    duration = 0;
}

Acgn::PacketQueue::~PacketQueue() {
    flush();// 先清除所有节点
    delete mutex;
    delete cond;
}

void Acgn::PacketQueue::start() {
    mutex->lock();
    abort_request = false;
    private_put(&flush_pkt); // 放入一个flush_pkt
    mutex->unlock();
}

int Acgn::PacketQueue::abort() {
    mutex->lock();
    abort_request = true;
    cond->signal(); // 释放一个条件信号
    mutex->unlock();
    return 0;
}
// return < 0 if aborted, 0 if no packet and > 0 if packet.
int Acgn::PacketQueue::get(AVPacket *pkt, int block, int *_serial) {
    Node *node1{};
    int result = 0;
    mutex->lock();
    for (;;) {
        if (abort_request) {
            result = -1;
            break;
        }

        node1 = first;
        if (node1) {
            first = node1->next;
            if (!first)
                last = nullptr;
            nb_packets--;
            size -= node1->pkt.size + sizeof(*node1);
            duration -= node1->pkt.duration;
            pkt = &node1->pkt;
            if (_serial)
                *_serial = node1->serial;
            av_free(node1);
            result = 1;
            break;
        }else if (!block) {
            result = 0;
            break;
        }else {
            cond->wait(mutex);
        }
    }

    mutex->unlock();
    return result;
}

int Acgn::PacketQueue::put(AVPacket *pkt) {
    int result = 0;

    mutex->lock();
    result = private_put(pkt);
    mutex->unlock();

    if (pkt != &flush_pkt && result < 0)
        av_packet_unref(pkt); // 放入失败， 释放AVPacket
    return result;
}
/* 放入空包 意味着 流的结束， 一般在视频读取完成的时候放入空包，
 * 该函数实现很明了，构建一个空包 然后调用put方法*/
int Acgn::PacketQueue::putnull(int stream_index) {
    AVPacket pkt1, *pkt = &pkt1;
    av_init_packet(pkt);
    pkt->data = nullptr;
    pkt->size = 0;
    pkt->stream_index = stream_index;
    return put(pkt);
}
/*用于将队列中所有节点清除。 比如用于销毁队列，seek操作等
 * 遍历释放所有节点，*/
void Acgn::PacketQueue::flush() {
    Node *node = nullptr, *node1 = nullptr;
    mutex->lock();
    for (node = first;  node ; node = node1) {
        node1 = node->next;
        av_packet_unref(&node->pkt);
        av_freep(&node);
    }

    last = nullptr;
    first = nullptr;
    nb_packets = 0;
    size = 0;
    duration = 0;
    mutex->unlock();
}

// 本函数主要完成三件事情
/* 1. 计算serial，serial标记了这个节点内的数据是何时的， 一般情况下新增节点与上一个节点的serial
 *      是一样的，但当队列中加入一个flush_pkt后， 后续节点的serial会比之前大1
 * 2. 队列操作。 经典的队列实现方式，这里不展开了
 * 3. 列队属性操作，更新队列中节点的数目，占用字节数（包含AVPacket.data的大小）以及时长*/
int Acgn::PacketQueue::private_put(AVPacket *pkt) {
    Node *node1 = nullptr;

    AVPacket *p = av_packet_alloc();

    if (abort_request) return -1;
    // here we using c++ new to replace it
    //    node1 = static_cast<Node *>(av_malloc(sizeof(Node)));
    node1 = new (std::nothrow) Node{};
    if (!node1) // 内存不足
        return -1;

    node1->pkt = *pkt; // 浅拷贝AVPacket.data 等内存并没有拷贝
    node1->next = nullptr;
    if (pkt == &flush_pkt) // 如果放入的flush_pkt, 则需要增加队列的序号，以区分不连续的两段数据
        serial++;
    node1->serial = serial; // 用队列需要标记节点

    // 队列操作， 如果last_pkt为null说明队列是空的，新增节点为队列头，否则队列有数据，则让原队列队尾的next为新增节点，最后将队尾指向新增节点
    if(!last)
        first = node1;
    else
        last->next = node1;
    last = node1;

    // 队列属性操作，增加节点数， cache大小， cache总时间长度
    nb_packets++;
    size += node1->pkt.size + sizeof(*node1);
    duration += node1->pkt.duration;

    // 发送信号 表明队列中有数据了， 通知等待中的读线程可以读取数据了
    cond->signal();
    return 0;
}





