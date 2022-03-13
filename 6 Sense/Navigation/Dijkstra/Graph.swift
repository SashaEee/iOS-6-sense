//
//  Graph.swift
//  UniMaps
//
//  Created by Benni on 13.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import Foundation


/**
This class represents the graph used for calculating the shortest path between nodes.
*/
public class Graph<Element: Hashable> {

	/**
	Stores the nodes that build the graph as a dictionary for better performance.
	The nodes are stored as the keys and the edges leading from the nodes are the dictionary values.
	*/
	private(set) var nodes: [Element: [Edge<Element>]] = [:]
	
	public init() {}
}


// MARK: - Public methods
public extension Graph {
	/**
	Adds a new node value to the nodes dictionary, containing the value passed in `with`.
	If a node with the given value already exists, this function returns an unexpected result.
	
	- Parameter with: The value that will be stored in the new node.
	- Returns: A Result object containing either the newly created `Node` or an error that the node already exists.
	*/
	@discardableResult func addNode(with value: Element) -> Result<Element> {
		guard nodes[value] == nil else {
			return .unexpected(GraphError.nodeAlreadyExists)
		}
		
		nodes[value] = []

		return .expected(value)
	}
	
	/**
	Adds a new `Edge` from the value `from` to the value `to`, given the weight in `weight`.
	As we use a undirected graph, a reverse `Edge` is also created, leading from `to` to `from` with the same weight as the first edge.
	Also, if there already is an `Edge` leading from `from` to `to` (or vice versa), no new edge will be created and the function simply returns.
	This is also the case if no node can be found for the `from` or `to` values.
	
	- Parameter from: A value that should be stored in a node in the graph, acting as the **source** of the new Edge.
	- Parameter to: A value that should be stored in a node in the graph, acting as the **destination** of the new Edge.
	- Parameter weight: The weight of the new edge. This is used for both the new edge and the reversed edge.
	*/
	@discardableResult func addEdge(from source: Element, to destination: Element, weight: Double) -> Result<Void> {
		guard !node(source, hasEdgeTo: destination),
			!node(destination, hasEdgeTo: source)
			else {
				return .unexpected(GraphError.edgeAlreadyExists)
		}

		self.nodes[source]?.append(Edge(to: destination, weight: weight))
		self.nodes[destination]?.append(Edge(to: source, weight: weight))
		
		return .expected(())
	}
	
	/**
	Calculates the shortest path in the graph from one node to another using Dijkstra's Algorithm.
	- Parameter from: The source node from where the algorithm calculates the shortest path.
	- Parameter to: The destination node to which the shortest path is calculated to from the source node.
	- Returns: A `Result` value containing either the calculated shortest `Path` or an unexpected error value.
	*/
	func shortestPath(from source: Element, to destination: Element) -> Result<Path<Element>> {
		/// If the source node can not be found in the graph, the algorithm returns an unexpected result.
		guard self[source] != nil else {
			return .unexpected(GraphError.startingPOINotFound)
		}
		/// If the destination node can not be found in the graph, the algorithm returns an unexpected result.
		guard self[destination] != nil else {
			return .unexpected(GraphError.destinationPOINotFound)
		}
		
		/// Initialize a path from the starting node with a weight of 0.
		let startingPath = Path(with: source)
		
		/// Initialize the list of open paths.
		var openList = [Path<Element>]()
		/// Initialize the list of eliminated nodes with the starting node.
		var eliminatedNodes: Set<Element> = [source]
		
		/// Add the paths leading from the starting path (containing only the starting node) to the open list.
		successorsPaths(for: startingPath).forEach { openList.addSorted($0) }
		
		/// While the open list still contains path to check, continue to find a shortest path.
		while !openList.isEmpty {
			/// Get the first path from the open list, which is the one with the smallest weight.
			let currentPath = openList.removeFirst()

			/// If the path's node is equal to the destination node, the algorithm exits successfully.
			if currentPath.node == destination {
				return .expected(currentPath)
			}

			/// The path's node is added to the list of eliminated nodes.
			eliminatedNodes.insert(currentPath.node)
			
			/// Get all paths leading from the currently inspected path's node.
			let successorPaths = successorsPaths(for: currentPath)

			/// Paths that lead to eliminated nodes are skipped in the loop
			for successor in successorPaths where !eliminatedNodes.contains(successor.node) {
				/// Get the index where the successor path should be inserted into the open list via binary search.
				let index = openList.index(for: successor)
				
				/// If the successor path is not part of the open list, add it to the open list at the determined index.
				if index < openList.count && openList[index] == successor {
					if successor.totalWeight < openList[index].totalWeight {
						// TODO: Find a test case where this is triggered
						let node = openList[index].node
						let newPath = currentPath.append(node, weight: openList[index].weight)
						openList[index] = newPath
					}
				} else {
					openList.insert(successor, at: index)
				}
			}
		}

		/// When the algorithm reaches this point, no path to the destination node could be found.
		return .unexpected(GraphError.shortestPathNotFound)
	}
	
	/**
	Removes all nodes from the graph.
	*/
	func clear() {
		nodes.removeAll()
	}
}

// MARK: - Internal Methods
extension Graph {
	/**
	Checks if this graph contains a node that has an `Edge` to another given node.
	This is needed to make sure only unique values are stored in the graph.
	
	- Parameter node: The source node.
	- Parameter anotherNode: The destination node.
	- Returns: A `Bool` indicating whether the graph has an edge leading from `node` to `anotherNode`.
	*/
	func node(_ node: Element, hasEdgeTo anotherNode: Element) -> Bool {
		guard let edges = nodes[node] else { return false }
		
		return edges.contains(where: { edge -> Bool in
			return edge.destination == anotherNode
		})
	}
	
	/**
	Calculates all paths leading from the destination node of a given `Path` value.
	
	**NOTE:** This is responsible for the false distances in the Dijkstra's final result `Path`.
	
	- Parameter for: The `Path` value from which's destination node the resulting paths will be diverged.
	- Returns: An array of diverging `Path` values from the given `Path` value.
	*/
	func successorsPaths(for path: Path<Element>) -> [Path<Element>] {
		guard let edges = nodes[path.node] else {
			return []
		}
		
		return edges.map { edge in
			return path.append(edge.destination, weight: edge.weight)
		}
	}
}

// MARK: - Subscripts
extension Graph {
	/**
	Gets the first `Node` object found for the given value content.
 
	- Parameter value: The value to look for in the nodes dictionary.
	- Returns: The `Node?` object that contains the given value or nil if no node contains this value.
	*/
	internal subscript(value: Element) -> [Edge<Element>]? {
		get {
			return nodes[value]
		}
	}
}
