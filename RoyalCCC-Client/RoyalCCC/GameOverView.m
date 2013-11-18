//
//  GameOverView.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-16.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "GameOverView.h"
#import "GameManager.h"
#import "AppDelegate.h"
@implementation GameOverView

+ (GameOverView *)createView:(NSArray *)player{
    GameOverView *view = [[[NSBundle mainBundle] loadNibNamed:@"GameOverView" owner:nil options:nil] objectAtIndex:0];
    [view showPlayer:player];
    return view;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)backRoomList:(id)sender {
    [self removeFromSuperview];
    [[GameManager sharedGameManager] exitRoomSuccess:^{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app.navController popViewControllerAnimated:YES];
    }];

}
- (IBAction)nextGame:(id)sender {
    [self removeFromSuperview];
}


- (void)showPlayer:(NSArray *)players{
    for (int i=0,length = players.count; i<length; i++) {
        NSString *tp = [players objectAtIndex:i];
        UILabel *lbl = [self valueForKey:[NSString stringWithFormat:@"lblPlayer%d",i+1]];
        lbl.hidden = NO;
        lbl.text = tp;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
