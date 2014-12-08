//
//  QGLShareBtnCell.m
//  QGLShareActivity
//
//  Created by Guicai.Li on 14-10-9.
//  Copyright (c) 2014年 Guicai Li. All rights reserved.
//

#import "QGLShareBtnCell.h"

@implementation QGLShareBtnCell

- (void)awakeFromNib {
    // Initialization code
    self.shareTitle.textAlignment = NSTextAlignmentCenter;
    self.shareTitle.font = [UIFont systemFontOfSize:12];
    self.shareTitle.textColor = [UIColor colorWithHex:@"#333333"];
}



@end
