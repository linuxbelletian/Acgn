package org.acgn.player;

public class HelloJni {

    static {
        System.loadLibrary("native-lib");
    }

    public native String stringFromJNI();

    public native int pngVersion();

    public static native int staticPngVersion();
}
