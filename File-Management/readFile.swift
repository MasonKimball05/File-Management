import Foundation
import Combine
#if canImport(UIKit)
import UIKit
#endif

class readFile: ObservableObject {
    @Published var text: String?
    @Published var error: Error?
    @Published var fileURL: URL?
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func readFileContents(fileURL: URL) -> String? {
        isLoading = true
        defer { isLoading = false }
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            self.text = contents
            self.fileURL = fileURL
            self.error = nil
        } catch {
            self.text = nil
            self.fileURL = fileURL
            self.error = error
        }
        return text
    }
    
}
