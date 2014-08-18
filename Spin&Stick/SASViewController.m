//
//  SASViewController.m
//  Spin&Stick
//
//  Created by Patrick D'Errico on 8/14/14.
//  Copyright (c) 2014 derricp1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SASViewController.h"
#import "SASMenuScene.h"

@implementation SASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [SASMenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.

}

-(void)viewWillAppear:(BOOL)animated
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    CGFloat height = screenRect.size.height;
    
    SASMenuScene* ms = [[SASMenuScene alloc] initWithSize:CGSizeMake(width,height)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene:ms];
    
}

@end
