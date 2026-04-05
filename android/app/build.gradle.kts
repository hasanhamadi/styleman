plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled15"
    compileSdk = flutter.compileSdkVersion
    
    // این خط را از حالت flutter.ndkVersion تغییر دهید به مقدار زیر:
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.untitled15"
        // اگر در هنگام اجرا با خطای نسخه مواجه شدید، می‌توانید این دو مورد را هم دستی ست کنید:
        minSdk = 21 
        targetSdk = 34 // یا نسخه‌ای که در سیستم نصب دارید
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}