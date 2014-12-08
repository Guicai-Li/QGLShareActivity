//
//  QGLShareActivity.h
//  QGLShareActivity
//
//  Created by Guicai.Li on 14-10-8.
//  Copyright (c) 2014年 Guicai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QGLShareActivityDelegate <NSObject>

- (void)didClickedWhichOne:(NSInteger)index;

@optional
- (void)didClickedCancel;

@end


@interface QGLShareActivity : UIView

@property(nonatomic, assign) BOOL hasCopyURLCell;

@property (nonatomic, strong) UIView *backGroundView;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<QGLShareActivityDelegate   >)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray;

- (void)showInView:(UIView *)view;

@end
