import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

class GameScene: SKScene {
    enum GameState {
        case menu, playing, gameOver
    }

    var state: GameState = .menu

    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var startLabel: SKLabelNode!
    var restartLabel: SKLabelNode!

    var score = 0
    var lives = 3
    var level = 1
    var ballSpeed: TimeInterval = 3.0

    override func didMove(to view: SKView) {
        backgroundColor = .black
        showMainMenu()
    }

    func showMainMenu() {
        state = .menu
        removeAllChildren()

        startLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        startLabel.text = "Tap to Start"
        startLabel.fontSize = 36
        startLabel.fontColor = .green
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startLabel)
    }

    func startGame() {
        state = .playing
        removeAllChildren()

        score = 0
        lives = 3
        level = 1
        ballSpeed = 3.0

        setupLabels()
        updateLabels()
        spawnBall()
    }

    func setupLabels() {
        scoreLabel = makeLabel(text: "Score: 0", y: frame.maxY - 60)
        livesLabel = makeLabel(text: "Lives: 3", y: frame.maxY - 100)
        levelLabel = makeLabel(text: "Level: 1", y: frame.maxY - 140)

        addChild(scoreLabel)
        addChild(livesLabel)
        addChild(levelLabel)
    }

    func makeLabel(text: String, y: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontSize = 24
        label.fontColor = .white
        label.position = CGPoint(x: frame.midX, y: y)
        return label
    }

    func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        livesLabel.text = "Lives: \(lives)"
        levelLabel.text = "Level: \(level)"
    }

    func spawnBall() {
        guard state == .playing else { return }

        let ball = SKSpriteNode(color: .red, size: CGSize(width: 60, height: 60))
        ball.position = CGPoint(x: CGFloat.random(in: 60...(frame.width - 60)), y: frame.maxY + 60)

        if Int.random(in: 1...10) == 1 {
            ball.color = .yellow
            ball.name = "bonus"
        } else {
            ball.name = "normal"
        }

        addChild(ball)

        let move = SKAction.moveTo(y: -60, duration: ballSpeed)
        let remove = SKAction.removeFromParent()
        let missed = SKAction.run { self.handleMissedBall() }

        ball.run(SKAction.sequence([move, missed, remove]))
    }

    func handleMissedBall() {
        guard state == .playing else { return }

        lives -= 1
        updateLabels()

        if lives <= 0 {
            endGame()
        } else {
            spawnBall()
        }
    }

    func endGame() {
        state = .gameOver

        let gameOverLabel = makeLabel(text: "Game Over!", y: frame.midY + 40)
        gameOverLabel.fontSize = 44
        gameOverLabel.fontColor = .yellow
        addChild(gameOverLabel)

        let finalScoreLabel = makeLabel(text: "Final Score: \(score)", y: frame.midY)
        addChild(finalScoreLabel)

        restartLabel = makeLabel(text: "Tap to Restart", y: frame.midY - 40)
        restartLabel.fontColor = .green
        addChild(restartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        switch state {
        case .menu:
            startGame()
        case .playing:
            let touchedNodes = nodes(at: location)
            for node in touchedNodes {
                if node.name == "normal" || node.name == "bonus" {
                    node.removeFromParent()

                    score += (node.name == "bonus") ? 5 : 1

                    if score % 10 == 0 {
                        level += 1
                        ballSpeed = max(1.0, ballSpeed - 0.3)
                    }

                    updateLabels()
                    spawnBall()
                    return
                }
            }
        case .gameOver:
            if restartLabel.contains(location) {
                startGame()
            }
        }
    }
}