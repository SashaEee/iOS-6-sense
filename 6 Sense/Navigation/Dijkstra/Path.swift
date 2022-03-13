//
//  PathAsClass.swift
//  CoreGraph
//
//  Created by Benni on 07.03.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation


public final class Path<Element: Equatable> {
	internal let node: Element
	internal let weight: Double
	internal let previous: Path<Element>?
	let totalWeight: Double
	
	init(with node: Element, weight: Double = 0.0, previous: Path<Element>? = nil) {
		self.node = node
		self.weight = weight
		self.previous = previous
		self.totalWeight = weight + (previous?.totalWeight ?? 0.0)
	}
}

internal extension Path {
	func append(_ element: Element, weight: Double) -> Path<Element> {
		return Path(with: element, weight: weight, previous: self)
	}
	
	func contains(_ element: Element) -> Bool {
		guard let previous = previous, node != element else {
			return node == element
		}
		
		return previous.contains(element)
	}
}

public extension Path {
	public var nodeData: [(node: Element, weight: Double)] {
		guard let previous = previous else {
			return [(node: node, weight: weight)]
		}
		
		return previous.nodeData + [(node: node, weight: weight)]
	}
}

// MARK: - Path CustomStringConvertible
extension Path: CustomStringConvertible {
	public var description: String {
		return nodeData.map { (node, weight) -> String in
			if weight == 0 {
				return "[\(node)]"
			}
			return " —\(weight)— [\(node)]"
			}.joined()
	}
}

// MARK: - Equatable
extension Path: Equatable {
	public static func ==(left: Path, right: Path) -> Bool {
		return left.node == right.node && left.previous == right.previous
	}
}

// MARK: - Comparable
extension Path: Comparable {
	public static func < (left: Path, right: Path) -> Bool {
		return  left.totalWeight < right.totalWeight
	}
}
