import SpriteKit
import UIKit

public class ShowTextActor: SKNode {
    
    private static let defaultAlignment: Int = 1 // ALIGNMENT_STYLE_CENTERED
    private static let defaultTextSize: CGFloat = 20.0
    
    private var textSize: CGFloat
    private var xPosition: Int
    private var yPosition: Int
    private var color: String
    private var variableToShow: UserVariable // Предполагается наличие класса UserVariable
    private var variableNameToCompare: String
    private var alignment: Int
    private var sprite: Sprite // Предполагается наличие класса Sprite
    
    private var labelNode: SKLabelNode!
    
    public init(userVariable: UserVariable, xPosition: Int, yPosition: Int, relativeSize: Float,
                color: String, sprite: Sprite, alignment: Int = ShowTextActor.defaultAlignment) {
        self.variableToShow = userVariable
        self.variableNameToCompare = userVariable.name
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.textSize = ShowTextActor.defaultTextSize * CGFloat(relativeSize)
        self.color = color
        self.sprite = sprite
        self.alignment = alignment
        
        super.init()
        
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        labelNode = SKLabelNode(fontNamed: "Helvetica")
        labelNode.fontSize = textSize
        labelNode.fontColor = parseColor(color)
        
        // Настройка выравнивания (аналог alignment)
        switch alignment {
        case 0: labelNode.horizontalAlignmentMode = .left
        case 2: labelNode.horizontalAlignmentMode = .right
        default: labelNode.horizontalAlignmentMode = .center
        }
        
        updatePosition()
        addChild(labelNode)
    }
    
    private func updatePosition() {
        labelNode.position = CGPoint(x: CGFloat(xPosition), y: CGFloat(yPosition))
    }
    
    /// Метод обновления отображения переменных за кадр (аналог draw в LibGDX)
    public func updateVariables() {
        // Получаем переменные проекта и спрайта
        // let projectVariables = ProjectManager.shared.currentProject?.userVariables ?? []
        // let multiplayerVariables = ProjectManager.shared.currentProject?.multiplayerVariables ?? []
        // let spriteVariables = sprite.userVariables
        
        // Заглушка логики поиска переменной и отрисовки значения
        if variableToShow.isDummy {
            labelNode.text = "No variable selected" // Или локализованная строка
            labelNode.isHidden = false
        } else {
            // Ищем переменную и выводим её значение если visible == true
            let variableValueString = String(describing: variableToShow.value)
            if variableValueString.isEmpty {
                labelNode.isHidden = true
            } else {
                labelNode.text = variableValueString
                labelNode.isHidden = !variableToShow.isVisible
            }
        }
    }
    
    private func parseColor(_ colorString: String) -> UIColor {
        // Простая конвертация HEX-строки цвета в UIColor
        var hexSanitized = colorString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public func setPositionX(_ xPosition: Int) {
        self.xPosition = xPosition
        updatePosition()
    }

    public func setPositionY(_ yPosition: Int) {
        self.yPosition = yPosition
        updatePosition()
    }

    public var targetVariableNameToCompare: String {
        return variableNameToCompare
    }

    public var associatedSprite: Sprite {
        return sprite
    }
}
