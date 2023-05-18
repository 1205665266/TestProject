package com.cotticoffee.cotticlient

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class CottiAppliction : FlutterApplication() {

    override fun attachBaseContext(base: Context?) {
        MultiDex.install(this)
        super.attachBaseContext(base)
    }
}
