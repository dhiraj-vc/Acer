//
//  GSImageViewerController.swift
/**
 *
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author     : Shiv Charan Panjeta < shiv@toxsl.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */
import UIKit

public struct GSImageInfo {
    
    public enum ImageMode : Int {
        case aspectFit  = 1
        case aspectFill = 2
    }
    public let image     : UIImage
    public let imageMode : ImageMode
    public var imageHD   : URL?
    public var imageID   : String?
    public var contentMode : UIView.ContentMode {
        return UIView.ContentMode(rawValue: imageMode.rawValue)!
    }
    
    public init(image: UIImage, imageMode: ImageMode) {
        self.image     = image
        self.imageMode = imageMode
    }
    
    public init(image: UIImage, imageMode: ImageMode, imageHD: URL?) {
        self.init(image: image, imageMode: imageMode)
        self.imageHD = imageHD
    }
    
    public init(image: UIImage, imageMode: ImageMode, imageHD: URL?, imageID: String) {
        self.init(image: image, imageMode: imageMode)
        self.imageHD = imageHD
        self.imageID = imageID
    }
    
    func calculateRect(_ size: CGSize) -> CGRect {
        
        let widthRatio  = size.width  / image.size.width
        let heightRatio = size.height / image.size.height
        
        switch imageMode {
            
        case .aspectFit:
            
            return CGRect(origin: CGPoint.zero, size: size)
            
        case .aspectFill:
            
            return CGRect(
                x      : 0,
                y      : 0,
                width  : image.size.width  * max(widthRatio, heightRatio),
                height : image.size.height * max(widthRatio, heightRatio)
            )
            
        }
    }
    
    func calculateMaximumZoomScale(_ size: CGSize) -> CGFloat {
        return max(2, max(
            image.size.width  / size.width,
            image.size.height / size.height
        ))
    }
    
}
open class GSTransitionInfo {
    open var duration: TimeInterval = 0.35
    open var canSwipe: Bool           = true
    public init(fromView: UIView) {
        self.fromView = fromView
    }
    weak var fromView : UIView?
    fileprivate var convertedRect : CGRect?
    
}
open class GSImageViewerController: UIViewController {
    open let imageInfo      : GSImageInfo
    open var transitionInfo : GSTransitionInfo?
    fileprivate let imageView  = UIImageView()
    fileprivate let scrollView = UIScrollView()
    fileprivate lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    // MARK: Initialization
    public init(imageInfo: GSImageInfo) {
        self.imageInfo = imageInfo
        super.init(nibName: nil, bundle: nil)
    }
    public convenience init(imageInfo: GSImageInfo, transitionInfo: GSTransitionInfo) {
        self.init(imageInfo: imageInfo)
        self.transitionInfo = transitionInfo
        if let fromView = transitionInfo.fromView, let referenceView = fromView.superview {
            self.transitioningDelegate = self
            self.modalPresentationStyle = .custom
            transitionInfo.convertedRect = referenceView.convert(fromView.frame, to: nil)
        }
    }
    public convenience init(image: UIImage, imageMode: UIView.ContentMode, imageHD: URL?, fromView: UIView?) {
        let imageInfo = GSImageInfo(image: image, imageMode: GSImageInfo.ImageMode(rawValue: imageMode.rawValue)!, imageHD: imageHD)
        if let fromView = fromView {
            self.init(imageInfo: imageInfo, transitionInfo: GSTransitionInfo(fromView: fromView))
        } else {
            self.init(imageInfo: imageInfo)
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Override
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScrollView()
        setupImageView()
        setupGesture()
        setupImageHD()
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = imageInfo.calculateRect(view.bounds.size)
        scrollView.frame = view.bounds
        scrollView.contentSize = imageView.bounds.size
        scrollView.maximumZoomScale = imageInfo.calculateMaximumZoomScale(scrollView.bounds.size)
    }
    // MARK: Setups
    fileprivate func setupView() {
        view.backgroundColor = UIColor.white
    }
    fileprivate func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    fileprivate func setupImageView() {
        imageView.image = imageInfo.image
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        if imageInfo.imageID != "" && KAppDelegate.loginTypeVal<3
        {
            
        let buttonBack = UIButton()
        buttonBack.frame = CGRect(x: 10, y: 20, width: 40, height: 40)
        buttonBack.setImage(UIImage(named: "ic_cross_new"), for: .normal)
        buttonBack.backgroundColor = UIColor.clear
        buttonBack.addTarget(self, action: #selector(buttonBackAction(sender:)), for: .touchUpInside)
        scrollView.addSubview(buttonBack)
            
       let button = UIButton()
           button.frame = CGRect(x: self.view.frame.size.width - 50, y: 20, width: 40, height: 40)
            button.setImage(UIImage(named: "ic_share_new"), for: .normal)
            button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
           scrollView.addSubview(button)
            
        let buttonDel = UIButton()
        buttonDel.frame = CGRect(x: self.view.frame.size.width-100, y: 20, width: 40, height: 40)
        buttonDel.setImage(UIImage(named: "ic_dlt_new"), for: .normal)
        buttonDel.backgroundColor = UIColor.clear
        buttonDel.addTarget(self, action: #selector(buttonDeleteAction(sender:)), for: .touchUpInside)
        scrollView.addSubview(buttonDel)
        }
     }
    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("ShareImage"), object: self.imageInfo.imageID )
        }
    }
    @objc func buttonBackAction(sender: UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
//        {
//            NotificationCenter.default.post(name: NSNotification.Name("ShareImage"), object: self.imageInfo.imageID )
//        }
    }
    @objc func buttonDeleteAction(sender: UIButton!) {
        self.dismiss(animated: true) {
            let info = ["Action":"Delete"]
            NotificationCenter.default.post(name: NSNotification.Name("ShareImage"), object: self.imageInfo.imageID, userInfo: info)
        }
    }
    
