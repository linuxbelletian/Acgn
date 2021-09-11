plugins {
    id("com.android.library")
    id("kotlin-android")
}

android {
    compileSdk = Version.Android.compileSdk
    buildToolsVersion = Version.Android.buildTool
    ndkVersion = Version.Android.ndkVersion

    defaultConfig {
        minSdk = Version.Android.minSdk
        targetSdk = Version.Android.targetSdk

        testInstrumentationRunner = Depends.AndroidTest.testRunner
        consumerProguardFiles("consumer-rules.pro")

        ndk {
            abiFilters += "arm64-v8a"
            abiFilters += "x86_64"
        }

        externalNativeBuild {
            cmake {
                cppFlags("-std=c++11")
            }
        }
    }

    buildTypes {
        getByName("debug") {

        }
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.21.2"
        }
    }

    splits {
        abi {
            reset()
            include("x86_64", "arm64-v8a") //select ABIs to build APKs for
//            include 'x86_64' //select ABIs to build APKs for
        }
    }
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))

    implementation("androidx.appcompat:appcompat:${Version.Androidx.appcompat}")
    testImplementation("junit:junit:${Version.JavaTest.junit}")
    androidTestImplementation("androidx.test.ext:junit:${Version.AndroidTest.extJunit}")
    androidTestImplementation("androidx.test.espresso:espresso-core:${Version.AndroidTest.espresso}")
    implementation("androidx.core:core-ktx:${Version.Androidx.coreKtx}")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:${Version.Kotlin.kotlinVersion}")
}
