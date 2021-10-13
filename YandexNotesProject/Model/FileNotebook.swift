//
//  FileNotebook.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 02/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import Foundation

class FileNotebook {
    
    let filename: String
    private(set) var notes : [Note] = []
    
    
    public func add (_ note: Note) {
        var isAppend = true
        //  проверка на дублирование uid.
        for (index, _) in notes.enumerated() {
            if notes[index].uid == note.uid {
                // перезапись заметки при дублировании uid.
                notes[index] = note
                isAppend = false
            }
        }
        
        if isAppend {
            notes.append(note)
        }
    }
    
    public func remove(with uid: String) {
        notes.removeAll(where: {
            $0.uid == uid
        })
    }
    
    public func saveToFile() {
        var tempArray : Array<Any> = []
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let filePath = path!.path + "/" + "\(filename).json"
        
        // проверка наличия директории и создание ее, если она отсутствует.
        if !FileManager.default.fileExists(atPath: path!.path) {
            do {
                try FileManager.default.createDirectory(at: path!, withIntermediateDirectories: true, attributes:nil)
            } catch let error {
                print("Error create directory: \(error)")
            }
        }
        
        for note in notes {
            tempArray.append(note.json)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tempArray, options: .prettyPrinted)
            FileManager.default.createFile(atPath: filePath, contents: jsonData, attributes: nil)
            // обработка ошибки JSONSerialization
        } catch let error {
            print("JSON data error: \(error)")
        }
    }
    
    public func loadFromFile() {
        notes.removeAll()
        
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let filePath = path!.path + "/" + "\(filename).json"
        
        // проверка на наличие файла
        if !FileManager.default.fileExists(atPath: filePath){
            print("Path error! File doesn't exist")
        } else {
            let data = FileManager.default.contents(atPath: filePath) ?? nil
            
            do {
                let decoded = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<Any>
                
                for item in decoded {
                    notes.append(Note.parse(json: item as! [String : Any])!)
                }
                // обработка ошибки JSONSerialization
            } catch let error {
                print("JSON decoded error: \(error)")
            }
        }
    }
    
    init(filename: String) {
        self.filename = filename
    }
}
