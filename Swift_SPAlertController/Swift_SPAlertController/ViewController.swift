//
//  ViewController.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/11/27.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

let SYSTEM_COLOR = UIColor.init(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var alertController: SPAlertController!
    var haveBg: Bool = false
    var lookBlur: Bool = false
    var sureAction: SPAlertAction!
    var phoneNumberTextField: UITextField!
    var passwordTextField: UITextField!
    
    var titles = ["actionSheet样式","alert样式","富文本","自定义视图","特殊情况","背景毛玻璃"]
    var dataSource = [
    ["actionSheet样式 默认动画(从底部弹出,有取消按钮)","actionSheet样式 默认动画(从底部弹出,无取消按钮)","actionSheet样式 从顶部弹出(无标题)","actionSheet样式 从顶部弹出(有标题)","actionSheet样式 水平排列（有取消样式按钮）","actionSheet样式 水平排列（无取消样式按钮)","actionSheet样式 action含图标","actionSheet样式 模拟多分区样式(>=iOS11才支持)"
      ],
    ["alert样式 默认动画(收缩动画)","alert样式 发散动画","alert样式 渐变动画","alert样式 垂直排列2个按钮","alert样式 水平排列2个以上的按钮","alert样式 设置头部图标","alert样式 含有文本输入框"
      ],
    ["富文本(action设置富文本)","富文本(头部设置富文本)"
      ],
    ["自定义头部(xib)","自定义整个对话框(alert样式)","自定义整个对话框(actionSheet样式(底))","自定义整个对话框(actionSheet样式(右)）","自定义整个对话框(actionSheet样式(左)）","自定义整个对话框(actionSheet样式(顶))","自定义整个对话框(pickerView)","自定义action部分","自定义整个对话框(全屏)"
      ],
    ["当按钮过多时，以scrollView滑动","当文字和按钮同时过多时,二者都可滑动",
    // "含有文本输入框，且文字过多",
     "action上的文字过长（垂直）","action上的文字过长（水平）"
      ],
    ["透明黑色背景样式(背景无毛玻璃,默认)","背景毛玻璃Dark样式","背景毛玻璃ExtraLight样式","背景毛玻璃Light样式"
      ]
    ]
    var dic = [Int]()
    let headerID = "header"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "演示Demo"
        tableView.sectionFooterHeight = 0.001
        setupNav()
    }
    
    private func setupNav() {
        let changeBgBtn = UIButton.init(type: .custom)
        changeBgBtn.setTitleColor(.black, for: .normal)
        changeBgBtn.setTitleColor(.blue, for: .selected)
        changeBgBtn.setTitle("切换背景", for: .normal)
        changeBgBtn.addTarget(self, action: #selector(changeBackgroundImage(btn:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: changeBgBtn)
        
        let blurBtn = UIButton.init(type: .custom)
        blurBtn.setTitleColor(.black, for: .normal)
        blurBtn.setTitleColor(.blue, for: .selected)
        blurBtn.setTitle("打开毛玻璃", for: .normal)
        blurBtn.setTitle("关闭毛玻璃", for: .selected)
        blurBtn.addTarget(self, action: #selector(lookBlurAction(btn:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: blurBtn)
    }
    
    @objc func changeBackgroundImage(btn: UIButton) {
        if btn.isSelected == false{
            tableView.backgroundView = UIImageView.init(image: UIImage.init(named: "背景2.jpg"))
            haveBg = true
        } else {
            haveBg = false
            tableView.backgroundView = nil
        }
        btn.isSelected = !btn.isSelected
        tableView.reloadData()
    }
    @objc func lookBlurAction(btn: UIButton) {
        lookBlur = !btn.isSelected
//        if btn.isSelected {
//            <#statements#>
//        } else {
//            <#statements#>
//        }
        btn.isSelected = !btn.isSelected
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertControllerTestCell")!
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 12)
        if haveBg == true {
            cell.backgroundColor = .clear
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID)
        if header == nil {
            header = UITableViewHeaderFooterView.init(reuseIdentifier: headerID)
            let label = UILabel()
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.tag = 200
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            header?.contentView.addSubview(label)
        }
        let label: UILabel = header?.viewWithTag(200) as! UILabel
        label.text = titles[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                actionSheetTest1()
            case 1:
                actionSheetTest2()
            case 2:
                actionSheetTest3()
            case 3:
                actionSheetTest4()
            case 4:
                actionSheetTest5()
            case 5:
                actionSheetTest6()
            case 6:
                actionSheetTest7()
            case 7:
                actionSheetTest8()
            default:
                actionSheetTest1()
            }
        } else if indexPath.section == 1 {//  alert样式区
            switch indexPath.row {
            case 0:
                alertTest1()
            case 1:
                alertTest2()
            case 2:
                alertTest3()
            case 3:
                alertTest4()
            case 4:
                alertTest5()
            case 5:
                alertTest6()
            case 6:
                alertTest7()
            default:
                actionSheetTest1()
            }
        } else if indexPath.section == 2 {//  富文本区
            switch indexPath.row {
            case 0:
                attributedStringTest1()
            case 1:
                attributedStringTest2()
            default:
                actionSheetTest1()
            }
        } else if indexPath.section == 3 {//  自定义
            switch indexPath.row {
            case 0:
                customTest1()
            case 1:
                customTest2()
            case 2:
                customTest3()
            case 3:
                customTest4()
            case 4:
                customTest5()
            case 5:
                customTest6()
            case 6:
                customTest7()
            case 7:
                customTest8()
            default:
                actionSheetTest1()
            }
        } else if indexPath.section == 4 { // 特殊情况区
            switch indexPath.row {
            case 0:
                specialtest1()
            case 1:
                specialtest2()
            case 2:
                specialtest4()
            case 3:
                specialtest5()
            default:
                actionSheetTest1()
            }
        } else if indexPath.section == 5 { // 背景毛玻璃示例
                   switch indexPath.row {
                   case 0:
                    background(appearanceStyle: .translucent)
                   case 1:
                       background(appearanceStyle: .blurDark)
                   case 2:
                       background(appearanceStyle: .blurExtraLight)
                   default:
                       background(appearanceStyle: .blurExtraLight)
                   }
               }
    }
}
