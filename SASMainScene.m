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

    @property NSTimer* gameclock;
    @property SKSpriteNode* gravityarrow;

    @property SASBlock* nextblock;

    @property int gamestate;

@end

@implementation SASMainScene

-(void)didMoveToView:(SKView *)view
{
    _swidth = CGRectGetMidX(self.frame) * 2;
    _sheight = CGRectGetMidY(self.frame) * 2;
    
    _level = 1;
    
    _gravity_x = 0;
    _gravity_y = 1;
    
    _csize = _swidth;
    if (_sheight < _swidth) {
        _csize = _sheight;
    }
    _blocksize = _csize/10;
    
    _maptop = CGRectGetMidY(self.frame) - (5*_blocksize);

    
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    //[self addChild: [self newMenuNode]];
    
    _gameclock = [NSTimer scheduledTimerWithTimeInterval:((1/60))
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self makegarrow];
    [self makestartblock:YES];
    [self startlevel];
   
}

-(void)makegarrow
{
    _gravityarrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    _gravityarrow.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)*1.85);
    
    _gravityarrow.xScale = 1.5*_blocksize/100;
    _gravityarrow.yScale = 1.5*_blocksize/100;
    
    [self addChild:_gravityarrow];
}

-(void)makestartblock:(BOOL) vis
{
    SASBlock* s = [[SASBlock alloc] init];
    
    int rseed = _level + 3;
    if (rseed > 8) {
        rseed = 8;
    }
    s.color = arc4random_uniform(rseed) + 1;
    
    rseed = _level;
    if (rseed > 5) {
        rseed = 5;
    }
    s.hitsleft = arc4random_uniform(rseed);
    
    
    s.rotation = arc4random_uniform(12);
    if (s.rotation > 4) {
        s.rotation = 0;
    }
    
    s.visible = vis;
    
    s.delay = 0;
    
    //main node
    NSString* ttstring = @"color_";
    NSString* nstring = [NSString stringWithFormat:@"%i", s.color];
    ttstring = [ttstring stringByAppendingString:nstring];
    ttstring = [ttstring stringByAppendingString:@".png"];
    
    SKSpriteNode* fullnode = [SKSpriteNode spriteNodeWithImageNamed:ttstring];
    
    if (s.hitsleft > 1) {
        NSString* qstring = [NSString stringWithFormat:@"%i", s.hitsleft];
        qstring = [qstring stringByAppendingString:@".png"];
        
        SKSpriteNode* number = [SKSpriteNode spriteNodeWithImageNamed:qstring];
        [fullnode addChild:number];
    }
    if (s.rotation > 1) {
        NSString* qstring = @"dir_";
        qstring = [qstring stringByAppendingString:[NSString stringWithFormat:@"%i", s.rotation]];
        qstring = [qstring stringByAppendingString:@".png"];
        
        SKSpriteNode* rot = [SKSpriteNode spriteNodeWithImageNamed:qstring];
        [fullnode addChild:rot];
    }
    
    fullnode.position = CGPointMake(CGRectGetMidX(self.frame)*0.25,CGRectGetMidY(self.frame)*1.85);
    
    fullnode.xScale = _blocksize/100;
    fullnode.yScale = _blocksize/100;
    
    s.snode = fullnode;
    
    [self addChild:s.snode];
    
    if (s.visible == NO)
        s.snode.alpha = 0;
    else
        s.snode.alpha = 1;
    
    _nextblock = s;
    
}

-(void)adjuststartblock:(BOOL) vis
{

    int rseed = _level + 3;
    if (rseed > 8) {
        rseed = 8;
    }
    _nextblock.color = arc4random_uniform(rseed) + 1;
    
    rseed = _level;
    if (rseed > 5) {
        rseed = 5;
    }
    _nextblock.hitsleft = arc4random_uniform(rseed);
    
    
    _nextblock.rotation = arc4random_uniform(12);
    if (_nextblock.rotation > 4) {
        _nextblock.rotation = 0;
    }
    
    _nextblock.visible = vis;
    
    _nextblock.delay = 5;
    
    //main node
    NSString* ttstring = @"color_";
    NSString* nstring = [NSString stringWithFormat:@"%i", _nextblock.color];
    ttstring = [ttstring stringByAppendingString:nstring];
    ttstring = [ttstring stringByAppendingString:@".png"];
    
    SKSpriteNode* fullnode = [SKSpriteNode spriteNodeWithImageNamed:ttstring];
    
    if (_nextblock.hitsleft > 1) {
        NSString* qstring = [NSString stringWithFormat:@"%i", _nextblock.hitsleft];
        qstring = [qstring stringByAppendingString:@".png"];
        
        SKSpriteNode* number = [SKSpriteNode spriteNodeWithImageNamed:qstring];
        [fullnode addChild:number];
    }
    if (_nextblock.rotation > 1) {
        NSString* qstring = @"dir_";
        qstring = [qstring stringByAppendingString:[NSString stringWithFormat:@"%i", _nextblock.rotation]];
        qstring = [qstring stringByAppendingString:@".png"];
        
        SKSpriteNode* rot = [SKSpriteNode spriteNodeWithImageNamed:qstring];
        [fullnode addChild:rot];
    }
    
    fullnode.position = CGPointMake(CGRectGetMidX(self.frame)*0.25,CGRectGetMidY(self.frame)*1.85);
    
    fullnode.xScale = _blocksize/100;
    fullnode.yScale = _blocksize/100;
    
    _nextblock.snode = fullnode;
    
    if (_nextblock.visible == NO)
        _nextblock.snode.alpha = 0;
    else
        _nextblock.snode.alpha = 1;
    
}

