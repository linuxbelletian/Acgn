plugins {
    id("com.android.library")
    id("kotlin-android")
    kotlin("kapt")
}

android {
    compileSdk = Version.Android.compileSdk
    buildToolsVersion = Version.Android.buildTool

    defaultConfig {
        minSdk = Version.Android.minSdk
        targetSdk = Version.Android.targetSdk

        testInstrumentationRunner = Depends.AndroidTest.testRunner
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }

        getByName("debug") {

        }

    }
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))
    implementation(kotlin("stdlib-jdk8", Version.Kotlin.kotlinVersion))
//    implementation(Depends.Androidx.appcomat)
//    implementation(Depends.Androidx.coreKtx)
//    testImplementation(Depends.Test.junit)
//    androidTestImplementation(Depends.AndroidTest.extJunit)
//    androidTestImplementation(Depends.AndroidTest.espresso)
}