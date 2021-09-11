// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {

    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:${Version.Android.gradlePlugin}")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${Version.Kotlin.gradlePlugin}")
        classpath("com.google.dagger:hilt-android-gradle-plugin:${Version.Androidx.hilt}")
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle.kts files
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
