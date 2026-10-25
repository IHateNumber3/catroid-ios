import UIKit
import SpriteKit

public class StageViewController: UIViewController {

    public static let tag = "StageViewController"
    
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
        view.backgroundColor = .black
        
        // Настраиваем SKView для отрисовки графики Catroid (вместо LibGDX)
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .height]
        view.addSubview(skView)
        
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
