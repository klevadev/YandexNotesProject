//
//  YandexNotesProjectTests.swift
//  YandexNotesProjectTests
//
//  Created by Lev Kolesnikov on 02/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import XCTest
@testable import YandexNotesProject

class YandexNotesProjectTests: XCTestCase {
    
    //        let filename = "output"
    var testNotebook: FileNotebook!
    
    override func setUp() {
        super.setUp()
        testNotebook = FileNotebook(filename: "output")
    }
    
    override func tearDown() {
        testNotebook = nil
        super.tearDown()
    }
    
    func testFileNotebook_isClass() {
        guard let fn = testNotebook, let displayStyle = Mirror(reflecting: fn).displayStyle else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(displayStyle, .class)
    }
    
    func testFileNotebook_whenInitialized_notesIsEmpty() {
        XCTAssertTrue(testNotebook.notes.isEmpty)
    }
    
    func testFileNotebook_whenAddNote_noteSavedInNotes() {
        let schoolNote = Note(title: "School", content: "Do Homework", importance: .common)
        testNotebook.add(schoolNote)
        
        let notes = testNotebook.notes
        
        XCTAssertEqual(notes.count, 1)
        
        let checkedNote = getNote(by: schoolNote.uid, from: notes)
        
        XCTAssertNotNil(checkedNote)
    }
    
    func testFileNotebook_whenAddNote_noteSavedInNotesWithAllInfo() {
        let schoolNote = Note(title: "School", content: "Do Homework", importance: .common)
        testNotebook.add(schoolNote)
        
        guard let checkedNote = getNote(by: schoolNote.uid, from: testNotebook.notes) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(schoolNote.uid, checkedNote.uid)
        XCTAssertEqual(schoolNote.title, checkedNote.title)
        XCTAssertEqual(schoolNote.content, checkedNote.content)
        XCTAssertEqual(schoolNote.importance, checkedNote.importance)
        XCTAssertEqual(schoolNote.color, checkedNote.color)
        
        XCTAssertNil(schoolNote.selfDestructionDate)
        XCTAssertNil(checkedNote.selfDestructionDate)
    }
    
    func testFileNotebook_whenAddNoteWithChangedInfo_updateNoteInNotes() {
        let schoolNote = Note(title: "School", content: "Do Homework", importance: .common)
        testNotebook.add(schoolNote)
        
        let programmingNote = Note(uid: schoolNote.uid, title: "Programming", content: "Do test case", color: .red, importance: .common, selfDestructionDate: Date())
        testNotebook.add(programmingNote)
        
        guard let checkedNote = getNote(by: programmingNote.uid, from: testNotebook.notes) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(programmingNote.uid, checkedNote.uid)
        XCTAssertEqual(programmingNote.title, checkedNote.title)
        XCTAssertEqual(programmingNote.content, checkedNote.content)
        XCTAssertEqual(programmingNote.importance, checkedNote.importance)
        XCTAssertEqual(programmingNote.color, checkedNote.color)
        
        XCTAssertNotNil(checkedNote.selfDestructionDate)
        
        guard let checkedDate = checkedNote.selfDestructionDate, let date = programmingNote.selfDestructionDate else {
            return
        }
        
        XCTAssertEqual(checkedDate, date)
    }
    
    
    func testFileNotebook_whenDeleteNote_noteRemoveFromNotes() {
        let schoolNote = Note(title: "School", content: "Do Homework", importance: .common)
        testNotebook.add(schoolNote)
        testNotebook.remove(with: schoolNote.uid)
        
        let notes = testNotebook.notes
        
        XCTAssertTrue(notes.isEmpty)
    }
    
    func testFileNotebook_whenSaveToFileAndLoadFromFile_correctRestoreNotes() {
        let schoolNote = Note(title: "School", content: "Do Homework", importance: .common)
        testNotebook.add(schoolNote)
        
        let programmingNote = Note(title: "Programming", content: "Do test case", color: .red, importance: .important, selfDestructionDate: Date())
        testNotebook.add(programmingNote)
        
        
        testNotebook.saveToFile()
        
        testNotebook.remove(with: schoolNote.uid)
        testNotebook.remove(with: programmingNote.uid)
        
        XCTAssertTrue(testNotebook.notes.isEmpty)
        
        let sportNote = Note(title: "Sport", content: "20 pull ups", color: .green, importance: .insignificant , selfDestructionDate: Date())
        testNotebook.add(sportNote)
        
        testNotebook.loadFromFile()
        
        let notes = testNotebook.notes
        XCTAssertEqual(notes.count, 2)
        XCTAssertNotNil(getNote(by: schoolNote.uid, from: notes))
        XCTAssertNotNil(getNote(by: programmingNote.uid, from: notes))
    }
    
    func testFileNotebook_whenSaveToFileAndLoadFromFile_equalsRestoredNotes() {
        let schoolNote = Note(title: "School", content: "Do Homework", importance: .common)
        testNotebook.add(schoolNote)
        
        let programmingNote = Note(title: "Programming", content: "Do test case", color: .red, importance: .important, selfDestructionDate: Date())
        testNotebook.add(programmingNote)
        
        testNotebook.saveToFile()
        
        testNotebook.loadFromFile()
        
        let notes = testNotebook.notes
        
        guard let checkedNote = getNote(by: schoolNote.uid, from: notes),
            let checkedNote2 = getNote(by: programmingNote.uid, from: notes) else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(schoolNote.uid, checkedNote.uid)
        XCTAssertEqual(schoolNote.title, checkedNote.title)
        XCTAssertEqual(schoolNote.content, checkedNote.content)
        XCTAssertEqual(schoolNote.importance, checkedNote.importance)
        XCTAssertEqual(schoolNote.color, checkedNote.color)
        
        XCTAssertNil(checkedNote.selfDestructionDate)
        
        guard let checkedDate = checkedNote.selfDestructionDate, let date = schoolNote.selfDestructionDate else {
            return
        }
        
        XCTAssertEqual(checkedDate, date)
        
        
        XCTAssertEqual(programmingNote.uid, checkedNote2.uid)
        XCTAssertEqual(programmingNote.title, checkedNote2.title)
        XCTAssertEqual(programmingNote.content, checkedNote2.content)
        XCTAssertEqual(programmingNote.importance, checkedNote2.importance)
        XCTAssertEqual(programmingNote.color, checkedNote2.color)
        
        XCTAssertNotNil(checkedNote.selfDestructionDate)
        
        guard let checkedDate2 = checkedNote2.selfDestructionDate, let date2 = programmingNote.selfDestructionDate else {
            return
        }
        
        XCTAssertEqual(checkedDate2, date2)
        
    }
    
    
    private func getNote(by uid: String, from notes:Any) -> Note? {
        if let notes = notes as? [String: Note] {
            return notes[uid]
        }
        
        if let notes = notes as? [Note] {
            return notes.filter { $0.uid == uid }.first
        }
        
        return nil
    }

}
