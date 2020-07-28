//
//  Watcher.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-20.
//

import Foundation
import SocketIO

struct RavenSocketCallback {
    
}

class RavenSocketManager {
    
    static let shared = RavenSocketManager()
    
    private let socket:SocketIOClient
    private let socketManager:SocketManager
    private let socketURL = URL(string: "http://raven.replicode.io")!
    
    private(set) var isConnected = false
    
    var eventHandlers = [String:NormalCallback]()
    
    enum Emittable:String {
        case join = "join"
        case leave = "leave"
    }
    
    enum Event {
        case marketStatus
        case stockTrade(_ symbol:String)
        case stockQuote(_ symbol:String)
        case stockAggregatePerSecond(_ symbol:String)
        case stockAggregatePerMinute(_ symbol:String)
        
        case forexQuote(_ symbol:String)
        case forexAggregate(_ symbol:String)
        
        case cryptoTrade(_ symbol:String)
        
        var name:String {
            switch self {
            case .marketStatus:
                return "market.status"
            case let .stockTrade(symbol):
                return "T.\(symbol)"
            case let .stockQuote(symbol):
                return "Q.\(symbol)"
            case let .stockAggregatePerSecond(symbol):
                return "A.\(symbol)"
            case let .stockAggregatePerMinute(symbol):
                return "AA.\(symbol)"
                
            case let .forexQuote(symbol):
                return "C.\(symbol)"
            case let .forexAggregate(symbol):
                return "CA.\(symbol)"
                
            case let .cryptoTrade(symbol):
                return "XT.\(symbol)"
            }
        }
    }

    private init() {
        socketManager = SocketManager(socketURL: socketURL,
                                      config: [.log(false), .compress])
        socket = socketManager.defaultSocket
            
    }
    
    func connect(completion: @escaping ()->()) {
        
        socket.on(clientEvent: .connect) {data, ack in
            self.isConnected = true
//            for (eventName, callback) in self.eventHandlers {
//                self.socket.on(eventName) { data, ack in
//                    print("yea yea we here: \(eventName)")
//                }
//                print("add event: \(eventName)")
//            }
            completion()
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.isConnected = false
            
            for (eventName, _) in self.eventHandlers {
                self.socket.off(eventName)
            }
            self.socket.connect()
            
        }

        socket.connect()
    }
    
    func emit(event:Emittable, with data:[Any], completion: (()->())?=nil) {
        socket.emit(event.rawValue, with: data) {
            completion?()
        }
    }
    
    func on(event:Event, callback: @escaping NormalCallback) {
        let eventName = event.name
        self.eventHandlers[eventName] = callback
        _on(eventName: eventName)
        
        //socket.on(event.name, callback: callback)
    }
    
    func off(event:Event) {
        let eventName = event.name
        socket.off(eventName)
        eventHandlers[eventName] = nil
    }
    
    
    private func _on(eventName:String) {
        guard let callback = eventHandlers[eventName] else { return }
        socket.on(eventName, callback: callback)
    }
    
}