-(void)startlevel
{

    
    //MAKE BLOCKS
    
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
            
            int rseed = _level + 3;
            if (rseed > 8) {
                rseed = 8;
            }
            s.color = arc4random_uniform(rseed) + 1;
            
            rseed = _level;
            if (rseed > 5) {
                rseed = 5;
            }
            s.hitsleft = arc4random_uniform(rseed);
            
            
            s.rotation = arc4random_uniform(12);
            if (s.rotation > 4) {
                s.rotation = 0;
            }
            
            if (i < 5) {
                s.visible = YES;
            }
            
            s.delay = 0;
            
            //main node
            NSString* ttstring = @"color_";
            NSString* nstring = [NSString stringWithFormat:@"%i", s.color];
            ttstring = [ttstring stringByAppendingString:nstring];
            ttstring = [ttstring stringByAppendingString:@".png"];
            
            SKSpriteNode* fullnode = [SKSpriteNode spriteNodeWithImageNamed:ttstring];
            
            if (s.hitsleft > 1) {
                NSString* qstring = [NSString stringWithFormat:@"%i", s.hitsleft];
                qstring = [qstring stringByAppendingString:@".png"];
                
                SKSpriteNode* number = [SKSpriteNode spriteNodeWithImageNamed:qstring];
                [fullnode addChild:number];
            }
            if (s.rotation > 1) {
                NSString* qstring = @"dir_";
                qstring = [qstring stringByAppendingString:[NSString stringWithFormat:@"%i", s.rotation]];
                qstring = [qstring stringByAppendingString:@".png"];
                
                SKSpriteNode* rot = [SKSpriteNode spriteNodeWithImageNamed:qstring];
                [fullnode addChild:rot];
            }
            
            fullnode.position = CGPointMake((_blocksize/2)+j*_blocksize,_maptop+(_blocksize/2)+i*_blocksize);
            
            fullnode.xScale = _blocksize/100;
            fullnode.yScale = _blocksize/100;
            
            s.snode = fullnode;
            
            [self addChild:s.snode];
            
            if (s.visible == NO)
                s.snode.alpha = 0;
            else
                s.snode.alpha = 1;
            
            _blocks[i][j] = s;
            
            
        }
    }
    
}

-(void)timerFired:(NSTimer*) t
{
    
    if (_gravity_x == 0 && _gravity_y == 1) {
        _gravityarrow.zRotation = 0;
    }
    else if (_gravity_x == 0 && _gravity_y == 0) {
        _gravityarrow.zRotation = (3.141);
    }
    else if (_gravity_x == 1 && _gravity_y == 1) {
        _gravityarrow.zRotation = (3.141/2);
    }
    else if (_gravity_x == 1 && _gravity_y == 0) {
        _gravityarrow.zRotation = (-3.141/2);
    }
    
    if (_nextblock.visible == NO)
        _nextblock.snode.alpha = 0;
    else
        _nextblock.snode.alpha = 1;
    
    for (int i=0;i<10;i++) {
        for (int j=0;j<10;j++) {
            SASBlock* s = _blocks[i][j];
            
            if (s.visible == NO)
                s.snode.alpha = 0;
            else
                s.snode.alpha = 1;
            
            _blocks[i][j] = s;
            
            if (s.delay > 0)
                s.delay = s.delay - 1;
            
        }
    }
}

-(void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pos = [touch locationInNode:self];
    //_spaceship.position = CGPointMake(pos.x, pos.y);
    
    int column = 0;
    for (int i=1;i<=9;i++) {
        if (pos.x > (i*_csize)/10) {
            column = i;
        }
    }
    
    if (_nextblock.visible == YES) {
        
        _nextblock.visible = NO;
        
        SASBlock* newblock = [[SASBlock alloc] init];
        newblock.color = _nextblock.color;
        newblock.rotation = _nextblock.rotation;
        newblock.hitsleft = _nextblock.hitsleft;
        newblock.visible = YES;
        
        //main node
        NSString* ttstring = @"color_";
        NSString* nstring = [NSString stringWithFormat:@"%i", newblock.color];
        ttstring = [ttstring stringByAppendingString:nstring];
        ttstring = [ttstring stringByAppendingString:@".png"];
        
        SKSpriteNode* fullnode = [SKSpriteNode spriteNodeWithImageNamed:ttstring];
        
        if (newblock.hitsleft > 1) {
            NSString* qstring = [NSString stringWithFormat:@"%i", newblock.hitsleft];
            qstring = [qstring stringByAppendingString:@".png"];
            
            SKSpriteNode* number = [SKSpriteNode spriteNodeWithImageNamed:qstring];
            [fullnode addChild:number];
        }
        if (newblock.rotation > 1) {
            NSString* qstring = @"dir_";
            qstring = [qstring stringByAppendingString:[NSString stringWithFormat:@"%i", newblock.rotation]];
            qstring = [qstring stringByAppendingString:@".png"];
            
            SKSpriteNode* rot = [SKSpriteNode spriteNodeWithImageNamed:qstring];
            [fullnode addChild:rot];
        }
        
        fullnode.position = CGPointMake((_blocksize/2)+column*_blocksize,_maptop+(_blocksize/2)+9*_blocksize);
        
        fullnode.xScale = _blocksize/100;
        fullnode.yScale = _blocksize/100;
        
        newblock.snode = fullnode;
        
        [self addChild:newblock.snode];

        newblock.snode.alpha = 1;
        newblock.delay = 5;
        
        _blocks[9][column] = newblock;
        
        [self adjuststartblock:NO];
        
    }
    
    
    
}

@end
