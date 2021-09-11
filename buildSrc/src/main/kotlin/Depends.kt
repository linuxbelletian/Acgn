
object Depends {


    object AndroidTest {
        const val testRunner = "androidx.test.runner.AndroidJUnitRunner"
        const val room = "androidx.room:room-testing:${Version.Androidx.room}"
        const val work = "androidx.work:work-testing:${Version.Androidx.work}"
        const val extJunit = "androidx.test.ext:junit:${Version.AndroidTest.extJunit}"
        const val espresso = "androidx.test.espresso:espresso-core:${Version.AndroidTest.espresso}"
    }

    object Test {
        const val junit = "junit:junit:${Version.JavaTest.junit}"
    }

    object Androidx {
        const val appcomat = "androidx.appcompat:appcompat:${Version.Androidx.appcompat}"
        const val coreKtx = "androidx.core:core-ktx:${Version.Androidx.coreKtx}"
        const val room = "androidx.room:room-ktx:${Version.Androidx.room}"
        const val roomCompiler = "androidx.room:room-compiler:${Version.Androidx.room}"
        const val navigation = "androidx.navigation:navigation-ui-ktx:${Version.Androidx.navigation}"
        const val work = "androidx.work:work-runtime-ktx:${Version.Androidx.work}"

        // For widget
        const val constraintlayout = "androidx.constraintlayout:constraintlayout:${Version.Androidx.constraintlayout}"
        const val recyclerview = "androidx.recyclerview:recyclerview:${Version.Androidx.recyclerview}"
        const val swiperefreshlayout = "androidx.swiperefreshlayout:swiperefreshlayout:${Version.Androidx.swiperefreshlayout}"
        const val drawerlayout = "androidx.drawerlayout:drawerlayout:${Version.Androidx.drawerlayout}"
    }

    object Google {
        const val material = "com.google.android.material:material:${Version.Google.material}"
        const val hilt = "com.google.dagger:hilt-android:${Version.Androidx.hilt}"
        const val hiltCompiler = "com.google.dagger:hilt-android-compiler:${Version.Androidx.hilt}"
    }

    object Libs {
        val libs = mapOf("dir" to "libs", "include" to listOf("*.jar"))
    }
}