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

// Cấu hình đồng bộ compileSdk cho tất cả subprojects
subprojects {
    // Sử dụng afterEvaluate nhưng thay đổi cách truy cập extension để tránh lỗi "too late"
    afterEvaluate {
        val androidExtension = project.extensions.findByName("android")
        if (androidExtension is com.android.build.gradle.BaseExtension) {
            androidExtension.apply {
                compileSdkVersion(34)
                buildToolsVersion("34.0.0")

                // Xử lý lỗi namespace cho các plugin cũ như app_links
                if (namespace == null) {
                    namespace = "com.extractor.application.${project.name.replace("-", "_")}"
                }
            }
        }
    }
}
