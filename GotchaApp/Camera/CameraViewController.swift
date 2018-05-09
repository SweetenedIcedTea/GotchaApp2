//
//  CameraViewController.swift
//  GotchaApp
//
//  Created by Lin, Kevin K. on 4/25/18.
//  Copyright © 2018 NepinNep. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var previewView: UIView!
    @IBOutlet var imagePreview: UIImageView!
    @IBOutlet var visibilityBackground: UIView!
    @IBOutlet var flashButton: UIButton!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var targetingViewOutline: UIView!
    
    var focusingImageView: FocusingImageView?
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var camPosition: AVCaptureDevice.Position = .back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loading view")
        self.flashButton.setTitle("Flash Off", for: .normal)
        
        // Status Bar background
        let gradient = CAGradientLayer()
        gradient.frame = visibilityBackground.bounds
        
        let topColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        let bottomColor = UIColor(white: 0.5, alpha: 0.0).cgColor
        
        gradient.colors = [topColor, bottomColor, bottomColor, bottomColor, bottomColor, topColor]
        
        visibilityBackground.layer.insertSublayer(gradient, at: 0)
        
        //Focusing Image View
        focusingImageView = FocusingImageView(frame: imagePreview.frame)
        
        //Gesture Recognizers
        let myTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.tapRecognized))
        let myPinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CameraViewController.pinchRecognized))
        
        focusingImageView?.addGestureRecognizer(myTapRecognizer)
        focusingImageView?.addGestureRecognizer(myPinchRecognizer)
        
        // Insert below 4 views -- View, previewView, visibilityBackground, imagePreview
        // But also above the buttons
        self.view.insertSubview(focusingImageView!, at: 4)
        
        //Targeting View
        let targetingView = TargetingView(frame: self.targetingViewOutline.frame)
        targetingView.backgroundColor = UIColor.clear
        self.view.insertSubview(targetingView, at: 4)
        
        
        //Camera Setup
        let completionHandler: (Bool) -> Void = { accessGranted in
            if accessGranted {
                print("camera access granted")
                self.setUpCameraView()
            } else {
                print("camera access denied")
                self.presentSettingsAlert()
            }
        }
        
        checkCameraAuthorization(completionHandler)
        
        //Player Specific setup
        //targetLabel.text = "Target: " + Player.target
    }
    
    func presentSettingsAlert(){
        let alert = UIAlertController(title: "Uh Oh...", message: "Photo Fun requires Camera usage. Please turn on Camera access in Settings", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) as URL? {
                UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: false], completionHandler: nil)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setUpCameraView(){
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: camPosition)
        if (captureDevice?.hasFlash)! {
            print("device has flash")
        } else {
            print("device does not have flash")
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            captureSession?.startRunning()
            
            //enabling live preview of capture
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            // Get an instance of AVCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            
        } catch {
            print(error)
        }
    }
    
    func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
                completionHandler(success)
            })
            
        case .denied:
            // The user has previously denied access.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
                completionHandler(success)
            })
            
        case .restricted:
            // The user doesn't have authority for access, e.g. parental restriction.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
                completionHandler(success)
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // FLASH
    @IBAction func toggleFlash(_ sender: UIButton) {
        switch sender.title(for: .normal)! {
        case "Flash On":
            flashButton.setTitle("Flash Off", for: .normal)
        case "Flash Off":
            if camPosition == .front{
                presentFlashAlert()
            } else {
                flashButton.setTitle("Flash On", for: .normal)
            }
        default:
            flashButton.setTitle("Flash Off", for: .normal)
        }
    }
    
    func presentFlashAlert(){
        let alert = UIAlertController(title: "Sorry", message: "Flash is not supported with back camera at the moment", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //PHOTO TAKING
    @IBAction func onTapTakePhoto(_ sender: UIButton) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        
        //Flash
        if flashButton.title(for: .normal) == "Flash On" && camPosition == .back{
            photoSettings.flashMode = .on
        } else {
            photoSettings.flashMode = .off
        }
        //        for mode in capturePhotoOutput.supportedFlashModes{
        //            print(mode)
        //        }
        
        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        print("photo taken")
    }
    
    // CAMERA FLIPPING
    @IBAction func flipCamera(_ sender: UIButton) {
        print("flipCamera pressed")
        if camPosition == .back{
            if flashButton.title(for: .normal) == "Flash On"{
                presentFlashAlert()
                flashButton.setTitle("Flash Off", for: .normal)
            }
            camPosition = .front
        } else {
            camPosition = .back
        }
        setUpCameraView()
        
    }
    
    // TAP TO FOCUS
    @objc func tapRecognized() {
        print("tap recognized")
        
        if focusingImageView!.drawJustHappened{
            return
        }
        
        focusingImageView!.doADrawing()
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: camPosition)
        
        if let focusingPoint = focusingImageView!.lastTouchLocation{
            
            do {
                try captureDevice?.lockForConfiguration()
                
                if (captureDevice?.isFocusPointOfInterestSupported)!{
                    captureDevice?.focusPointOfInterest = focusingPoint
                    captureDevice?.focusMode = .continuousAutoFocus
                }
                if (captureDevice?.isExposurePointOfInterestSupported)! {
                    captureDevice?.exposurePointOfInterest = focusingPoint
                    captureDevice?.exposureMode = .continuousAutoExposure
                }
                
                captureDevice?.unlockForConfiguration()
            } catch {
                print("error getting lock for focus")
            }
        }
    }
    
    // PINCH TO ZOOM
    var lastZoomFactor: CGFloat = 1.0
    
    @objc func pinchRecognized(_ recognizer: UIPinchGestureRecognizer){
        //        print(recognizer.velocity, recognizer.scale)
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: camPosition)
        
        let minimumZoom: CGFloat = 1.0
        let maximumZoom: CGFloat = 8.0
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), captureDevice!.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try captureDevice?.lockForConfiguration()
                defer { captureDevice?.unlockForConfiguration() }
                captureDevice?.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        let newScaleFactor = minMaxZoom(recognizer.scale * lastZoomFactor)
        
        switch recognizer.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
        
    }
    
    //TRANSITIONS
    
    @IBAction func unwindToCam(unwindSegue: UIStoryboardSegue){
        print("unwind to Cam triggered")
        self.imagePreview.image = nil
        self.focusingImageView!.clearRects()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier!
        switch id{
        case "showSendVC":
            print("showing send view")
            let SEVC = segue.destination as! SendViewController
            
            SEVC.image = self.imagePreview.image
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CameraViewController Appearing")
    }
}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    //Provides the captured image and metadata from an image capture
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        //get the image data
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        //create a UIImage from the data and set the imagePreview image
        if let capturedImage = UIImage.init(data: imageData, scale: 1.0) {
            imagePreview.image = capturedImage
            
            if camPosition == .front {
                let flipped = UIImage(cgImage: capturedImage.cgImage!, scale: 1.0, orientation: .leftMirrored)
                imagePreview.image = flipped
            }
            
            print("image preview set")
        }
        
        //segue to the send view controller
        performSegue(withIdentifier: "showSendVC", sender: self)
        
    }
    
}

