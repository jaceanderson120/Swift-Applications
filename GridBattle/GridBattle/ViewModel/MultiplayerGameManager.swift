


import MultipeerConnectivity

extension String {
    static var serviceName = "xando"
}

@Observable
class MultiplayerGameManager: NSObject, ObservableObject {
    
    let serviceType = String.serviceName
    var peerId: MCPeerID
    var session: MCSession!
    var nearbyAdvertiser: MCNearbyServiceAdvertiser?
    var nearbyBrowser: MCNearbyServiceBrowser?
    
    var availablePlayers: [MCPeerID] = []
    var connected: Bool = false
    var boardOne: Bool = false
    var gameManager: MultiplayerGameManagerBoardTwo?
    
    func setupGame(game: MultiplayerGameManagerBoardTwo) {
        self.gameManager = game
    }
    
    override init() {
        peerId = MCPeerID(displayName: UIDevice.current.name)
        super.init()
        
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .optional)
        nearbyAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
        

        
        session.delegate = self
        nearbyAdvertiser?.delegate = self
        nearbyBrowser?.delegate = self
    }
    
    deinit {
        stopBrowse()
        stopAdvertise()
    }
    
    func advertise() {
        nearbyAdvertiser?.startAdvertisingPeer()
    }
    
    func stopAdvertise() {
        nearbyAdvertiser?.stopAdvertisingPeer()
    }
    
    func browse() {
        nearbyBrowser?.startBrowsingForPeers()
    }
    
    func stopBrowse() {
        nearbyBrowser?.stopBrowsingForPeers()
        availablePlayers.removeAll()
    }
    
    func sendBoardAndPieces() {
        let state : GameState
        state = GameState(pieces: gameManager!.pieces, board: gameManager!.board, currentPlayer: gameManager!.playerTurn, gamePhase: gameManager!.turnPhase, turnCount: gameManager!.turn, gameOver: gameManager!.gameOver, redWon: gameManager!.redWon, blueWon: gameManager!.blueWon, deadPieces: gameManager!.deadPieces)
        do {
            let data = try JSONEncoder().encode(state)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Failed to encode and send: \(error)")
        }
    }
    
    func disconnect() {
        connected = false
        session.disconnect()
    }
}


extension MultiplayerGameManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
                    case .connected:
                        print("Successfully connected to \(peerID.displayName)")
                        self.connected = true
                        self.stopAdvertise()
                        self.stopBrowse()
                    case .connecting:
                        print("Attempting to connect to \(peerID.displayName)")
                    case .notConnected:
                        print("Disconnected from \(peerID.displayName)")
                        self.connected = false
                    @unknown default:
                        print("Unknown connection state")
                    }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let receivedState = try JSONDecoder().decode(GameState.self, from: data)
            DispatchQueue.main.async {
                self.gameManager?.pieces = receivedState.pieces
                self.gameManager?.board = receivedState.board
                self.gameManager?.playerTurn = receivedState.currentPlayer
                self.gameManager?.turnPhase = receivedState.gamePhase
                self.gameManager?.turn = receivedState.turnCount
                self.gameManager?.gameOver = receivedState.gameOver
                self.gameManager?.blueWon = receivedState.blueWon
                self.gameManager?.redWon = receivedState.redWon
                self.gameManager?.deadPieces = receivedState.deadPieces
            }
        } catch {
            print("Failed to decode received state: \(error)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}


extension MultiplayerGameManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}


extension MultiplayerGameManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            if !self.availablePlayers.contains(peerID) {
                self.availablePlayers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = availablePlayers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            self.availablePlayers.remove(at: index)
        }
    }
}
