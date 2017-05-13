//
//  DragFileView.swift
//  MovieCombiner
//
//  Created by Zeke Snider on 2/19/17.
//  Copyright © 2017 Zeke Snider. All rights reserved.
//

import Cocoa

class DragView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Declare and register an array of accepted types
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])
    }
    
    let fileTypes = ["jpg", "jpeg", "bmp", "png", "gif"]
    var fileTypeIsOk = false
    var droppedFilePath: String?
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(drag: sender) {
            fileTypeIsOk = true
            return .copy
        } else {
            fileTypeIsOk = false
            return []
        }
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsOk {
            return .copy
        } else {
            return []
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let imagePath = board[0] as? String {
            // THIS IS WERE YOU GET THE PATH FOR THE DROPPED FILE
            droppedFilePath = imagePath
            return true
        }
        return false
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String {
            let url = NSURL(fileURLWithPath: path)
            if let fileExtension = url.pathExtension?.lowercased() {
                return fileTypes.contains(fileExtension)
            }
        }
        return false
    }
}
