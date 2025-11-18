import SwiftUI

struct TableDisplayView: View {
    let data: [[String]]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("File Array Table - \(data.count) rows")
                    .font(.title)
                    .padding()
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .padding()
            }
            
            if data.isEmpty {
                Text("No data to display")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView([.horizontal, .vertical]) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header row
                        HStack(spacing: 0) {
                            Text("Row")
                                .fontWeight(.bold)
                                .frame(width: 50)
                                .padding(8)
                                .background(Color.blue.opacity(0.2))
                                .border(Color.gray, width: 1)
                            
                            ForEach(0..<(data.first?.count ?? 0), id: \.self) { colIndex in
                                Text("Col \(colIndex)")
                                    .fontWeight(.bold)
                                    .frame(minWidth: 120, alignment: .leading)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .border(Color.gray, width: 1)
                            }
                        }
                        
                        // Data rows
                        ForEach(data.indices, id: \.self) { rowIndex in
                            HStack(spacing: 0) {
                                // Row number
                                Text("\(rowIndex)")
                                    .frame(width: 50)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .border(Color.gray, width: 1)
                                
                                // Data columns
                                ForEach(data[rowIndex].indices, id: \.self) { colIndex in
                                    Text(data[rowIndex][colIndex])
                                        .frame(minWidth: 120, alignment: .leading)
                                        .padding(8)
                                        .border(Color.gray, width: 1)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct FileViewer: View {
    let fileURL: URL
    @State private var fileContents: String = ""
    @State private var showTable = false
    @State private var tableData: [[String]] = []
    
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
                Button("Get File Array") {
                    let array = fileArray()
                    
                    print("Array count: \(array.count)")
                    print("First row: \(array.first ?? [])")
                    
                    // Set data first
                    tableData = array
                    
                    // Then show sheet after a tiny delay
                    DispatchQueue.main.async {
                        print("DEBUG - tableData now has \(tableData.count) rows")
                        showTable = true
                    }
                    
                    printFormattedArray(array)
                }
            }
            .padding()
        }
        .onAppear(perform: refreshContents)
        .sheet(isPresented: $showTable) {
            TableDisplayView(data: tableData)
        }
    }
    
    func refreshContents() {
        do {
            fileContents = try String(contentsOf: fileURL)
        } catch {
            fileContents = "Failed to load file: \(error.localizedDescription)"
        }
    }
    
    func printFormattedArray(_ array: [[String]]) {
        print("\n=== File Array Table ===")
        for (index, row) in array.enumerated() {
            print("Row \(index): [\(row.joined(separator: " | "))]")
        }
        print("========================\n")
    }
}
