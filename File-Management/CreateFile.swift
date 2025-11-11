//
//  CreateFile.swift
//  File-Management
//
//  Created by Mason Kimball on 11/11/25.
//
import Foundation
import AppKit

let filename = "formatted_names.txt"
let desktopURL = URL(
    fileURLWithPath: NSHomeDirectory()
    ).appendingPathComponent("Documents")

let fileURL = desktopURL.appendingPathComponent(filename)

func createContent() -> [String] {
    let firstNames = ["Liam", "Olivia", "Noah", "Emma", "Ava", "James", "Sophia", "Lucas", "Isabella", "Mason"]
    let lastNames = ["Smith", "Johnson", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Wilson"]

    let street = [
        "123 Maple St", "45 Oak Ave", "678 Pine Rd", "89 Birch Blvd", "12 Cedar Ct",
        "56 Elm St", "90 Willow Way", "34 Aspen Dr", "77 Cherry Ln", "5 Walnut Pl"
    ]

    let city = [
        "New York", "Los Angeles", "Chicago", "Houston", "Phoenix",
        "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose"
    ]

    let state = [
        "NY", "CA", "IL", "TX", "AZ", "PA", "TX", "CA", "TX", "CA"
    ]

    let zipCode = (0..<10).map { _ in
        String(format: "%05d", Int.random(in: 10000...99999))
    }
    let dob = (0..<10).map { _ in
        let year = Int.random(in: 1970...2005)
        let month = Int.random(in: 1...12)
        let day = Int.random(in: 1...28)
        return String(format: "%02d-%02d-%04d", day, month, year)
    }

    let phoneNumber = (0..<10).map { _ in
        String(format: "(%03d) %03d-%04d",
               Int.random(in: 200...999),
               Int.random(in: 100...999),
               Int.random(in: 1000...9999))
    }
    let fn = firstNames.randomElement()!
    let ln = lastNames.randomElement()!
    let st = street.randomElement()!
    let c = city.randomElement()!
    let stt = state.randomElement()!
    let zc = zipCode.randomElement()!
    let d = dob.randomElement()!
    let p = phoneNumber.randomElement()!
    
    return [fn, ln, st, c, stt, zc, d, p]
}

func createFile() {
    // Ensure the file exists before appending
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
    } else {
        let emptyString = ""
        do {
            try emptyString.write(to: fileURL, atomically: false, encoding: .utf8)
            print("File contents cleared successfully at: \(fileURL)")
        } catch {
            print("Error clearing file contents: \(error.localizedDescription)")
        }
    }

    for i in 1...100 {
        let content = "\(i)) " + createContent().joined(separator: ", ") + "\n"

        do {
            // Open file for appending
            let handle = try FileHandle(forWritingTo: fileURL)
            handle.seekToEndOfFile() // Move pointer to end
            if let data = content.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        } catch {
            print("Failed to write to file: \(error)")
        }
    }

    print("File appended successfully at \(fileURL.path)")
    
    NSWorkspace.shared.open(fileURL)
}

func appendFile() {
    
    for i in 1...50 {
        let content = "\(i + 100)) " + createContent().joined(separator: ", ") + "\n"
        
        do {
            // Open file for appending
            let handle = try FileHandle(forWritingTo: fileURL)
            handle.seekToEndOfFile() // Move pointer to end
            if let data = content.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        } catch {
            print("Failed to write to file: \(error)")
        }
    }
    NSWorkspace.shared.open(fileURL)
}
