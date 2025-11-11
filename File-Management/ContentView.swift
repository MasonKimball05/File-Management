import SwiftUI

struct FileViewer: View {
    let fileURL: URL
    @State private var fileContents: String = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $fileContents)
                .padding()
                .frame(minHeight: 300)
            
            HStack {
                Button("Refresh File") {
                    refreshContents()
                }
                Button("Append 50 Lines") {
                    appendFile()
                    refreshContents()
                }
                Button("Reset File") {
                    createFile()
                    refreshContents()
                }
            }
            .padding()
        }
        .onAppear(perform: refreshContents)
    }
    
    func refreshContents() {
        do {
            fileContents = try String(contentsOf: fileURL)
        } catch {
            fileContents = "Failed to load file: \(error.localizedDescription)"
        }
    }
}
