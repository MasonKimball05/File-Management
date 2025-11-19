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
                                Text(["First", "Last", "Address", "City", "State", "ZIP", "DOB", "Phone"][colIndex])
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

enum FileType: String, CaseIterable {
    case txt = "TXT"
    case json = "JSON"
}

struct FileViewer: View {
    @State private var selectedFileType: FileType = .txt
    @State private var fileContents: String = ""
    @State private var showTable = false
    @State private var tableData: [[String]] = []
    
    var currentFileURL: URL {
        selectedFileType == .txt ? txtfileURL : jsonfileURL
    }
    
    var body: some View {
        VStack {
            // File type selector
            Picker("File Type", selection: $selectedFileType) {
                ForEach(FileType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedFileType) { _ in
                refreshContents()
            }
            
            TextEditor(text: $fileContents)
                .padding()
                .frame(minHeight: 300)
            
            HStack {
                Button("Reset File") {
                    if selectedFileType == .txt {
                        createFile()
                    } else {
                        createjsonFile()
                    }
                    refreshContents()
                }
                
                Button("Append 50 Lines") {
                    if selectedFileType == .txt {
                        appendFile()
                    } else {
                        appendtoJsonFile()
                    }
                    refreshContents()
                }
                
                Button("Show Table") {
                    // First close any existing sheet
                    showTable = false
                    
                    // Small delay to ensure sheet is closed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        // Check if file exists, create it if not
                        if !FileManager.default.fileExists(atPath: currentFileURL.path) {
                            print("File doesn't exist, creating it...")
                            if selectedFileType == .txt {
                                createFile()
                            } else {
                                createjsonFile()
                            }
                            refreshContents()
                        }
                        
                        let array = selectedFileType == .txt ? fileArray() : jsonFileArray()
                        
                        print("Array count: \(array.count)")
                        print("First row: \(array.first ?? [])")
                        
                        if array.isEmpty {
                            print("Array is empty, creating file with data...")
                            // File exists but is empty, create data
                            if selectedFileType == .txt {
                                createFile()
                            } else {
                                createjsonFile()
                            }
                            refreshContents()
                            
                            // Try reading again after creating
                            let newArray = selectedFileType == .txt ? fileArray() : jsonFileArray()
                            tableData = newArray
                        } else {
                            tableData = array
                        }
                        
                        // Show table
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            print("DEBUG - tableData now has \(tableData.count) rows")
                            showTable = true
                        }
                        
                        printFormattedArray(tableData)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            refreshContents()
            // Create files if they don't exist
            if !FileManager.default.fileExists(atPath: txtfileURL.path) {
                createFile()
            }
            if !FileManager.default.fileExists(atPath: jsonfileURL.path) {
                createjsonFile()
            }
        }
        .sheet(isPresented: $showTable) {
            if !tableData.isEmpty {
                TableDisplayView(data: tableData)
            } else {
                VStack {
                    Text("No data to display")
                        .font(.title)
                        .padding()
                    Button("Close") {
                        showTable = false
                    }
                    .padding()
                }
            }
        }
    }
    
    func refreshContents() {
        do {
            fileContents = try String(contentsOf: currentFileURL)
        } catch {
            fileContents = "File not found. Click 'Reset File' to create it."
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
