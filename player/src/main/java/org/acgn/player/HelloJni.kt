package org.acgn.player

class HelloJni {


    companion object {

        init {
            System.loadLibrary("player")
        }

        val pngVersion: Int = nativePngVersion()

        val codecVersion: Int = nativeAVcodecVersion()

        val formatVersion: Int = nativeAVcontextformatVersion()

        @JvmStatic
        private external fun nativePngVersion(): Int
        @JvmStatic
        private external fun nativeAVcodecVersion(): Int
        @JvmStatic
        private external fun nativeAVcontextformatVersion(): Int

        @JvmStatic
        external fun nativeLockAction(): Int
    }
}