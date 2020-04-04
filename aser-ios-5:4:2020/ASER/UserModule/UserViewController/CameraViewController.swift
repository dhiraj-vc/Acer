//
//  CameraViewController.swift
//  Acer
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
import AVFoundation
import Foundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var bottomLbl: UILabel!
    //    oval.png

    var picture:[UIImage] = [
        UIImage(named: "oval.png")!,
        UIImage(named: "square.png")!,
        UIImage(named: "circle.png")!,
        UIImage(named: "heart.png")!,
        UIImage(named: "leftear.png")!,
        UIImage(named: "rightear.png")!,
        UIImage(named: "eyes.png")!,
        UIImage(named: "ic_lefteye.png")!,
        UIImage(named: "righteye.png")!,
        UIImage(named: "lips.png")!,
        UIImage(named: "lefthand.png")!,
        UIImage(named: "righthand.png")!,
        UIImage(named: "boxportarait.png")!,
        UIImage(named: "boxlandscape.png")!,
        UIImage(named: "head.png")!,
        UIImage(named: "headReverse.png")!,
        UIImage(named: "forearm.png")!,
        UIImage(named: "leftLeg.png")!,
        UIImage(named: "rightLeg.png")!,
        UIImage(named: "stomach.png")!,
        UIImage(named: "nose.png")!,
        UIImage(named: "triangle.png")!,
        UIImage(named: "boxx")!]

    var textArray: NSArray = ["  Shape Oval!","  Shape Square!","  Shape Circle!","  Shape Heart!","  Shape Left Ear!","  Shape Right Ear!","  Shape Both Eyes!","  Shape Left Eye!","  Shape Right Eye!","  Shape Lips!","  Shape Left Hand!","  Shape Right Hand!","  Shape Horizontal Box!","  Shape Vertical Box!"," head.png"," headReverse.png"," forearm.png"," Shape Left Leg"," Shape Right Leg"," Shape Stomach"," Shape Nose"," Shape Triangle!","  No Shape Overlay!"]
    
    
    @IBOutlet weak var gridImg: UIImageView!
    @IBOutlet weak var imgOverlay: UIImageView!
    
    @IBOutlet weak var shapeLayer1: UIView!
    
    @IBOutlet weak var btnCapture: UIButton!

    
    var imageIndex = 0
    
    //MARK: - AVcapture Properteis
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //=======================
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaType.video)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevice.Position.back) {
                        captureDevice = device
                        if captureDevice != nil {
                            print("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Camera intialize
    
    func beginSession()
    {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        }
        catch
        {
            print("error: \(error.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        shapeLayer1.layer.addSublayer(previewLayer!)
        
        imgOverlay.image = picture[imageIndex]//self.drawCirclesOnImage(fromImage: nil, targetSize: imgOverlay.bounds.size)
        
        self.view.bringSubviewToFront(imgOverlay)
        self.view.bringSubviewToFront(btnCapture)
        // don't use shapeLayer anymore...
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.previewLayer!.frame = self.shapeLayer1.bounds
            }
        }
    }
    
    // MARK: Set Image Layout and Color and Draw image layout
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: shapeLayer1.frame.size.width, height: shapeLayer1.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func drawImageOnImage(fromImage: UIImage? = nil, targetSize: CGSize? = CGSize.zero) -> UIImage? {
        
        if fromImage == nil && targetSize == CGSize.zero {
            return nil
        }
        
        var tmpimg: UIImage?
        
        if targetSize == CGSize.zero
        {
            tmpimg = fromImage
            
        } else {
            
            tmpimg = getImageWithColor(color: UIColor.clear, size: targetSize!)
        }
        
        guard let img = tmpimg else
        {
            return nil
        }
        
        let imageSize = img.size
        
        let scale: CGFloat = 0
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        
        img.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let selectedImg : CGImage
        

         if imageIndex == 6
        {
            selectedImg = (UIImage(named: "eyesReverse")?.cgImage!)!

        }
       else if imageIndex == 3
        {
            selectedImg = (UIImage(named: "heartReverse")?.cgImage!)!
        }
        else if imageIndex == 7
        {
            selectedImg = (UIImage(named: "ic_lefteyeReverse")?.cgImage!)!

        }
        else if imageIndex == 4
        {
            selectedImg = (UIImage(named: "leftearReverse")?.cgImage!)!

        }
        else if imageIndex == 10
        {
            selectedImg = (UIImage(named: "lefthandReverse")?.cgImage!)!

        }
        else if imageIndex == 9
        {
            selectedImg = (UIImage(named: "lipsReverse")?.cgImage!)!

        }

        else if imageIndex == 5
        {
            selectedImg = (UIImage(named: "rightearReverse")?.cgImage!)!

        }
        else if imageIndex == 8
        {
            selectedImg = (UIImage(named: "righteyeReverse")?.cgImage!)!

        }
        else if imageIndex == 11
        {
            selectedImg = (UIImage(named: "righthandReverse")?.cgImage!)!

        }
        else
        
        {
            selectedImg = picture[imageIndex].cgImage!

        }
        
        if gridImg.isHidden == true
        {
            context.draw(selectedImg, in: CGRect(x: 0.0,y: 0.0,width: 1100,height: 1100))

            
        }
        else
        {
            let gridImg : CGImage = (UIImage(named: "grid")?.cgImage!)!//((UIImage(named: "heartReverse")?.cgImage!)!)


            context.draw(gridImg, in: CGRect(x: 0.0,y: 0.0,width: 1100,height: 1100))

            context.draw(selectedImg, in: CGRect(x: 0.0,y: 0.0,width: 1100,height: 1100))

        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: Save image to gallery and crop image
    func saveToCamera()
    {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video)
        {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer!)
                {
                    if let cameraImage = UIImage(data: imageData) {
                                                
                        let finalImg = self.cropToBounds(image: cameraImage, width: 0, height: 0)
                        
//                        if let nImage = self.drawImageOnImage(fromImage: finalImg, targetSize: CGSize.zero) {
                        
                        
                        UIImageWriteToSavedPhotosAlbum(finalImg, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                        galleryCameraImageObj?.passSelectedimage(selectImage: finalImg)
                            
                            UIImageWriteToSavedPhotosAlbum(finalImg, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                            galleryCameraImageObj?.passSelectedimage(selectImage: finalImg)

                            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)

//                        }
                    }
                }
            })
        }
    }
    // MARK: crop image
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = imgOverlay.frame.size.width//CGFloat(width)
        var cgheight: CGFloat = imgOverlay.frame.size.height//CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    // MARK: Save image delegate
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
    {
        if let error = error
        {
            
            let alertController = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
            }))
            present(alertController, animated: true)
        } else {

        }
    }
    // MARK: Camera postion 
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == position
            {
                return device as? AVCaptureDevice
            }
        }
        return nil
    }
    
    // MARK: IBActoins
    @IBAction func actionCameraCapture(_ sender: AnyObject) {
        
        print("Camera button pressed")
        saveToCamera()
    }
    
    @IBAction func changeFilterTap(_ sender: Any)
    {
//        print(imageIndex)
        
        imgOverlay.image = picture[imageIndex+1]
        
        bottomLbl.isHidden = false

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(yourMethodHere), object: nil)
        
        perform(#selector(yourMethodHere), with: nil, afterDelay: 2)

        bottomLbl.text = textArray[imageIndex + 1] as? String
//        print(imageIndex)
        if imageIndex == 21
        {
            imageIndex = -2
        }
        imageIndex = imageIndex + 1
//        print("122132142    ",imageIndex)
 
    }
    
    @objc func yourMethodHere()
    {
        bottomLbl.isHidden = true

    }
    
    @IBAction func changeCameratap(_ sender: Any)
    {
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0]
        captureSession.removeInput(currentCameraInput)
        var newCamera:AVCaptureDevice! = nil
        if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
            newCamera = self.cameraWithPosition(position: .front)!
            
        } else {
            newCamera = self.cameraWithPosition(position: .back)!
            
        }
        var newVideoInput: AVCaptureDeviceInput?
        do{
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        }
        catch{
            print(error)
        }
        if let newVideoInput = newVideoInput
        {
            captureSession.addInput(newVideoInput)
        }
    }
   

    @IBAction func gridViewTap(_ sender: Any)
    {
        if gridImg.isHidden == true
        {
            gridImg.isHidden = false
        }
        else
        {
            gridImg.isHidden = true
        }
    }
    
    @IBAction func flashTap(_ sender: Any)
    {
        if let avDevice = AVCaptureDevice.default(for: AVMediaType.video)
        {
            if (avDevice.hasTorch)
            {
                do
                {
                    try avDevice.lockForConfiguration()
                }
                catch
                {
                    print("aaaa")
                }
                let currentCameraInput: AVCaptureInput = captureSession.inputs[0]
                
                if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back
                {
                    if avDevice.isTorchActive
                    {
                        avDevice.torchMode = AVCaptureDevice.TorchMode.off
                    }
                    else
                    {
                        avDevice.torchMode = AVCaptureDevice.TorchMode.on
                    }
                }
                else
                {
                    print("flash should Disable while front camera mode is ON")
                }
            }
            // unlock your device
            avDevice.unlockForConfiguration()
        }
    }
    
    @IBAction func backTap(_ sender: Any)
    {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)

    }
    
    
}
