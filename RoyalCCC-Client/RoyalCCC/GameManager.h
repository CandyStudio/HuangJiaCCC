//
//  GameNanager.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ScheduldBloc)(void);
@class PomeloClient;
@class Player;
@class RoomControl;
@interface GameManager : NSObject{
    NSMutableDictionary *_scheduleDict;

}
@property(nonatomic,strong)PomeloClient *pomelo;
@property(nonatomic,strong)Player *player;
@property(nonatomic,strong)RoomControl *roomControl;
@property(nonatomic,strong)NSMutableDictionary *qusetionDict;
+ (GameManager *)sharedGameManager;
/**
 *  更新玩家信息
 *
 *  @param dict 数据
 */
- (void)upDatePlayer:(NSDictionary *)dict;

/**
 *  登录
 *
 *  @param username 用户名
 *  @param password 密码
 *  @param succ     成功后操作
 */
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andSuccsess:(void(^)())succ;

/**
 *  登出
 *
 *  @param succ 成功后的操作
 */
- (void)logout:(void(^)())succ;

/**
 *  进入房间
 *
 *  @param roomid 房间id
 *  @param succ   成功后的操作
 */
- (void)enterRoom:(NSString *)roomid andSuccess:(void(^)(id))succ;

/**
 *  退出房间
 *
 *  @param succ 成功后的操作
 */
- (void)exitRoomSuccess:(void(^)())succ;

/**
 *  显示提示框
 *
 *  @param info 提示框的描述
 */
- (void)showAlert:(NSString *)info;

/**
 *  加入循环
 *
 *  @param key 指定的key
 *  @param sch 循环方法
 */
- (void)addScheduleForKey:(NSString *)key andSchedule:(ScheduldBloc)sch;

/**
 *  删除指定循环
 *
 *  @param key 指定的key
 */
- (void)removerScheduleForKey:(NSString *)key;

/**
 *  删除所有的循环
 */
- (void)removeAllSchedule;
@end
