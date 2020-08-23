//
//  HomeViewController.swift
//  Into The Void
//
//  Created by Yang on 3/20/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class HomeViewController: UIViewController {
    //variables
    var isMicAccess: Bool = false
    //Outlets
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnGamePlay: UIButton!
    //User Voice Range
    var lowestNote: Note = Notes.instance.C[4]
    var highestNote: Note = Notes.instance.C[6]
    override func viewDidLoad() {
        super.viewDidLoad()
        //ask for microphone permission
        requestMicrophoneAccess()
    }
    
    @IBAction func btnStartOnClick(_ sender: Any) {
        if isMicAccess {
            //navigate to Level Selection
            let levelSelectionVC = self.storyboard!.instantiateViewController(withIdentifier: "LevelSelectionVC") as! LevelSelectionViewController
            levelSelectionVC.modalPresentationStyle = .fullScreen
            self.present(levelSelectionVC, animated: true, completion: nil)
        } else {
            self.alert(message: Strings.NoMicrophonePermissionWarning)
        }
    }
    //for debug purpose: goes straight to gameplay
    @IBAction func btnGamePlayOnClick(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: true, completion: nil)
    }
    
    //requests microphone access (if access is not granted yet).
    //displays alert messages if user denies microphone access.
    func requestMicrophoneAccess(){
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: // The user has previously granted access
                //do nothing
                isMicAccess = true
                print("Microphone Access already granted")
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    if granted {
                        self.isMicAccess = true
                        print("Microphone Access already granted")
                    } else {
                        //alert and instructs users to turn on micrphone access
                        self.isMicAccess = false
                        self.alert(message: Strings.NoMicrophonePermissionWarning)
                    }
                }
            
            case .denied: // The user has previously denied access.
                self.isMicAccess = false
                self.alert(message: Strings.NoMicrophonePermissionWarning)
                return

            case .restricted: // The user can't grant access due to restrictions.
                self.isMicAccess = false
                print("access can't be granted due to restrictions")
                return
        @unknown default:
            print("unkown authorizationStatus Enum")
        }
    }
    
    func alert(title:String = "ALERT", message: String){
        //UI present needs to be on the main thread
        DispatchQueue.main.async() {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           self.present(alert, animated: true)
        }
    }
}
