allprojects {
    repositories {
        google()
        mavenCentral()
        // Fallback mirrors, only contacted if the repositories above fail.
        maven {
            name = "mavenCentralMirror"
            url = uri("https://maven-central.storage-download.googleapis.com/maven2/")
        }
        maven {
            name = "aliyunMirror"
            url = uri("https://maven.aliyun.com/repository/public")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Some older Flutter plugins hard-code an outdated compileSdk
// (e.g. image_cropper 9.1.0 uses 33) while their AndroidX dependencies now
// require 34+. Raise it so their AAR metadata checks pass.
subprojects {
    val raiseCompileSdk = {
        extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.let { android ->
            if ((android.compileSdk ?: 0) < 36) {
                android.compileSdk = 36
            }
        }
    }
    if (state.executed) raiseCompileSdk() else afterEvaluate { raiseCompileSdk() }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
