//
//  DueDatePicker.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-19.
//
import Foundation
import SwiftUI

struct DueDatePicker: UIViewRepresentable {
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    private let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()
    public var placeholder : String
    var backgroundColor: UIColor = .white
    @Binding public var date: Date?
    func makeUIView(context: Context) ->  UITextField {
        let now = Date()
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)
        self.datePicker.minimumDate = now
        self.textField.text = ""
        self.textField.placeholder = self.placeholder
        self.textField.inputView = self.datePicker
        self.textField.layer.cornerRadius = 5
        self.textField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.textField.layer.borderWidth = 0.5
        self.textField.backgroundColor = backgroundColor
        self.textField.clipsToBounds = true
        
        // close button Tool bar - to close the calender
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self.helper, action: #selector(self.helper.closeButtonClick))
        toolBar.setItems([flexibleSpace, closeButton], animated: true)
        self.textField.inputAccessoryView = toolBar
        self.helper.dateChanged = {
            self.date = self.datePicker.date
        }
        self.helper.closeButton = {
            if self.date == nil{
                self.date = self.datePicker.date
            }
            self.textField.resignFirstResponder()
        }
        return self.textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = self.date{
            uiView.text = self.dateFormatter.string(from: selectedDate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Helper{
        public var dateChanged: (() -> Void)?
        public var closeButton: (() -> Void)?
        @objc func dateValueChanged(){
            self.dateChanged?()
        }
        @objc func closeButtonClick(){
            self.closeButton?()
        }
    }
    class Coordinator
    {
        
    }
    
}
