//
//  CreateFile.swift
//  File-Management
//
//  Created by Mason Kimball on 11/11/25.
//
import Foundation
import AppKit

let txtfilename = "formatted_names.txt"
let jsonfilename = "formatted_names.json"
let documentsURL = URL(
    fileURLWithPath: NSHomeDirectory()
    ).appendingPathComponent("Documents")

let txtfileURL = documentsURL.appendingPathComponent(txtfilename)
let jsonfileURL = documentsURL.appendingPathComponent(jsonfilename)

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

// TXT FILE FUNCTIONS

func createFile() {
    // Ensure the file exists before appending
    if !FileManager.default.fileExists(atPath: txtfileURL.path) {
        FileManager.default.createFile(atPath: txtfileURL.path, contents: nil)
    } else {
        let emptyString = ""
        do {
            try emptyString.write(to: txtfileURL, atomically: false, encoding: .utf8)
            print("File contents cleared successfully at: \(txtfileURL)")
        } catch {
            print("Error clearing file contents: \(error.localizedDescription)")
        }
    }

    for _ in 1...100 {
        let content = createContent().joined(separator: ", ") + "\n"

        do {
            // Open file for appending
            let handle = try FileHandle(forWritingTo: txtfileURL)
            handle.seekToEndOfFile() // Move pointer to end
            if let data = content.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        } catch {
            print("Failed to write to file: \(error)")
        }
    }

    print("File appended successfully at \(txtfileURL.path)")
    
    NotificationCenter.default.post(name: .fileDidUpdate, object: nil)
}

func appendFile() {
    for _ in 1...50 {
        let content = createContent().joined(separator: ", ") + "\n"
        
        do {
            // Open file for appending
            let handle = try FileHandle(forWritingTo: txtfileURL)
            handle.seekToEndOfFile() // Move pointer to end
            if let data = content.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        } catch {
            print("Failed to write to file: \(error)")
        }
    }
}

func fileArray() -> [[String]] {
    var fileData: [[String]] = []
    
    do {
        let content = try String(contentsOf: txtfileURL, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            // Skip empty lines
            if !line.isEmpty {
                let components = line.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                fileData.append(components)
            }
        }
        
    } catch {
        print("Error reading file: \(error.localizedDescription)")
    }
    
    return fileData
}

// JSON FILE FUNCTIONS

func createjsonFile() {
    // Create array of dictionaries
    var jsonArray: [[String: String]] = []
    
    for _ in 1...100 {
        let content = createContent()
        let person: [String: String] = [
            "firstName": content[0],
            "lastName": content[1],
            "address": content[2],
            "city": content[3],
            "state": content[4],
            "zip": content[5],
            "dob": content[6],
            "phone": content[7]
        ]
        jsonArray.append(person)
    }
    
    do {
        // Convert to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        
        // Write to file
        try jsonData.write(to: jsonfileURL)
        print("JSON file created successfully at: \(jsonfileURL)")
    } catch {
        print("Error creating JSON file: \(error.localizedDescription)")
    }
    
    NotificationCenter.default.post(name: .fileDidUpdate, object: nil)
}

func appendtoJsonFile() {
    do {
        // Read existing JSON
        let existingData = try Data(contentsOf: jsonfileURL)
        var jsonArray = try JSONSerialization.jsonObject(with: existingData) as? [[String: String]] ?? []
        
        // Add 50 new entries
        for _ in 1...50 {
            let content = createContent()
            let person: [String: String] = [
                "firstName": content[0],
                "lastName": content[1],
                "address": content[2],
                "city": content[3],
                "state": content[4],
                "zip": content[5],
                "dob": content[6],
                "phone": content[7]
            ]
            jsonArray.append(person)
        }
        
        // Write back to file
        let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        try jsonData.write(to: jsonfileURL)
        print("JSON file appended successfully at \(jsonfileURL.path)")
    } catch {
        print("Error appending to JSON file: \(error.localizedDescription)")
    }
    
    NotificationCenter.default.post(name: .fileDidUpdate, object: nil)
}

func jsonFileArray() -> [[String]] {
    var fileData: [[String]] = []
    
    do {
        let jsonData = try Data(contentsOf: jsonfileURL)
        let jsonArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: String]] ?? []
        
        for person in jsonArray {
            let row = [
                person["firstName"] ?? "",
                person["lastName"] ?? "",
                person["address"] ?? "",
                person["city"] ?? "",
                person["state"] ?? "",
                person["zip"] ?? "",
                person["dob"] ?? "",
                person["phone"] ?? ""
            ]
            fileData.append(row)
        }
        
    } catch {
        print("Error reading JSON file: \(error.localizedDescription)")
    }
    
    return fileData
}

extension Notification.Name {
    static let fileDidUpdate = Notification.Name("fileDidUpdate")
}
