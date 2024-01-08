import Foundation

struct AddTask: Codable {
    var taskTitle: String = ""
    var taskDetail: String = ""
    var isChecked: Bool = false
}
