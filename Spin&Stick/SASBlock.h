//
//  SASBlock.h
//  Spin&Stick
//
//  Created by Patrick D'Errico on 8/17/14.
//  Copyright (c) 2014 derricp1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SASBlock : NSObject
    @property int color; //1-8
    @property int hitsleft; //1-5, 0 deletes
    @property int rotation; //0-none, 1-4 goes clockwise
    @property BOOL visible;
    @property SKSpriteNode* snode;
    @property int delay;
@end
