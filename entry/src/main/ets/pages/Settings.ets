@Component
export struct SettingsPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @StorageLink('time') time: number = 1;
  @StorageLink('speed') speed: number = 1;
  @StorageLink('customInhale') customInhale: number = 4;
  @StorageLink('customHold') customHold: number = 4;
  @StorageLink('customExhale') customExhale: number = 4;
  @StorageLink('dailyReminder') dailyReminder: boolean = false;

  @Builder
  Adjuster(
    label: string,
    value: number,
    onMinus: () => void,
    onPlus: () => void
  ) {
    Row() {

      Text(label)
        .fontSize(14)
        .fontColor('#006064')
        .width('35%')

      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 28, height: 28 })
          .fill('#4EB8DA')

        Text('-')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .onClick(onMinus)

      Text(value.toString())
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .width(30)
        .textAlign(TextAlign.Center)

      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 28, height: 28 })
          .fill('#4EB8DA')

        Text('+')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .onClick(onPlus)

    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  build() {
    NavDestination() {
      Column() {
        Text('Settings').fontSize(22).fontColor('#006064').fontWeight(FontWeight.Bold).margin({ bottom: 10 })

        List() {
        ListItem() {
          Column() {
            Text('Session Duration (min)').fontColor('#006064').fontSize(12)
            Row() {
              Button('-').onClick(() => {if (this.time > 1){ this.time--} }).backgroundColor('#334EB8DA').fontColor('#006064')
              Text(this.time.toString()).fontColor('#006064').margin(10).fontSize(20)
              Button('+').onClick(() => { if (this.time < 30){ this.time++} }).backgroundColor('#334EB8DA').fontColor('#006064')
            }
          }.padding(10).backgroundColor('#1A4EB8DA').borderRadius(15).width('90%')
        }

        ListItem() {
          Column({ space: 5 }) {
            Text('Custom Rhythm (sec)').fontColor('#006064').fontSize(14).fontWeight(FontWeight.Bold)
            this.Adjuster('Inhale', this.customInhale, () => { if (this.customInhale > 1) {this.customInhale--} }, () => { this.customInhale++ })
            this.Adjuster('Hold', this.customHold, () => { if (this.customHold > 0) {this.customHold--} }, () => { this.customHold++ })
            this.Adjuster('Exhale', this.customExhale, () => { if (this.customExhale > 1) {this.customExhale--} }, () => { this.customExhale++ })
          }.padding(10).backgroundColor('#1A4EB8DA').borderRadius(15).width('90%')
        }

        ListItem() {
          Row() {
            Text('Daily Reminder').fontColor('#006064')
            Toggle({ type: ToggleType.Switch, isOn: this.dailyReminder })
              .onChange((isOn) => { this.dailyReminder = isOn })
          }.width('90%').justifyContent(FlexAlign.SpaceBetween).padding(10).backgroundColor('#1A4EB8DA').borderRadius(15)
        }
      }
        .height('80%')
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#E0F7FA')
    }
    .hideTitleBar(true)
  }
}
