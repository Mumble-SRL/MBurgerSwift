//
//  MBUploadableElementsFactory.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

/// Used to create MBUploadableElement without specifiyng the locale for every item.
/// The locale is initialized with the factory and passed to all the objects. You can also change the locale and use the same instance of a MBUploadableElementsFactory to create objects with a different locale.
public struct MBUploadableElementsFactory {
    
    /// The locale identifier passed to every objects created.
    var localeIdentifier: String
    
    /// Initializes a factory with the locale identifier.
    /// - Parameters:
    ///   - localeIdentifier: The locale identifier.
    public init(localeIdentifier: String) {
        self.localeIdentifier = localeIdentifier
    }
    
    /// Creates a text element.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - text: The text.
    /// - Returns: A MBUploadableTextElement.
    public func createTextElement(name: String, text: String) -> MBUploadableTextElement {
        return MBUploadableTextElement(elementName: name, localeIdentifier: localeIdentifier, text: text)
    }
    
    /// Creates an images element with a single image.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - image: The image of the element.
    ///   - compressionQuality: The compression quality of the image (from 0 to 1), default is 1.
    /// - Returns: A MBUploadableImagesElement.
    public func createImageElement(name: String, image: UIImage, compressionQuality: CGFloat = 1) -> MBUploadableImagesElement {
           return MBUploadableImagesElement(elementName: name, localeIdentifier: localeIdentifier, images: [image], compressionQuality: compressionQuality)
    }
    
    /// Creates images element with an array of images.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - images: The images of the element.
    ///   - compressionQuality: The compression quality of the image (from 0 to 1), default is 1.
    /// - Returns: A MBUploadableImagesElement.
    public func createImagesElement(name: String, images: [UIImage], compressionQuality: CGFloat = 1) -> MBUploadableImagesElement {
        return MBUploadableImagesElement(elementName: name, localeIdentifier: localeIdentifier, images: images, compressionQuality: compressionQuality)
    }
    
    /// Creates a checkbox element with a bool value.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - value: The value of the element.
    /// - Returns: A MBUploadableCheckboxElement.
    public func createCheckboxElement(name: String, value: Bool) -> MBUploadableCheckboxElement {
        return MBUploadableCheckboxElement(elementName: name, localeIdentifier: localeIdentifier, value: value)
    }
    
    /// Creates a file element with a single file.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - file: The file of the element.
    /// - Returns: A MBUploadableFilesElement.
    public func createFileElement(name: String, file: URL) -> MBUploadableFilesElement {
        return MBUploadableFilesElement(elementName: name, localeIdentifier: localeIdentifier, fileUrls: [file])
    }
    
    /// Creates a file element with an array of files.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - files: The files of the element.
    /// - Returns: A MBUploadableFilesElement.
    public func createFilesElement(name: String, files: [URL]) -> MBUploadableFilesElement {
        return MBUploadableFilesElement(elementName: name, localeIdentifier: localeIdentifier, fileUrls: files)
    }
}
