//
//  AddDailyComponent.swift
//  DailyMood
//
//  Created by kino on 14-7-14.
//  Copyright (c) 2014 kino. All rights reserved.
//

import Foundation


@objc(AddDailyComponent)

class AddDailyComponent: NSObject {
    
    weak var hostController:UIViewController?
    
    init(controller:UIViewController){
        hostController = controller
    }
    
    func showComponent(){
        
    }
}

class MoodComponent : AddDailyComponent{
    override func showComponent() {
        
    }
}

class PictureComponent : AddDailyComponent ,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        GKImagePickerDelegate{
    
    var pictrueFinishBlock:(image:UIImage)->Void?
    var isExistPicture:Bool = false
    
    init(controller: UIViewController, pictureFinish:(image:UIImage)->Void){
        pictrueFinishBlock = pictureFinish
        
        super.init(controller: controller)
    }
    
    deinit{
        println("opps!!!")
    }
    
    override func showComponent() {
        
        var sheet = DoActionSheet()
        sheet.nAnimationType = 2 //todo i don not how to use the objc's enum in swift...
                                 //DoAlertViewTransitionStyle.DoASTransitionStylePop doesn't work
        
        sheet.showC("Chose a mood for now  :)",
            cancel: "Cancel",
            buttons: ["take picture","picture library"],
            result: {[weak self] result in
                println("result : \(result)")
//                self.takePhoto()
                
                if let weakSelf = self{
                    switch result{
                    case 0:
                        weakSelf.takePhoto()
                        println("take photo")
                    case 1:
                        weakSelf.selectPhotoFromLib()
                    default:
                        println("opps?")
                    }
                }
            })
        
    }
    
    func takePhoto(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
//            var picker:UIImagePickerController = UIImagePickerController()
//            picker.delegate = self
//            picker.allowsEditing = true
//            picker.sourceType = UIImagePickerControllerSourceType.Camera
//            hostController?.presentViewController(picker, animated: true, completion: nil)
            imagePicker = GKImagePicker(sourceType: UIImagePickerControllerSourceType.Camera)
            
            imagePicker.cropSize = CGSizeMake(320, 160);
            imagePicker.delegate = self;
            imagePicker.resizeableCropArea = false;
            hostController?.presentViewController(imagePicker.imagePickerController, animated: true, completion: nil)
        }
    }
    
    var imagePicker = GKImagePicker(sourceType: UIImagePickerControllerSourceType.PhotoLibrary)
    
    func selectPhotoFromLib(){
        
        imagePicker = GKImagePicker(sourceType: UIImagePickerControllerSourceType.PhotoLibrary)
        
        imagePicker.cropSize = CGSizeMake(320, 160);
        imagePicker.delegate = self;
        imagePicker.resizeableCropArea = false;
        println("\(hostController) and \(imagePicker.imagePickerController)")
        
        hostController?.presentViewController(imagePicker.imagePickerController, animated: true, completion: nil)
    }
    
    ///UIImagePickerControllerDelegate
    
    func imagePicker(imagePicker: GKImagePicker!, pickedImage image: UIImage!) {
//        var chosenImage = info[UIImagePickerControllerEditedImage] as UIImage
        imagePicker.imagePickerController.dismissViewControllerAnimated(true, completion:nil)
        
        pictrueFinishBlock(image: image)?
    }
    
    func imagePickerDidCancel(imagePicker: GKImagePicker!) {
        imagePicker.imagePickerController.dismissViewControllerAnimated(true, completion:nil)
    }
    
}

class LocationComponent : AddDailyComponent{
    override func showComponent() {
        
    }
}

class WeatherComponent : AddDailyComponent{
    override func showComponent() {
        
    }
}