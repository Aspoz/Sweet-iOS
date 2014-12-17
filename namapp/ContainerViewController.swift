////
////  ContainerViewController.swift
////  namapp
////
////  Created by Jordi Wippert on 17-12-14.
////  Copyright (c) 2014 Jordi Wippert. All rights reserved.
////
//
//import UIKit
//
//enum SlideOutState {
//    case BothCollapsed
//    case RightPanelExpanded
//}
//
//class ContainerViewController: UIViewController, DocumentViewControllerDelegate, UIGestureRecognizerDelegate {
//    var centerNavigationController: UINavigationController!
//    var documentViewController: DocumentViewController!
//    
//    var currentState: SlideOutState = .BothCollapsed {
//        didSet {
//            let shouldShowShadow = currentState != .BothCollapsed
//            showShadowForCenterViewController(shouldShowShadow)
//            println("currentState")
//        }
//    }
//    
//    var rightViewController: NoteViewController?
//    
//    let centerPanelExpandedOffset: CGFloat = 600
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        documentViewController = UIStoryboard.documentViewController()
//        documentViewController.delegate = self
//        
//        // wrap the centerViewController in a navigation controller, so we can push views to it
//        // and display bar button items in the navigation bar
//        centerNavigationController = UINavigationController(rootViewController: documentViewController)
//        view.addSubview(centerNavigationController.view)
//        addChildViewController(centerNavigationController)
//        
//        centerNavigationController.didMoveToParentViewController(self)
//        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
//        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
//        println("ViewDidLoad")
//
//    }
//    
//    // MARK: CenterViewController delegate methods
//    
//    func toggleRightPanel() {
//        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
//        
//        if notAlreadyExpanded {
//            addRightPanelViewController()
//        }
//        println("toggleRight")
//
//        animateRightPanel(shouldExpand: notAlreadyExpanded)
//    }
//    
//    func collapseSidePanels() {
//        switch (currentState) {
//        case .RightPanelExpanded:
//            toggleRightPanel()
//            println("collapse")
//
//        default:
//            break
//        }
//    }
//    
//    func addRightPanelViewController() {
//        if (rightViewController == nil) {
//            rightViewController = UIStoryboard.rightViewController()
////            rightViewController!.notes = Note.notesWithJSON()
//            println("addrightview")
//
//            addChildNoteViewController(rightViewController!)
//        }
//    }
//    
//    func addChildNoteViewController(noteViewController: NoteViewController) {
//        noteViewController.delegate = documentViewController
//        
//        view.insertSubview(noteViewController.view, atIndex: 0)
//        println("addchild")
//
//        addChildViewController(noteViewController)
//        noteViewController.didMoveToParentViewController(self)
//    }
//    
//    func animateRightPanel(#shouldExpand: Bool) {
//        if (shouldExpand) {
//            currentState = .RightPanelExpanded
//            println("animateright")
//
//            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
//        } else {
//            animateCenterPanelXPosition(targetPosition: 0) { _ in
//                self.currentState = .BothCollapsed
//                
//                self.rightViewController!.view.removeFromSuperview()
//                self.rightViewController = nil;
//            }
//        }
//    }
//    
//    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
//        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
//            self.centerNavigationController.view.frame.origin.x = targetPosition
//            }, completion: completion)
//        println("animatecenter")
//
//    }
//    
//    func showShadowForCenterViewController(shouldShowShadow: Bool) {
//        if (shouldShowShadow) {
//            centerNavigationController.view.layer.shadowOpacity = 0.8
//        } else {
//            centerNavigationController.view.layer.shadowOpacity = 0.0
//        }
//        println("shadow")
//
//    }
//    
//    // MARK: Gesture recognizer
//    
//    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
//        // we can determine whether the user is revealing the left or right
//        // panel by looking at the velocity of the gesture
//        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
//        println("gesture")
//
//        switch(recognizer.state) {
//        case .Began:
//            if (currentState == .BothCollapsed) {
//                // If the user starts panning, and neither panel is visible
//                // then show the correct panel based on the pan direction
//                
//                if (gestureIsDraggingFromLeftToRight) {
//                } else {
//                    addRightPanelViewController()
//                }
//                
//                showShadowForCenterViewController(true)
//            }
//        case .Changed:
//            // If the user is already panning, translate the center view controller's
//            // view by the amount that the user has panned
//            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
//            recognizer.setTranslation(CGPointZero, inView: view)
//        case .Ended:
//            // When the pan ends, check whether the left or right view controller is visible
//           if (rightViewController != nil) {
//                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
//                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
//            }
//        default:
//            break
//        }
//    }
//}
//
//private extension UIStoryboard {
//    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
//    
//    class func rightViewController() -> NoteViewController? {
//        return mainStoryboard().instantiateViewControllerWithIdentifier("NoteViewController") as? NoteViewController
//    }
//    
//    class func documentViewController() -> DocumentViewController? {
//        return mainStoryboard().instantiateViewControllerWithIdentifier("DocumentViewController") as? DocumentViewController
//    }
//}