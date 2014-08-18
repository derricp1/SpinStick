//
//  SASMenuScene.m
//  Spin&Stick
//
//  Created by Patrick D'Errico on 8/14/14.
//  Copyright (c) 2014 derricp1. All rights reserved.
//

#import "SASMenuScene.h"
#import "SASMainScene.h"

@interface SASMenuScene()
    @property BOOL contentCreated;
    @property float buttx;
    @property float butty;
@end

@implementation SASMenuScene

-(void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newMenuNode]];
}

-(SKLabelNode *)newMenuNode {
    SKLabelNode *menuNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    menuNode.text = @"Begin";
    menuNode.fontSize = 42;
    menuNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    menuNode.name = @"menuNode";
    
    _buttx = CGRectGetMidX(self.frame);
    _butty = CGRectGetMidY(self.frame);
    
    return menuNode;
}

-(void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pos = [touch locationInNode:self];
    
    float tx = pos.x;
    float ty = pos.y;
    
    if (abs(tx-_buttx) < 50 && abs(ty-_butty) < 50) {
        SKNode *menuNode = [self childNodeWithName:@"menuNode"];
            if (menuNode != nil) {
                SKAction *fade = [SKAction fadeOutWithDuration:0.5];
                SKAction *remove = [SKAction removeFromParent];
                SKAction *moveSequence = [SKAction sequence:@[fade, remove]];
                [menuNode runAction: moveSequence completion:^{
                    SASMainScene *mainScene = [[SASMainScene alloc] initWithSize:self.size];
                    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
                    [self.view presentScene:mainScene transition:doors];
                }];
                
            }
    }
}


@end

