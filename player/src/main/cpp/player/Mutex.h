//
// Created by aber tian on 2020/3/21.
//


#pragma once

#include <pthread.h>
/**
 * 多线程锁对象
 * */
namespace Acgn {
class Mutex {


private:
    pthread_mutex_t mutex{};


public:
    static const int MUTEX_TIMEOUT = 1;

    Mutex();

    ~Mutex();

    pthread_mutex_t * getMutex() { return &mutex;};

    int lock();

    int tryLock();

    int unlock();

};

}
