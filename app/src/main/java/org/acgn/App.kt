package org.acgn

import android.app.Application
import android.util.Log
import dagger.hilt.android.HiltAndroidApp
import javax.inject.Inject

@HiltAndroidApp
class App: Application() {

    override fun onCreate() {
        super.onCreate()
    }

    @Inject
    fun hello() {
        Log.d(TAG, "hello: Injection of Hilt")
    }

    companion object {
        private const val TAG = "App"
    }
}