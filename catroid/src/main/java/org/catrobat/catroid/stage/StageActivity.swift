import UIKit
import SpriteKit

public class StageViewController: UIViewController {
    public static var stageListener: StageListener? { StageListener.shared }
    public var currentStageScene: StageScene?

    public static let tag = "StageViewController"
    public private(set) static var lastTestResult: TestResult?

    public static func finishTestWithResult(_ result: TestResult) {
        lastTestResult = result
        DispatchQueue.main.async {
            guard let controller = activeStage else { return }
            let title = result.resultCode == TestResult.stageActivityTestFail ? "Catroid test failed" : "Catroid test result"
            let alert = UIAlertController(title: title, message: result.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            if controller.presentedViewController == nil { controller.present(alert, animated: true) }
        }
    }
    
    // Слабая ссылка на активный экземпляр (аналог activeStageActivity)
    public static weak var activeStage: StageViewController?

    // Флаг запуска по шорткату
    public var isFromShortcut: Bool = false
    
    // Спрайт-кит вьюха для рендеринга сцены (аналог LibGDX AndroidGraphics / StageListener)
    private var skView: SKView!
    
    // Менеджеры (заглушки или портированные модули)
    // var cameraManager: CameraManager?
    // var vibrationManager: VibrationManager?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        StageViewController.activeStage = self
        setupUI()
        
        print("[\(StageViewController.tag)] Stage created (iOS Port)")
        // Эквивалент StageLifeCycleController.stageCreate(self)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StageViewController.activeStage = self
        // Эквивалент StageLifeCycleController.stageResume(self)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Эквивалент StageLifeCycleController.stagePause(self)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            // Эквивалент stageDestroy / finish
            manageLoadAndFinish()
        }
    }

    private func setupUI() {
        EmbroideryPatternManager.shared.clear()
        view.backgroundColor = .black
        
        // Настраиваем SKView для отрисовки графики Catroid (вместо LibGDX)
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)
        let scene = StageScene(size: skView.bounds.size)
        currentStageScene = scene
        skView.presentScene(scene)
        
        // Демонстрация FPS / статистики при необходимости
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    /// Аналог onBackPressed / сброса сцены
    public func handleBackAction() {
        if isFromShortcut {
            manageLoadAndFinish()
            dismiss(animated: true)
            return
        }
        
        // Если это обычный выход, показываем диалог паузы/скриншота
        // stageDialog.show()
        manageLoadAndFinish()
        dismiss(animated: true)
    }

    /// Очистка ресурсов при закрытии сцены (аналог manageLoadAndFinish)
    public func manageLoadAndFinish() {
        print("[\(StageViewController.tag)] Cleaning up stage resources...")
        
        // Остановка TextToSpeech, Bluetooth, RaspberryPi сервисов
        // TextToSpeechHolder.shared.shutDownTextToSpeech()
        // BluetoothDeviceService.shared.disconnectDevices()
    }

    // MARK: - Статические методы управления (аналоги из Android-версии)

    public static func finishStage() {
        DispatchQueue.main.async {
            activeStage?.dismiss(animated: true)
        }
    }

    /// Расчет размеров экрана и масштабирование (аналог calculateScreenSizes)
    public func calculateScreenSizes() {
        // Логика подгонки виртуального разрешения проекта под экран iOS-устройства
        let screenBounds = UIScreen.main.bounds
        print("[\(StageViewController.tag)] Screen size updated: \(screenBounds.width)x\(screenBounds.height)")
    }
}

/// Compatibility alias for code ported from Android's StageActivity.
public typealias StageActivity = StageViewController
