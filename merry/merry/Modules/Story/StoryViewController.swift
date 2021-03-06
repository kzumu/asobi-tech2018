
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
    @IBOutlet weak var footerViewHeight: NSLayoutConstraint! // not use
    
    private let viewModel = StoryViewModel()
    private let disposeBag = DisposeBag()

    var comboManager = ComboManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()

        viewModel.nextChat()
        self.tableView.reloadData()
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
		tableView.register(UINib(nibName: "CallViewCell", bundle: nil), forCellReuseIdentifier: "Called")

//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped))
//        tapRecognizer.cancelsTouchesInView = false // TableViewへタップイベントを流す
//        self.tableView.addGestureRecognizer(tapRecognizer)
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

        viewModel.totalScore.asDriver()
            .map { "Score: \($0)" }
            .drive(footerView.scoreLabel.rx.text)
            .disposed(by: disposeBag)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height

        footerView.button1.rx.tap.withLatestFrom(viewModel.choice1.asObservable())
            .subscribe(onNext: { [weak self] (c) in
                guard let wself = self else { return }
                if c.score >= 3{
                    let combo = wself.comboManager.getNextComboImage()
                    let imageView = UIImageView(frame: CGRect(x: (screenWidth / 2.0) - 100, y: 300, width: 200, height: 100))
                    imageView.image = combo
                    wself.view.addSubview(imageView)

//                    wself.viewModel.appendChoiceIntoChats(c)
//                    wself.viewModel.nextChat(nextId: c.nextId)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8){
                        imageView.removeFromSuperview()
                    }
                }else{
                    self?.comboManager.endCombo()
//                    wself.viewModel.appendChoiceIntoChats(c)
//                    wself.viewModel.nextChat(nextId: c.nextId)
                }
                wself.viewModel.appendChoiceIntoChats(c)
                wself.viewModel.nextChat(nextId: c.nextId)
                wself.tableView.reloadData()
                wself.tableView.scrollToRow(at: IndexPath(row: wself.viewModel.chats.count-1, section: 0), at: .bottom, animated: true)
            }).disposed(by: disposeBag)
        
        footerView.button2.rx.tap.withLatestFrom(viewModel.choice2.asObservable())
            .subscribe(onNext: { [weak self] (c) in
                guard let wself = self else { return }
                if c.score >= 3{
                    let combo = wself.comboManager.getNextComboImage()
                    let imageView = UIImageView(frame: CGRect(x: (screenWidth / 2.0) - 100, y: 300, width: 200, height: 100))
                    imageView.image = combo
                    wself.view.addSubview(imageView)

//                    wself.viewModel.appendChoiceIntoChats(c)
//                    wself.viewModel.nextChat(nextId: c.nextId)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8){
                        imageView.removeFromSuperview()
                    }
                }else{
                    self?.comboManager.endCombo()
//                    wself.viewModel.appendChoiceIntoChats(c)
//                    wself.viewModel.nextChat(nextId: c.nextId)
                }
                wself.viewModel.appendChoiceIntoChats(c)
                wself.viewModel.nextChat(nextId: c.nextId)
                wself.tableView.reloadData()
                wself.tableView.scrollToRow(at: IndexPath(row: wself.viewModel.chats.count-1, section: 0), at: .bottom, animated: true)
            }).disposed(by: disposeBag)

        footerView.button3.rx.tap.withLatestFrom(viewModel.choice3.asObservable())
            .subscribe(onNext: { [weak self] (c) in
                guard let wself = self else { return }
                if c.score >= 3{
                    let combo = wself.comboManager.getNextComboImage()
                    let imageView = UIImageView(frame: CGRect(x: (screenWidth / 2.0) - 100, y: 300, width: 200, height: 100))
                    imageView.image = combo
                    wself.view.addSubview(imageView)

//                    wself.viewModel.appendChoiceIntoChats(c)
//                    wself.viewModel.nextChat(nextId: c.nextId)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8){
                        imageView.removeFromSuperview()
                    }
                }else{
                    self?.comboManager.endCombo()
//                    wself.viewModel.appendChoiceIntoChats(c)
//                    wself.viewModel.nextChat(nextId: c.nextId)
                }
                wself.viewModel.appendChoiceIntoChats(c)
                wself.viewModel.nextChat(nextId: c.nextId)
                wself.tableView.reloadData()
                wself.tableView.scrollToRow(at: IndexPath(row: wself.viewModel.chats.count-1, section: 0), at: .bottom, animated: true)
            }).disposed(by: disposeBag)

        viewModel.shouldShowFooter.subscribe(onNext: { [weak self] (should) in
            if should {
                UIView.animate(withDuration: 0.5, animations: {
                    self?.footerView.alpha = 1.0
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self?.footerView.alpha = 0.0
                })
            }
        }).disposed(by: disposeBag)

        viewModel.state.subscribe(onNext: { (s) in
            switch s {
            case .normal:
                print("[state] normal")
            case .calling(let chat):
                print("[state] calling")
                DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
                    let vc = UIStoryboard(name: "Call", bundle: nil).instantiateInitialViewController() as! CallViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.talkString = chat.text
                    self.present(vc, animated: false, completion: nil)
                })
            case .clear(let score):
                print("[state] clear")
                let vc = UIStoryboard(name: "Clear", bundle: nil).instantiateInitialViewController() as! ClearViewController
                vc.modalPresentationStyle = .fullScreen
                vc.displayScore = score
                vc.parentVC = self
                self.present(vc, animated: false, completion: nil)
            case .gameover:
                print("[state] gameover")
                let vc = UIStoryboard(name: "SurpriseCamera", bundle: nil).instantiateInitialViewController() as! SupriseCameraViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }).disposed(by: disposeBag)
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
		
		if chat.type == .call {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Called") as! CallViewCell
//			cell.heightAnchor = 30
			return cell
		} else {
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
