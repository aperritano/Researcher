

import UIKit
import Material

class RootViewController: UIViewController {
    fileprivate var addButton: FabButton!
    fileprivate var audioLibraryMenuItem: MenuItem!
    fileprivate var reminderMenuItem: MenuItem!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareAddButton()
        prepareAudioLibraryButton()
        prepareBellButton()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareMenuController()
    }
}

extension RootViewController {
    fileprivate func prepareAddButton() {
        addButton = FabButton(image: Icon.cm.add, tintColor: .white)
        addButton.pulseColor = .white
        addButton.backgroundColor = Color.red.base
        addButton.addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
    }
    
    fileprivate func prepareAudioLibraryButton() {
        audioLibraryMenuItem = MenuItem()
        audioLibraryMenuItem.button.image = Icon.cm.audioLibrary
        audioLibraryMenuItem.button.tintColor = .white
        audioLibraryMenuItem.button.pulseColor = .white
        audioLibraryMenuItem.button.backgroundColor = Color.green.base
        audioLibraryMenuItem.button.depthPreset = .depth1
        audioLibraryMenuItem.title = "Audio Library"
    }
    
    fileprivate func prepareBellButton() {
        reminderMenuItem = MenuItem()
        reminderMenuItem.button.image = Icon.cm.bell
        reminderMenuItem.button.tintColor = .white
        reminderMenuItem.button.pulseColor = .white
        reminderMenuItem.button.backgroundColor = Color.blue.base
        reminderMenuItem.title = "Reminders"
    }
    
    fileprivate func prepareMenuController() {
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        mc.menu.delegate = self
        mc.menu.views = [addButton, audioLibraryMenuItem, reminderMenuItem]
    }
}

extension RootViewController {
    @objc
    fileprivate func handleToggleMenu(button: Button) {
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        if mc.menu.isOpened {
            mc.closeMenu { (view) in
                (view as? MenuItem)?.hideTitleLabel()
            }
        } else {
            mc.openMenu { (view) in
                (view as? MenuItem)?.showTitleLabel()
            }
        }
    }
}

extension RootViewController: MenuDelegate {
    func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool) {
        guard isOutside else {
            return
        }
        
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        mc.closeMenu { (view) in
            (view as? MenuItem)?.hideTitleLabel()
        }
    }
}
