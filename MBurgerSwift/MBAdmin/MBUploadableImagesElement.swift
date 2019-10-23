//
//  MBUploadableImagesElement.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworkingSwift

/// An uploadable element representing some images.
public struct MBUploadableImagesElement: MBUplodableElementProtocol {
    public var localeIdentifier: String
    
    public var elementName: String
    
    /// The array of images.
    public let images: [UIImage]
    
    /// The compression quality used to encode the image in jpg.
    public let compressionQuality: CGFloat
    
    /// The folder in which the images are saved.
    private var imageFolderPath: String = {
        let path = String(format: "Images_%f", Date().timeIntervalSince1970)
        return path
    }()
    
    /// The URL of the directory.
    private var directoryURL: URL {
        let cachesFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let folderPath = URL(fileURLWithPath: cachesFilePath ?? "").appendingPathComponent(imageFolderPath)
        return folderPath
    }
    
    /// Initializes a text element with the name, the locale and a text.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - images: The text of the element.
    ///   - compressionQuality: The compression quality of the image (from 0 to 1), default is 1.
    init(elementName: String, localeIdentifier: String, images: [UIImage], compressionQuality: CGFloat = 1.0) {
        self.elementName = elementName
        self.localeIdentifier = localeIdentifier
        self.images = images
        self.compressionQuality = compressionQuality
        
        createDirectory(atPath: directoryURL)
        
        self.images.enumerated().forEach { (index, image) in
            let filePath = self.fileURL(forIndex: index)
            write(atPath: filePath, data: image.jpegData(compressionQuality: compressionQuality))
        }
    }
    
    public func toForm() -> [MBMultipartForm]? {
        var multipartElements: [MBMultipartForm]?
        if images.count != 0 {
            multipartElements = []
            self.images.enumerated().forEach { (index, image) in
                let filePath = self.fileURL(forIndex: index)
                multipartElements?.append(MBMultipartForm(name: parameterName(forIndex: index), url: filePath, mimeType: "image/jpeg"))
            }
        }
        return multipartElements
    }
    
    fileprivate func createDirectory(atPath path: URL) {
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func write(atPath path: URL, data: Data?) {
        do {
            try data?.write(to: path, options: .atomic)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func fileURL(forIndex index: Int) -> URL {
        return directoryURL.appendingPathComponent(fileName(forIndex: index))
    }
    
    fileprivate func fileName(forIndex index: Int) -> String {
        return String(format: "Images_%d.jpg", index)
    }
    
    fileprivate func parameterName(forIndex index: Int) -> String {
        return String(format: "%@[%ld]", parameterName, index)
    }
}

internal extension FileManager {
    func documentsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    func cachesDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

internal extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsstring = self as NSString
        return nsstring.appendingPathComponent(path)
    }
}
