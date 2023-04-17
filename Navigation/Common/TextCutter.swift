import Foundation

class TextCutter {
    func cut(_ text: String, charsAmount:Int = 100, postFixText: String = String(localized: "read full article...")) -> String {
        let listItems = text.components(separatedBy: ", ")
        var returnString = ""
        for item in listItems {
            returnString += item
            if returnString.count >= charsAmount {
                break
            }
        }
        if returnString.count != text.count {
            returnString += " \(postFixText)"
        }
        return returnString
    }
}
