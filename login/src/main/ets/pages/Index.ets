import { router } from '@kit.ArkUI';
import {login, login_type, return_login_type} from 'commons'
import json from '@ohos.util.json';
import PreferencesUtils from 'commons/src/main/ets/utils/preferences';
import { common } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[Page_UIAbilityComponentsInteractive]';

@Entry
@Component
struct Index {
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
      // router.replaceUrl({
      //   url: 'pages/Index'
      // })

      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
      // context为需要停止的UIAbility实例的AbilityContext
      // context.terminateSelf((err) => {
      //   if (err.code) {
      //     hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self. Code is ${err.code}, message is ${err.message}`);
      //     return;
      //   }
      // });
      // 带返回值的Ability
      const RESULT_CODE: number = 1001;
      let abilityResult: common.AbilityResult = {
        resultCode: RESULT_CODE,
        want: {
          bundleName: 'com.samples.stagemodelabilitydevelop',
          moduleName: 'entry', // moduleName非必选
          abilityName: 'FuncAbilityB',
          parameters: {
            token: value.token,
            userInfo: json.stringify(value.userInfo)
          },
        },
      };
      context.terminateSelfWithResult(abilityResult, (err) => {
        if (err.code) {
          hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self with result. Code is ${err.code}, message is ${err.message}`);
          return;
        }
      });

    }).catch(() => {
      this.showRuleTip = true;
    })
  }
}