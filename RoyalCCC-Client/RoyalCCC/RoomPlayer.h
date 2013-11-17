//
//  RoomPlayer.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-15.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "BasicModel.h"

@interface RoomPlayer : BasicModel
@property(nonatomic,strong) NSNumber *playerid;
@property(nonatomic,strong) NSNumber *hp;
@property(nonatomic,strong) NSNumber *score;
@property(nonatomic,copy) NSString *seat;
@end
