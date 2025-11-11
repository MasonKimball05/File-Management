//
//  CreateFile.swift
//  File-Management
//
//  Created by Mason Kimball on 11/11/25.
//
import Foundation

let filename = "formatted_names.txt"
let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let fileURL = documentsDir.appendingPathComponent(filename)


func createFile() {
    let content = "Some text here"

    do {
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        print("File created and written successfully at \(fileURL.path)")
    } catch {
        print("Failed to write to file: \(error)")
    }
}
