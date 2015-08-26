//
//  RotateAnimationNavigationController.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/16.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "RotateAnimationNavigationController.h"
#import "TransitionRotateAnimator.h"
#import "rootViewController.h"
@interface RotateAnimationNavigationController()<PanInteractionDelegate, UIViewControllerTransitioningDelegate>

@property(nonatomic, strong) TransitionRotateAnimator *rotateAnimator;

@end



@implementation RotateAnimationNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    self.rotateAnimator = [TransitionRotateAnimator new];
    self.rotateAnimator.delegate = self;
    //画面を戻る場合はリバースフラグを立てる
    if (operation == UINavigationControllerOperationPop) {
        return nil;
    }
    self.rotateAnimator.isReverse = operation == UINavigationControllerOperationPop;
    
    return self.rotateAnimator;
}


/*
 インタラクションコントローラを返すメソッド（ナビゲーションコントローラ）
 */
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    
    TransitionRotateAnimator *animateCon = (TransitionRotateAnimator *)animationController;
    
    return animateCon;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
  
//    UIViewController *rootVC = navigationController.viewControllers[0];
    
    [self addGesture];

    
}

#pragma mark -
#pragma mark SlideInteractionDelegate, PanInteractionDelegate
- (void)interactionBeganAtPoint:(CGPoint)point
{

    
}

/*
 add gesture
 */

-(void)addGesture
{
    UIPanGestureRecognizer *gesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    
    rootViewController *rootVC = (rootViewController *)self.viewControllers[0];
    
    [rootVC.view addGestureRecognizer:gesture];
}

#pragma mark gesture handler
// ジェスチャーハンドラ
// 指の位置に応じて画面遷移を進める
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // 画面遷移開始
            CGPoint point = [gesture locationInView:self.view];
            self.rotateAnimator.interactive = YES;
            [self interactionBeganAtPoint:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // 画面遷移の進捗を更新
            CGPoint translation = [gesture translationInView:self.view];
            [self.rotateAnimator updateInteractiveTransitionWithTranslation:translation];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            // ジェスチャーの方向によりキャンセルまた終了を判断
            CGPoint velocity = [gesture velocityInView:self.view];
            if (velocity.x <= 0) {
                [self.rotateAnimator cancelInteractiveTransition];
            } else {
                [self.rotateAnimator finishInteractiveTransitionWithVelocity:velocity];
            }
            self.rotateAnimator.interactive = NO;
            break;
        }
        default:
            break;
    }
}



@end
