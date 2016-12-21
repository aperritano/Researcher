/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material

class RootViewController: UIViewController {
    
    fileprivate var addButton: FabButton!
    fileprivate var penMenuItem: MenuItem!
    
    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    fileprivate var nextButton: FlatButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = Color.grey.lighten5.withAlphaComponent(0.5)
        

        prepareAddButton()
        prepareAddPaperButton()
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
    
    fileprivate func prepareAddPaperButton() {
        penMenuItem = MenuItem()
        penMenuItem.button.image = Icon.cm.pen
        penMenuItem.button.tintColor = .white
        penMenuItem.button.pulseColor = .white
        penMenuItem.button.backgroundColor = Color.green.base
        penMenuItem.button.depthPreset = .depth1
        penMenuItem.title = "Import Papers (RIS File)"
    }
    
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
    }
    
    fileprivate func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
    }
    
    fileprivate func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "Researcher"
        //navigationItem.detail = "Optimize your Literature Review"
        
        //navigationItem.leftViews = [menuButton]
//        navigationItem.rightViews = [starButton, searchButton]
    }
    
    fileprivate func prepareMenuController() {
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        mc.menu.delegate = self
        mc.menu.views = [addButton, penMenuItem]
    }
    
    fileprivate func prepareNextButton() {
        nextButton = FlatButton()
        nextButton.pulseAnimation = .none
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        view.layout(nextButton).edges()
    }
}

extension RootViewController {
    @objc
    fileprivate func handleNextButton() {
        navigationController?.pushViewController(NextViewController(), animated: true)
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

