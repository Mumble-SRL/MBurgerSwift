//
//  MBAdmin.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworkingSwift

/// Manages the calls to the MBurger admin APIs.
public struct MBAdmin {
    // MARK: - Update sections
    
    /// Add a section to the block with the specified id.
    /// - Parameters:
    ///   - blockId: The `id` of the block
    ///   - elements: An `Array` of the elements to upload. They must conform to MBUplodableElementProtocol
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes one argument.
    ///   - sectionId: The `id` of the created section.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func addSectionToBlock(withBlockId blockId: Int,
                                         elements: [MBUplodableElementProtocol],
                                         success: @escaping(_ sectionId: Int) -> Void,
                                         failure: @escaping(_ error: Error) -> Void) {
        var multipartForms = [MBMultipartForm]()
        for element in elements {
            if let formElement = element.toForm() {
                formElement.forEach({ multipartForms.append($0) })
            }
        }
        
        let apiName = String(format: "blocks/%ld/sections", blockId)
        MBApiManager.upload(withToken: MBManager.shared.apiToken,
                            locale: MBManager.shared.localeString,
                            apiName: apiName,
                            method: .post,
                            multipartParameters: multipartForms,
                            development: MBManager.shared.development) { (response) in
                                switch response {
                                case .success(let succ):
                                    print(succ)
                                case .error(let error):
                                    failure(error)
                                }
        }
    }
    
    /// Edit the section with the specified id.
    /// - Parameters:
    ///   - id: The `id` of the section.
    ///   - elements: An `Array` of the elements to upload. They must conform to MBUplodableElementProtocol.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func editSection(withSectionId id: Int,
                                   elements: [MBUplodableElementProtocol],
                                   success: @escaping() -> Void,
                                   failure: @escaping(_ error: Error) -> Void) {
        var multipartForms = [MBMultipartForm]()
        for element in elements {
            if let formElements = element.toForm() {
                formElements.forEach({ multipartForms.append($0) })
            }
        }
        
        let apiName = String(format: "sections/%ld/update", id)
        MBApiManager.upload(withToken: MBManager.shared.apiToken,
                            locale: MBManager.shared.localeString,
                            apiName: apiName,
                            method: .post,
                            multipartParameters: multipartForms,
                            development: MBManager.shared.development) { (response) in
                                switch response {
                                case .success:
                                    success()
                                case .error(let error):
                                    print(error.localizedDescription)
                                    failure(error)
                                }
        }
    }
    
    /// Remove the section with the specified id.
    /// - Parameters:
    ///   - id: The `id` of the section.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func deleteSection(withSectionId id: Int,
                                     success: @escaping() -> Void,
                                     failure: @escaping(_ error: Error) -> Void) {
        let apiName = String(format: "sections/%ld/", id)
        MBApiManager.request(withToken: MBManager.shared.apiToken,
                             locale: MBManager.shared.localeString,
                             apiName: apiName,
                             method: .delete,
                             success: { (response) in
                                success()
        }, failure: { error in
            failure(error)
        })
    }
    
    // MARK: - Media
    
    /// Remove the media (image or file) with the specified id.
    /// - Parameters:
    ///   - id: The `id` of the media.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func deleteMedia(withMediaId id: Int,
                                   success: @escaping() -> Void,
                                   failure: @escaping(_ error: Error) -> Void) {
        let apiName = String(format: "media/%ld/", id)
        MBApiManager.request(withToken: MBManager.shared.apiToken,
                             locale: MBManager.shared.localeString,
                             apiName: apiName,
                             method: .delete,
                             success: { (response) in
                                success()
        }, failure: { error in
            failure(error)
        })
    }
}
