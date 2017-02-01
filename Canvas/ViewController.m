//
//  ViewController.m
//  Canvas
//
//  Created by  Michael Lin on 2/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenOpen;
@property (nonatomic, assign) CGPoint trayCenterWhenClosed;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a

    self.trayCenterWhenOpen = self.trayView.center;
    self.trayCenterWhenClosed = CGPointMake(self.trayCenterWhenOpen.x, self.trayCenterWhenOpen.y + self.trayView.frame.size.height - 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
        self.trayOriginalCenter = self.trayView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
        CGPoint translation = [sender translationInView:self.trayView];
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x, self.trayOriginalCenter.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
        CGPoint velocity = [sender velocityInView:self.trayView];
        if (velocity.y > 0) {
            NSLog(@"MOVING DOWN");
            [UIView animateWithDuration:0.5 animations:^{
                self.trayView.center = self.trayCenterWhenClosed;
            }];
        } else {
            NSLog(@"MOVING UP");
            [UIView animateWithDuration:0.5 animations:^{
                self.trayView.center = self.trayCenterWhenOpen;
            }];
        }
    }
}

@end
