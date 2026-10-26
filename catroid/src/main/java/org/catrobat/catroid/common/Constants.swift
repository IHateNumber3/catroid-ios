import Foundation

/// Автогенерация из Constants.java (примитивы и строки). Файловые пути — ниже и в FlavoredConstants.
public enum Constants {
    public static let currentCatrobatLanguageVersion: Double = 1.14
    public static let remoteDisplayAppId: String = "CEBB9229"
    public static let castConnectionTimeout: Int = 5000
    public static let castNotSeeingDeviceTimeout: Int = 3000
    public static let progessiveInputDelay: Int64 = 400
    public static let progessiveInputCountdownIntervall: Int64 = 500
    public static let retrofitWriteTimeout: Int64 = 15
    public static let platformName: String = "iOS"
    public static let applicationBuildNumber: Int = 0
    public static let applicationBuildName: String = ""
    public static let codeXmlFileName: String = "code.xml"
    public static let permissionsFileName: String = "permissions.txt"
    public static let tmpCodeXmlFileName: String = "tmp_" + codeXmlFileName
    public static let undoCodeXmlFileName: String = "undo_" + codeXmlFileName
    public static let deviceVariableJsonFileName: String = "DeviceVariables.json"
    public static let deviceListJsonFileName: String = "DeviceLists.json"
    public static let pocketCodeExternalExportStorageDirectoryName: String = "Catrobat"
    public static let catrobatExtension: String = ".catrobat"
    public static let zipExtension: String = ".zip"
    public static let defaultImageExtension: String = ".png"
    public static let jpegImageExtension: String = ".jpg"
    public static let defaultSoundExtension: String = ".wav"
    public static let embroideryFileExtension: String = ".dst"
    public static let svgFileExtension: String = ".svg"
    public static let textFileExtension: String = ".txt"
    public static let noMediaFile: String = ".nomedia"
    public static let imageDirectoryName: String = "images"
    public static let soundDirectoryName: String = "sounds"
    public static let screenshotAutomaticFileName: String = "automatic_screenshot" + defaultImageExtension
    public static let screenshotManualFileName: String = "manual_screenshot" + defaultImageExtension
    public static let recentBricksDirectory: String = "recent_bricks"
    public static let recentBricksFile: String = "recent_bricks.json"
    public static let backpackDirectoryName: String = "backpack"
    public static let backpackJsonFileName: String = "backpack.json"
    public static let backbackScenesDirectoryName: String = "scenes"
    public static let backpackSoundDirectoryName: String = "backpack_sound"
    public static let backpackImageDirectoryName: String = "backpack_image"
    public static let trustedDomainsFileName: String = "trustedDomains.json"
    public static let trustedUserDomainsFileName: String = "trustedUserDomains.json"
    public static let trustListJsonArrayName: String = "domains"
    public static let jsonIndentation: Int = 4
    public static let cachedProjectZipFileName: String = "projectImportCache.zip"
    public static let tmpImageFileName: String = "image"
    public static let tmpDirectoryName: String = "tmp"
    public static let textToSpeechTmpPath: String = tmpPath + "/textToSpeech"
    public static let uploadUrl: String = "https://upload.catrob.at"
    public static let mainUrlHttps: String = "https://catrob.at"
    public static let baseAppUrlHttps: String = mainUrlHttps + "/app/"
    public static let shareProjectUrl: String = mainUrlHttps + "/project/"
    public static let catrobatAboutUrl: String = "https://www.catrobat.org/"
    public static let catrobatFormulaWikiUrl: String = "https://catrobat.org/docs/"
    public static let aboutPocketcodeLicenseUrl: String = "https://developer.catrobat.org/pages/legal/licenses/"
    public static let webRequestWikiUrl: String = "https://catrobat.org/docs/"
    public static let catrobatTermsOfUseUrl: String = "https://developer.catrobat.org/pages/legal/terms-of-use-and-service/"
    public static let catrobatFunctionsWikiUrl: String = "https://catrobat.org/docs/"
    public static let catrobatLogicWikiUrl: String = "https://catrobat.org/docs/"
    public static let catrobatSensorsWikiUrl: String = "https://catrobat.org/docs/"
    public static let catrobatObjectWikiUrl: String = "https://catrobat.org/docs/"
    public static let catrobatDeleteAccountUrl: String = mainUrlHttps + "/profile/edit"
    public static let catrobatTermsOfUseTokenFlavorUrl: String = "?flavorName="
    public static let catrobatTermsOfUseTokenVersionUrl: String = "&versionCode="
    public static let catrobatTermsOfUseAccepted: Int = 1
    public static let playStorePageLink: String = "https://play.google.com/store/apps/details?id="
    public static let huaweiAppGalleryLink: String = "https://catrob.at/HuaweiAppGallery"
    public static let usernameCookieName: String = "CATRO_LOGIN_USER"
    public static let tokenCookieName: String = "CATRO_LOGIN_TOKEN"
    public static let userAgent: String = "Mozilla/5.0 (compatible; Catrobatbot/1.0; +https://catrob.at/bot)"
    public static let errorBadRequest: Int = 400
    public static let errorTooManyRequests: Int = 429
    public static let errorServerError: Int = 500
    public static let errorTimeout: Int = 504
    public static let errorAuthenticationRequired: Int = 511
    public static let bluetoothLegoNxt: String = "BLUETOOTH_LEGO_NXT"
    public static let nfc: String = "NFC"
    public static let raspiBroadcastPrefix: String = "#RASPI#"
    public static let catrobatTokenLoginAmpToken: String = "&token="
    public static let token: String = "token"
    public static let noToken: String = "no_token"
    public static let username: String = "username"
    public static let noUsername: String = "no_username"
    public static let email: String = "email"
    public static let noEmail: String = "no_email"
    public static let locale: String = "locale"
    public static let restrictedUser: String = "restricted_user"
    public static let jsonErrorCode: String = "errorCode"
    public static let googleId: String = "GOOGLE_ID"
    public static let noGoogleId: String = "NO_GOOGLE_ID"
    public static let googleUsername: String = "GOOGLE_USERNAME"
    public static let noGoogleUsername: String = "NO_GOOGLE_USERNAME"
    public static let googleLocale: String = "GOOGLE_LOCALE"
    public static let noGoogleLocale: String = "NO_GOOGLE_LOCALE"
    public static let googleEmail: String = "GOOGLE_EMAIL"
    public static let noGoogleEmail: String = "NO_GOOGLE_EMAIL"
    public static let googleIdToken: String = "GOOGLE_ID_TOKEN"
    public static let noGoogleIdToken: String = "NO_GOOGLE_ID_TOKEN"
    public static let googleExchangeCode: String = "GOOGLE_EXCHANGE_CODE"
    public static let noGoogleExchangeCode: String = "NO_GOOGLE_EXCHANGE_CODE"
    public static let currentOauthProvider: String = "PROVIDER"
    public static let googlePlus: String = "GPLUS"
    public static let noOauthProvider: String = "NATIVE"
    public static let requestMobile: String = "mobile"
    public static let flavorDefault: String = "PocketCode"
    public static let platformDefault: String = "iOS"
    public static let whatsappUri: String = "whatsapp://"
    public static let invalidScratchProgramId: Int64 = 0
    public static let scratchConverterHost: String = "scratch2.catrob.at"
    public static let scratchSearchUrl: String = "https://api.scratch.mit.edu/search/projects"
    public static let scratchConverterMaxNumberOfJobsPerClient: Int = 3
    public static let scratchConverterWebSocket: String = "wss://" + scratchConverterHost + "/convertersocket"
    public static let scratchConverterBaseUrl: String = "https://" + scratchConverterHost + "/"
    public static let scratchConverterApiBaseUrl: String = scratchConverterBaseUrl + "api/v1/"
    public static let scratchConverterApiDefaultProjectsUrl: String = scratchConverterApiBaseUrl + "projects/"
    public static let scratchSecondReleasePublishedDateYear: Int = 2013
    public static let scratchSecondReleasePublishedDateMonth: Int = 5
    public static let scratchSecondReleasePublishedDateDay: Int = 9
    public static let scratchHttpRequestMinTimeout: Int = 1_000
    public static let scratchHttpRequestMaxNumberOfRetries: Int = 2
    public static let scratchImageDefaultWidth: Int = 480
    public static let scratchImageDefaultHeight: Int = 360
    public static let dateFormatDefault: String = "yyyy-MM-dd HH:mm:ss"
    public static let dateFormatIso8601: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    public static let intentScratchProgramData: String = "scratchProgramData"
    public static let intentRequestCodeConvert: Int = 1
    public static let nxt: Int = 0
    public static let ev3: Int = 1
    public static let port1: Int = 0
    public static let port2: Int = 1
    public static let port3: Int = 2
    public static let port4: Int = 3
    public static let extraPicturePathPocketPaint: String = "org.catrobat.extra.PAINTROID_PICTURE_PATH"
    public static let pocketPaintIntentActivityName: String = "org.catrobat.paintroid.MainActivity"
    public static let extraProjectName: String = "projectName"
    public static let extraProjectDescription: String = "projectDescription"
    public static let extraProjectPath: String = "projectPath"
    public static let extraProjectId: String = "projectId"
    public static let extraSceneNames: String = "sceneNames"
    public static let extraUserEmail: String = "userEmail"
    public static let extraLanguage: String = "language"
    public static let extraResultReceiver: String = "resultReceiver"
    public static let extraProvider: String = "provider"
    public static let extraUploadName: String = "uploadName"
    public static let uploadResultReceiverResultCode: Int = 1
    public static let buffer8k: Int = 8 * 1024
    public static let prefProjectnameKey: String = "projectName"
    public static let maxFileNameLength: Int = 127
    public static let coordinateTransformationOffset: Double = 0.5
    public static let collisionPngMetaTagKey: String = "CollisionPolygonVertices"
    public static let collisionVertexLimit: Int = 100
    public static let collisionPolygonCreationEpsilon: Float = 10.0
    public static let collisionPolygonMetadataPattern: String = "((((\\d+\\.\\d+);(\\d+\\.\\d+);){2,}(\\d+\\.\\d+);(\\d+\\.\\d+))\\|)*((\\d+\\.\\d+);(\\d+\\.\\d+);){2,}(\\d+\\.\\d+);(\\d+\\.\\d+)"
    public static let collisionWithFingerTouchRadius: Float = 50
    public static let castIdleBackgroundColor: Int = 0x66000000
    public static let zIndexBackground: Int = 0
    public static let zIndexNumberVirtualLayers: Int = 2
    public static let zIndexFirstSprite: Int = zIndexBackground + zIndexNumberVirtualLayers + 1
    public static let sayBrick: Int = 0
    public static let thinkBrick: Int = 1
    public static let maxStringLengthBubbles: Int = 16
    public static let borderThicknessBubbles: Int = 5
    public static let textSizeBubble: Int = 30
    public static let lineSpacingBubbles: Int = 3
    public static let paddingTop: Int = 40
    public static let offsetForThinkBubblesAndArrow: Int = 40
    public static let uploadImageScaleWidth: Int = 480
    public static let uploadImageScaleHeight: Int = 480
    public static let textFromCameraSensorHashcode: Int = 1613638780
    public static let maxNumberOfCheckedTags: Int = 3
    public static let updateDownloadProgress: Int = 101
    public static let updateDownloadError: Int = 105
    public static let maxPercent: Int = 100
    public static let statusCodeInternalServerError: Int = 500
    public static let statusCodeUploadMissingData: Int = 501
    public static let statusCodeUploadMissingChecksum: Int = 503
    public static let statusCodeUploadInvalidChecksum: Int = 504
    public static let statusCodeUploadCopyFailed: Int = 505
    public static let statusCodeUploadUnzipFailed: Int = 506
    public static let statusCodeUploadMissingXml: Int = 507
    public static let statusCodeUploadRenameFailed: Int = 513
    public static let statusCodeUploadSaveThumbnailFailed: Int = 514
    public static let statusCodeUploadOldCatrobatLanguage: Int = 518
    public static let statusCodeUploadOldCatrobatVersion: Int = 519
    public static let flavorPocketCode: String = "catroid"
    public static let flavorEmbroideryDesigner: String = "embroideryDesigner"
    public static let flavorLegoNxtEv3: String = "mindstorms"
    public static let flavorPhiro: String = "phiro"
    public static let flavorLunaAndCat: String = "lunaAndCat"
    public static let flavorCreateAtSchool: String = "createAtSchool"
    public static let stitchEduUrl: String = "https://stitchedu.com/"
    public static let preferencePlaystoreEmbroideryUrl: String = "https://play.google.com/store/apps/developer?id=Catrobat"
    public static let preferenceAppgalleryEmbroideryUrl: String = "https://appgallery.huawei.com/app/C100085769"
    public static let preferencePlaystoreMindstormsUrl: String = "https://play.google.com/store/apps/developer?id=Catrobat"
    public static let preferenceAppgalleryMindstormsUrl: String = "https://appgallery.huawei.com/app/C100085769"
    public static let preferencePlaystorePhiroUrl: String = "https://play.google.com/store/apps/developer?id=Catrobat"
    public static let preferenceAppgalleryPhiroUrl: String = "https://appgallery.huawei.com/app/C100085769"
    public static let deviceBrandHuawei: String = "huawei"

