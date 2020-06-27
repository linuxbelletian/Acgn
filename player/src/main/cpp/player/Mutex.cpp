//
// Created by aber tian on 2020/3/21.
//

#include "Mutex.h"
#include "android/log.h"
#include <cerrno>

static const char *TAG = "Mutex";
namespace Acgn {

    Mutex::Mutex()
    {
        pthread_mutexattr_t attr{};
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);

        if (pthread_mutex_init(&mutex, &attr) != 0) {
            __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_mutex_init() failed");
        }
    }

    Mutex::~Mutex(){
        pthread_mutex_destroy(&mutex);
    }

    int Mutex::tryLock() {
        int retval = 0;
        int result = 0;

        retval = 0;
        result = pthread_mutex_trylock(&mutex);
        if (result != 0) {
            if (result == EBUSY) {
                retval = MUTEX_TIMEOUT;
            } else {
                __android_log_print(ANDROID_LOG_ERROR, TAG, "pthreadd_mutex_trylock() failed");
                retval = -1;
            }
        }
        return retval;
    }

    int Mutex::unlock() {
        if (pthread_mutex_unlock(&mutex) != 0) {
            __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_mutex_unlock() failed");
            return -1;
        }
        return 0;
    }

    int Mutex::lock() {
        if (pthread_mutex_lock(&mutex) != 0) {
            __android_log_print(ANDROID_LOG_ERROR, TAG, "pthread_mutex_lock() failed");
            return -1;
        }
        return 0;
    }
}
