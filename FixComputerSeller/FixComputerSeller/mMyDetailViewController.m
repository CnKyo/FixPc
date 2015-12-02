//
//  mMyDetailViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/13.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "mMyDetailViewController.h"
#import "mMyDeatailView.h"
#import "RSKImageCropper.h"

#import "Masonry.h"
@interface mMyDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource,UITextFieldDelegate>



@end

@implementation mMyDetailViewController
{
    mMyDeatailView *mm;
    UIImage *tempImage;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     IQKeyboardManager为自定义收起键盘
     **/
    [[IQKeyboardManager sharedManager] setEnable:YES];///视图开始加载键盘位置开启调整
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];///是否启用自定义工具栏
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;///启用手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];///视图消失键盘位置取消调整
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];///关闭自定义工具栏
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.hiddenlll = YES;
    self.mPageName = self.Title = @"我的账号";
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView{
    mm = [mMyDeatailView shareView];
    mm.mPwdTx.text = [SUser currentUser].mUserName;
    
    [self.view addSubview:mm];
    [mm makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
        make.height.offset(DEVICE_Height);
    }];
    
//    [mm.mEditBtn addTarget:self action:@selector(headBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    mm.mPwdTx.enabled = NO;
    [mm.mSaveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mm.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    NSLog(@"%@",[SUser currentUser].mHeadImgURL);
    mm.mAgeLB.text = [NSString stringWithFormat:@"%d",[SUser currentUser].mAge];
    mm.mSexLB.text = [SUser currentUser].mSex;
    
    if ([[SUser currentUser].mSex isEqualToString:@"男"]) {
        mm.mSexImg.image = [UIImage imageNamed:@"nan"];
    }else{
        mm.mSexImg.image = [UIImage imageNamed:@"nv"];
    }
    mm.mRemarkTextV.text = [SUser currentUser].mBrief;
}
- (BOOL)isEdit{
    return mm.mHeaderImg != nil;
}
- (void)saveAction:(UIButton *)sender{
    
    SUser *user = [SUser currentUser];
    if ( ![self isEdit]) {
        [SVProgressHUD showErrorWithStatus:@"没有任何数据修改"];
        return;
    }
    if (mm.mPwdTx.text.length > 30) {
        [self showErrorStatus:@"用户名长度不能超过30位"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"保存中" maskType:SVProgressHUDMaskTypeClear];
    [user updateUserInfo:mm.mPwdTx.text HeadImg:tempImage Brief:mm.mRemarkTextV.text block:^(SResBase *resb) {
        
        if (resb.msuccess) {
        
            [self showSuccessStatus:resb.mmsg];
            [self popViewController];
        }else{
            [self showErrorStatus:resb.mmsg];
        }
        [SVProgressHUD dismiss];

    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)headBtnTouched:(UIButton *)sender
{
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    ac.tag = 1001;
    [ac showInView:[self.view window]];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex != 2 ) {
        
        [self startImagePickerVCwithButtonIndex:buttonIndex];
    }
    
}
- (void)startImagePickerVCwithButtonIndex:(NSInteger )buttonIndex
{
    int type;
    
    
    if (buttonIndex == 0) {
        type = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing =NO;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }
    else if(buttonIndex == 1){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
        
    }
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage* tempimage1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self gotCropIt:tempimage1];
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^() {
        
    }];
    
}
-(void)gotCropIt:(UIImage*)photo
{
    RSKImageCropViewController *imageCropVC = nil;
    
    imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
    imageCropVC.dataSource = self;
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    
    [controller.navigationController popViewControllerAnimated:YES];
}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    return   CGRectMake(self.view.center.x-mm.mHeaderImg.frame.size.width/2, self.view.center.y-mm.mHeaderImg.frame.size.height/2, mm.mHeaderImg.frame.size.width, mm.mHeaderImg.frame.size.height);
    
}
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    return [UIBezierPath bezierPathWithRect:CGRectMake(self.view.center.x-mm.mHeaderImg.frame.size.width/2, self.view.center.y-mm.mHeaderImg.frame.size.height/2, mm.mHeaderImg.frame.size.width, mm.mHeaderImg.frame.size.height)];
    
}
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    tempImage = croppedImage;//[Util scaleImg:croppedImage maxsize:140];
    
    mm.mHeaderImg.image = tempImage;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
