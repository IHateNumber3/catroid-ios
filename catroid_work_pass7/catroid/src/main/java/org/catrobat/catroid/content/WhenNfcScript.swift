import Foundation

public final class WhenNfcScript: Script {

    public var nfcTag: NfcTagData?
    public var matchAll: Bool = true

    public convenience init(nfcTag: NfcTagData?) {
        self.init()
        self.nfcTag = nfcTag
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenNfcBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(BrickResource.nfcAdapter)
        super.addRequiredResources(resourcesSet)
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        if matchAll {
            return EventId(EventId.anyNfc)
        } else if let tag = nfcTag {
            return NfcEventId(uid: tag.nfcTagUid)
        }
        fatalError("We want to identify a specific NfcTag, but null is given.")
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? WhenNfcScript {
            nfcTag = o.nfcTag
            matchAll = o.matchAll
        }
    }
}
