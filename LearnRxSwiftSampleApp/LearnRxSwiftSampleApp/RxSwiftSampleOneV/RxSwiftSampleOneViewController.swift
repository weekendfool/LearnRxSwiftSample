//
//  RxSwiftSampleOneViewController.swift
//  LearnRxSwiftSampleApp
//
//  Created by Oh!ara on 2022/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftSampleOneViewController: UIViewController {
    
    // MARK: - viewの設定
    // MARK: - 変数
    
    // 変数名：型名　＝ {}()
    // インスタンス化している
    // {}内で初期化処理？
    // computedプロパティ
    // get{} の省略形
    var timerLabel: UILabel = {
        // 設定とかを書いてる、実体
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.font = UIFont.italicSystemFont(ofSize: 40)
        label.textAlignment = NSTextAlignment.center
        // returnで設定を大元の変数に返している
        return label
        
    }()
    
    let startStopButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 50
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Reset", for: UIControl.State.normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 50
        button.isHidden = true
        return button
    }()
    
    private var viewModel: RxSwiftSampleOneViewModelType
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - ライフサイクル
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - 関数
    init(viewModel: RxSwiftSampleOneViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RxSwiftSampleOneViewController {
    // MARK: - 関数
    func bind() {
        
        startStopButton.rx.tap.asSignal()
            .withLatestFrom(viewModel.output.isTimerWorked)
            .emit { [weak self] isTimerStop in
                self?.viewModel.input.isPauseTimer.accept(!isTimerStop)
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap.asSignal()
            .emit(to: viewModel.input.isResetButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.isTimerWorked
            .drive( onNext: { [weak self] isWorked in
                if isWorked {
                    self?.startStopButton.backgroundColor = UIColor(red: 255/255, green: 110/255, blue: 134/255, alpha: 1)
                    self?.startStopButton.setTitle("Stop", for: UIControl.State.normal)
                } else {
                    self?.startStopButton.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
                    self?.startStopButton.setTitle("Start", for: UIControl.State.normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.timerText
            .drive(timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isResetButtonHidden
            .drive(resetButton.rx.isHidden)
            .disposed(by: disposeBag)

    }
    
    func setupSubView() {
        view.backgroundColor = .white
        let view10width = self.view.frame.size.width / 10
        let view20Height = self.view.frame.size.height / 20
        
        view.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view20Height * 4).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: view10width * 7).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: view20Height * 4).isActive = true
        
        view.addSubview(startStopButton)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: view20Height * 3).isActive = true
        startStopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view10width * 2).isActive = true
        startStopButton.widthAnchor.constraint(equalToConstant: view10width * 2.5).isActive = true
        startStopButton.heightAnchor.constraint(equalToConstant: view20Height * 3).isActive = true
        
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: view20Height * 3).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view10width * 2)).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: view10width * 2.5).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: view20Height * 3).isActive = true
    }
}
