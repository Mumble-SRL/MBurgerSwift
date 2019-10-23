//
//  MBDecoder.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 22/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import Foundation
import UIKit

/// A type that can decode itself from an external representation.
public class MBDecoder {
    private let elements: [String : MBElement]
    
    /// Creates a new instance of MBDecoder.
    /// 
    /// - Parameters:
    /// - elements: The elements of the MBSection.
    public init(elements: [String : MBElement]) {
        self.elements = elements
    }
}

public extension MBDecoder {
    /// A convenience method for creating a decoder and decoding a value.
    /// - parameter type: The .Type of the entity.
    /// - parameter elements: The elements of the MBSection.
    ///
    /// - Returns: The entity.
    /// - throws: `MBDecodingErrors` if the decoding process detects an error.
    static func decode<T: MBDecodable>(_ type: T.Type, elements: [String: MBElement]) throws -> T {
        return try MBDecoder(elements: elements).decode(T.self)
    }
}

extension MBDecoder: Decoder {
    public var codingPath: [CodingKey] { return [] }
    
    public var userInfo: [CodingUserInfoKey : Any] { return [:] }
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        let container = MBElementsKeyedContainer<Key>(decoder: self)
        return KeyedDecodingContainer(container)
    }
    
    // MARK: - MBElementsKeyedContainer
    private struct MBElementsKeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var decoder: MBDecoder
        
        var codingPath: [CodingKey] = []
        
        var allKeys: [Key] {
            return decoder.elements.keys.compactMap { Key(stringValue: $0) }
        }
        
        func contains(_ key: Key) -> Bool {
            return true
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            guard let entry = decoder.elements[key.stringValue] else {
                throw MBDecodingErrors.keyNotFoundInElements
            }
            guard let element = try decoder.find(entry, as: type) else {
                throw MBDecodingErrors.entryNotConformingToDecodable(entry)
            }
            return element
        }
        
        /// Decodes a value of the given type for the given key, if present.
        func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T : Decodable {
            guard let entry = decoder.elements[key.stringValue] else {
                throw MBDecodingErrors.keyNotFoundInElements
            }
            return try decoder.find(entry, as: type)
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            return true
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return try decoder.container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return try decoder.unkeyedContainer()
        }
        
        func superDecoder() throws -> Decoder {
            return decoder
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            return decoder
        }
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(decoder: self)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return UnkeyedContainer(decoder: self)
    }
    
    func decode(value: MBElement, ofType type: String.Type) throws -> String {
        if let textElement = value as? MBTextElement {
            return textElement.text
        }
        
        if let markdownElement = value as? MBMarkdownElement {
            return markdownElement.text
        }
        throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
    }
    
    func decode(value: MBElement, ofType type: [MBFile].Type) throws -> [MBFile] {
        if let imageElement = value as? MBImagesElement {
            return imageElement.images
        }
        
        if let mediaElement = value as? MBMediaElement {
            return mediaElement.medias
        }
        throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
    }
    
    func decode(value: MBElement, ofType type: MBFile.Type) throws -> MBFile? {
        if let imageElement = value as? MBImagesElement {
            return imageElement.firstImage
        }
        
        if let mediaElement = value as? MBMediaElement {
            return mediaElement.firstMedia
        }
        throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
    }
    
    func decode(value: MBElement, ofType type: Date.Type) throws -> Date {
        guard let dateElement = value as? MBDateElement else {
            throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
        }
        return dateElement.date
    }
    
    func decode(value: MBElement, ofType type: Bool.Type) throws -> Bool {
        guard let checkboxElement = value as? MBCheckboxElement else {
            throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
        }
        return checkboxElement.checked
    }
    
    func decode(value: MBElement, ofType type: MBPollElement.Type) throws -> MBPollElement {
        guard let poll = value as? MBPollElement else {
            throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
        }
        return poll
    }
    
    func decode(value: MBElement, ofType type: MBAddressElement.Type) throws -> MBAddressElement {
        guard let address = value as? MBAddressElement else {
            throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
        }
        return address
    }
    
    func decode(value: MBElement, ofType type: MBRelationElement.Type) throws -> MBRelationElement {
        guard let relation = value as? MBRelationElement else {
            throw MBDecodingErrors.wrongedType(expecting: type, reality: value)
        }
        return relation
    }
    
    private func find<T : Decodable>(_ value: [String: MBElement], as type: T.Type) throws -> T? {
        var result = [String: Any]()
        
        for (dictKey, dictValue) in value {
            let key = dictKey
            result[key] = try find_(dictValue, as: type)
        }
        return result as? T
    }
    
    private func find<T : Decodable>(_ value: MBElement, as type: T.Type) throws -> T? {
        return try find_(value, as: type) as? T
    }
    
    /// Find a value of the given type for the given key, if present.
    /// - Returns: the corresponding element, if present.
    /// - throws: `MBDecodingErrors.typeNotConformingToMBDecodable` if the encountered a type that cannot be decoded.
    private func find_(_ value: MBElement, as type: Decodable.Type) throws -> Any {
        switch type {
        case is String.Type:
            return try self.decode(value: value, ofType: String.self)
        case is [MBFile].Type:
            return try self.decode(value: value, ofType: [MBFile].self)
        case is Date.Type:
            return try self.decode(value: value, ofType: Date.self)
        case is Bool.Type:
            return try self.decode(value: value, ofType: Bool.self)
        case is MBPollElement.Type:
            return try self.decode(value: value, ofType: MBPollElement.self)
        case is MBAddressElement.Type:
            return try self.decode(value: value, ofType: MBAddressElement.self)
        case is MBRelationElement.Type:
            return try self.decode(value: value, ofType: MBRelationElement.self)
        case is MBFile.Type:
            return try self.decode(value: value, ofType: MBFile.self) as Any
        default:
            throw MBDecodingErrors.typeNotConformingToMBDecodable(type)
        }
    }
    
    /// Find a value of the given type for the given key, if present.
    /// - Returns: the corresponding element, if present.
    /// - throws: `MBDecodingErrors.typeNotConformingToMBDecodable` if the encountered a type that cannot be decoded.
    private func decode<T: Decodable>(_ type: T.Type) throws -> T {
        if let decodableType = type as? MBDecodable.Type {
            return try decodableType.init(from: self) as! T
        }
        throw MBDecodingErrors.typeNotConformingToMBDecodable(type)
    }
    
    // MARK: - UnkeyedContainer
    private struct UnkeyedContainer: UnkeyedDecodingContainer, SingleValueDecodingContainer {
        var decoder: MBDecoder
        
        var codingPath: [CodingKey] { return [] }
        
        var count: Int? { return nil }
        
        var currentIndex: Int { return 0 }

        var isAtEnd: Bool { return false }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            return try decoder.decode(T.self)
        }
        
        func decodeNil() -> Bool {
            return true
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return try decoder.container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            return self
        }
        
        func superDecoder() throws -> Decoder {
            return decoder
        }
    }
}

/// The error type.
public extension MBDecoder {
    /// All errors which `MBDecoder` itself can throw.
    enum MBDecodingErrors: Swift.Error {
        /// Attempted to decode a type which is not `Decodable`.
        case entryNotConformingToDecodable(MBElement)
    
        case keyNotFoundInElements
        
        case wrongedType(expecting: Decodable.Type, reality: MBElement)
        
        case wrongType(expecting: MBElement.Type, reality: MBElement)
        
        case typeNotConformingToMBDecodable(Decodable.Type)
    }
}
