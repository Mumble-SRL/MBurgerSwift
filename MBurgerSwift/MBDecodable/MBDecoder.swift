//
//  MyDecoder.swift
//  SDKTests
//
//  Created by Alessandro Viviani on 18/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import Foundation
import UIKit

public class MBDecoder {
    private let elements: [String : MBElement]
    
    public init(elements: [String : MBElement]) {
        self.elements = elements
    }
}

public extension MBDecoder {
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
        
//        func decode(_ type: MBTextElement.Type, forKey key: Key) throws -> MBTextElement {
//            guard let element = decoder.elements[key.stringValue] else {
//                throw MBDecodingErrors.keyNotFoundInElements
//            }
//            
//            guard let textElement = element as? MBTextElement else {
//                throw MBDecodingErrors.wrongType(expecting: type, reality: element)
//            }
//            return textElement
//        }
//        
//        func decode(_ type: MBMarkdownElement.Type, forKey key: Key) throws -> MBMarkdownElement {
//            guard let element = decoder.elements[key.stringValue] else {
//                throw MBDecodingErrors.keyNotFoundInElements
//            }
//            
//            guard let markdownElement = element as? MBMarkdownElement else {
//                throw MBDecodingErrors.wrongType(expecting: type, reality: element)
//            }
//            return markdownElement
//        }
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
    
    func find<T : Decodable>(_ value: [String: MBElement], as type: T.Type) throws -> T {
        var result = [String: Any]()
        
        for (dictKey, dictValue) in value {
            let key = dictKey
            result[key] = try find_(dictValue, as: type)
        }
        return result as! T
    }
    
    func find<T : Decodable>(_ value: MBElement, as type: T.Type) throws -> T {
        guard let elementFound = try find_(value, as: type) as? T else {
            throw MBDecodingErrors.typeNotConformingToMBDecodable(type)
        }
        return elementFound
    }
    
    func find_(_ value: MBElement, as type: Decodable.Type) throws -> Any {
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
            throw MBDecodingErrors.typeNotConformingToBinaryDecodable(type)
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        if let decodableType = type as? MBDecodable.Type {
            return try decodableType.init(fromBinary: self) as! T
        }
        throw MBDecodingErrors.typeNotConformingToBinaryDecodable(type)
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
    /// All errors which `BinaryDecoder` itself can throw.
    enum MBDecodingErrors: Swift.Error {
        /// The decoder hit the end of the data while the values it was decoding expected
        /// more.
        case prematureEndOfData
        
        /// Attempted to decode a type which is `Decodable`, but not `BinaryDecodable`. (We
        /// require `BinaryDecodable` because `BinaryDecoder` doesn't support full keyed
        /// coding functionality.)
        case typeNotConformingToBinaryDecodable(Decodable.Type)
        
        /// Attempted to decode a type which is not `Decodable`.
        case typeNotConformingToDecodable(Any.Type)
        
        /// Attempted to decode an `Int` which can't be represented. This happens in 32-bit
        /// code when the stored `Int` doesn't fit into 32 bits.
        case intOutOfRange(Int64)
        
        /// Attempted to decode a `UInt` which can't be represented. This happens in 32-bit
        /// code when the stored `UInt` doesn't fit into 32 bits.
        case uintOutOfRange(UInt64)
        
        /// Attempted to decode a `Bool` where the byte representing it was not a `1` or a
        /// `0`.
        case boolOutOfRange(UInt8)
        
        /// Attempted to decode a `String` but the encoded `String` data was not valid
        /// UTF-8.
        case invalidUTF8([UInt8])
        
        
        // MARK: - real mumble errors for the SDK
        case keyNotFoundInElements
        
        case wrongedType(expecting: Decodable.Type, reality: MBElement)
        
        case wrongType(expecting: MBElement.Type, reality: MBElement)
        
        case typeNotConformingToMBDecodable(Decodable.Type)
    }
}
