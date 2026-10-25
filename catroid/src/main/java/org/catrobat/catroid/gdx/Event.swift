import Foundation

/// Замена scene2d.Event
open class Event {
    public init() {}
}

/// Замена scene2d.EventListener
public protocol EventListener: AnyObject {
    /// true — событие обработано
    func handle(_ event: Event) -> Bool
}
