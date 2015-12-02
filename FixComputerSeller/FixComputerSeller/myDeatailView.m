//
//  myDeatailView.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/24.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "myDeatailView.h"
#import "RSKImageCropper.h"

@interface myDeatailView ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource>

@end

@implementation myDeatailView
{
    UIImage *tempImage;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.hiddenlll = YES;
    self.Title = self.mPageName = @"我的账号";
    self.rightBtnTitle = @"保存";

    [self.mSetBtn addTarget:self action:@selector(headBtnTouched:) forControlEvents:UIControlEventTouchUpInside];

    self.mHeaderImg.layer.masksToBounds = YES;
    self.mHeaderImg.layer.cornerRadius = self.mHeaderImg.mheight/2;

    [self.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead.png"]];
    MLLog(@"头像地址：%@",[SUser currentUser].mHeadImgURL);

    self.mUserName.text = [SUser currentUser].mUserName;
    self.mPhone.text = [SUser currentUser].mPhone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnTouched:(id)sender{
    MLLog(@"保存");
    if (!tempImage )
    {
        [self showErrorStatus:@"未作任何修改"];
        return;
    }

//    [[SUser currentUser]updateUserInfo:nil HeadImg:tempImage block:^(SResBase *resb) {
//        if (resb.msuccess) {
//            [self showSuccessStatus:resb.mmsg];
//            [self popViewController];
//        }
//        
//        else
//        {
//            [self showErrorStatus:resb.mmsg];
//        }
//    }];

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
    return   CGRectMake(self.view.center.x-self.mHeaderImg.frame.size.width/2, self.view.center.y-self.mHeaderImg.frame.size.height/2, self.mHeaderImg.frame.size.width, self.mHeaderImg.frame.size.height);
    
}
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    return [UIBezierPath bezierPathWithRect:CGRectMake(self.view.center.x-self.mHeaderImg.frame.size.width/2, self.view.center.y-self.mHeaderImg.frame.size.height/2, self.mHeaderImg.frame.size.width, self.mHeaderImg.frame.size.height)];
    
}
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    tempImage = croppedImage;//[Util scaleImg:croppedImage maxsize:140];
    
    self.mHeaderImg.image = tempImage;
    
    
}

@end