    fileprivate func setupGesture() {
        let single = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        let double = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        double.numberOfTapsRequired = 2
        single.require(toFail: double)
        scrollView.addGestureRecognizer(single)
        scrollView.addGestureRecognizer(double)
        
        if transitionInfo?.canSwipe == true {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
            pan.delegate = self
            scrollView.addGestureRecognizer(pan)
        }
    }
    
    fileprivate func setupImageHD() {
        guard let imageHD = imageInfo.imageHD else { return }
            
        let request = URLRequest(url: imageHD, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.imageView.image = image
            self.view.layoutIfNeeded()
        })
        task.resume()
    }
    
    // MARK: Gesture
    
    @objc fileprivate func singleTap() {
        if navigationController == nil || (presentingViewController != nil && navigationController!.viewControllers.count <= 1) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func doubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: scrollView)
        
        if scrollView.zoomScale == 1.0 {
            scrollView.zoom(to: CGRect(x: point.x-40, y: point.y-40, width: 80, height: 80), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    fileprivate var panViewOrigin : CGPoint?
    fileprivate var panViewAlpha  : CGFloat = 1
    
    @objc fileprivate func pan(_ gesture: UIPanGestureRecognizer) {
        
        func getProgress() -> CGFloat {
            let origin = panViewOrigin!
            let changeX = abs(scrollView.center.x - origin.x)
            let changeY = abs(scrollView.center.y - origin.y)
            let progressX = changeX / view.bounds.width
            let progressY = changeY / view.bounds.height
            return max(progressX, progressY)
        }
        
        func getChanged() -> CGPoint {
            let origin = scrollView.center
            let change = gesture.translation(in: view)
            return CGPoint(x: origin.x + change.x, y: origin.y + change.y)
        }

        switch gesture.state {

        case .began:
            
            panViewOrigin = scrollView.center
            
        case .changed:
            
            scrollView.center = getChanged()
            panViewAlpha = 1 - getProgress()
            view.backgroundColor = UIColor(white: 0.0, alpha: panViewAlpha)
            gesture.setTranslation(CGPoint.zero, in: nil)

        case .ended:
            
            if getProgress() > 0.25 {
                dismiss(animated: true, completion: nil)
            } else {
                fallthrough
            }
            
        default:
            
            UIView.animate(withDuration: 0.3,
                animations: {
                    self.scrollView.center = self.panViewOrigin!
                    self.view.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
                },
                completion: { _ in
                    self.panViewOrigin = nil
                    self.panViewAlpha  = 1.0
                }
            )
            
        }
    }
    
}

extension GSImageViewerController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.frame = imageInfo.calculateRect(scrollView.contentSize)
    }
    
}

extension GSImageViewerController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GSImageViewerTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .present)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GSImageViewerTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .dismiss)
    }
    
}

class GSImageViewerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let imageInfo      : GSImageInfo
    let transitionInfo : GSTransitionInfo
    var transitionMode : TransitionMode
    
    enum TransitionMode {
        case present
        case dismiss
    }
    
    init(imageInfo: GSImageInfo, transitionInfo: GSTransitionInfo, transitionMode: TransitionMode) {
        self.imageInfo = imageInfo
        self.transitionInfo = transitionInfo
        self.transitionMode = transitionMode
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionInfo.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let tempMask = UIView()
            tempMask.backgroundColor = UIColor.black
        
        let tempImage = UIImageView(image: imageInfo.image)
            tempImage.layer.cornerRadius = transitionInfo.fromView!.layer.cornerRadius
            tempImage.layer.masksToBounds = true
            tempImage.contentMode = imageInfo.contentMode
        
        containerView.addSubview(tempMask)
        containerView.addSubview(tempImage)
        
        if transitionMode == .present {
            
            let imageViewer = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! GSImageViewerController
                imageViewer.view.layoutIfNeeded()
            
                tempMask.alpha = 0
                tempMask.frame = imageViewer.view.bounds
                tempImage.frame = transitionInfo.convertedRect!
            
            UIView.animate(withDuration: transitionInfo.duration,
                animations: {
                    tempMask.alpha  = 1
                    tempImage.frame = imageViewer.imageView.frame
                },
                completion: { _ in
                    tempMask.removeFromSuperview()
                    tempImage.removeFromSuperview()
                    containerView.addSubview(imageViewer.view)
                    transitionContext.completeTransition(true)
                }
            )
            
        }
        
        if transitionMode == .dismiss {
            
            let imageViewer = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! GSImageViewerController
                imageViewer.view.removeFromSuperview()
            
                tempMask.alpha = imageViewer.panViewAlpha
                tempMask.frame = imageViewer.view.bounds
                tempImage.frame = imageViewer.scrollView.frame
            
            UIView.animate(withDuration: transitionInfo.duration,
                animations: {
                    tempMask.alpha  = 0
                    tempImage.frame = self.transitionInfo.convertedRect!
                },
                completion: { _ in
                    tempMask.removeFromSuperview()
                    imageViewer.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
            )
            
        }
        
    }
    
}

extension GSImageViewerController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            if scrollView.zoomScale != 1.0 {
                return false
            }
            if imageInfo.imageMode == .aspectFill && (scrollView.contentOffset.x > 0 || pan.translation(in: view).x <= 0) {
                return false
            }
        }
        return true
    }
    
}
