import { LengthUnit } from '@kit.ArkUI'

@Component
export struct StatsPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @StorageLink('streak') streak: number = 0;
  @StorageLink('totalMinutes') totalMinutes: number = 0;

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Text('Statistics').fontSize(22).fontColor('#006064').fontWeight(FontWeight.Bold)

        Row() {
        Column() {
          Text('Streak').fontColor('#006064').fontSize(14)
          Text(`${this.streak} Days`).fontColor('#006064').fontSize(20).fontWeight(FontWeight.Bolder)
        }
        .padding(15)
        .backgroundColor('#1A4EB8DA')
        .borderRadius(15)
        .width('45%')

        Column() {
          Text('Total Time').fontColor('#006064').fontSize(14)
          Text(`${this.totalMinutes} Min`).fontColor('#006064').fontSize(20).fontWeight(FontWeight.Bolder)
        }
        .padding(15)
        .backgroundColor('#1A4EB8DA')
        .borderRadius(15)
        .width('45%')
      }.width('100%').justifyContent(FlexAlign.SpaceAround)

        Button('Back')
          .onClick(() => {
            this.pageStack.pop()
          })
          .margin({ top: 20 })
          .backgroundColor('#4EB8DA')
          .fontColor(Color.White)
      }
      .width('100%')
      .height('100%')
      .padding(20)
      .backgroundColor('#E0F7FA')
    }
    .hideTitleBar(true)
  }
}
