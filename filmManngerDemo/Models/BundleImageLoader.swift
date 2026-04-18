import UIKit

enum BundleImageLoader {
    /// 递归搜索整个 App Bundle，加载所有匹配扩展名的图片
    static func loadImages(extension ext: String = "jpg") -> [UIImage] {
        let fileManager = FileManager.default
        guard let resourcePath = Bundle.main.resourcePath else {
            print("[BundleImageLoader] Bundle.resourcePath is nil")
            return []
        }

        // 1. 先尝试从 Models 子目录加载
        let modelsPath = (resourcePath as NSString).appendingPathComponent("Models")
        if fileManager.fileExists(atPath: modelsPath),
           let files = try? fileManager.contentsOfDirectory(atPath: modelsPath) {
            let images = files
                .filter { $0.lowercased().hasSuffix(".\(ext.lowercased())") }
                .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
                .compactMap { file -> UIImage? in
                    let fullPath = (modelsPath as NSString).appendingPathComponent(file)
                    return UIImage(contentsOfFile: fullPath)
                }
            if !images.isEmpty {
                print("[BundleImageLoader] 从 Models/ 加载到 \(images.count) 张图片")
                return images
            }
        }

        // 2. 如果 Models 目录没有，递归遍历整个 Bundle
        var imagePaths: [String] = []
        if let enumerator = fileManager.enumerator(atPath: resourcePath) {
            for case let filePath as String in enumerator {
                if filePath.lowercased().hasSuffix(".\(ext.lowercased())") {
                    imagePaths.append((resourcePath as NSString).appendingPathComponent(filePath))
                }
            }
        }

        imagePaths.sort { $0.localizedStandardCompare($1) == .orderedAscending }

        let images = imagePaths.compactMap { path -> UIImage? in
            let image = UIImage(contentsOfFile: path)
            if image == nil {
                print("[BundleImageLoader] 无法加载: \(path)")
            }
            return image
        }

        print("[BundleImageLoader] 从 Bundle 递归加载到 \(images.count) 张图片 (共扫描到 \(imagePaths.count) 个路径)")
        return images
    }

    /// 调试：打印 Bundle 根目录下的所有文件和文件夹
    static func printBundleContents() {
        let fileManager = FileManager.default
        guard let resourcePath = Bundle.main.resourcePath else {
            print("[BundleImageLoader] Bundle.resourcePath is nil")
            return
        }

        print("[BundleImageLoader] Bundle root: \(resourcePath)")
        print("[BundleImageLoader] 根目录内容:")
        if let items = try? fileManager.contentsOfDirectory(atPath: resourcePath) {
            for item in items.sorted() {
                let fullPath = (resourcePath as NSString).appendingPathComponent(item)
                var isDir: ObjCBool = false
                fileManager.fileExists(atPath: fullPath, isDirectory: &isDir)
                print("  \(isDir.boolValue ? "📁" : "📄") \(item)")
            }
        } else {
            print("  (无法读取)")
        }
    }
}
