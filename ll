import SpriteKit

class GameScene: SKScene {
    enum State {
        case menu, playing
    }

    var gameState: State = .menu
    var startLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        backgroundColor = .black
        showStartLabel()
    }

    func showStartLabel() {
        startLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        startLabel.text = "Tap to Start"
        startLabel.fontSize = 36
        startLabel.fontColor = .green
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startLabel)
    }

    func startGame() {
        gameState = .playing
        startLabel.removeFromParent()
        spawnBall()
    }

    func spawnBall() {
        let ball = SKShapeNode(circleOfRadius: 30)
        ball.fillColor = .red
        ball.position = CGPoint(x: frame.midX, y: frame.maxY + 60)
        addChild(ball)

        let move = SKAction.moveTo(y: -60, duration: 3.0)
        let remove = SKAction.removeFromParent()
        ball.run(SKAction.sequence([move, remove]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .menu:
            startGame()
        case .playing:
            break // We'll add tap logic later
        }
    }
}