//
//  TransitionRotateAnimator.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/16.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "TransitionRotateAnimator.h"

@interface TransitionRotateAnimator ()
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGFloat percentComplete;
@property (nonatomic, assign) CGFloat transitionDuration;
@end


@implementation TransitionRotateAnimator

- (instancetype)init
{
    if (self = [super init])
    {
        // アニメーションの時間
        self.duration = 1.0f;
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [self rotateTransition:transitionContext fromView:fromVC.view toView:toVC.view];
}

#pragma mark - animation

// アニメーションを作る
- (void)rotateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromView:(UIView *)fromView toView:(UIView *)toView
{
    
    //コンテナビューを取得
    UIView* containerView = [transitionContext containerView];

    //コンテナビューに遷移先のビューを追加
    [containerView addSubview:toView];
    
    //次のページに行く場合は遷移先のビューを再背面にする
    if (!self.isReverse) [containerView sendSubviewToBack:toView];
    
    //パースペクティブの初期値を設定する
    //CATransform3DIdentityは3Dマトリクスの単位行列で、数字で言えば1と同じ、演算しても結果が変わらない値
    CATransform3D transform = CATransform3DIdentity;

    //透視変換をm34で設定が可能
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    //動くビューを決める。戻るなら遷移元が動く。次のページに行くなら前の画面が動く。
    UIView *flippedSectionOfView = self.isReverse ? toView : fromView;
    
    //前のページに戻る場合、先に動かすビューのフレームを指定しておく
    if (self.isReverse) flippedSectionOfView.frame = CGRectMake(0, CGRectGetHeight(flippedSectionOfView.frame)*2, flippedSectionOfView.frame.size.height, flippedSectionOfView.frame.size.width);
    
    //アニメーション時間を取得する
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:1.0
                                                                animations:^{
                                                                    //transformの変更して、回転を実行
                                                                    flippedSectionOfView.layer.transform = [self rotate:self.isReverse];
                                                                    
                                                                    if (self.isReverse)//前の画面に戻るとき
                                                                    {
                                                                        //フレームを0,0に直す
                                                                        flippedSectionOfView.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
                                                                    } else//次のビューに進むとき
                                                                    {
                                                                        //
                                                                        flippedSectionOfView.frame = CGRectMake(0, CGRectGetHeight(flippedSectionOfView.frame)*2, CGRectGetWidth(flippedSectionOfView.frame), CGRectGetHeight(flippedSectionOfView.frame));
                                                                    }
                                                                }];
                              } completion:^(BOOL finished) {
                                  //キャンセルされた場合
                                  if ([transitionContext transitionWasCancelled])
                                  {
                                      //遷移先のビューを消す
                                      [toView removeFromSuperview];
                                  } else {
                                      //キャンセルがなかった場合は遷移元のビューを消す
                                      [fromView removeFromSuperview];
                                  }
                                  
                                  //タブバーの場合
                                  if (self.isTabbar) {

                                      //動かすビューをフレームをリセット
                                      flippedSectionOfView.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));                                      
                                      //向きもリセットする
                                      flippedSectionOfView.layer.transform = [self rotate:YES];

                                  }
                                  
                                  //システムに画面遷移が終了したことを知らせる。
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
}

- (CATransform3D)rotate:(BOOL)initTransform
{
     //半径半分で回転しつつ、z軸で-2の位置に移動する
    CATransform3D transform = initTransform ? CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 0.0) : CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, -2.0);
    
    return  transform;
}


#pragma mark - UIViewControllerInteractiveTransitioning Delegate
- (void)startInteractiveTransition:
(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 画面遷移コンテキストを保存
    self.transitionContext = transitionContext;
    
    // 遷移元、遷移先のビューコントローラを取得
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // コンテナビューにビューを追加
    [[transitionContext containerView] insertSubview:toVC.view
                                        belowSubview:fromVC.view];
    // 画面遷移時間を取得し保存
    self.transitionDuration = [[fromVC transitionCoordinator] transitionDuration];
}

- (CGFloat)completionSpeed
{
    return self.duration;
}


#pragma mark - private methods
// 画面遷移の進捗を更新
- (void)updateInteractiveTransitionWithTranslation:(CGPoint)translation
{
    if (self.transitionContext == nil) return;
    
    UIViewController *fromVC =
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // ビューの位置を更新
    CGRect frame = fromVC.view.frame;
    frame.origin.x = translation.x;
    frame.origin.y = translation.y;
    fromVC.view.frame = frame;
    
    // 画面遷移の進捗を更新
    self.percentComplete = frame.origin.x < 0 ? 0 : frame.origin.x / frame.size.width;
    
    NSLog(@"percent : %f", self.percentComplete);
    
    [self.transitionContext updateInteractiveTransition:self.percentComplete];
}

// インタラクティブ画面遷移終了
- (void)finishInteractiveTransitionWithVelocity:(CGPoint)velocity
{
    if (self.transitionContext == nil) return;
    
    UIViewController *fromVC =
    [self.transitionContext
     viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 最終frameの計算
    CGRect frame = fromVC.view.frame;
    CGRect finalFrame = frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat dx = width - frame.origin.x;
    CGFloat dy = velocity.y < 0 ?
    - (height + frame.origin.y) : height - frame.origin.y;
    
    if (velocity.y == 0 || fabs(dx/dy) < fabs(velocity.x/velocity.y)) {//右に消える
        finalFrame.origin.x = width;
        finalFrame.origin.y += dx * velocity.y / velocity.x;
    } else { // 上または下に消える
        finalFrame.origin.x += dy * velocity.x / velocity.y;
        finalFrame.origin.y = (velocity.y < 0 ? -height : height);
    }
    
    // アニメーション時間の計算 --- (1)
    NSTimeInterval duration = self.transitionDuration // --- (1-a)
    * (1 - self.percentComplete) // --- (1-b)
    / [self completionSpeed]; // --- (1-c)
    
    // インタラクティブ画面遷移終了 --- (2)
    [self.transitionContext finishInteractiveTransition];
    
    // 残りのアニメーションを実行 --- (3)
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished){
                         // 画面遷移終了を通知 --- (4)
                         [self.transitionContext completeTransition:YES];
                     }];
    
}

// インタラクティブ画面遷移キャンセル
- (void)cancelInteractiveTransition
{
    if (self.transitionContext == nil) return;
    
    UIViewController *fromVC =
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect frame = [self.transitionContext initialFrameForViewController:fromVC];
    
    // アニメーション時間の計算 --- (1)
    NSTimeInterval duration = self.transitionDuration
    * self.percentComplete
    / [self completionSpeed];
    
    // インタラクティブ画面遷移キャンセル --- (2)
    [self.transitionContext cancelInteractiveTransition];
    
    // キャンセル時のアニメーションを実行 --- (3)
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // 画面遷移終了を通知
                         [self.transitionContext completeTransition:NO];
                     }];
}


@end
