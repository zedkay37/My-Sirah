import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Charge key.properties s'il existe (ignoré en CI / debug)
val keyPropertiesFile = rootProject.file("key.properties")
val hasReleaseSigning = keyPropertiesFile.exists()
val keyProperties = Properties()
if (hasReleaseSigning) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}

val requestedReleaseBuild = gradle.startParameter.taskNames.any {
    it.contains("Release", ignoreCase = true)
}
if (requestedReleaseBuild && !hasReleaseSigning) {
    throw GradleException(
        "Release signing is missing. Create android/key.properties before building a release artifact."
    )
}

fun releaseSigningProperty(name: String): String =
    keyProperties.getProperty(name)
        ?: throw GradleException(
            "Release signing property '$name' is missing in ${keyPropertiesFile.path}. " +
                "Available keys: ${keyProperties.stringPropertyNames().joinToString(", ")}"
        )

android {
    namespace = "com.sirah.sirah_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = releaseSigningProperty("keyAlias")
                keyPassword = releaseSigningProperty("keyPassword")
                storeFile = file(releaseSigningProperty("storeFile"))
                storePassword = releaseSigningProperty("storePassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.sirah.sirah_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

