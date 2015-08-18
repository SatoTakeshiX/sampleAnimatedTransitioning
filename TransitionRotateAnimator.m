//
//  TransitionRotateAnimator.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/16.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "TransitionRotateAnimator.h"

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
    //insertaddsubviewでもよい
    [containerView addSubview:toView];
    
    //リバースによって、遷移先のビューを再背面にする
    //最初に実行される
    if (!self.isReverse) [containerView sendSubviewToBack:toView];
    
    //パースペクティブの初期値を設定する
    //（Identityは3Dマトリクスの単位行列で、数字で言えば1と同じ、演算しても結果が変わらない値
    CATransform3D transform = CATransform3DIdentity;

    //透視変換の導入 m34で設定が可能
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    //フリップ、動くビューを決める。リバースするなら遷移元。リバースじゃないなら前の画面
    UIView *flippedSectionOfView = self.isReverse ? toView : fromView;
    
    //このフレームはどんなフレームだ？？
    ////x軸が0
    //y軸が高さの２倍
    //横幅(width)が高さ
    //高さ(height)が横幅
    //アニメーションをする前にフレームは設定してしまう。
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
                                                                    
                                                                    if (self.isReverse)//一つ前のビューに戻るとき
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
                                  
                                  
 
                                  if (self.isTabbar) {

                                      flippedSectionOfView.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));                                      
                                      flippedSectionOfView.layer.transform = [self rotate:YES];

                                  }
                                  
                                  //システムに画面遷移が終了したことを知らせる。
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
}

- (CATransform3D)rotate:(BOOL)initTransform
{
    //CATransform3DMakeRotationは
    
    
    /*
     第一引数：回転する角度を指定
     第二引数：X軸での回転成分を指定
     第三引数：Y軸での回転成分を指定
     第四引数：Z軸での回転成分を指定
     
     M_PI_2→円周率の1/2を表す定数
     */
    
    
    
    /*
     
      CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, -2.0);
     半径半分で回転しつつ、z軸で-2の位置に移動するという意味
     */
    CATransform3D transform = initTransform ? CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 0.0) : CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, -2.0);
    
    return  transform;
}

@end
