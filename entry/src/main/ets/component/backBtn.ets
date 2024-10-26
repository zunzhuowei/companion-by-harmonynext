import { router } from "@kit.ArkUI"

@Component
export default struct BackBtn {

  build() {
    // 返回按钮
    Row(){
      Text('< 返回')
        .width('100%')
        .onClick(() => router.back())
    }
    .width(60)
    .height(25)
    .backgroundColor(Color.Orange)
    .borderRadius(25)
    .opacity(0.5)
    .padding(5)
    .margin({top: 10,left:10})
  }

}