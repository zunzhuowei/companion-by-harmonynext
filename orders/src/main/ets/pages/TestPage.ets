import { common } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[Page_UIAbilityComponentsInteractive]';

@Entry
@Component
struct TestPage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Image($r('app.media.startIcon')).width(80).height(80)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
        .id('image')
      Text('admin').fontSize(30)
        .alignRules({
          top: { anchor: 'image', align: VerticalAlign.Bottom },
          middle: { anchor: 'image', align: HorizontalAlign.Center },
        })
        .id('name')

      Text('我的订单').fontSize(30)
        .alignRules({
          top: { anchor: 'name', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
        })
        .margin({left: 20,top: 20})
        .id('myOrder')
      Text('全部').fontSize(30)
        .alignRules({
          top: { anchor: 'name', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        })
        .margin({ right: 20,top:20})
        .id('all')

      Column(){
        Image($r('app.media.startIcon')).width(20).height(20)
        Text('待支付')
      }
      .alignRules({
        top: { anchor: 'myOrder', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
      })
      .margin({left: 20,top: 20})
      .id('waitPay')

      Column(){
        Image($r('app.media.startIcon')).width(20).height(20)
        Text('待服务')
      }
      .alignRules({
        top: { anchor: 'myOrder', align: VerticalAlign.Bottom },
        left: { anchor: 'waitPay', align: HorizontalAlign.End },
      })
      .margin({left: 20,top: 20})
      .id('waitService')

      Column(){
        Image($r('app.media.startIcon')).width(20).height(20)
        Text('已完成')
      }
      .alignRules({
        top: { anchor: 'myOrder', align: VerticalAlign.Bottom },
        left: { anchor: 'waitService', align: HorizontalAlign.End },
      })
      .margin({left: 20,top: 20})
      .id('completePay')

      Column(){
        Image($r('app.media.startIcon')).width(20).height(20)
        Text('已取消')
      }
      .alignRules({
        top: { anchor: 'myOrder', align: VerticalAlign.Bottom },
        left: { anchor: 'completePay', align: HorizontalAlign.End },
      })
      .margin({left: 20,top: 20})
      .id('cancelPay')

      Text('服务对象管理').fontSize(30)
        .alignRules({
          top: { anchor: 'cancelPay', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
        .margin({top: 20})

      Text('分享分发').fontSize(30)
        .alignRules({
          top: { anchor: 'cancelPay', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
        .margin({top: 60})

      Button('FuncAbilityB')
        .onClick(() => {
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
                info: '来自FuncAbility Index页面2'
              },
            },
          };
          context.terminateSelfWithResult(abilityResult, (err) => {
            if (err.code) {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self with result. Code is ${err.code}, message is ${err.message}`);
              return;
            }
          });
        })
        .alignRules({
          top: { anchor: 'cancelPay', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
        .margin({top: 120})

    }
    .height('100%')
    .width('100%')
  }
}