//
//  Transceiver.swift
//  CardsAgainst
//
//  Created by JP Simard on 11/3/14.
//  Copyright (c) 2014 JP Simard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum TransceiverMode {
    case Browse, Advertise, Both
}

public class Transceiver: SessionDelegate {

    var transceiverMode = TransceiverMode.Both
    var session: Session
    var advertiser: Advertiser
    var browser: Browser
    let displayName: String

    public init(displayName: String!) {
        self.displayName = displayName
        session = Session(displayName: self.displayName, delegate: nil)
        advertiser = Advertiser(mcSession: session.mcSession)
        browser = Browser(mcSession: session.mcSession)
        session.delegate = self
    }

    func startTransceiving(#serviceType: String, discoveryInfo: [String: String]? = nil) {
        advertiser.startAdvertising(serviceType: serviceType, discoveryInfo: discoveryInfo)
        browser.startBrowsing(serviceType)
        transceiverMode = .Both
    }

    func stopTransceiving() {
        session.delegate = nil
        advertiser.stopAdvertising()
        browser.stopBrowsing()
        session.disconnect()
        
        
        // Reset, like, everything
        self.session = Session(displayName: self.displayName, delegate: nil)
        self.advertiser = Advertiser(mcSession: session.mcSession)
        self.browser = Browser(mcSession: session.mcSession)
        self.session.delegate = self
    }

    func startAdvertising(#serviceType: String, discoveryInfo: [String: String]? = nil) {
        advertiser.startAdvertising(serviceType: serviceType, discoveryInfo: discoveryInfo)
        transceiverMode = .Advertise
    }

    func startBrowsing(#serviceType: String) {
        browser.startBrowsing(serviceType)
        transceiverMode = .Browse
    }

    public func connecting(myPeerID: MCPeerID, toPeer peer: MCPeerID) {
        didConnecting(myPeerID, peer)
    }

    public func connected(myPeerID: MCPeerID, toPeer peer: MCPeerID) {
        didConnect(myPeerID, peer)
    }

    public func disconnected(myPeerID: MCPeerID, fromPeer peer: MCPeerID) {
        didDisconnect(myPeerID, peer)
    }

    public func receivedData(myPeerID: MCPeerID, data: NSData, fromPeer peer: MCPeerID) {
        didReceiveData(data, fromPeer: peer)
    }

    public func finishReceivingResource(myPeerID: MCPeerID, resourceName: String, fromPeer peer: MCPeerID, atURL localURL: NSURL) {
        didFinishReceivingResource(myPeerID, resourceName, fromPeer: peer, atURL: localURL)
    }
}
