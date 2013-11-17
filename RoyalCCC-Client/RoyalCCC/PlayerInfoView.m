//
//  PlayerInfoView.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-15.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "PlayerInfoView.h"
#import "RoomPlayer.h"
@implementation PlayerInfoView

+ (PlayerInfoView *)createPlayerInfoIsLeft:(BOOL)is{
    PlayerInfoView *view = [[[NSBundle mainBundle] loadNibNamed:@"PlayerInfoView" owner:nil options:nil] objectAtIndex:0];
    view.isLeft = is;
    [view makeInterface];
    view.hidden = YES;
    return view;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSArray *array = [NSArray arrayWithObjects:@"palyer_dog.png",@"player_bear.png",@"player_cow.png",@"player_rabbit.png", nil];
    int index = arc4random()%4;
    self.imagePhoto.image = [UIImage imageNamed:[array objectAtIndex:index]];

}
- (void)makeInterface{
    if (self.isLeft) {
        [self.imageHp setFrame:CGRectMake(4,4,8,48)];
        self.imagebg.image = [UIImage imageNamed:@"peopleinfoleft.png"];
    }else{
        [self.imageHp setFrame:CGRectMake(60,4,8,48)];
        self.imagebg.image = [UIImage imageNamed:@"peopleinforight.png"];
    }
}

- (void)updateInfo:(Player *)dict andRoomPlayer:(RoomPlayer *)roomPlayer{
    if (dict) {
        
    }
    if (roomPlayer) {
        float hpper = [roomPlayer.hp floatValue]/100.0;
        [self.imageHp setFrame:CGRectMake(60,4,8,48*hpper)];
        if (hpper == 0) {
            //sile
        }
    }
}


@end
