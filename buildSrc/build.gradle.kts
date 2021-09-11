import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.config.KotlinCompilerVersion

plugins {
    `kotlin-dsl`
//    id("org.gradle.kotlin.kotlin-dsl") version "2.1.6"
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib-jdk7", KotlinCompilerVersion.VERSION))
}
val compileKotlin: KotlinCompile by tasks
compileKotlin.kotlinOptions {
    jvmTarget = "1.8"
}
val compileTestKotlin: KotlinCompile by tasks
compileTestKotlin.kotlinOptions {
    jvmTarget = "1.8"
}