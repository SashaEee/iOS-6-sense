//
//  UniMapsError.swift
//  UniMaps
//
//  Created by Benni on 07.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

/**
Error enum to provide more useful and typed error information during graph operations.
*/
public enum GraphError: Error {
	/// Indicates that a node already exists in the graph when trying to add a new node.
	case nodeAlreadyExists
	/// Indicates that a edge already exists in the graph when trying to add a new edge.
	case edgeAlreadyExists
	/// The shortest path from the source node to the destination node was not found.
	case shortestPathNotFound
	/// The requested source node is not part of the graph.
	case startingPOINotFound
	/// The requested destination node is not part of the graph.
	case destinationPOINotFound
	/// The frontier is empty.
	case frontierIsEmpty
	/// An element was not removed from the frontier.
	case elementNotRemoved
	/// An edge couldn't be found.
	case edgeNotFound
}
