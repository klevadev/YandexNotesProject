//
//  EditNoteViewController.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 02/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

protocol NotesLoader {
    func loadNote(_ note: Note)
}

class EditNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var whiteBox: ColorView!
    @IBOutlet weak var redBox: ColorView!
    @IBOutlet weak var greenBox: ColorView!
    @IBOutlet weak var customBox: ColorView!
    @IBOutlet weak var scrollViewContent: UIScrollView!
    
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    private let datePickerHeight: CGFloat = 150
    
    private enum CurrentColorView {
        case white
        case red
        case green
        case custom
    }
    
    private var currentCustomColor: UIColor? = nil
    private var boxColor: UIColor = .white
    
    var delegate: NotesLoader?
    var note: Note?
    
    private func setCurrentBox(current: CurrentColorView) {
        whiteBox.isChecked = (current == CurrentColorView.white)
        redBox.isChecked = (current == CurrentColorView.red)
        greenBox.isChecked = (current == CurrentColorView.green)
        customBox.isChecked = (current == CurrentColorView.custom)
    }
    
    @IBAction func whiteColorClicked (_ sender: UITapGestureRecognizer) {
        setCurrentBox(current: .white)
        boxColor = .white
        currentCustomColor = nil
    }
    
    @IBAction func redColorClicked (_ sender: UITapGestureRecognizer) {
        setCurrentBox(current: .red)
        boxColor = .red
        currentCustomColor = nil
    }
    
    @IBAction func greenColorClicked (_ sender: UITapGestureRecognizer) {
        setCurrentBox(current: .green)
        boxColor = .green
        currentCustomColor = nil
    }
    
    @IBAction func customColorClicked (_ sender: UITapGestureRecognizer) {
        if currentCustomColor == nil {
            setCurrentBox(current: .custom)
        }
    }
    
    @IBAction func customColorLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            performSegue(withIdentifier: "colorPalette", sender: self)
        }
    }
    
    @IBAction func useDestroyDateDidChange(_ sender: UISwitch) {
        
        self.datePickerHeightConstraint.constant = self.destroyDateSwitch.isOn ? self.datePickerHeight : 0
        self.destroyDatePicker.isHidden = !self.destroyDatePicker.isHidden
        self.destroyDatePicker.alpha = self.destroyDatePicker.isHidden ? 0 : 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorPalette",
           let controller = segue.destination as? ColorPickerViewController {
            
            controller.delegate = self
            
            if customBox.isGradient {
                controller.selectedColor = .red
            } else {
                controller.selectedColor = currentCustomColor
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        scrollViewContent.contentInset.bottom = 0
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollViewContent.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        scrollViewContent.contentInset.bottom = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(editNote))
        
        loadNoteData()
        
        upadteUI()
    }
    
    func upadteUI() {
        self.contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentTextView.layer.borderWidth = 1
        self.datePickerHeightConstraint.constant = destroyDateSwitch.isOn ? datePickerHeight : 0
    }
}

// MARK: - ChangeColorDelegate
extension EditNoteViewController: ChangeColorDelegate {
    func userSelectedAColor(_ color: UIColor) {
        customBox.isGradient = false
        customBox.backgroundColor = color
        currentCustomColor = color
        setCurrentBox(current: .custom)
    }
}

// MARK: - EditNoteViewController Operations
extension EditNoteViewController {
    private func loadNoteData() {
        guard let note = note else {
            title = "Новая заметка"
            whiteBox.isChecked = true
            navigationItem.rightBarButtonItem?.title = "Add"
            destroyDatePicker.isHidden = true
            destroyDateSwitch.setOn(false, animated: true)
            return
        }
        
        navigationItem.rightBarButtonItem?.title = "Save"
        
        title = note.title
        titleTextField.text = note.title
        contentTextView.text = note.content
        if let destructionDate = note.selfDestructionDate {
            destroyDatePicker.setDate(destructionDate, animated: true)
            destroyDateSwitch.setOn(true, animated: true)
        } else {
            destroyDatePicker.setDate(Date(), animated: false)
            self.destroyDatePicker.isHidden = true
            print("Дата ноль")
        }
        
        switch note.color {
        case .white:
            whiteBox.isChecked = true
        case .red:
            redBox.isChecked = true
        case .green:
            greenBox.isChecked = true
        default:
            currentCustomColor = note.color
            customBox.isGradient = false
            customBox.backgroundColor = note.color
            customBox.isChecked = true
        }
        
    }
    
    @objc private func editNote() {
        guard let title = titleTextField.text, title != "",
              let content = contentTextView.text
        else {
            titleTextField.placeholder = "Пустое поле!"
            return
        }
        
        let uid: String
        if let note = note {
            uid = note.uid
        } else {
            uid = UUID().uuidString
        }
        
        var noteColor: UIColor = .white
        
        if let color = currentCustomColor {
            noteColor = color
        } else {
            noteColor = boxColor
        }
        
        let destructionDate = destroyDateSwitch.isOn ? destroyDatePicker.date : nil
        
        let note = Note(uid: uid, title: title, content: content, color: noteColor, selfDestructionDate: destructionDate)
        
        delegate?.loadNote(note)
        
        performSegue(withIdentifier: "backToNotes", sender: nil)
    }
    
}

