package com.example.nominal_role

import android.os.Environment
import android.provider.MediaStore
import android.content.ContentValues
import android.content.Context
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.nominal_role/file"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "saveExcelToDownloads") {
                val fileName = call.argument<String>("fileName")
                val bytes = call.argument<ByteArray>("bytes")

                if (fileName != null && bytes != null) {
                    val resolver = applicationContext.contentResolver
                    val contentValues = ContentValues().apply {
                        put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                        put(MediaStore.Downloads.MIME_TYPE, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                        put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                    }

                    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
                    if (uri != null) {
                        val outputStream: OutputStream? = resolver.openOutputStream(uri)
                        outputStream?.write(bytes)
                        outputStream?.close()
                        result.success("File saved at: $uri")
                    } else {
                        result.error("SAVE_ERROR", "Failed to create file in Downloads", null)
                    }
                } else {
                    result.error("INVALID_ARGS", "Missing fileName or bytes", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

