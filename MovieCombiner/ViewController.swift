//
//  ViewController.swift
//  MovieCombiner
//
//  Created by Zeke Snider on 2/9/17.
//  Copyright © 2017 Zeke Snider. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let allowedFileExtensions = [
        "wmv",
        "mov",
        "mp4",
        "avi",
        "mkv",
        "rmvb"
    ]
    
    @IBOutlet weak var endTimeText: NSTextField!
    @IBOutlet weak var startTimeText: NSTextField!
    
    @IBAction func trimButtonPressed(_ sender: Any) {
        let startTime = startTimeText.stringValue
        let endTime = endTimeText.stringValue
        let myBrowser = FileBrowser()
        
        let (result, out) = myBrowser.trimFile(documentsUrl: URL(fileURLWithPath: pathControl.stringValue), startTime: startTime, endTime: endTime)!
        
        let answer = dialogOKCancel(question: "Copy command to clipboard?", text: "File compilation txt file created. Would you like to copy the ffmeg command to your clipboard?")
        
        if (answer == true) {
            let pb = NSPasteboard.init(name: NSGeneralPboard)
            pb.string(forType: NSPasteboardTypeString)
            pb.declareTypes([NSStringPboardType], owner: nil)
            pb.setString(out, forType: NSStringPboardType)
        }
    }
    @IBOutlet weak var pathControl: NSPathControl!
    @IBAction func chooseFileButtonPressed(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a directory"
        dialog.showsResizeIndicator = true
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = allowedFileExtensions
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url
            
            if let path = result?.path {
                pathControl.stringValue = path
            }
        } else {
            return
        }
    }
    @IBAction func combineButtonPressed(_ sender: Any) {
        let myBrowser = FileBrowser()
        if let (result, out) = myBrowser.checkDirectory(documentsUrl: URL(fileURLWithPath: pathControl.stringValue)) {
            print(result)
            print(out)
            
            let answer = dialogOKCancel(question: "Copy command to clipboard?", text: "File compilation txt file created. Would you like to copy the ffmeg command to your clipboard?")
            
            if (answer == true) {
                let pb = NSPasteboard.init(name: NSGeneralPboard)
                pb.string(forType: NSPasteboardTypeString)
                pb.declareTypes([NSStringPboardType], owner: nil)
                pb.setString(out, forType: NSStringPboardType)
            }
        }
        
        
        
        
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.informational
        myPopup.addButton(withTitle: "OK")
        myPopup.addButton(withTitle: "Cancel")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //http://stackoverflow.com/a/11175851
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

