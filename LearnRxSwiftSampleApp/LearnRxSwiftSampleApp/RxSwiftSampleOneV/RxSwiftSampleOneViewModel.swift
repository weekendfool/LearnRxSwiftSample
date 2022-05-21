//
//  RxSwiftSampleOneViewModel.swift
//  LearnRxSwiftSampleApp
//
//  Created by Oh!ara on 2022/05/21.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - protocol

protocol RxSwiftSampleOneViewModelInput: AnyObject {
    var isPauseTimer: PublishRelay<Bool> { get }
    var isResetButtonTapped: PublishRelay<Void> { get }
}

protocol RxSwiftSampleOneViewModelOutput: AnyObject {
    var isTimerWorked: Driver<Bool> { get }
    var timerText: Driver<String> { get }
    var isResetButtonHidden: Driver<Bool> { get }
}

protocol RxSwiftSampleOneViewModelType: AnyObject {
    var input: RxSwiftSampleOneViewModelInput { get }
    var output: RxSwiftSampleOneViewModelOutput { get }
}

// MARK: - class

//final class RxSwiftSampleOneViewModel: RxSwiftSampleOneViewModelType, RxSwiftSampleOneViewModelInput,  RxSwiftSampleOneViewModelOutput {
//    var input: RxSwiftSampleOneViewModelInput { return self }
//    var output: RxSwiftSampleOneViewModelOutput { return self }
//
//    // MARK: - input
//    let isPauseTimer = PublishRelay<Bool>()
//    var isResetButtonTapped = PublishRelay<Void>()
//
//    // MARK: - output
//    let isTimerWorked: Driver<Bool>
//    let timerText: Driver<String>
//    let isResetButtonHidden: Driver<Bool>
//
//    private let disposeBag = DisposeBag()
//    private let totalTimeDuration = BehaviorRelay<Int>(value: 0)
//
//    init() {
//        isTimerWorked = isPauseTimer.asDriver(onErrorDriveWith: .empty())
//
//        timerText = totalTimeDuration
//            .map { String("\(Double($0) / 10)") }
//            .asDriver(onErrorDriveWith: .empty())
//
//        isResetButtonHidden = Observable.merge(isTimerWorked.asObservable(), isResetButtonTapped.map { _ in
//            true }.asObservable())
//        .skip(1)
//        .asDriver(onErrorDriveWith: .empty())
//
//        isTimerWorked.asObservable()
//            .flatMapLatest { [weak self] isWorked -> Observable<Int> in
//                if isWorked {
////                    return Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
//                    return Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
//                        .withLatestFrom(Observable<Int>.just(self?.totalTimeDuration.value ?? 0)) { ($0 + $1)}
//                } else {
//                    return Observable<Int>.just(self?.totalTimeDuration.value ?? 0)
//                }
//            }
//            .bind(to: totalTimeDuration)
//            .disposed(by: disposeBag)
//
//        isResetButtonTapped.map { _ in 0 }
//            .bind(to: totalTimeDuration)
//            .disposed(by: disposeBag)
//        }
//
//
//}

final class RxSwiftSampleOneViewModel: RxSwiftSampleOneViewModelType, RxSwiftSampleOneViewModelInput, RxSwiftSampleOneViewModelOutput {
    
    var isResetButtonTapped: PublishRelay<Void>
    
    var input: RxSwiftSampleOneViewModelInput { return self }
    var output: RxSwiftSampleOneViewModelOutput { return self }

    // MARK: - Input
    let isPauseTimer = PublishRelay<Bool>()
    var isResetButtonTaped = PublishRelay<Void>()

    // MARK: - Output
    let isTimerWorked: Driver<Bool>
    let timerText: Driver<String>
    let isResetButtonHidden: Driver<Bool>

    private let disposeBag = DisposeBag()
    private let totalTimeDuration = BehaviorRelay<Int>(value: 0)

    init() {
        isTimerWorked = isPauseTimer.asDriver(onErrorDriveWith: .empty())

        timerText = totalTimeDuration
            .map { String("\(Double($0) / 10)") }
            .asDriver(onErrorDriveWith: .empty())
        
        isResetButtonHidden = Observable.merge(isTimerWorked.asObservable(), isResetButtonTaped.map { _ in true }.asObservable())
            .skip(1)
            .asDriver(onErrorDriveWith: .empty())

        isTimerWorked.asObservable()
            .flatMapLatest { [weak self] isWorked -> Observable<Int> in
                if isWorked {
                    return Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
                        .withLatestFrom(Observable<Int>.just(self?.totalTimeDuration.value ?? 0)) { ($0 + $1) }
                } else {
                    return Observable<Int>.just(self?.totalTimeDuration.value ?? 0)
                }
             }
            .bind(to: totalTimeDuration)
            .disposed(by: disposeBag)

        isResetButtonTaped.map { _ in 0 }
            .bind(to: totalTimeDuration)
            .disposed(by: disposeBag)
    }
}


