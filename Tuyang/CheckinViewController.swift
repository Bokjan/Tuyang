//
//  CheckinViewController.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//

import Just
import UIKit

class CheckinViewController : BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var commentTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		commentTextField.placeholder = "#我在\(UserDefault.getValue(key: "currentTitle")!)"

		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = UIImagePickerControllerSourceType.camera
		commentTextField.delegate = self
		present(picker, animated: true, completion: { () -> Void in

		})
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		photoImageView.image = image
		picker.dismiss(animated: true, completion: { () -> Void in
		})
	}
	@IBAction func submitButtonTouched(_ sender: Any) {
		// API
		let imageBase64 = UIImageJPEGRepresentation(photoImageView.image!, 0.1)?.base64EncodedString()
		let RFC3339DateFormatter = DateFormatter()
		RFC3339DateFormatter.locale = Locale(identifier: "zh_CN")
		RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let time = RFC3339DateFormatter.string(from: Date())
		debugPrint(time)
		let comment = (commentTextField.text?.isEmpty)! ? commentTextField.placeholder : commentTextField.text!

		let jsonret = Just.post(Http.genPath(route: "visits/new"), json: ["username":Global.username!, "token":Global.usertoken!, "place_id":UserDefault.getValue(key: "currentID") as! Int, "time":time, "coordinate":UserDefault.getValue(key: "coordString") as! String, "photo":imageBase64!, "comments":comment!]).text
		debugPrint(jsonret!)
		self.dismiss(animated: true, completion: {() -> Void in

		})
	}
}
