//
//  MainViewController.m
//  ShiuFlappyBird
//
//  Created by 許佳豪 on 2016/1/26.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *pillarsLayerArrays;
@property (nonatomic, strong) CALayer *birdLayer;

@end

@implementation MainViewController

#pragma mark - UIGestureRecognizer Action

- (IBAction)flyAction:(id)sender {
    CGRect temp = self.birdLayer.frame;
    temp.origin.y -= 50;
    self.birdLayer.frame = temp;
}

#pragma mark - private method

- (void)initDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink setPaused:YES];
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self changeBardLayerAndPillarsLayer];
    if ([self isOverScreen] || [self isOverlapping]) {
        [self.displayLink setPaused:YES];
        [self initAlertAction:@"重新開始"];
    }
    [CATransaction commit];
}

- (BOOL)isOverScreen {
    // 檢查鳥的 y 是否超過螢幕範圍，如果是，判定鳥落地，遊戲結束
    if (CGRectGetHeight(self.view.frame) < CGRectGetMinY(self.birdLayer.frame)) {
        return YES;
    }
    return NO;
}

- (BOOL)isOverlapping {
    // 檢查每根柱子的 frame 是否與鳥的 frame 交疊（CGRectIntersectsRect），如果是，遊戲結束
    for (int i = 0; i < self.pillarsLayerArrays.count; i++) {
        CALayer *pillarLayer = self.pillarsLayerArrays[i];
        if (CGRectIntersectsRect(pillarLayer.frame, self.birdLayer.frame)) {
            return YES;
        }
    }
    return NO;
}

- (void)changeBardLayerAndPillarsLayer {
    // 每執行一次，鳥的 position 的 y 軸都往下掉 4 pixel
    CGRect temp = self.birdLayer.frame;
    temp.origin.y += 4;
    self.birdLayer.frame = temp;

    // 每執行一次，每根柱子的 position 的 x 軸都減 1 pixle
    for (int i = 0; i < self.pillarsLayerArrays.count; i++) {
        CALayer *pillarLayer = self.pillarsLayerArrays[i];
        CGRect temp = pillarLayer.frame;
        temp.origin.x -= 1;
        pillarLayer.frame = temp;
    }
}

#pragma mark - init

- (void)initBirdLayer {
    self.birdLayer = [CALayer layer];
    self.birdLayer.backgroundColor = [[UIColor yellowColor] CGColor];
    self.birdLayer.frame = CGRectMake(0, 0, 40, 40);
    CGRect newFrame = self.birdLayer.frame;
    newFrame.origin.x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(newFrame)) / 2;
    newFrame.origin.y = (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(newFrame)) / 2;
    self.birdLayer.frame = newFrame;
    self.birdLayer.contents = (__bridge id)[UIImage imageNamed:@"bird@2x.png"].CGImage;
    self.birdLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:self.birdLayer];
}

- (void)initPillarsLayer {
    for (int i = 1; i <= 30; i++) {
        int viewHeight = CGRectGetHeight(self.view.bounds);
        int topPillarHeight = 20 + (arc4random() % (viewHeight - 200));
        int space = 100 + (i * 160);
        int downPillarHeight = topPillarHeight + 150;

        CALayer *pillarLayer = [CALayer layer];
        pillarLayer.backgroundColor = [[UIColor redColor] CGColor];
        pillarLayer.frame = CGRectMake(space, 0, 60, topPillarHeight);

        CALayer *pillarLayerDown = [CALayer layer];
        pillarLayerDown.backgroundColor = [[UIColor redColor] CGColor];
        pillarLayerDown.frame = CGRectMake(space, downPillarHeight, 60, viewHeight - downPillarHeight);

        [self.view.layer addSublayer:pillarLayer];
        [self.view.layer addSublayer:pillarLayerDown];
        [self.pillarsLayerArrays addObject:pillarLayer];
        [self.pillarsLayerArrays addObject:pillarLayerDown];
    }
}

- (void)initAlertAction:(NSString *)message {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"遊戲"
                                                 message:message
                                          preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:@"Yes, please"
                                          style:UIAlertActionStyleDefault
                                        handler: ^(UIAlertAction *action)
                                {
                                    [weakSelf.pillarsLayerArrays removeAllObjects];
                                    [weakSelf.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                                    [weakSelf initBirdLayer];
                                    [weakSelf initPillarsLayer];
                                    [weakSelf.displayLink setPaused:NO];
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDisplayLink];
    self.pillarsLayerArrays = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initAlertAction:@"開始"];
}
@end
