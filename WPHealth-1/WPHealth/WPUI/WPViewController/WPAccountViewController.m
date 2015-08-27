//
//  WPAccountViewController.m
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPAccountViewController.h"
#import "VPImageCropperViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WPWorldAreaViewController.h"
#import "WPUpdateUserInfoCommand.h"
#import "UIImageView+WebCache.h"
#import "WPUploadFileCommand.h"
#import "WPWorldAreaTree.h"
#import "ZHPickView.h"
#import "UIImage+WP.h"
#import "WPUtil.h"

@interface WPAccountViewController () <UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
VPImageCropperDelegate,
ZHPickViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UIButton *modifyBtn;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *accountLabel;

@property (nonatomic, strong) ZHPickView *pickview;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *weight;

@end

@implementation WPAccountViewController

- (void)updateUserInfo:(NSString *)aIconUrl
{
    NSArray *heightArray = [self.height componentsSeparatedByString:@" "];
    NSArray *weightArray = [self.weight componentsSeparatedByString:@" "];
    
    WPUpdateUserInfoCommand *updateUserInfoCmd = [[WPUpdateUserInfoCommand alloc] init];
    
    updateUserInfoCmd.birthday = self.age;
    updateUserInfoCmd.nickName = [[WPContentService shared] contentCurrentUser].user_nick;
    updateUserInfoCmd.avatar = aIconUrl;
    updateUserInfoCmd.firstName = @"";
    updateUserInfoCmd.lastName = @"";
    updateUserInfoCmd.height = @([[heightArray firstObject] integerValue]);
    updateUserInfoCmd.weight = @([[weightArray firstObject] integerValue]);
    updateUserInfoCmd.address = self.area;
    
    [updateUserInfoCmd postCommandWithSuccess:^(NSDictionary *aResponseDict){
        NSLog(@"aResponseDict: %@", aResponseDict);
        if (aResponseDict == nil) {
            [APP_DELEGATE showInfoPanelInView:self.view title:@"用户信息更新失败" hideAfter:2];
            return ;
        }
        
        NSString *status = [aResponseDict objectForKey:@"status"];
        if (status && [status isEqualToString:@"OK"]) {
            [[WPContentService shared] contentCurrentUser].birthday = self.age;;
            [[WPContentService shared] contentCurrentUser].user_nick = [[WPContentService shared] contentCurrentUser].user_nick;
            [[WPContentService shared] contentCurrentUser].icon = aIconUrl;
            [[WPContentService shared] contentCurrentUser].gender = @"0";
            [[WPContentService shared] contentCurrentUser].height = self.height;
            [[WPContentService shared] contentCurrentUser].weight = self.weight;
            [[WPContentService shared] contentCurrentUser].area = self.area;
            
            [[WPContentService shared] updateContentCurrentUser];
            
            [APP_DELEGATE showInfoPanelInView:self.view title:@"用户信息更新成功" hideAfter:2];
            
            __block UIButton *tempIconBtn = self.iconBtn;
            if ([[[WPContentService shared] contentCurrentUser].icon length] > 0) {
                [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[[WPContentService shared] contentCurrentUser].icon]
                                                          delegate:self
                                                           options:(SDWebImageOptions)0
                                                          userInfo:nil
                                                           success:^(UIImage *imageDown, BOOL cached,NSDictionary *info){
                                                               
                                                               UIImage *configImage = imageDown;
                                                               [tempIconBtn setBackgroundImage:configImage forState:UIControlStateNormal];
                                                               
                                                           } failure:nil];
            }
            
            // 此处是为了同步首页中使用的内存中的数据
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kWPNotificationHomePageUpadteNotify
                                                                object:nil
                                                              userInfo:nil];
        } else {
            [APP_DELEGATE showInfoPanelInView:self.view title:@"用户信息更新失败" hideAfter:2];
        }
        
    } failure:^(NSError *aError){
        [APP_DELEGATE showInfoPanelInView:self.view title:@"用户信息更新失败" hideAfter:2];
    }];
}

- (void)uploadUserAvatar:(NSData *)aImageData
{
    [self updateUserInfo:[[WPContentService shared] contentCurrentUser].icon];
    return;
    
    WPUploadFileCommand *uploadFileCmd = [[WPUploadFileCommand alloc] init];
    
    uploadFileCmd.fileData = aImageData;
    [uploadFileCmd postCommandWithSuccess:^(NSDictionary *aResponseDict) {
        
        NSLog(@"aResponseDict:%@",aResponseDict);
        NSString *success = [aResponseDict objectForKey:@"status"];
        if ([success isEqualToString:@"ok"]) {
            NSString *filename = [aResponseDict objectForKey:@"filename"];
            NSString *uploadIconUrl = [NSString stringWithFormat:@"%@/fileResource/%@", WPBASEURL, filename];
            
            [self updateUserInfo:uploadIconUrl];
        } else {
            [APP_DELEGATE showInfoPanelInView:self.view title:@"头像 修改失败" hideAfter:1];
        }
    } failure:^(NSError *aError) {
        [APP_DELEGATE showInfoPanelInView:self.view title:@"头像 修改失败" hideAfter:1];
    }];
}

