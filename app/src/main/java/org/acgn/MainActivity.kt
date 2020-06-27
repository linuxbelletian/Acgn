package org.acgn

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import org.acgn.player.HelloJni
import java.util.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Example of a call to a native method
        val tv = findViewById<TextView>(R.id.sample_text)
        tv.text = String.format(Locale.getDefault(),
                "png version: %d\ncodec version: %d\ncontextformat version: %d",
                HelloJni.pngVersion,
                HelloJni.codecVersion,
                HelloJni.formatVersion)
        tv.setOnClickListener {
            it ->
            for (i in 1 until 5) {
                Thread(Runnable {
                    HelloJni.nativeLockAction()
                }).start()
            }

        }
    }

    companion object {
        const val TAG = "MainActivity"
    }
}