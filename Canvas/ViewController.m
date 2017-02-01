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

@property (nonatomic, strong) UIImageView *newlyCreatedFace;
@property (nonatomic, assign) CGPoint newlyCreatedFaceOriginalCenter;
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
- (IBAction)facePan:(UIPanGestureRecognizer *)sender {
    NSLog(@"face pan");
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        self.newlyCreatedFaceOriginalCenter = self.newlyCreatedFace.center;
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x, faceCenter.y + self.trayView.frame.origin.y);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.newlyCreatedFace.center = location;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

@end
