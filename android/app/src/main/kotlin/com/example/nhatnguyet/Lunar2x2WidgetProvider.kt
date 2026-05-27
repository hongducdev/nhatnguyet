package com.example.nhatnguyet

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class Lunar2x2WidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_lunar_2x2)
            
            val month = widgetData.getString("lunar_month", "Tháng 1 Âm")
            val day = widgetData.getString("lunar_day", "1")
            val solar = widgetData.getString("solar_date", "DL: 1/1/2026")
            
            views.setTextViewText(R.id.lunar_month, month)
            views.setTextViewText(R.id.lunar_day, day)
            views.setTextViewText(R.id.solar_date, solar)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
