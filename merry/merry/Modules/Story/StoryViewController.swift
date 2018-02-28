
//
//  StoryViewController.swift
//  merry
//
//  Created by 下村一将 on 2018/02/27.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerView: StoryFooterView!
    @IBOutlet weak var footerViewHeight: NSLayoutConstraint!
    
    private let viewModel = StoryViewModel()
    private let disposeBag = DisposeBag()

    var comboManager = ComboManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension StoryViewController {
    
    private func setupUI() {
        footerView.alpha = 0.0

        tableView.backgroundColor = .black
        tableView.separatorColor = UIColor.clear
        tableView.estimatedRowHeight = 10000
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive

        tableView.register(UINib(nibName: "YourChatViewCell", bundle: nil), forCellReuseIdentifier: "YourChat")
        tableView.register(UINib(nibName: "MyChatViewCell", bundle: nil), forCellReuseIdentifier: "MyChat")

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped))
        tapRecognizer.cancelsTouchesInView = false // TableViewへタップイベントを流す
        self.tableView.addGestureRecognizer(tapRecognizer)
    }

    private func subscribe() {
        viewModel.choice1.map { $0.text }
            .subscribe(onNext: { [weak self] (str) in
                self?.footerView.button1.setTitle(str, for: .normal)
            }).disposed(by: disposeBag)
        viewModel.choice2.map { $0.text }
            .subscribe(onNext: { [weak self] (str) in
                self?.footerView.button2.setTitle(str, for: .normal)
            }).disposed(by: disposeBag)
        viewModel.choice3.map { $0.text }
            .subscribe(onNext: { [weak self] (str) in
                self?.footerView.button3.setTitle(str, for: .normal)
            }).disposed(by: disposeBag)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height

        footerView.button1.rx.tap.withLatestFrom(viewModel.choice1.asObservable())
            .subscribe(onNext: { [weak self] (c) in
                guard let wself = self else { return }
                wself.viewModel.appendChoiceIntoChats(c)
                wself.viewModel.nextChat(nextId: c.nextId)
                wself.tableView.reloadData()
                wself.tableView.scrollToRow(at: IndexPath(row: wself.viewModel.chats.count-1, section: 0), at: .bottom, animated: true)
                
                if c.score >= 3{
                    var combo = self?.comboManager.getNextComboImage()
                    let imageView = UIImageView(frame: CGRect(x: (screenWidth / 2.0) - 100, y: 300, width: 200, height: 100))
                        imageView.image = combo
                    
                    self?.view.addSubview(imageView)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8){
                        imageView.removeFromSuperview()
                    }
                }else{
                    self?.comboManager.endCombo()
                }
            }).disposed(by: disposeBag)
        
        footerView.button2.rx.tap.withLatestFrom(viewModel.choice2.asObservable())
            .subscribe(onNext: { [weak self] (c) in
                guard let wself = self else { return }
                wself.viewModel.appendChoiceIntoChats(c)
                wself.viewModel.nextChat(nextId: c.nextId)
                wself.tableView.reloadData()
                wself.tableView.scrollToRow(at: IndexPath(row: wself.viewModel.chats.count-1, section: 0), at: .bottom, animated: true)
                
                if c.score >= 3{
                    var combo = self?.comboManager.getNextComboImage()
                    let imageView = UIImageView(frame: CGRect(x: (screenWidth / 2.0) - 100, y: 300, width: 200, height: 100))
                    imageView.image = combo
                    
                    self?.view.addSubview(imageView)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8){
                        imageView.removeFromSuperview()
                    }
                }else{
                    self?.comboManager.endCombo()
                }
            }).disposed(by: disposeBag)

        footerView.button3.rx.tap.withLatestFrom(viewModel.choice3.asObservable())
            .subscribe(onNext: { [weak self] (c) in
                guard let wself = self else { return }
                wself.viewModel.appendChoiceIntoChats(c)
                wself.viewModel.nextChat(nextId: c.nextId)
                wself.tableView.reloadData()
                wself.tableView.scrollToRow(at: IndexPath(row: wself.viewModel.chats.count-1, section: 0), at: .bottom, animated: true)
                
                if c.score >= 3{
                    var combo = self?.comboManager.getNextComboImage()
                    let imageView = UIImageView(frame: CGRect(x: (screenWidth / 2.0) - 100, y: 300, width: 200, height: 100))
                    imageView.image = combo
                    
                    self?.view.addSubview(imageView)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8){
                        imageView.removeFromSuperview()
                    }
                }else{
                    self?.comboManager.endCombo()
                }
            }).disposed(by: disposeBag)

        viewModel.shouldShowFooter.subscribe(onNext: { [weak self] (should) in
            if should {
                UIView.animate(withDuration: 0.5, animations: {
//                    self?.tableView.frame.size.height = self!.view.frame.height - 200
//                    self?.footerView.frame.origin.y = self!.view.frame.height - 200
                    self?.footerView.alpha = 1.0
                })
//                self?.footerViewHeight.constant = 200
//                self?.footerView.isHidden = false
            } else {
                UIView.animate(withDuration: 0.5, animations: {
//                    self?.tableView.frame.size.height = self!.view.frame.height
//                    self?.footerView.frame.origin.y = self!.view.frame.height
                    self?.footerView.alpha = 0.0
                })
//                self?.footerViewHeight.constant = 0
//                self?.footerView.isHidden = true
            }
        }).disposed(by: disposeBag)

        viewModel.state.subscribe(onNext: { (s) in
            switch s {
            case .normal:
                print("[state] normal")
            case .calling:
                print("[state] calling")
            case .clear:
                print("[state] clear")
            case .gameover:
                print("[state] gameover")
            }
        }).disposed(by: disposeBag)

//        viewModel.shouldShowFooter.onNext(false)
    }

    @objc func backgroundTapped() {
        viewModel.nextChat()
        self.tableView.reloadData()
    }
}

extension StoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = viewModel.chats[indexPath.row]
        switch chat.owner {
        case .self:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChat") as! MyChatViewCell
            cell.clipsToBounds = true
            // Todo: isRead
            cell.updateCell(text: chat.text, time: "", isRead: true)
            return cell
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChat") as! YourChatViewCell
            cell.clipsToBounds = true
            cell.updateCell(text: chat.text, time: "")
            return cell
        }
    }
}

extension StoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        self.bottomView.chatTextField.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
}
