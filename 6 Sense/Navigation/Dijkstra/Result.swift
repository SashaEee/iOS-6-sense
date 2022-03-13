//
//  Result.swift
//  UniMaps
//
//  Created by Benni on 07.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

/**
An enum that represents the result of a function.
It is used when a more expressive way of communication is needed, for example when mutliple states of
unexpected behaviour can appear.

It is generic over the type of the expected result.
*/
public enum Result<T> {
	/// The expected result case with the correct data as the associated value.
	case expected(T)
	/// The result is unexpected and a more expressive Error is passed along as the associated value.
	case unexpected(Error)
}

// MARK: - Public methods and properties
public extension Result {
	/// A boolean value indicating that the result holds the expected data.
	var isExpected: Bool {
		switch self {
		case .expected(_): return true
		case .unexpected(_): return false
		}
	}
	
	/// A boolean value indicating that the result is unexpected and holds an error value.
	var isUnexpected: Bool {
		return !isExpected
	}
	
	/// The expected data in case of an expected result or nil if unexpected.
	var data: T? {
		if case .expected(let data) = self {
			return data
		}
		
		return nil
	}
	
	/// The error value in case of an unexpected result or nil if the result holds the expected data.
	var error: Error? {
		if case .unexpected(let error) = self {
			return error
		}
		
		return nil
	}
	
	/**
	This function takes a closure as it's parameter which gets called if the result holds the expected data.
	- Parameter callback: A closure of type `(T) -> Void` where `T` is the type of the expected data. It gets called if the result type holds the expected data. The data gets passed to the closure as a non-optional parameter, ready for use.
	*/
	func onExpected(_ callback: (T) -> Void) {
		if case .expected(let data) = self {
			callback(data)
		}
	}

	/**
	This function takes a closure as it's parameter which gets called in case of an unexpected result.
	- Parameter callback: A closure of type `(GraphError) -> Void` which gets called if the result is unexpected. The error value gets passed to the closure as a non-optional parameter, ready for use.
	*/
	func onUnexpected(_ callback: (Error) -> Void) {
		if case .unexpected(let error) = self {
			callback(error)
		}
	}
}