#pragma mark - buttonAction

- (void)handleModifyBtnEvent
{
    if (self.modifyBtn.selected) {
        self.modifyBtn.selected = NO;
        // 不可修改
        self.iconImageView.hidden = YES;
        
        [self updateUserInfo:[[WPContentService shared] contentCurrentUser].icon];
    } else {
        self.modifyBtn.selected = YES;
        // 可修改
        self.iconImageView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (void)handleIconBtnEvent
{
    if (self.modifyBtn.selected == NO) {
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - loadView

- (void)configNavigationView
{
    self.modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44, 24.)];
    [self.modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.modifyBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.modifyBtn addTarget:self action:@selector(handleModifyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.modifyBtn];
    
    [self.navigationItem setRightBarButtonItem:rightItem animated:NO];
}

- (void)configTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 150.0)];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconImageView.backgroundColor = [UIColor colorWithRed:82./255. green:184./255. blue:170./255. alpha:1.];
    self.iconImageView.userInteractionEnabled = NO;
    self.iconImageView.layer.cornerRadius = 86./2;
    self.iconImageView.hidden = YES;
    [headerView addSubview:self.iconImageView];
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(86.);
        make.height.equalTo(86.);
        make.centerX.equalTo(headerView.centerX);
        make.top.equalTo(headerView.top).offset(27);
    }];
    
    self.iconBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    self.iconBtn.layer.cornerRadius = 80./2;
    self.iconBtn.layer.masksToBounds = YES;
    __block UIButton *tempIconBtn = self.iconBtn;
    if ([[[WPContentService shared] contentCurrentUser].icon length] > 0) {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[[WPContentService shared] contentCurrentUser].icon]
                                                  delegate:self
                                                   options:(SDWebImageOptions)0
                                                  userInfo:nil
                                                   success:^(UIImage *imageDown, BOOL cached,NSDictionary *info){
                                                       
                                                       UIImage *configImage = imageDown;
                                                       [tempIconBtn setBackgroundImage:configImage forState:UIControlStateNormal];
                                                       
                                                   } failure:nil];
    } else {
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    }
    
    [self.iconBtn addTarget:self action:@selector(handleIconBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:self.iconBtn];
    [self.iconBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80.);
        make.height.equalTo(80.);
        make.centerX.equalTo(headerView.centerX);
        make.top.equalTo(headerView.top).offset(30);
    }];
    
    self.sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.sexImageView.image = [UIImage imageNamed:@"sex_boy_icon.png"];
    self.sexImageView.userInteractionEnabled = NO;
    [headerView addSubview:self.sexImageView];
    [self.sexImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconBtn.right);
        make.bottom.equalTo(self.iconBtn.bottom);
        make.width.equalTo(20.);
        make.height.equalTo(20.);
    }];
    
    self.accountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.accountLabel setFont:[UIFont boldSystemFontOfSize:15.]];
    self.accountLabel.backgroundColor = [UIColor clearColor];
    self.accountLabel.textColor = [UIColor blackColor];
    self.accountLabel.text = @"点点猫";
    [headerView addSubview:self.accountLabel];
    [self.accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconBtn.bottom).offset(5);
        make.centerX.equalTo(headerView.centerX);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView* tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.tableView.frame.size.width, self.tableView.frame.size.height)];
    tableBgView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = tableBgView;
    tableBgView = nil;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
    self.title = @"我的账号";
    
    // 默认值
    self.area = [[[WPContentService shared] contentCurrentUser].area length] > 0?[[WPContentService shared] contentCurrentUser].area:@"未知";
    self.age = [[[WPContentService shared] contentCurrentUser].birthday length] > 0?[[WPContentService shared] contentCurrentUser].birthday:@"请选择";
    self.height = [[[WPContentService shared] contentCurrentUser].height length] > 0?[[WPContentService shared] contentCurrentUser].height:@"请选择";
    self.weight = [[[WPContentService shared] contentCurrentUser].weight length] > 0?[[WPContentService shared] contentCurrentUser].weight:@"请选择";
    
    [self configNavigationView];
    
    [self createTableView];
    [self configTableHeaderView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[WPWorldAreaTree shared] rootTreeNode];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *needReplaceCity = [[WPGlobalConfig shared] needReplaceCity];
    if ([needReplaceCity length] > 0 && [needReplaceCity isEqualToString:@"1"]) {
        NSString *waitReplaceCity = [[WPGlobalConfig shared] waitReplacedCity];
        if ([waitReplaceCity length] > 0) {
            self.area = waitReplaceCity;
        } else {
            self.area = @"未知";
        }
        [self.tableView reloadData];
        [[WPGlobalConfig shared] setNeedReplaceCity:@"0"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WPMoreTableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"WPMoreTableCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIImageView* bottomLineSepView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bottomLineSepView.backgroundColor = [UIColor clearColor];
        bottomLineSepView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:bottomLineSepView];
        [bottomLineSepView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.left).offset(15.);
            make.bottom.equalTo(cell.contentView.bottom);
            make.height.equalTo(1);
            make.right.equalTo(cell.contentView.right);
        }];
    }
    
    if (self.modifyBtn.selected) {
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:82./255. green:184./255. blue:170./255. alpha:1.];
    } else {
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"地区";
        cell.detailTextLabel.text = self.area;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"年龄";
        cell.detailTextLabel.text = self.age;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"身高";
        cell.detailTextLabel.text = self.height;
    } else {
        cell.textLabel.text = @"体重";
        cell.detailTextLabel.text = self.weight;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.modifyBtn.selected) {
        return;
    }
    
    if (indexPath.row == 0) {
        WPWorldAreaViewController *worldAreaVC = [[WPWorldAreaViewController alloc] init];
        worldAreaVC.rootTreeNode = [[WPWorldAreaTree shared] rootTreeNode];
        
        [self.navigationController pushViewController:worldAreaVC animated:YES];
        return;
    }
    
    self.selectedIndexPath = indexPath;
    [self.pickview remove];
    
    NSString *pickViewTitle = nil;
    
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
    if (indexPath.row == 1) {
        NSMutableArray *minArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 200; index++) {
            [minArray addObject:[NSString stringWithFormat:@"%d", index]];
        }
        [contentArray addObject:minArray];
        
        [contentArray addObject:@[@"岁"]];
        
        pickViewTitle = @"年龄";
        
    } else if (indexPath.row == 2) {
        NSMutableArray *minArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 300; index++) {
            [minArray addObject:[NSString stringWithFormat:@"%d", index]];
        }
        [contentArray addObject:minArray];
        
        [contentArray addObject:@[@"cm"]];
        
        pickViewTitle = @"身高";
    } else if (indexPath.row == 3) {
        NSMutableArray *minArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 300; index++) {
            [minArray addObject:[NSString stringWithFormat:@"%d", index]];
        }
        [contentArray addObject:minArray];
        
        [contentArray addObject:@[@"kg"]];
        
        pickViewTitle = @"体重";
    }
    
    self.pickview = [[ZHPickView alloc] initPickviewWithArray:contentArray];
    [self.pickview setTitleLabelWithString:pickViewTitle];
    self.pickview.delegate=self;
    [self.pickview show];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    if (self.selectedIndexPath.row == 1) {
        self.age = resultString;
    } else if (self.selectedIndexPath.row == 2) {
        self.height = resultString;
    } else if (self.selectedIndexPath.row == 3) {
        self.weight = resultString;
    }
    cell.detailTextLabel.text = resultString;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == 0)
        {
            // 拍照
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [APP_DELEGATE showAlertViewWithString:@"相机不可用，请检查设置"];
                return;
            }
            // 兼容IOS 7 相机访问控制
            if (IS_IOS_7_OR_LATER) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
                    [APP_DELEGATE showAlertViewWithString:@"请在设备的\"设置-隐私-相机\"中允许【畅游+】访问相机"];
                    return ;
                }
            }
            
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            ipc.allowsEditing =  NO;
            
            [APP_DELEGATE.window.rootViewController presentViewController:ipc animated: YES completion:nil];
        }
        else
        {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            ipc.allowsEditing = NO;
            
            [APP_DELEGATE.window.rootViewController presentViewController:ipc animated: YES completion:nil];
        }
    }
}

#pragma mark - VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    NSData *tmpData = [editedImage scaleSizeToKB:60];
    
    [self.iconBtn setBackgroundImage:editedImage forState:UIControlStateNormal];
    
    [self uploadUserAvatar:tmpData];
    
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"UIImageWriteToSavedPhotosAlbum OK");
    } else {
        NSLog(@"save Error:%@", [error localizedDescription]);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info);
    
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //相机取图,保存本地
        UIImageWriteToSavedPhotosAlbum(selectImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //相册取图
    }
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = imageByScalingToMaxSize(portraitImg);
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 75.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        imgEditorVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:imgEditorVC animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        
    }];
}

@end
