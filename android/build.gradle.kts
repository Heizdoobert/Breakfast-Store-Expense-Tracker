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

// Đoạn mã đã được sửa sang cú pháp Kotlin DSL chuẩn
subprojects {
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(34)
                buildToolsVersion("34.0.0")
                
                // Sửa lỗi namespace cho các thư viện cũ như app_links
                if (namespace == null) {
                    namespace = "com.extractor.application.${project.name.replace("-", "_")}"
                }
            }
        }
    }
}
