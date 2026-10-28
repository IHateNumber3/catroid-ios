import Foundation
import AVFoundation
import UIKit

/// iOS implementation for Catroid's camera-preview and torch actions.
/// The preview is attached to the active stage view; camera access remains permission-gated by iOS.
public final class IOSCameraService {
    public static let shared = IOSCameraService()
    private let sessionQueue = DispatchQueue(label: "org.catrobat.catroid.camera-session")
    private let session = AVCaptureSession()
    private var input: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var previewRequested = false
    private var frontCameraRequested = false
    private var configured = false

    private init() {}

    public func selectFrontCamera(_ front: Bool) {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard self.frontCameraRequested != front else { return }
            self.frontCameraRequested = front
            self.configured = false
            self.configureSession()
        }
    }

    public func setPreviewEnabled(_ enabled: Bool) {
        previewRequested = enabled
        if enabled {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self, granted else { return }
                self.sessionQueue.async {
                    self.configureSession()
                    if !self.session.isRunning { self.session.startRunning() }
                    DispatchQueue.main.async { self.attachPreviewLayerIfNeeded() }
                }
            }
        } else {
            sessionQueue.async { [weak self] in
                guard let self = self else { return }
                if self.session.isRunning { self.session.stopRunning() }
                DispatchQueue.main.async { self.previewLayer?.removeFromSuperlayer(); self.previewLayer = nil }
            }
        }
    }

    public func setTorchEnabled(_ enabled: Bool) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted, let self = self else { return }
            self.sessionQueue.async {
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
                    ?? AVCaptureDevice.default(for: .video)
                guard let device = device, device.hasTorch else { return }
                do {
                    try device.lockForConfiguration()
                    device.torchMode = enabled ? .on : .off
                    device.unlockForConfiguration()
                } catch {
                    NSLog("Catroid torch configuration failed: %@", String(describing: error))
                }
            }
        }
    }

    private func configureSession() {
        guard !configured else { return }
        session.beginConfiguration()
        session.sessionPreset = .high
        if let old = input { session.removeInput(old); input = nil }
        let position: AVCaptureDevice.Position = frontCameraRequested ? .front : .back
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
            ?? AVCaptureDevice.default(for: .video)
        if let device = device, let newInput = try? AVCaptureDeviceInput(device: device), session.canAddInput(newInput) {
            session.addInput(newInput); input = newInput
        }
        session.commitConfiguration()
        configured = true
    }

    private func attachPreviewLayerIfNeeded() {
        guard previewRequested, let view = StageViewController.activeStage?.view else { return }
        if previewLayer == nil {
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill
            layer.frame = view.bounds
            view.layer.insertSublayer(layer, at: 0)
            previewLayer = layer
        } else {
            previewLayer?.frame = view.bounds
        }
    }
}
