//
//  MBUploadableFilesElement.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworkingSwift

/// An uploadable element representing some files.
public struct MBUploadableFilesElement: MBUplodableElementProtocol {
    public var localeIdentifier: String
    
    public var elementName: String
    
    /// The URLs of the files.
    public let files: [URL]
    
    /// Initializes a files element with the name, the locale and an array of file URLs.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - fileUrls: The text of the element.
    init(elementName: String, localeIdentifier: String, fileUrls: [URL]) {
        self.elementName = elementName
        self.localeIdentifier = localeIdentifier
        self.files = fileUrls
    }
    
    fileprivate func parameterName(forIndex index: Int) -> String {
        return String(format: "%@[%ld]", parameterName, index)
    }
    
    public func toForm() -> [MBMultipartForm]? {
        var multipartElements: [MBMultipartForm]?
        if files.count != 0 {
            multipartElements = []
            for (index, file) in files.enumerated() {
                multipartElements?.append(MBMultipartForm(name: parameterName(forIndex: index), url: file))
            }
        }
        return multipartElements
    }
}
