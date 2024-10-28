import { common } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[Page_UIAbilityComponentsInteractive]';

@Entry
@Component
struct Index {

  build() {
    Column() {
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
    }
    .height('100%')
    .width('100%')
  }

  /*
  调用terminateSelf()方法停止当前UIAbility实例时，默认会保留该实例的快照（Snapshot），即在最近任务列表中仍然能查看到该实例对应的任务。
  如不需要保留该实例的快照，可以在其对应UIAbility的module.json5配置文件中，将abilities标签的removeMissionAfterTerminate字段配置为true。

  如需要关闭应用所有的UIAbility实例，可以调用ApplicationContext的killAllProcesses()方法实现关闭应用所有的进程。
   */
}