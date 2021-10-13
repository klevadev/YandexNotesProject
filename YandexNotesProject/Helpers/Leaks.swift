//
//  MemoryLeaks.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 02/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import Foundation

//Специальный файл с классами для того, чтобы затригерить утечку памяти.

class Student {
    let name: String
    var laptop: Laptop?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) освобождается ")
    }
}

class Laptop {
    let model: String
//    если weak, то утечки не будет. Если убрать, то будет.
    weak var owner: Student?
    
    init(model: String) {
        self.model = model
    }
    
    deinit {
        print("Ноутбук модели \(model) освобождается")
    }
}
