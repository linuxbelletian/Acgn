plugins {
    id("com.android.application")
    id("kotlin-android")
    kotlin("kapt")
    id("dagger.hilt.android.plugin")
}

android {
    compileSdk = Version.Android.compileSdk
    buildToolsVersion = Version.Android.buildTool

    defaultConfig {
        applicationId = "org.acgn"
        minSdk = Version.Android.minSdk
        targetSdk = Version.Android.targetSdk
        versionCode = 1
        versionName = "1.0"

//        ndk {
////            abiFilters 'arm64-v8a', 'x86_64'
//            abiFilters 'x86_64'
//        }

        testInstrumentationRunner = Depends.AndroidTest.testRunner
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

//    splits {
//        abi {
////            include 'x86_64', 'arm64-v8a' //select ABIs to build APKs for
//            include 'x86_64' //select ABIs to build APKs for
//        }
//    }
}

dependencies {

    implementation(fileTree(Depends.Libs.libs))
    implementation(Depends.Androidx.coreKtx)
    implementation(Depends.Androidx.appcomat)
    implementation(Depends.Google.material)
    kapt(Depends.Androidx.roomCompiler)
    implementation(Depends.Androidx.room)

    testImplementation(Depends.Test.junit)
    androidTestImplementation(Depends.AndroidTest.espresso)
    implementation(project(path = ":player"))
    implementation(kotlin("stdlib-jdk8", Version.Kotlin.kotlinVersion))

    // Kotlin + coroutines

    // optional - RxJava2 support

    // optional - GCMNetworkManager support
//    implementation "androidx.work:work-gcm:$work_version"

    implementation(Depends.Google.hilt)
    kapt(Depends.Google.hiltCompiler)
}

