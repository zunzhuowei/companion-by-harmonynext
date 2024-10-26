@Component
export default struct counter {
  @Prop allSeconds: number;
  @State text: string = '';

  aboutToAppear(): void {
    this.startCountDown(this.allSeconds)
  }

  updateText(str: string): void {
    this.text = str;
  }

  startCountDown(allSeconds: number): void {
    let totalSeconds = Math.floor(allSeconds / 1000);

    const fn = () => {
      const hour = Math.floor(totalSeconds / 3600);
      const minute = Math.floor((totalSeconds % 3600)/ 60);
      const second = Math.floor(totalSeconds % 60);
      const str = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:${second.toString().padStart(2, '0')}`
      this.updateText(str)
      if (totalSeconds <= 0) {
        clearInterval(id)
      }
      totalSeconds -- ;
    }
    let id = setInterval(fn, 1000)
    fn()
  }

  build() {
    Text(this.text).fontSize(13).fontColor('#ffffa200')
  }
}