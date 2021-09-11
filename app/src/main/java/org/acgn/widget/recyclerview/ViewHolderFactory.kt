package org.acgn.widget.recyclerview

import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
/**
 * ViewHolder Factory create a ViewHolder instance
 * */
interface ViewHolderFactory<VH: RecyclerView.ViewHolder> {
    /**
     * Return a ViewHolder instance
     * */
    fun create(parent: ViewGroup, viewType: Int): VH
}