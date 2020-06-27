//
// Created by aber tian on 2020/3/21.
//

#pragma once
/**
 * 多线程条件对象
 * */
#include "Mutex.h"

namespace Acgn {
    class Cond {

    private:
        pthread_cond_t cond{};

    public:
        Cond();

        int signal();

        int broadcast();

        int waitTimeout(Mutex *mutex, int32_t ms);

        int wait(Mutex *mutex);

        virtual ~Cond();
    };
}
