import { companion, companion_hospital, return_companion_type } from '../api/createOrder';

@CustomDialog
export struct CustomDialogContent {
  controller?: CustomDialogController;
  @Prop contentType: string;
  @Prop orderData: return_companion_type;
  @Prop selectedIdx: number|undefined;
  range: string[] = [];
  cancel?: () => void;
  confirm?: (obj: companion | companion_hospital | undefined) => void;
  @State
  confirmObj: companion | companion_hospital | undefined = undefined;

  aboutToAppear(): void {
    this.range = this.contentType === 'hospital_name' ?
    this.orderData.hospitals.map((item: companion_hospital) => item.name) :
    this.orderData.companion.map((item: companion) => item.name)

    this.confirmObj = this.contentType === 'hospital_name' ?
    this.orderData.hospitals[0] :
    this.orderData.companion[0]
  }

  build() {
    Column() {
      Text(this.contentType === 'hospital_name' ? '选择医院' : '选择陪诊师')
        .fontSize(18)
        .fontColor(Color.Black)
        .margin({ top: 20 })
        .fontWeight(FontWeight.Bold)
      Divider()
        .color(Color.Black)
        .strokeWidth(1)
        .margin({ top: 10, bottom: 10 })

      Row() {
        Button('确认选中')
          .type(ButtonType.Normal)
          .borderRadius(5)
          .onClick(() => {
            if (this.confirm) {
              this.confirm(this.confirmObj);
            }
          })
        Button('取消')
          .backgroundColor(Color.Red)
          .type(ButtonType.Normal)
          .borderRadius(5)
          .onClick(() => {
            if (this.cancel) {
              this.cancel();
            }
          })
      }
      .width('100%')
      .padding(10)
      .justifyContent(FlexAlign.SpaceBetween)

      TextPicker({ range: this.range, selected: this.selectedIdx })
        .canLoop(false)
        .width('100%')
        .onChange((value: string | string[], index: number | number[]) => this.onChange(value, index, this.contentType))
    }
    .height(300)
  }

  onChange(value: string | string[], index: number | number[], contentType: string) {
    let result: companion | companion_hospital | undefined = contentType === 'hospital_name' ?
    this.orderData.hospitals[index as number] :
    this.orderData.companion[index as number]
    this.confirmObj = result;
    console.log('888', JSON.stringify(this.orderData))
  }
}


@CustomDialog
export struct CustomDateDialogContent {
  controller?: CustomDialogController;
  @Prop orderData: return_companion_type;
  @Prop selected: Date | undefined;
  range: string[] = [];
  cancel?: () => void;
  confirm?: (obj: Date) => void;
  @State
  confirmObj: Date = new Date(Date.now() + 86400000);

  aboutToAppear(): void {

  }

  build() {
    Column() {
      Text('选择就诊时间')
        .fontSize(18)
        .fontColor(Color.Black)
        .margin({ top: 20 })
        .fontWeight(FontWeight.Bold)
      Divider()
        .color(Color.Black)
        .strokeWidth(1)
        .margin({ top: 10, bottom: 10 })

      Row() {
        Button('确认选中')
          .type(ButtonType.Normal)
          .borderRadius(5)
          .onClick(() => {
            if (this.confirm) {
              this.confirm(this.confirmObj);
            }
          })
        Button('取消')
          .backgroundColor(Color.Red)
          .type(ButtonType.Normal)
          .borderRadius(5)
          .onClick(() => {
            if (this.cancel) {
              this.cancel();
            }
          })
      }
      .width('100%')
      .padding(10)
      .justifyContent(FlexAlign.SpaceBetween)

      DatePicker({
        start: new Date(Date.now() + 86400000),
        end: new Date(Date.now() + 86400000 * 7),
        selected: this.selected
      })
        .onDateChange((value: Date) => {
          console.log('888', JSON.stringify(value))
          this.confirmObj = value;
        })
    }
    .height(300)
  }
}

@CustomDialog
export struct CustomQrDialogContent {
  controller?: CustomDialogController;
  @Prop qrData: string = 'weixin://wxpay/bizpayurl?pr=Z4O2GuLz1';
  cancel?: () => void;

  build() {
    Column() {
      Column(){
        Text('请使用微信扫码支付')
          .fontSize(18)
          .fontColor(Color.Black)
          .margin({ top: 20 })
          .fontWeight(FontWeight.Bold)
        Divider()
          .color(Color.Black)
          .strokeWidth(1)
          .margin({ top: 10, bottom: 10 })

        QRCode(this.qrData).width(140).height(140)
      }

      Column(){
        Text('X')
          .border({ width: 1 })
          .borderRadius('50%')
          .width(20)
          .height(20)
          .textAlign(TextAlign.Center)
          .margin({bottom:20})
          .onClick(() => {
            if (this.cancel) {
              this.cancel();
            }
          })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height(300)
  }
}