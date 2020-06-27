plugins {
    id("com.android.application")
    id("kotlin-android")
    id("kotlin-android-extensions")
    id("org.jetbrains.kotlin.kapt")
}

android {
    compileSdkVersion(29)
    buildToolsVersion = "29.0.3"

    defaultConfig {
        applicationId = "org.acgn"
        minSdkVersion(28)
        targetSdkVersion(29)
        versionCode = 1
        versionName = "1.0"

//        ndk {
////            abiFilters 'arm64-v8a', 'x86_64'
//            abiFilters 'x86_64'
//        }

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
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

    val room_version = "2.2.5"
    val lifecycle_version = "2.2.0"
    val arch_version = "2.1.0"

    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))

    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:$lifecycle_version")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:$lifecycle_version")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:$lifecycle_version")
    implementation("androidx.lifecycle:lifecycle-viewmodel-savedstate:$lifecycle_version")
    implementation("androidx.lifecycle:lifecycle-common-java8:$lifecycle_version")
    implementation("androidx.lifecycle:lifecycle-service:$lifecycle_version")
//    testImplementation "androidx.arch.core:core-testing:$arch_version"

    val paging_version = "2.1.2"

    implementation("androidx.paging:paging-runtime-ktx:$paging_version")
    testImplementation("androidx.paging:paging-common-ktx:$paging_version")
    // optional - RxJava support
    implementation("androidx.paging:paging-rxjava2-ktx:$paging_version")

    implementation("androidx.viewpager2:viewpager2:1.0.0")

    implementation("androidx.appcompat:appcompat:1.1.0")
    implementation("androidx.constraintlayout:constraintlayout:1.1.3")
    kapt("androidx.room:room-compiler:$room_version")
    implementation("androidx.room:room-rxjava2:$room_version")
    implementation("androidx.room:room-runtime:$room_version")
    implementation("androidx.room:room-ktx:$room_version")
    testImplementation("androidx.room:room-testing:$room_version")
    implementation("androidx.preference:preference:1.1.1")
    implementation("androidx.preference:preference-ktx:1.1.1")

    testImplementation("junit:junit:4.13")
    androidTestImplementation("androidx.test.ext:junit:1.1.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.2.0")
    implementation(project(path = ":player"))
    implementation("androidx.core:core-ktx:1.3.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.3.72")
    implementation("com.google.android.material:material:1.3.0-alpha01")
    implementation("androidx.recyclerview:recyclerview:1.1.0")
    implementation("androidx.recyclerview:recyclerview-selection:1.1.0-rc01")


    val work_version = "2.3.4"

    // Kotlin + coroutines
    implementation("androidx.work:work-runtime-ktx:$work_version")

    // optional - RxJava2 support
    implementation("androidx.work:work-rxjava2:$work_version")

    // optional - GCMNetworkManager support
//    implementation "androidx.work:work-gcm:$work_version"

    // optional - Test helpers
    androidTestImplementation("androidx.work:work-testing:$work_version")
    implementation("androidx.swiperefreshlayout:swiperefreshlayout:1.1.0")

    implementation("androidx.drawerlayout:drawerlayout:1.1.0")
}
