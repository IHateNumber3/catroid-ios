import SpriteKit
import Foundation

public class CameraPositioner {
    
    public var camera: SKCameraNode
    public var virtualHeightHalf: CGFloat
    public var virtualWidthHalf: CGFloat
    
    public var spriteToFocusOn: Sprite?
    public var horizontalFlex: Float = 0.0f
    public var verticalFlex: Float = 0.0f
    
    private static let calculatePercent: Float = 100.0
    
    public init(camera: SKCameraNode, virtualHeightHalf: CGFloat, virtualWidthHalf: CGFloat) {
        self.camera = camera
        self.virtualHeightHalf = virtualHeightHalf
        self.virtualWidthHalf = virtualWidthHalf
    }
    
    /// Обновление позиции камеры для следования за сфокусированным спрайтом
    public func updateCameraPositionForFocusedSprite() {
        guard let sprite = spriteToFocusOn,
              let look = sprite.look else { return }
        
        // Получаем координаты спрайта (аналог xInUserInterfaceDimensionUnit)
        let spritePositionX = CGFloat(look.position.x) // Или твоя реализация UI координат
        let spritePositionY = CGFloat(look.position.y)
        
        let limitX = virtualWidthHalf * (CGFloat(horizontalFlex) / CGFloat(CameraPositioner.calculatePercent))
        let limitY = virtualHeightHalf * (CGFloat(verticalFlex) / CGFloat(CameraPositioner.calculatePercent))
        
        let currentPos = camera.position
        let currentXDifference = spritePositionX - currentPos.x
        let currentYDifference = spritePositionY - currentPos.y
        
        var newCameraXPos = currentPos.x
        var newCameraYPos = currentPos.y
        
        if abs(currentXDifference) > limitX {
            newCameraXPos = spritePositionX - convertLimitOnNegativeDifference(difference: Float(currentXDifference), limit: Float(limitX))
        }
        
        if abs(currentYDifference) > limitY {
            newCameraYPos = spritePositionY - convertLimitOnNegativeDifference(difference: Float(currentYDifference), limit: Float(limitY))
        }
        
        if newCameraXPos != currentPos.x || newCameraYPos != currentPos.y {
            camera.position = CGPoint(x: newCameraXPos, y: newCameraYPos)
        }
    }
    
    private func convertLimitOnNegativeDifference(difference: Float, limit: Float) -> CGFloat {
        return CGFloat(difference < 0 ? -limit : limit)
    }
    
    public func reset() {
        guard spriteToFocusOn != nil else { return }
        spriteToFocusOn = nil
        camera.position = .zero
    }
}
