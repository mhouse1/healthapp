//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//

#import "ZHPickView.h"

#define IMAGE_WIDTH     250.
#define IMAGE_HEIGHT    340.

#define ZHToobarHeight 40.
#define ZHPickerHeight 240.

@interface ZHPickView ()<UIPickerViewDelegate,
UIPickerViewDataSource,
UIGestureRecognizerDelegate>

@property(nonatomic, copy) NSString *plistName;
@property(nonatomic, strong) NSArray *plistArray;
@property(nonatomic, assign) BOOL isLevelArray;
@property(nonatomic, assign) BOOL isLevelString;
@property(nonatomic, assign) BOOL isLevelDic;
@property(nonatomic, strong) NSDictionary *levelTwoDic;
@property(nonatomic, strong) UIView *toolbar;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, assign) NSDate *defaulDate;
@property(nonatomic, copy) NSString *resultString;
@property(nonatomic, strong) NSMutableArray *componentArray;
@property(nonatomic, strong) NSMutableArray *dicKeyArray;
@property(nonatomic, copy) NSMutableArray *state;
@property(nonatomic, copy) NSMutableArray *city;

@property (nonatomic, strong) UIImageView *popImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZHPickView

#pragma mark - buttonAction

-(void)doneClick
{
    if (_pickerView) {
        if (_resultString) {
            
        } else {
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            } else if (_isLevelArray) {
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            } else if (_isLevelDic) {
                if (_state==nil) {
                    _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][0][0];
                }
                if (_city==nil) {
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                }
                _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
            }
        }
    } else if (_datePicker) {
        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    [self removeFromSuperview];
}

#pragma mark - GestureRecognizer

- (void)handletap
{
    [self remove];
}

#pragma mark - property

-(NSArray *)plistArray
{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray
{
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}

#pragma mark - custom Methods

-(void)setArrayClass:(NSArray *)array
{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        } else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        } else if ([levelTwo isKindOfClass:[NSDictionary class]]) {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(NSArray *)getPlistArrayByplistName:(NSString *)plistName
{
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

#pragma mark - init

- (void)createPopBgImageView
{
    self.popImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-IMAGE_WIDTH)/2, (self.bounds.size.height-IMAGE_HEIGHT)/2, IMAGE_WIDTH, IMAGE_HEIGHT)];
    self.popImageView.backgroundColor = [UIColor whiteColor];
    self.popImageView.userInteractionEnabled = YES;
    self.popImageView.layer.cornerRadius = 5;
    self.popImageView.layer.masksToBounds = YES;
    [self addSubview:self.popImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+20., self.popImageView.frame.origin.y+20., self.popImageView.frame.size.width-20.*2, 20.)];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16.]];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithRed:76./255. green:174./255. blue:168./255. alpha:1.];
    [self addSubview:self.titleLabel];
}

-(void)createToolBar
{
    _toolbar=[[UIView alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x, self.popImageView.frame.origin.y+self.popImageView.frame.size.height-ZHToobarHeight-20., self.popImageView.frame.size.width, ZHToobarHeight)];
    _toolbar.backgroundColor = [UIColor clearColor];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20., 0., 82, 40.)];
    [cancelButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
    [_toolbar addSubview:cancelButton];
    
    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(_toolbar.bounds.size.width-116.-20., 1., 116., 38.)];
    [enterButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"add_finish_btn.png"] forState:UIControlStateNormal];
    [_toolbar addSubview:enterButton];
    
    [self addSubview:_toolbar];
}

-(void)createPickView
{
    UIPickerView *pickView=[[UIPickerView alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+50., self.popImageView.frame.origin.y+40., self.popImageView.frame.size.width-50.*2, ZHPickerHeight)];
    pickView.backgroundColor=[UIColor clearColor];
    pickView.delegate=self;
    pickView.dataSource=self;
    [self addSubview:pickView];
    
    _pickerView=pickView;
}

-(void)createDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode
{
    UIDatePicker *datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+50., self.popImageView.frame.origin.y+40., self.popImageView.frame.size.width-50.*2, ZHPickerHeight)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.backgroundColor=[UIColor clearColor];
    datePicker.datePickerMode = datePickerMode;
    [self addSubview:datePicker];
    
    _datePicker=datePicker;
    if (_defaulDate) {
        [_datePicker setDate:_defaulDate];
    }
}

- (void)createGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

-(instancetype)initPickviewWithPlistName:(NSString *)plistName
{
    self=[super initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        
        [self createPopBgImageView];
        [self createToolBar];
        [self createPickView];
        [self createGestureRecognizer];
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array
{
    self=[super initWithFrame:CGRectMake(0.0, 0.0, WPMAINSCREEN_SIZE.width, WPMAINSCREEN_SIZE.height)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.plistArray=array;
        [self setArrayClass:array];
        
        [self createPopBgImageView];
        [self createToolBar];
        [self createPickView];
        [self createGestureRecognizer];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode
{
    self=[super initWithFrame:CGRectMake(0.0, 0.0, WPMAINSCREEN_SIZE.width, WPMAINSCREEN_SIZE.height)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        _defaulDate=defaulDate;
        
        [self createPopBgImageView];
        [self createToolBar];
        [self createDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self createGestureRecognizer];
    }
    return self;
}

-(void)remove
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show
{
    self.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setPickViewColer:(UIColor *)color
{
    _pickerView.backgroundColor=color;
}

-(void)setTintColor:(UIColor *)color
{
    _toolbar.tintColor=color;
}

-(void)setToolbarTintColor:(UIColor *)color
{
    _toolbar.backgroundColor=color;
}

- (void)setTitleLabelWithString:(NSString *)aTitle
{
    self.titleLabel.text = aTitle;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIDatePicker class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    } else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    } else if (_isLevelString) {
        rowArray=_plistArray;
    } else if (_isLevelDic) {
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
                if ([dicValue isKindOfClass:[NSArray class]]) {
                    if (component%2==1) {
                        rowArray=dicValue;
                    } else {
                        rowArray=_plistArray;
                    }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    } else if (_isLevelString) {
        rowTitle=_plistArray[row];
    } else if (_isLevelDic) {
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0) {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
           if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isLevelDic&&component%2==0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
    } else if (_isLevelArray) {
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            } else {
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    } else if (_isLevelDic) {
        if (component==0) {
          _state =_dicKeyArray[row][0];
        } else {
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
