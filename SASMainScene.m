//
//  SASMainScene.m
//  Spin&Stick
//
//  Created by Patrick D'Errico on 8/17/14.
//  Copyright (c) 2014 derricp1. All rights reserved.
//

#import "SASMainScene.h"
#import "SASBlock.h"

@interface SASMainScene()
    @property float blocksize;
    @property int contentCreated;
    @property int numblocks;
    @property float swidth;
    @property float sheight;
    @property int csize;

    @property int level;

    @property int gravity_x;
    @property int gravity_y;

    @property int maptop; //top left corner, can add half of block size
    @property NSMutableArray* blocks;

@end

@implementation SASMainScene

-(void)didMoveToView:(SKView *)view
{
    _swidth = CGRectGetMidX(self.frame) * 2;
    _sheight = CGRectGetMidY(self.frame) * 2;
    
    _level = 1;
    
    _gravity_x = 0;
    _gravity_y = 1;
    
    _csize = MIN(_swidth, _sheight);
    _blocksize = _csize/10;
    
    _maptop = CGRectGetMidX(self.frame) - (5*_blocksize);
    
    _blocks = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0;i<10;i++) {
        NSMutableArray* temp = [[NSMutableArray alloc] initWithCapacity:10];
        for (int j=0;j<10;j++) {
            [temp insertObject:[[SASBlock alloc] init] atIndex:j];
        }
        [_blocks insertObject:(id)temp atIndex:i];
    }
    
    
    for (int i=0;i<10;i++) {
        for (int j=0;j<10;j++) {
            SASBlock* s = _blocks[i][j];
            
            s.visible = NO;
            s.color = MIN(8,floor(rand()*MIN(8,_level+3)) + 1);
            s.hitsleft = MIN(5,floor(rand()*MIN(5,_level)) + 1);
            s.rotation = floor(rand()*12);
            if (s.rotation > 4) {
                s.rotation = 0;
            }
            
            if (i > 5) {
                s.visible = YES;
            }
            
            //main node
            NSString* ttstring = @"color_";
            NSString* nstring = [NSString stringWithFormat:@"%i", s.color];
            ttstring = [ttstring stringByAppendingString:nstring];
            ttstring = [ttstring stringByAppendingString:@".png"];
            
            SKSpriteNode* fullnode = [SKSpriteNode spriteNodeWithImageNamed:ttstring];
            fullnode.xScale = _csize/100;
            fullnode.yScale = _csize/100;
            
            SKAction *flash = [SKAction sequence:@[
                                                   [SKAction fadeOutWithDuration:0.1],
                                                   [SKAction fadeInWithDuration:0.1]]];
            [fullnode runAction: [SKAction repeatActionForever:flash]];
            
            if (s.hitsleft > 1) {
                NSString* qstring = [NSString stringWithFormat:@"%i", s.hitsleft];
                qstring = [qstring stringByAppendingString:@".png"];
                
                SKSpriteNode* number = [SKSpriteNode spriteNodeWithImageNamed:qstring];
                [number runAction: [SKAction repeatActionForever:flash]];
                [fullnode addChild:number];
            }
            if (s.rotation > 1) {
                NSString* qstring = @"dir_";
                qstring = [qstring stringByAppendingString:[NSString stringWithFormat:@"%i", s.hitsleft]];
                qstring = [qstring stringByAppendingString:@".png"];
                
                SKSpriteNode* rot = [SKSpriteNode spriteNodeWithImageNamed:qstring];
                [rot runAction: [SKAction repeatActionForever:flash]];
                [fullnode addChild:rot];
            }
            
            _blocks[i][j] = s;
        }
    }
    
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    //[self addChild: [self newMenuNode]];
}

@end
