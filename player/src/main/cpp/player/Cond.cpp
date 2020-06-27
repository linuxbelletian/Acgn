//
// Created by aber tian on 2020/3/21.
//

#include "Cond.h"
#include "android/log.h"
#include <cerrno>

static const char* TAG = "Cond";

int Acgn::Cond::signal() {
    if (pthread_cond_signal(&cond) != 0) {
        __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_cond_signal() failed");
        return -1;
    }
    return 0;

}

int Acgn::Cond::wait(Mutex *mutex) {
    if (pthread_cond_wait(&cond, mutex->getMutex()) != 0) {
        __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_cond_wait() failed");
        return -1;
    }
    return 0;
}

Acgn::Cond::Cond() {
    if (pthread_cond_init(&cond, nullptr) != 0) {
        __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_cond_init() failed");
    }
}

Acgn::Cond::~Cond() {
    pthread_cond_destroy(&cond);
}
// Restart all threads that are waiting on the condition variable
int Acgn::Cond::broadcast() {

    int retval = 0;
    if (pthread_cond_broadcast(&cond) != 0) {
        __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_cond_broadcast() failed");
        retval = -1;
    }
    return retval;
}

int Acgn::Cond::waitTimeout(Mutex *mutex, int32_t ms) {
    // TODO
    int retval = 0;
    timeval delta{};
    timespec abstime{};
    clock_gettime(CLOCK_REALTIME, &abstime);

    abstime.tv_nsec += (ms % 1000) * 1000000;
    abstime.tv_sec += ms / 1000;

    if (abstime.tv_nsec > 1000000000) {
        abstime.tv_sec += 1;
        abstime.tv_nsec -= 1000000000;
    }
    tryagain:
    retval = pthread_cond_timedwait(&cond, mutex->getMutex(), &abstime);
    switch (retval) {
        case EINTR:
            goto tryagain;
        case ETIMEDOUT:
            retval = Acgn::Mutex::MUTEX_TIMEOUT;
            break;
        case 0:
            break;
        default:
            __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_cond_timedwait() failed");
            retval = -1;
    }
    return retval;
}
