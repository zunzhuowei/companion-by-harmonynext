import { login, login_type, return_login_type } from '../api/login';
import { router } from '@kit.ArkUI';
import PreferencesUtils from '../utils/preferences';
import json from '@ohos.util.json';

@Entry
@Component
struct LoginPage {
  @State showRuleTip: boolean = false;
  @State @Watch('onLoginParamsChange') loginParams: login_type = {
    userName: '13689587452',
    passWord: '123456'
  }

  // onPageShow(): void {
  //   login({
  //     userName: '13689587452',
  //     passWord: '123456'
  //   })
  //     .then((value: return_login_type) => {
  //       console.log('登录返回:', JSON.stringify(value))
  //     })
  // }

  onLoginParamsChange(){
    this.showRuleTip = false;
  }

  build() {
    Column() {
      Row() {
        Text('用户登录').fontWeight(FontWeight.Bold).fontSize(25)
      }
      .padding(30)

      Row() {
        Text('用户名:').fontSize(15).width('30%')
        TextInput({ placeholder: '用户名' ,text: this.loginParams.userName}).fontSize(15).width('70%')
          .onChange((text: string) => {
            this.loginParams.userName = text
          })
      }
      .padding(10)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('密码:').fontSize(15).width('30%')
        TextInput({ placeholder: '密码' ,text: this.loginParams.passWord}).fontSize(15).width('70%').type(InputType.Password)
          .onChange((text: string) => {
            this.loginParams.passWord = text
          })
      }
      .padding(10)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.showRuleTip) {
        Row() {
          Text('请把密码和用户名填写完整').fontColor(Color.Red)
        }
      }

      Row() {
        Button('登录')
          .width('80%')
          .height(40)
          .margin({ top: 30 })
          .onClick(() => this.loginLogic(this.loginParams))
      }
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }

  loginLogic(loginParams: login_type){
    if (!loginParams.userName || !loginParams.passWord) {
      this.showRuleTip = true;
      return;
    }
    login(loginParams).then((value: return_login_type) => {
      PreferencesUtils.set('token', value.token)
      PreferencesUtils.set('userInfo', json.stringify(value.userInfo))
      router.replaceUrl({
        url: 'pages/Index'
      })
    }).catch(() => {
      this.showRuleTip = true;
    })
  }
}