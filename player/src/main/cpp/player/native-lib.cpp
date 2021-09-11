#include <jni.h>
#include <string>
//#include "png.h"
//#include "PacketQueue.h"

#ifdef __cplusplus
extern "C" {
#endif
//#include "libavformat/avformat.h"
//#include "libavutil/avutil.h"
#ifdef  __cplusplus
}
#endif

#include <iostream>
#include <android/log.h>
#include <unistd.h>

extern "C"
JNIEXPORT jint JNICALL
Java_org_acgn_player_HelloJni_nativePngVersion(JNIEnv *env, jclass clazz) {
    return 1;
}

extern "C"
JNIEXPORT jint JNICALL
Java_org_acgn_player_HelloJni_nativeAVcodecVersion(JNIEnv *env, jclass clazz) {
    return 1;
}

extern "C"
JNIEXPORT jint JNICALL
Java_org_acgn_player_HelloJni_nativeAVcontextformatVersion(JNIEnv *env, jclass clazz) {
    return 1;
}

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

int count = 0;

JavaVM *VM;

extern "C"
JNIEXPORT jint JNICALL
Java_org_acgn_player_HelloJni_nativeLockAction(JNIEnv *env, jclass clazz) {
    if (pthread_mutex_lock(&mutex) == 0)
    {
        if (count == 0)
            sleep(5);
        count++;
        __android_log_print(ANDROID_LOG_DEBUG, "Mutex-lock", "count: %d", count);
    }
    pthread_mutex_unlock(&mutex);
    return 0;
}

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void* reserved)
{
    return JNI_VERSION_1_6;
}
