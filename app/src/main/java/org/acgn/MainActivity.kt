package org.acgn

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import org.acgn.player.HelloJni
import org.acgn.widget.recyclerview.BaseViewHolder
import org.acgn.widget.recyclerview.DataSourceProvider
import org.acgn.widget.recyclerview.FactoryAdapter
import org.acgn.widget.recyclerview.ViewHolderFactory
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
        tv.setOnClickListener { it ->
            for (i in 1 until 5) {
                Thread(Runnable {
                    HelloJni.nativeLockAction()
                }).start()
            }

        }

        val adapter = FactoryAdapter(MyFactory(), PeopleProvider())
        supportFragmentManager
    }

    data class People(val name: String)

    class PeopleProvider: DataSourceProvider<People> {

        val peoples = arrayListOf(People("Hello"),
                People("World"),
                People("Nice")
        )

        override fun getItemAtPosition(position: Int): People {
            return peoples[position]
        }

        override fun getSize(): Int {
            return peoples.size
        }

        override fun getTypeAtPosition(position: Int): Int {
            return 0
        }

    }

    class BaseVH(itemView: View) : BaseViewHolder<People>(itemView) {
        val textView: TextView
        var item: People? = null

        init {
            textView = itemView.findViewById(android.R.id.text1)
            textView.setOnClickListener { v -> Log.d(TAG, "$item: ") }
        }

        override fun bind(d: People) {
            item = d
            textView.text = d.name
        }


        override fun bind(d: People, payloads: MutableList<Any>) {
            bind(d)
        }

    }

    class MyFactory : ViewHolderFactory<BaseVH> {

        override fun create(parent: ViewGroup, viewType: Int): BaseVH {
            val inflater = LayoutInflater.from(parent.context)
            return BaseVH(inflater.inflate(android.R.layout.simple_list_item_1, parent, false))
        }

    }

    companion object {
        const val TAG = "MainActivity"
    }
}