package org.acgn.widget.recyclerview

interface DataSourceProvider<D> {
    fun getItemAtPosition(position: Int): D
    fun getSize(): Int
    fun getTypeAtPosition(position: Int): Int
}