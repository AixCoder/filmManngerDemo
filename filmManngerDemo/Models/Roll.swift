import Foundation
import UIKit

struct Roll: Identifiable {
    let id: String
    var name: String
    var type: String
    var camera: String?
    var photos: [Photo] = []

    var displayName: String {
        if name.count > 10 {
            return String(name.prefix(10)) + "..."
        }
        return name
    }

    static func filmColor(for type: String) -> UIColor {
        let lower = type.lowercased()
        if lower.contains("fuji") || lower.contains("superia") {
            return Theme.fujiGreen
        }
        if lower.contains("b/w") || lower.contains("hp5") || lower.contains("tmax") {
            return Theme.bwGray
        }
        return Theme.kodakYellow
    }
}
