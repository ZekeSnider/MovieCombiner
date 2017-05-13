//
//  Helpers.swift
//  MovieCombiner
//
//  Created by Zeke Snider on 2/9/17.
//  Copyright © 2017 Zeke Snider. All rights reserved.
//

import Foundation

struct FileBrowser {
    private let suffixes = [
        ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
        ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"],
        ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l"]
    ]
    
    private let suffixPostFix = [
        "",
        ".FHD",
        ".HD",
        "-o",
        "-output"
    ]
    
    private let cleanUpSuffixes = [
        "_",
        " ",
        "-",
        "-CD"
    ]
    
    //Remove suffixes from a name
    private func cleanUpName(name: String) -> String {
        for cleanUp in cleanUpSuffixes {
            if name.hasSuffix(cleanUp) {
                let index = name.index(name.startIndex, offsetBy: name.lastIndex(of: cleanUp)!)
                return name.substring(to: index)
            }
        }
        return name
    }
    
    //Check if a URL conforms
    private func doesURLConform(url: URL, baseName: String, correctExtension: String) -> Bool {
        let fileName = url.deletingPathExtension().lastPathComponent
        
        guard fileName.hasPrefix(baseName) else {
            return false
        }
        
        guard (url.pathExtension == correctExtension) else {
            return false
        }
        
        return true
    }
    
    //Check if a file exists
    private func doesFileExist(baseURL: URL, baseName: String, correctExtension:String) -> Bool {
        if (FileManager.default.fileExists(atPath: baseURL.appendingPathComponent(baseName + "." + correctExtension).relativePath)) {
            return true
        }
        else {
            return false
        }
    }
    public func trimFile(documentsUrl: URL, startTime: String, endTime: String) -> (Bool, String)? {
        let fileName = documentsUrl.lastPathComponent
        let outFileName = documentsUrl.deletingPathExtension().lastPathComponent + "-o." + documentsUrl.pathExtension
        let outputString = "cd \"\(documentsUrl.deletingLastPathComponent().relativePath)\"; ffmpeg -ss \(startTime) -i \(fileName) -to \(endTime) -c copy \(outFileName)"
        return (true, outputString)
    }
    public func checkDirectory(documentsUrl: URL) -> (Bool, String)? {
        do {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: documentsUrl.path, isDirectory: &isDir) {
                if (!isDir.boolValue) {
                    return checkFile(inFile: documentsUrl.deletingPathExtension().lastPathComponent, file: documentsUrl, documentsUrl: documentsUrl.deletingLastPathComponent())
                }
                else {
                    // Get the directory contents urls (including subfolders urls)
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                    
                    //Loop over all files
                    outerLoop: for file in directoryContents {
                        let baseFile = file.deletingPathExtension().lastPathComponent
                        if let (result, out) = checkFile(inFile: baseFile, file: file, documentsUrl: documentsUrl) {
                            return (result,out)
                        }
                    }

                }
            }
                        return (false, "No Files found.")
        } catch let error as NSError {
            print(error.localizedDescription)
            return (false, "An Error Occured.")
        }
    }
    
    public func checkFile(inFile: String, file: URL, documentsUrl: URL) -> (Bool, String)? {
        var baseFile = inFile
        var suffixIndex = 0
        for postfix in suffixPostFix {
            for suffixSet in suffixes {
                guard (baseFile.hasSuffix(suffixSet[suffixIndex] + postfix)) else {
                    continue
                }
                var writeString = "file '\(baseFile).\(file.pathExtension)'\n"
                
                
                let index = baseFile.index(baseFile.startIndex, offsetBy: baseFile.lastIndex(of: suffixSet[suffixIndex])!)
                baseFile = baseFile.substring(to: index)
                
                var fileCount = 1
                
                //Find next part file until there are no more parts
                findNextLoop: while(true) {
                    suffixIndex += 1
                    //Check to see if the next file exists
                    if (doesFileExist(baseURL: documentsUrl, baseName: baseFile + suffixSet[suffixIndex] + postfix, correctExtension: file.pathExtension)) {
                        //If it does exist, add it
                        writeString += "file '\(baseFile + suffixSet[suffixIndex] + postfix).\(file.pathExtension)'\n"
                        fileCount += 1
                    }
                        //Otherwise, stop here.
                    else {
                        break findNextLoop
                    }
                }
                
                //If there was only 1 part found, exit here
                guard fileCount > 1 else {
                    continue
                }
                
                
                //writing the file
                do {
                    let writePath = file.deletingLastPathComponent().appendingPathComponent("test.txt")
                    try writeString.write(to: writePath, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {/* error handling here */}
                
                let outFileName = cleanUpName(name: baseFile) + "." + file.pathExtension
                
                let stringOut = "cd \"" + documentsUrl.relativePath + "\"; /usr/local/bin/ffmpeg -f concat -safe 0 -i test.txt -c copy \(outFileName)"
                
                return (true, stringOut)
            }
        }
        return nil
    }
}



