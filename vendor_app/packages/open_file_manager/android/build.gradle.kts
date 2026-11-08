import com.android.build.gradle.LibraryExtension
import groovy.lang.GroovyObject
import org.gradle.kotlin.dsl.configure
import org.gradle.kotlin.dsl.withGroovyBuilder

group = "com.aubergine.open_file_manager"
version = "1.0-SNAPSHOT"

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.5.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

fun GroovyObject.intProperty(name: String): Int {
    val value = getProperty(name)
    return when (value) {
        is Number -> value.toInt()
        is String -> value.toInt()
        else -> error("Property '$name' is not an Int-compatible value: $value")
    }
}

val agpVersion = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION
    .substringBefore('.')
    .toInt()
val builtInKotlinProperty = providers.gradleProperty("android.builtInKotlin").orNull
val isBuiltInKotlinEnabled = agpVersion >= 9 &&
    (builtInKotlinProperty == null || builtInKotlinProperty.toBoolean())
val shouldApplyKotlinAndroidPlugin = agpVersion < 9 || !isBuiltInKotlinEnabled

apply(plugin = "com.android.library")
if (shouldApplyKotlinAndroidPlugin) {
    apply(plugin = "org.jetbrains.kotlin.android")
}

val flutterExtension = extensions.getByName("flutter") as GroovyObject
val flutterCompileSdkVersion = flutterExtension.intProperty("compileSdkVersion")

configure<LibraryExtension> {
    compileSdk = flutterCompileSdkVersion
    namespace = "com.aubergine.open_file_manager"

    defaultConfig {
        minSdk = 21
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    if (shouldApplyKotlinAndroidPlugin) {
        withGroovyBuilder {
            "kotlinOptions" {
                setProperty("jvmTarget", JavaVersion.VERSION_17.toString())
            }
        }
    }
}

dependencies {
    add("implementation", "androidx.core:core-ktx:1.12.0")
}
