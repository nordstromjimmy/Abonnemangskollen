plugins {
    id("com.android.application")
    id("kotlin-android")                 // keep as-is if it works for you
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.subscriptions"

    // You can keep Flutter’s values, but I prefer constants to avoid surprises:
    // compileSdk = flutter.compileSdkVersion
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.subscriptions"

        // IMPORTANT: override Flutter’s default minSdk to satisfy isar_community (needs 23)
        // minSdk = flutter.minSdkVersion
        minSdk = 23

        // targetSdk = flutter.targetSdkVersion
        targetSdk = 34

        // You can keep these from Flutter if you prefer:
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            // Debug should not shrink/obfuscate.
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            // EITHER enable both:
            isMinifyEnabled = true          // turn on R8/ProGuard
            isShrinkResources = true        // allowed only when minify is ON
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // OR, if you prefer to keep minify off for now, then also keep shrink off:
            // isMinifyEnabled = false
            // isShrinkResources = false
        }
    }

    // AGP 8 requires Java 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}


flutter {
    source = "../.."
}
