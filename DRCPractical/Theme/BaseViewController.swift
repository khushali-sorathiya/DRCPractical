//
//  BaseViewController.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import UIKit

class BaseViewController: UIViewController{
    
    //MARK: Vaiables
    var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var navigationBar: NavigationBarView!
    var statusBar: StatusBarView!
    var isOnlyStatusBar:Bool = false
    var isNavigationBar:Bool = true
    var isVisibleFav = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SetUp Navigation and Status bar
        statusBar = StatusBarView.loadNib()
        self.view.addSubview(self.statusBar)
        navigationBar = NavigationBarView.loadNib()
        self.view.addSubview(self.navigationBar)
        
        self.navigationBar.layoutIfNeeded()
        navigationBar.btnTrailing.isHidden = !isVisibleFav
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //configure()
        self.view.layoutIfNeeded()
    }
    
    deinit {
        //WebRequester.shared.cancelAllReuest()
        print("Remove NotificationCenter Deinit \(self)")
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure() {
        
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top
        
        self.statusBar.anchor(top: nil, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom:self.view.safeAreaLayoutGuide.topAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor , padding:.zero, size: .init(width: 0, height: topPadding ?? 0))
        self.statusBar.bringToFront()

        self.navigationBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom:nil, trailing: self.view.safeAreaLayoutGuide.trailingAnchor , padding:.zero, size: .init(width: 0, height: UINavigationController.topbarHeight))
        self.navigationBar.bringToFront()

        if isOnlyStatusBar{
            navigationBar.isHidden = isOnlyStatusBar
        }else{
            navigationBar.isHidden = !isNavigationBar
            statusBar.isHidden = !isNavigationBar
        }
        
    }
   
}

//MARK:- Custom User Actions
extension BaseViewController{
    @objc func onClickBack(_ sender: UIButton){
        //print("Back from Baseview")
    }
}

//MARK:- Custom redirection methods
extension BaseViewController{
    func pushViewController(_ viewController: UIViewController, animated: Bool = true){
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @discardableResult
    func popViewController(animated: Bool = true) -> UIViewController?{
        //sharedAppdelegate.stopLoader()
        return self.navigationController?.popViewController(animated: animated)
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool = true) -> [UIViewController]?{
        //sharedAppdelegate.stopLoader()
        return self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        let viewControllers = self.navigationController!.viewControllers
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    func popToViewControllers(_ ofClass: AnyClass, animated: Bool = true) {
        let viewControllers = self.navigationController!.viewControllers
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    override func dismiss(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
    
    func present(asPopUpView vc: UIViewController, completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: completion)
    }
    
    //MARK: SET ROOT CONTROLLER TO Home SCREEN
    func setHomeRootViewController() {
        DispatchQueue.main.async {
            
        }
    }
    
}

extension BaseViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


