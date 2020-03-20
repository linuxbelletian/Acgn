#include <jni.h>
#include <string>
#include "png.h"

extern "C" JNIEXPORT jstring JNICALL
Java_org_acgn_player_HelloJni_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Hello from C++ Cmake";
    auto version_number = png_access_version_number();
    return env->NewStringUTF(hello.c_str());
}
extern "C"
JNIEXPORT jint JNICALL
Java_org_acgn_player_HelloJni_pngVersion(JNIEnv *env, jobject thiz) {
    jint version = static_cast<jint>(png_access_version_number());
//    jint version = 1;
    return version;
}

extern "C"
JNIEXPORT jint JNICALL
Java_org_acgn_player_HelloJni_staticPngVersion(JNIEnv *env, jclass clazz) {
    return static_cast<jint>(png_access_version_number());
}