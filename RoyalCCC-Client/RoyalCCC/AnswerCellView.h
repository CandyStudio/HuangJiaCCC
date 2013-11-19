//
//  AnswerCellView.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-15.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnswerCellViewDlegate
- (void)answerClick:(NSNumber *)tag andIndex:(NSString *)index;
@end
@interface AnswerCellView : UIView
{
    
}
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *answerInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer;
@property (nonatomic,copy) NSString *index;

+ (AnswerCellView *)createView;

- (void)updateInfo:(NSString *)answer andTag:(NSNumber *)tag andIndex:(NSString *)a;
- (void)answerRight;
- (void)answerWrong;
@end
