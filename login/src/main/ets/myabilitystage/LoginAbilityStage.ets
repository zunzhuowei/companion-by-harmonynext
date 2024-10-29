import { AbilityConstant, AbilityStage, Configuration, Want } from "@kit.AbilityKit";
import hilog from "@ohos.hilog";

export default class LoginAbilityStage extends AbilityStage {
  onCreate() {
    // 应用的HAP在首次加载的时，为该Module初始化操作
    hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityStage onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityStage onDestroy');
  }

  onAcceptWant(want: Want): string {
    // 仅specified模式下触发
    hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityStage onAcceptWant');
    return 'OrdersAbilityStage';
  }

  onNewProcessRequest(want: Want): string {
    hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityStage onNewProcessRequest');
    return 'LoginAbilityStage';
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    //当系统全局配置发生变更时触发的事件，系统语言、深浅色等，配置项目前均定义在Configuration类中。
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    // 根据系统可用内存的变化情况，释放不必要的内存
  }

}