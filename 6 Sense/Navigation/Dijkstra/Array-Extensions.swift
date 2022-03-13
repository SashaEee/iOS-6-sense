//
//  Array-Extensions.swift
//  CoreGraph
//
//  Created by Benni on 10.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
	// Remove first collection element that is equal to the given `object`:
	@discardableResult mutating func remove(object: Element) -> Result<Int> {
		if let index = index(of: object) {
			remove(at: index)
			return .expected(index)
		}
		
		return .unexpected(GraphError.elementNotRemoved)
	}
	
	func element(after element: Element) -> Element? {
		guard let index = index(of: element) else {
			return nil
		}
		
		return self[safe: index + 1]
	}
	
	func element(before element: Element) -> Element? {
		guard let index = index(of: element) else {
			return nil
		}
		
		return self[safe: index - 1]
	}
	
	func index(where closure: (Element) -> (Bool)) -> Int? {
		guard let filteredElement = filter(closure).first else {
			return nil
		}
		
		return index(of: filteredElement)
	}
	
	subscript (safe index: Int) -> Element? {
		get {
			guard index >= 0, index < count else {
				return nil
			}
			
			return self[index]
		}
	}
}

extension Array where Element: Comparable {
	mutating func addSorted(_ element: Element) {
		insert(element, at: index(for: element))
	}
	
	/**
	Calculates the index in the minimum heap for a given element value.
	This is used for inserting elements in the array which gets automatically sorted along the way.
	- Parameter for: An element value to get the index for.
	- Returns: The index of the given element.
	*/
	func index(for element: Element) -> Int {
		var low = startIndex
		var high = endIndex
		
		while low != high {
			let mid = low.advanced(by: low.distance(to: high) / 2)
			
			if self[mid] < element {
				low = mid.advanced(by: 1)
			} else {
				high = mid
			}
		}
		
		return low
	}
}
