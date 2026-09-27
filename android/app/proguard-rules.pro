# Flutter and its plugins ship their own rules; these cover the extras this
# app pulls in, so resource shrinking does not strip something at runtime.

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# Firebase Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# flutter_local_notifications uses reflection for scheduled notifications
-keep class com.dexterous.** { *; }
-keep class androidx.core.app.** { *; }

# flutter_tts
-keep class android.speech.tts.** { *; }

# Keep annotations Play Core / Flutter deferred components look for
-dontwarn com.google.android.play.core.**