    // Символы в Java были char; здесь Character
    public static let remixUrlPrefixIndicator: Character = "["
    public static let remixUrlSufixIndicator: Character = "]"
    public static let remixUrlSeparator: Character = ","
    public static let remixUrlPrefixReplaceIndicator: Character = "("
    public static let remixUrlSufixReplaceIndicator: Character = ")"
    public static let remixUrlReplaceSeparator: Character = ";"

    // Файловые константы (Android: Environment/Context) — см. FlavoredConstants
    public static var tmpLookFile: URL { return FlavoredConstants.defaultRootDirectory.appendingPathComponent("temporary_look_file" + defaultImageExtension) }
    public static var trustedUserDomainsFile: URL { return FlavoredConstants.defaultRootDirectory.appendingPathComponent(trustedUserDomainsFileName) }
    public static var tmpPath: String { return cacheDirectory.path + "/" + tmpDirectoryName }
    public static var cacheDirectory: URL { return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0] }
    public static var pocketPaintCacheDirectory: URL { return cacheDirectory.appendingPathComponent("pocketPaint") }
    public static var cameraCacheDirectory: URL { return cacheDirectory.appendingPathComponent("camera") }
    public static var soundRecorderCacheDirectory: URL { return cacheDirectory.appendingPathComponent("soundRecorder") }
    public static var mediaLibraryCacheDirectory: URL { return cacheDirectory.appendingPathComponent("mediaLibrary") }
}

public enum FlavoredConstants {
    /// Documents/Catrobat (в iOS внешнего хранилища нет)
    public static var defaultRootDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Catrobat")
    }
}

