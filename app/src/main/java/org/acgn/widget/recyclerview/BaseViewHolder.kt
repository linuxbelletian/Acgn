package org.acgn.widget.recyclerview

import android.view.View
import androidx.recyclerview.widget.RecyclerView

/**
 * Base ViewHolder which provide a bind method with [D] type data
 * */
abstract class BaseViewHolder<D>(itemView: View): RecyclerView.ViewHolder(itemView) {

    /**
     * @param d The data to be bind
     * */
    abstract fun bind(d: D)
    /**
     * Partial update
     * @param d The data to be bind
     * @param payloads Partial update information
     * @see RecyclerView.Adapter.onBindViewHolder]
     * */
    abstract fun bind(d: D, payloads: MutableList<Any>)
}