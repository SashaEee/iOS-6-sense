//
//  Path.swift
//  CoreGraph
//
//  Created by Benni on 24.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

/**
A path segment along the graph, represented as a linked list.
It consists of a node element, a corresponding weight to it and a reference to a previous path segment.
This way it represents a whole path along the graph which can be traversed by the dijkstra algorithm.
The `end` case marks a path's end segment.

The `Path` enum is generic over the head node element's type and forces the previous path segment
to be generic over the same type.
*/
public enum PathAsEnum<Element: Equatable> {
	/// Indicates that the path is at it's end.
	case end
	/** The node segment that contains the specified node data, a corresponding weight
	to this node from the previous one, a reference to the previous path segment and an
	estimated weight to the destination node (this is only used in the A*-Algorithm).
	*/
	indirect case node(
		data: Element,
		weight: Double,
		previous: PathAsEnum<Element>
	)
}

// MARK: - Internal methods and properties
internal extension PathAsEnum {
	/**
	Creates a new path from the current one, with a new head node, a weight to the head
	node and the current path as the previous segment.
	- Parameter element: The new head node at the start of the new path.
	- Parameter weight: The weight to the new head node.
	- Returns: A new path object that represents the old path plus the given node as its new head.
	*/
	func append(_ element: Element, weight: Double) -> PathAsEnum<Element> {
		return .node(data: element, weight: weight, previous: self)
	}

	/**
	This method checks if a given element is part of the path by recursivly checking
	the previous path segments until it either reaches the end or finds the given node.
	
	- Parameter element: The node element to look for in the path.
	- Returns: A boolean value indicating whether the given node is part of the path.
	*/
	func contains(_ element: Element) -> Bool {
		if case let .node(data, _, previous) = self {
			if data == element {
				return true
			}
		
			return previous.contains(element)
		}
		
		return false
	}

	/**
	The node element of the path segment if present and nil if the path segment marks the end of the path.
	*/
	var node: Element? {
		if case .node(let destination, _, _) = self {
			return destination
		}
		
		return nil
	}

	/**
	The previous path segment if present and nil if the path segment marks the end of the path.
	*/
	var previous: PathAsEnum? {
		if case .node(_, _, let previous) = self {
			return previous
		}
		
		return nil
	}

	/**
	The weight of the previous path segment to this node element and 0 if the
	path segment marks the end of the path.
	*/
	var weight: Double {
		if case .node(_, let weight, _) = self {
			return weight
		}
		return 0
	}
}

// MARK: - Public methods and properties
public extension PathAsEnum {
	/**
	The node and weight data that makes op the path. It is given as an array of tuples where the first entry is a
	node element and the second entry represents the weight **to that node from the previous one**.
	
	Example data for this path:
	````
	end <- [N1] <-15— [N2] <-10— [N3] <-20— [N4] <-15— [N5]
	
	[(N1, 0),
	(N2, 15),
	(N3, 10),
	(N4, 20),
	(N5, 15)]
	````
	*/
	var nodeData: [(node: Element, weight: Double)] {
		if case let .node(node, weight, previous) = self {
			return previous.nodeData + [(node: node, weight: weight)]
		}
		
		return []
	}
	
	/// Returns the sum of all weights on the path.
	var totalWeight: Double {
		return weight + (previous?.totalWeight ?? 0)
	}
}


// MARK: - Path CustomStringConvertible
extension PathAsEnum: CustomStringConvertible {
	public var description: String {
		return nodeData.map { (node, weight) -> String in
			if weight == 0 {
				return "[\(node)]"
			}
			return " —\(weight)— [\(node)]"
			}.joined()
	}
}

// MARK: - Path Equatable
extension PathAsEnum: Equatable {
	public static func ==(left: PathAsEnum, right: PathAsEnum) -> Bool {
		return left.node == right.node && left.previous == right.previous
	}
}

// MARK: - Path Comparable
extension PathAsEnum: Comparable {
	public static func < (left: PathAsEnum, right: PathAsEnum) -> Bool {
		return  left.totalWeight < right.totalWeight
	}
}


