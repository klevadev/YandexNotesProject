//
//  Notes.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 20/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import Foundation

class Notes {
    private(set) var data = [Note]()
    
    func add(_ note: Note) {
        let noteExists = data.contains { (item) -> Bool in
            return item.uid == note.uid
        }
        
        if !noteExists {
            data.insert(note, at: 0)
        } else {
            print("Заметка уже существует!")
        }
    }
    
    func remove(with uid: String) {
        data.removeAll(where: {
            $0.uid == uid
        })
    }
    
    static func initialNotes() -> Notes {
        let notes = Notes()
        
        let note1 = Note(title: "Матан", content: "Подготовиться к поступлению в магистратуру", color: .red, importance: .important, selfDestructionDate: Date())
        let note2 = Note(title: "Психология", content: "Бихевиоризм – одно из направлений социальной психологии, которое рассматривает поведение человека как результат воздействия факторов окружающей среды. Используется в современной психотерапии для лечения навязчивых страхов (фобий). Ригидность (лат. rigidus — жесткий, твердый) – в психологии термин служит для обозначения невозможности личности адаптироваться к новым условиям, продиктованным объективными изменениями извне. Степень проявления ригидности зависит как от психологических характеристик конкретной личности, так и от особенностей ситуации, которая требует адаптации. Фрустра́ция (лат. frustratio — «обман», «неудача», «тщетное ожидание», «расстройство замыслов») — психическое состояние, возникающее в ситуации реальной или предполагаемой невозможности удовлетворения тех или иных потребностей, или, проще говоря, в ситуации несоответствия желаний имеющимся возможностям. ", color: .yellow, importance: .important, selfDestructionDate: Date())
        let note3 = Note(title: "Документы в ГАИ", content: "паспорт, права, снилс и прочее", color: .purple, importance: .important, selfDestructionDate: Date())
        let note4 = Note(title: "Короткая заметка", content: "Купить новую книгу", color: .blue, importance: .important, selfDestructionDate: Date())
        let note5 = Note(title: "Заметка с белым цветом", content: "Я - белая заметка", color: .white, importance: .important, selfDestructionDate: Date())
        
        
        notes.add(note1)
        notes.add(note2)
        notes.add(note3)
        notes.add(note4)
        notes.add(note5)
        
        return notes
        
    }
    
    @discardableResult func edit(_ note: Note) -> Int? {
        let _notePosition = data.firstIndex { $0.uid == note.uid }
        
        if let notePosition = _notePosition {
            remove(with: note.uid)
            data.insert(note, at: notePosition)
            return notePosition
        } else {
            return nil
        }
    }
    
    func get(_ index: Int) -> Note {
        return data[index]
    }
}
