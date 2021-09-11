package org.acgn.widget.recyclerview

import android.view.ViewGroup
import androidx.annotation.CallSuper
import androidx.recyclerview.widget.RecyclerView

/**
 * Factory creation of ViewHolder out
 * @see ViewHolderFactory
 * */
class FactoryAdapter<D, VH: BaseViewHolder<D>>(
        /**
         * Using this factory to create ViewHolder instance
         * */
        private val factory: ViewHolderFactory<VH>,
        private val dataSource: DataSourceProvider<D>
): RecyclerView.Adapter<VH>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        return factory.create(parent, viewType)
    }

    override fun getItemCount(): Int = dataSource.getSize()

    @CallSuper
    override fun onBindViewHolder(holder: VH, position: Int) {
        holder.bind(dataSource.getItemAtPosition(position))
    }

    override fun onBindViewHolder(holder: VH, position: Int, payloads: MutableList<Any>) {
        if (payloads.isEmpty())
            onBindViewHolder(holder, position)
        else
            holder.bind(dataSource.getItemAtPosition(position), payloads)
    }

    override fun onFailedToRecycleView(holder: VH): Boolean {
        return super.onFailedToRecycleView(holder)
    }

    override fun onAttachedToRecyclerView(recyclerView: RecyclerView) {
        super.onAttachedToRecyclerView(recyclerView)
    }

    override fun onDetachedFromRecyclerView(recyclerView: RecyclerView) {
        super.onDetachedFromRecyclerView(recyclerView)
    }

    override fun onViewAttachedToWindow(holder: VH) {
        super.onViewAttachedToWindow(holder)
    }

    override fun onViewDetachedFromWindow(holder: VH) {
        super.onViewDetachedFromWindow(holder)
    }

    override fun onViewRecycled(holder: VH) {
        super.onViewRecycled(holder)
    }
}