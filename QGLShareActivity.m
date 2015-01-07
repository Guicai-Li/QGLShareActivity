//
//  QGLShareActivity.m
//  QGLShareActivity
//
//  Created by Guicai.Li on 14-10-8.
//  Copyright (c) 2014年 Guicai Li. All rights reserved.
//

#import "QGLShareActivity.h"
#import "QGLShareBtnCell.h"


#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithWhite:0.0f alpha:0.8f]
#define ANIMATE_DURATION                        0.25f


#define TITLE_INTERVAL_WIDTH                    30
#define TITLE_INTERVAL_HEIGHT                   15
#define TITLE_WIDTH                             260
#define TITLE_HEIGHT                            35
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f)
#define SHARETITLE_FONT                         [UIFont fontWithName:@"Helvetica-Bold" size:14]
#define TITLE_NUMBER_LINES                      2


#define CANCEL_INTERVAL_WIDTH                   0
#define CANCEL_HEIGHT                           40
#define CANCEL_INTERVAL_HEIGHT                  [UIScreen mainScreen].bounds.size.height - CANCEL_HEIGHT
#define CANCEL_WIDTH                            [UIScreen mainScreen].bounds.size.width - 2 * CANCEL_INTERVAL_WIDTH

#define SPACE_BETWEEN_CANCELANDBUTTON           5


#define SHAREBTN_INTERVAL_WIDTH                 0
#define SHAREBTN_WIDTH                          [UIScreen mainScreen].bounds.size.width - 2 * SHAREBTN_INTERVAL_WIDTH
#define SHAREBTN_LINE_SPACE                     15

#define SHAREBTN_EDGEINSETSMAKE_TOP             20
#define SHAREBTN_EDGEINSETSMAKE_LEFT            30
#define SHAREBTN_EDGEINSETSMAKE_BOTTOM          0
#define SHAREBTN_EDGEINSETSMAKE_RIGHT           30

#define SHAREBTN_ITEM_SIZE_WIDTH                60
#define SHAREBTN_ITEM_SIZE_HEIGHT               60





@interface QGLShareActivity () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id<QGLShareActivityDelegate>delegate;
@property (nonatomic, strong) UICollectionView *shareBtnView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *shareButtonTitlesArray;
@property (nonatomic, strong) NSArray *shareButtonImagesNameArray;


@end


@implementation QGLShareActivity


-(void)dealloc {
    _title = nil;
    _cancelButtonTitle = nil;
    _shareButtonImagesNameArray = nil;
    _shareButtonImagesNameArray = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<QGLShareActivityDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self.backGroundView addGestureRecognizer:tapGesture];
    
        if (delegate) {
            self.delegate = delegate;
        }
        self.cancelButtonTitle = cancelButtonTitle;
        
        self.shareButtonImagesNameArray = shareButtonImagesNameArray;
        self.shareButtonTitlesArray = shareButtonTitlesArray;
        
        [self creatButtonsWithTitle:title cancelButtonTitle:self.cancelButtonTitle shareButtonTitles:self.shareButtonTitlesArray withShareButtonImagesName:self.shareButtonImagesNameArray];

    }
    return self;
}


- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle shareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray {
    [self addSubview:self.backGroundView];
    [self addSubview:[self cancelButtonWith:self.cancelButtonTitle]];
    [self createButton];
}

-(UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
        [self.backGroundView addGestureRecognizer:tapGesture];
    }
    return _backGroundView;
}

- (UILabel *)titleLabel:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = SHADOW_OFFSET;
    titleLabel.font = SHARETITLE_FONT;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = TITLE_NUMBER_LINES;
    return titleLabel;
}
- (UIButton *)cancelButtonWith:(NSString *)cancelButtonTitle {
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(CANCEL_INTERVAL_WIDTH, CANCEL_INTERVAL_HEIGHT, CANCEL_WIDTH, CANCEL_HEIGHT);
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    
    cancelButton.backgroundColor = [UIColor whiteColor];
    
    [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGPoint originPoint = CGPointMake(0.0f, 2.0f);
    CGPoint toPoint = CGPointMake(self.frame.size.width, 2.0f);
    [linePath moveToPoint:originPoint];
    [linePath addLineToPoint:toPoint];
    [linePath setLineWidth:2.0f];
    [shapeLayer setPath:linePath.CGPath];
    [shapeLayer setFillColor:nil];
    shapeLayer.opacity = 1.0f;
    [shapeLayer setStrokeColor:[UIColor colorWithRed:0.34 green:0.74 blue:0.99 alpha:1].CGColor];

    [cancelButton.layer addSublayer:shapeLayer];

    return cancelButton;
}

- (void)createButton {
    NSInteger count = [self.shareButtonTitlesArray count];
    NSInteger line = 1;
    if (count >= 4) {
        line = 2;
    }
    NSInteger column = count / line;
    if (count % line) {
        column ++;
    }
    
    if (NIIsPad()) {
        line = 1;
        column = count;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SHAREBTN_ITEM_SIZE_WIDTH, SHAREBTN_ITEM_SIZE_HEIGHT);

    CGFloat width = ([[UIScreen mainScreen] bounds].size.width - SHAREBTN_ITEM_SIZE_WIDTH * column + 20) / (column + 2 - 1);
    
    flowLayout.minimumLineSpacing = SHAREBTN_LINE_SPACE;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(SHAREBTN_EDGEINSETSMAKE_TOP, width - 10, SHAREBTN_EDGEINSETSMAKE_BOTTOM, width - 10);
    flowLayout.minimumInteritemSpacing = width;
    
    CGFloat height = SHAREBTN_ITEM_SIZE_HEIGHT * line + (SHAREBTN_EDGEINSETSMAKE_TOP + SHAREBTN_EDGEINSETSMAKE_BOTTOM) * line + SHAREBTN_LINE_SPACE ;
    CGFloat y = CANCEL_INTERVAL_HEIGHT - height;
    
    self.shareBtnView = [[UICollectionView alloc] initWithFrame:CGRectMake(SHAREBTN_INTERVAL_WIDTH, y, SHAREBTN_WIDTH, height) collectionViewLayout:flowLayout];
    
    self.shareBtnView.backgroundColor = [UIColor whiteColor];
    self.shareBtnView.delegate = self;
    self.shareBtnView.dataSource = self;
    [self.shareBtnView registerNib:[UINib nibWithNibName:@"QGLShareBtnCell" bundle:nil] forCellWithReuseIdentifier:@"QGLShareBtnCell"];
    [self addSubview:self.shareBtnView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.hasCopyURLCell) {
        return [self.shareButtonTitlesArray count] - 1;
    }
    return [self.shareButtonTitlesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QGLShareBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QGLShareBtnCell" forIndexPath:indexPath];
    cell.shareTitle.text = [self.shareButtonTitlesArray objectAtIndex:indexPath.row];
    cell.shareImage.image = [UIImage imageNamed:[self.shareButtonImagesNameArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didClickedWhichOne:indexPath.row];
    
    [self dismiss];
}

- (void)tappedBackGroundView {
    [self dismiss];
    [self.delegate didClickedCancel];
}

- (void)tappedCancel {
    [self dismiss];
    [self.delegate didClickedCancel];
}

- (void)dismiss {
    @weakify(self);
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        @strongify(self);
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        @strongify(self);
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
