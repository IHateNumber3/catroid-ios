import Foundation
import CoreLocation
import AVFoundation
import UIKit

public class StageResourceHolder {
    
    private static let tag = "StageResourceHolder"
    
    private unowned var stageViewController: StageViewController
    private var requiredResourceCounter: Int = 0
    private var failedResources: Set<String> = []
    
    public init(stageViewController: StageViewController) {
        self.stageViewController = stageViewController
    }
    
    /// Инициализация ресурсов сцены (аналог initResources)
    public func initResources() {
        failedResources.removeAll()
        
        // Пример проверки необходимых ресурсов проекта
        // let requiredResources = ProjectManager.shared.currentProject?.requiredResources ?? []
        // requiredResourceCounter = requiredResources.count
        
        print("[\(StageResourceHolder.tag)] Initializing stage resources...")
        
        // Проверка камеры на iOS
        checkCameraAvailability()
        
        // Проверка геолокации (GPS) на iOS
        checkGpsAvailability()
        
        // Проверка вибрации / тактильного отклика
        checkVibrationAvailability()
        
        // Если ресурсов нет или все инициализированы — запускаем сцену
        if requiredResourceCounter == 0 {
            initFinishedRunStage()
        }
    }
    
    private func checkCameraAvailability() {
        let captureDevice = AVCaptureDevice.default(for: .video)
        if captureDevice != nil {
            resourceInitialized()
        } else {
            resourceFailed(resourceName: "Camera")
        }
    }
    
    private func checkGpsAvailability() {
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            resourceInitialized()
        } else {
            resourceFailed(resourceName: "GPS")
        }
    }
    
    private func checkVibrationAvailability() {
        // На всех современных iPhone есть тактильный движок (Taptic Engine)
        resourceInitialized()
    }
    
    public func resourceInitialized() {
        requiredResourceCounter -= 1
        if requiredResourceCounter <= 0 {
            if failedResources.isEmpty {
                initFinishedRunStage()
            } else {
                showResourceFailedErrorDialog()
            }
        }
    }
    
    public func resourceFailed(resourceName: String) {
        print("[\(StageResourceHolder.tag)] Resource failed: \(resourceName)")
        failedResources.insert(resourceName)
        resourceInitialized()
    }
    
    private func initFinishedRunStage() {
        print("[\(StageResourceHolder.tag)] All resources initialized. Starting stage...")
        // Разблокировка и запуск игрового цикла сцены
        // stageViewController.stageScene.isPausedState = false
    }
    
    private func showResourceFailedErrorDialog() {
        let alert = UIAlertController(
            title: "Ошибка ресурсов",
            message: "Некоторые необходимые для проекта ресурсы недоступны на этом устройстве: \(failedResources.joined(separator: ", "))",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.stageViewController.dismiss(animated: true)
        })
        
        DispatchQueue.main.async {
            self.stageViewController.present(alert, animated: true, completion: nil)
        }
    }
}
