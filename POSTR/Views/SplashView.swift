//
//  SplashView.swift
//  POSTR
//
//  Created by Maryann Yin on 2/9/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation
import UIKit

protocol SplashViewDelegate {
    func animationEnded()
}

class SplashView: UIView {
    
    var delegate: SplashViewDelegate?
    
    lazy var logoImage: UIImageView = {
        let theLogoImage = UIImageView()
        theLogoImage.image = #imageLiteral(resourceName: "postrLogo")
        theLogoImage.contentMode = .scaleAspectFit
        return theLogoImage
    }()
    
    lazy var versionLabel: UILabel = {
        let version = UILabel()
        version.text = "Version 1.0"
        version.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        version.textAlignment = .center
        return version
    }()
    
    lazy var copyrightLabel: UILabel = {
        let copyright = UILabel()
        copyright.text = "\u{A9} Team On-The-Line" // Unicode scalar U+00A9
        copyright.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        copyright.textAlignment = .center
        return copyright
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
        //animateView()
    }
    
    private func setupViews() {
        setupLogoImage()
        setupVersionLabel()
        setupCopyrightLabel()
    }
    
    private func setupLogoImage() {
        addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        logoImage.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor)
    }
    
    private func setupVersionLabel() {
        addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        versionLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    private func setupCopyrightLabel() {
        addSubview(copyrightLabel)
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabel.centerXAnchor.constraint(equalTo: versionLabel.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    public func animateView() {
        
        UIView.animate(withDuration: 0.5, delay: 3.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: [.curveLinear], animations: {
            
            self.logoImage.frame = self.logoImage.frame.offsetBy(dx: 0, dy: -900)
            self.versionLabel.frame = self.versionLabel.frame.offsetBy(dx: 0, dy: -900)
            self.copyrightLabel.frame = self.copyrightLabel.frame.offsetBy(dx: 0, dy: -900)
        }) { (success:Bool) in
            if success {
                self.logoImage.frame = self.logoImage.frame.offsetBy(dx: 0, dy: 0)
                self.versionLabel.frame = self.versionLabel.frame.offsetBy(dx: 0, dy: 0)
                self.copyrightLabel.frame = self.copyrightLabel.frame.offsetBy(dx: 0, dy: 0)
                //Fade the entire view out
                UIView.animate(withDuration: 0.5, animations: {
                    self.logoImage.layer.opacity = 0
                    self.versionLabel.layer.opacity = 0
                    self.copyrightLabel.layer.opacity = 0
                    self.alpha = 0
                }) {(success) in
                    self.delegate?.animationEnded()
                    
                }
            }
        }
    }
    
}

