//
//  RoomControl.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-14.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RoomViewController;
@interface RoomControl : NSObject{
    RoomViewController *_roomController;
}


@property(nonatomic,strong)NSMutableDictionary *players;
@property(nonatomic,strong)NSMutableDictionary *roomPlayers;
@property(nonatomic,strong)NSMutableDictionary *seatDict;
- (void)addRote;
- (void)offRote;
- (RoomControl *)initAndMakeView:(RoomViewController **)viewController andRoomInfo:(NSDictionary *)info;

- (void)userHelp:(NSNumber *)help success:(void(^)())block;

@end
