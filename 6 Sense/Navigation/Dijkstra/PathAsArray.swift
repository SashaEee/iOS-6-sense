//
//  PathAsArray.swift
//  CoreGraph
//
//  Created by Benni on 07.03.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation


public struct PathAsArray<Node: Equatable> {
	private var nodes: [Node] = []
	private var weights: [Double] = []
	private(set) var totalWeight: Double = 0.0
}


extension PathAsArray: CustomStringConvertible {
	func append(_ element: Node, weight: Double) -> PathAsArray<Node> {
		return PathAsArray(nodes: nodes + [element], weights: weights + [weight], totalWeight: totalWeight + weight)
	}
	
	func contains(_ element: Node) -> Bool {
		return nodes.contains(element)
	}
	
	var nodeData: [(node: Node, weight: Double)] {
		return zip(nodes, weights).map { ($0, $1) }
	}
	
	public var description: String {
		return nodeData.map { (node, weight) -> String in
			if weight == 0 {
				return "[\(node)]"
			}
			return " —\(weight)— [\(node)]"
			}.joined()
	}
	
	var node: Node {
		return nodes.last!
	}

	
	var weight: Double {
		return weights.last ?? 0
	}
}

// MARK: - Path Equatable
extension PathAsArray: Equatable {
	public static func ==(left: PathAsArray, right: PathAsArray) -> Bool {
		return left.nodes == right.nodes
	}
}

// MARK: - Path Comparable
extension PathAsArray: Comparable {
	public static func < (left: PathAsArray, right: PathAsArray) -> Bool {
		return  left.totalWeight < right.totalWeight
	}
}
