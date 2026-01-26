allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    plugins.withType<com.android.build.gradle.api.AndroidBasePlugin> {
        configure<com.android.build.gradle.BaseExtension> {
            compileSdkVersion(34)
            buildToolsVersion("34.0.0")

            try {
                if (this is com.android.build.gradle.LibraryExtension || this is com.android.build.gradle.AppExtension) {
                    if (namespace == null) {
                        namespace = "com.extractor.application.${project.name.replace("-", "_")}"
                    }
                }
            } catch (e: Exception) {
            }
        }
    }
}
