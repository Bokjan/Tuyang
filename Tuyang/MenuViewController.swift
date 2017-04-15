//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!

	@IBOutlet weak var usernameLabel: UILabel!

	@IBOutlet weak var avatarImage: UIImageView!
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!

    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?


	@IBOutlet weak var avatar: UIImageView!

	func beforeViewDidLoad() {
		let username = UserDefault.getValue(key: "username") as! String
		let usertoken = UserDefault.getValue(key: "usertoken") as! String
//		Alamofire.request(Http.genPath(route: "users/info"), method: .post, parameters: ["username":username, "token":usertoken]).responseString { response in
//			if let str = response.result.value {
//				let json = JSON(str)
//				if let avatarUrl = json["result"]["avatar_url"].string {
//					Global.avatarUrl = avatarUrl
//					UserDefault.setValue(key: "avatarUrl", value: avatarUrl)
//					self.avatarImage.downloadedFrom(link: avatarUrl)
//				}
//			}
//		}
		if let jsonstr = Just.post(Http.genPath(route: "users/info"), json: ["username":username, "token":usertoken]).text {
			debugPrint(jsonstr)
			if let jsonData = jsonstr.data(using: String.Encoding.utf8) {
				let json = JSON(data: jsonData)
				if let avatarUrl = json["result"]["avatar_url"].string {
					Global.avatarUrl = avatarUrl
					UserDefault.setValue(key: "avatarUrl", value: avatarUrl)
					debugPrint(avatarUrl)
					debugPrint(jsonstr)
					self.avatarImage.downloadedFrom(link: avatarUrl)
				}
			}
		}
	}

    override func viewDidLoad() {
		beforeViewDidLoad()
		self.avatar.layer.masksToBounds = true
		self.avatar.layer.cornerRadius = 30
		usernameLabel.text = Global.username
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
		arrayMenuOptions.append(["title":"我的足迹", "icon":"MyTrack"])
		arrayMenuOptions.append(["title":"系统设置", "icon":"Settings"])
        arrayMenuOptions.append(["title":"关于我们", "icon":"AboutUs"])
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
