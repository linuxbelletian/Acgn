object Version {
    object Kotlin {
        const val kotlinVersion = "1.5.30"

        const val gradlePlugin = kotlinVersion
    }

    object Android {
        const val gradlePlugin = "7.0.2"
        const val buildTool = "30.0.3"
        const val targetSdk = 30
        const val minSdk = 29
        const val ndkVersion = "23.0.7599858"
        const val compileSdk = targetSdk
    }

    object Androidx {
        const val appcompat = "1.1.0"
        const val lifecycle = "2.2.0"
        const val navigation = "2.3.0"
        const val arch = "2.1.0"
        const val coreKtx = "1.3.1"
        const val room = "2.2.5"
        const val paging = "3.0.0"
        const val viewpager2 = "1.0.0"
        const val constraintlayout = "2.0.4"
        const val preference = "1.1.1"
        const val recyclerview = "1.2.0"
        const val recyclerviewSelection = "1.1.0"
        const val work = "2.3.4"
        const val swiperefreshlayout = "1.1.0"
        const val drawerlayout = "1.1.0"
        const val hilt = "2.36"
    }

    object Google {
        const val material = "1.3.0"
    }

    object AndroidTest {
        const val extJunit = "1.1.1"
        const val espresso = "3.2.0"
        const val roomTesting = Androidx.room
    }

    object JavaTest {
        const val junit = "4.13"
    }
}