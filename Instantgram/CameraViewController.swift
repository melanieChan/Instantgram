//
//  CameraViewController.swift
//  Instantgram
//
//  Created by Melanie Chan on 3/6/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // when user clicks post button
    @IBAction func onPost(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        // fill in post info
        post["caption"] = commentField.text
        post["author"] = PFUser.current()
        
        let imageData = imageView.image!.pngData()  // get image
        let file = PFFileObject(name: "image.png", data: imageData!)   // turn image into object
        
        post["image"] = file    // reference to the image file object saved
        
        // save post to database
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("post saved")
            } else {
                print("error saving post")
            }
        }
        
        
    }
    
    // when user taps on image, allow user to pick image
    @IBAction func onImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // open up camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        // use photo library
        else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // get image that user chose from library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get image from info dictionary
        let image = info[.editedImage] as! UIImage
        
        // resize image
        let size = CGSize(width: 300, height: 300)
        let scaled_image = image.af_imageScaled(to: size)
        
        // set view
        imageView.image = scaled_image
        
        // dismiss camera view
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
