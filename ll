import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = SKScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .cyan

        let label = SKLabelNode(text: "It works!")
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(label)

        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}