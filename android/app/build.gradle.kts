plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    
    // [PENTING] Tambahkan Plugin Google Services di sini
    id("com.google.gms.google-services")
}

android {
    namespace = "com.logithm.projects"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8

        // Mengaktifkan Desugaring (Agar fitur Java 8+ jalan di Android lama)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        // Pastikan Application ID ini SAMA PERSIS dengan yang didaftarkan di Firebase
        applicationId = "com.logithm.projects"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
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

dependencies {
    // Library untuk Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
    
    // Note: Dependency Firebase (BOM) tidak perlu ditulis manual di sini 
    // karena Flutter (pubspec.yaml) sudah mengurusnya secara otomatis.
}