# iOS Swift screen rewrite notes

Reviewed and rewrote these four UIKit screens:
- `MainMenuViewController.swift`: real navigation to projects/settings and creates an in-memory model project through `ProjectManager`.
- `ProjectListViewController.swift`: removes the hard-coded zero-row table and displays the currently open in-memory project.
- `ProjectViewController.swift`: displays actual scene/sprite names from `ProjectManager` and allows switching from scene list to the selected scene's sprite list.
- `SettingsViewController.swift`: functional native settings list with explanatory dialogs instead of dead rows/log-only handlers.

`project.yml` explicitly includes these screens while retaining the `**/ui/**` exclusion. This avoids pulling in the duplicate `UniqueNameProvider.swift` under `ui/recyclerview/util`.

## Important limitations

This is a UI/navigation repair pass, not a completed one-to-one Pocket Code port. The supplied archive does not register an iOS `ProjectSerializing` implementation, and `DefaultProjectHandler` currently constructs a `Project` model without implementing the original Android disk persistence. Therefore the project list only displays the currently open in-memory project; it does not claim to enumerate or load saved projects. The editor currently lists scenes and sprites but does not yet implement the full brick editor, image/sound import, stage runtime, or persistent save flow. Build was not run in this Linux environment because Xcode/iOS SDK are unavailable.
