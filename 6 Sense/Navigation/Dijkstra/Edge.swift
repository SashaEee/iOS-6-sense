//
//  Edge.swift
//  UniMaps
//
//  Created by Benni on 13.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import Foundation

/**
This struct acts as the connection between two nodes.
It has a weight that represents the distance between these nodes.
The `Edge` struct only stores the destination node as itself is stored in the graph's `nodes` dictionary with the source node as key for all edges departing from it.

The Edge is generic over the node element's type.
*/
public struct Edge<Element> {
	/// The destination of this `Edge`.
	var destination: Element
	/// The weight of this `Edge`, stored as a `Double` for exact precision in the dijkstra algorithm
	var weight: Double
	
	/**
	Initializer of the `Edge`.
	*/
	init(to destination: Element, weight: Double) {
		self.weight = weight
		self.destination = destination
	}
}
