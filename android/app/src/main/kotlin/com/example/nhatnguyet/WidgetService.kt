package com.example.nhatnguyet

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin

class WidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return WidgetRemoteViewsFactory(applicationContext)
    }
}

class WidgetRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var cells = listOf<String>()

    private fun loadCells() {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val cellsString = prefs.getString("month_cells", "") ?: ""
        cells = if (cellsString.isNotEmpty()) cellsString.split("|") else emptyList()
    }

    override fun onCreate() {
        loadCells()
    }

    override fun onDataSetChanged() {
        loadCells()
    }

    override fun onDestroy() {}

    override fun getCount(): Int = cells.size

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_calendar_cell)
        if (position < cells.size) {
            val parts = cells[position].split(",")
            if (parts.size >= 4) {
                val solar = parts[0]
                val lunar = parts[1]
                val isCurrentMonth = parts[2] == "1"
                val isToday = parts[3] == "1"

                views.setTextViewText(R.id.cell_solar, solar)
                views.setTextViewText(R.id.cell_lunar, if (lunar == "1") "1/M" else lunar) // Tự mùng 1 show 1/M đại diện

                // Style theo trạng thái
                if (isToday) {
                    views.setTextColor(R.id.cell_solar, 0xFFFFC107.toInt()) // Màu vàng/cam
                    views.setTextColor(R.id.cell_lunar, 0xFFFFC107.toInt())
                } else if (!isCurrentMonth) {
                    views.setTextColor(R.id.cell_solar, 0xFFBBBBBB.toInt()) // Ẩn mờ tháng trước/sau
                    views.setTextColor(R.id.cell_lunar, 0xFFDDDDDD.toInt())
                } else {
                    views.setTextColor(R.id.cell_solar, 0xFF333333.toInt()) // Màu tối chủ đạo
                    views.setTextColor(R.id.cell_lunar, 0xFFFFC107.toInt()) // Màu âm lịch
                }
            }
        }
        return views
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}
