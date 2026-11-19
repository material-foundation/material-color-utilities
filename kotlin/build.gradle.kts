import org.jetbrains.kotlin.gradle.ExperimentalWasmDsl
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    // Applied below only when client targets are enabled (needs Android SDK).
    alias(libs.plugins.androidMultiplatformLibrary) apply false
}

// Cloud Build / `gcloud run deploy` set these and skip the KMP client; only the JVM target is
// required for :server. Avoid configuring Android/iOS/JS/Wasm there (no SDK / Xcode).
val enableClientTargets =
    System.getenv("GOOGLE_BUILDABLE") == null && System.getenv("GOOGLE_TOOL_ARGUMENTS") == null

if (enableClientTargets) {
    apply(plugin = "com.android.kotlin.multiplatform.library")
}

kotlin {
    // Plain JVM for :server (and any other JVM consumer).
    jvm()

    if (enableClientTargets) {
        listOf(iosArm64(), iosSimulatorArm64()).forEach { iosTarget ->
            iosTarget.binaries.framework {
                baseName = "MaterialColorUtils"
                isStatic = true
            }
        }

        js { browser() }

        @OptIn(ExperimentalWasmDsl::class)
        wasmJs { browser() }

        androidLibrary {
            namespace = "com.google.materialcolorutils"
            compileSdk = libs.versions.android.compileSdk.get().toInt()
            minSdk = libs.versions.android.minSdk.get().toInt()
            compilerOptions {
                jvmTarget = JvmTarget.JVM_11
            }
        }
    }

    sourceSets {
        commonMain {
            kotlin {
                // List source subdirectories explicitly instead of "." to avoid a Gradle
                // task-ordering conflict: wasmJsPublicPackageJson writes package.json to
                // the project root, and srcDirs(".") would make the compiler read that same
                // root — triggering an implicit-dependency warning.
                srcDirs(
                    "blend",
                    "contrast",
                    "dislike",
                    "dynamiccolor",
                    "hct",
                    "palettes",
                    "scheme",
                    "temperature",
                    "utils",
                )
                // StringUtils uses java.text / java.util.Locale — not KMP-compatible
                exclude("StringUtils.kt")
            }
        }
    }
}
