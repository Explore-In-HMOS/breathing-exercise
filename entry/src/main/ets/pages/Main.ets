import { ArcButton, ArcButtonOptions, ArcButtonPosition } from '@ohos.arkui.advanced.ArcButton';
import { ArcButtonStyleMode } from '@kit.ArkUI';
import vibrator from '@ohos.vibrator';
import { BreathingTechnique, PRESET_TECHNIQUES, Phase } from '../model/BreathingTechnique';
import { SessionResult } from '../model/SessionModel';
import { StatsService } from '../service/StatsService';

@Component
export struct Main {
  @Consume('pageStack') pageStack: NavPathStack;
  private sessionTimeout: number | null = null;
  private phaseInterval: number | null = null;
  private sizeInterval: number | null = null;

  @State isStarted: boolean = false;
  @State currentPhase: string = 'Ready';
  @State phaseCountdown: number = 0;
  @State circleSize: number = 118;

  @StorageLink('speed') speed: number = 1;
  @StorageLink('time') time: number = 1;
  @StorageLink('selectedTechniqueId') selectedTechniqueId: string = 'box';
  @StorageLink('customInhale') customInhale: number = 4;
  @StorageLink('customHold') customHold: number = 4;
  @StorageLink('customExhale') customExhale: number = 4;

  private currentTechnique: BreathingTechnique = PRESET_TECHNIQUES[0];
  private currentPhaseIndex: number = 0;

  aboutToAppear(): void {
    this.updateTechnique();
  }

  aboutToDisappear(): void {
    this.clearTimers();
  }

  private clearTimers(): void {
    if (this.sessionTimeout !== null) {
      clearTimeout(this.sessionTimeout);
      this.sessionTimeout = null;
    }
    if (this.phaseInterval !== null) {
      clearInterval(this.phaseInterval);
      this.phaseInterval = null;
    }
    if (this.sizeInterval !== null) {
      clearInterval(this.sizeInterval);
      this.sizeInterval = null;
    }
  }

  private stopSizeAnimation(): void {
    if (this.sizeInterval !== null) {
      clearInterval(this.sizeInterval);
      this.sizeInterval = null;
    }
  }

  private updateTechnique(): void {
    const found: BreathingTechnique | undefined = PRESET_TECHNIQUES.find(
      (item: BreathingTechnique): boolean => item.id === this.selectedTechniqueId
    );

    if (found) {
      this.currentTechnique = {
        id: found.id,
        name: found.name,
        description: found.description,
        phases: found.phases.map((phase: Phase): Phase => ({
          name: phase.name,
          duration: phase.duration
        }))
      };
    }

    if (this.currentTechnique.id === 'custom') {
      this.currentTechnique = {
        id: 'custom',
        name: 'Custom',
        description: 'Custom breathing technique',
        phases: [
          { name: 'Inhale', duration: this.customInhale },
          { name: 'Hold', duration: this.customHold },
          { name: 'Exhale', duration: this.customExhale }
        ]
      };
    }
  }

  private resetUi(): void {
    this.isStarted = false;
    this.currentPhase = 'Ready';
    this.phaseCountdown = 0;
    this.circleSize = 118;
    this.currentPhaseIndex = 0;
  }

  stop(completed: boolean = false): void {
    this.clearTimers();

    if (completed) {
      const totalPhaseDuration: number = this.currentTechnique.phases.reduce(
        (sum: number, phase: Phase): number => sum + phase.duration,
        0
      );

      const result: SessionResult = {
        techniqueName: this.currentTechnique.name,
        duration: this.time,
        totalBreaths: totalPhaseDuration > 0 ? Math.floor((this.time * 60) / totalPhaseDuration) : 0,
        timestamp: Date.now()
      };

      StatsService.saveSession(result);

      this.resetUi();

      this.pageStack.replacePathByName('SummaryPage', result);
      return;
    }

    this.resetUi();
  }

  start(): void {
    this.clearTimers();
    this.updateTechnique();

    this.isStarted = true;
    this.currentPhaseIndex = 0;
    this.circleSize = 118;

    this.startPhase();

    this.sessionTimeout = setTimeout((): void => {
      this.stop(true);
    }, this.time * 60 * 1000);
  }

  private animateCircleTo(targetSize: number, phaseDuration: number): void {
    this.stopSizeAnimation();

    const startSize: number = this.circleSize;
    const totalMs: number = phaseDuration * 1000 / this.speed;
    const stepMs: number = 40;
    const steps: number = Math.max(1, Math.floor(totalMs / stepMs));
    let currentStep: number = 0;

    this.sizeInterval = setInterval((): void => {
      currentStep++;

      const progress: number = currentStep / steps;
      const eased: number = progress < 0.5
        ? 2 * progress * progress
        : 1 - Math.pow(-2 * progress + 2, 2) / 2;

      this.circleSize = startSize + (targetSize - startSize) * eased;

      if (currentStep >= steps) {
        this.circleSize = targetSize;
        this.stopSizeAnimation();
      }
    }, stepMs);
  }

  private startPhase(): void {
    const phase: Phase = this.currentTechnique.phases[this.currentPhaseIndex];
    this.currentPhase = phase.name;
    this.phaseCountdown = phase.duration;

    if (phase.name === 'Inhale') {
      this.animateCircleTo(178, phase.duration);
    } else if (phase.name === 'Hold') {
      this.stopSizeAnimation();
    } else if (phase.name === 'Exhale') {
      this.animateCircleTo(96, phase.duration);
    }

    this.vibrate();

    if (this.phaseInterval !== null) {
      clearInterval(this.phaseInterval);
      this.phaseInterval = null;
    }

    this.phaseInterval = setInterval((): void => {
      this.phaseCountdown = this.phaseCountdown - 1;

      if (this.phaseCountdown <= 0) {
        if (this.phaseInterval !== null) {
          clearInterval(this.phaseInterval);
          this.phaseInterval = null;
        }
        this.nextPhase();
      }
    }, 1000 / this.speed);
  }

  private nextPhase(): void {
    this.currentPhaseIndex = (this.currentPhaseIndex + 1) % this.currentTechnique.phases.length;
    this.startPhase();
  }

  private vibrate(): void {
    try {
      vibrator.startVibration(
        {
          type: 'time',
          duration: 80
        },
        {
          id: 0,
          usage: 'alarm'
        },
        (error?: Object): void => {
          if (error) {
            console.error(`vibration error: ${JSON.stringify(error)}`);
          }
        }
      );
    } catch (err) {
      console.error(`vibration catch: ${JSON.stringify(err)}`);
    }
  }

  @Builder
  StartButton(): void {
    Column() {
      ArcButton({
        options: new ArcButtonOptions({
          label: this.isStarted ? 'Stop' : 'Start',
          position: ArcButtonPosition.BOTTOM_EDGE,
          styleMode: ArcButtonStyleMode.NORMAL_LIGHT,
          onClick: (): void => {
            if (this.isStarted) {
              this.stop();
            } else {
              this.start();
            }
          }
        })
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
  }

  @Builder
  BreathingCircle(): void {
    Stack({ alignContent: Alignment.Center }) {
      Circle({ width: 10, height: 10 })
        .fill('#53B8DB')
        .translate({ x: 0, y: -108 });

      Circle({ width: 10, height: 10 })
        .fill('#53B8DB')
        .translate({ x: 78, y: 88 });

      Circle({ width: this.circleSize, height: this.circleSize })
        .fill('#63BCDD')
        .opacity(0.95);

      Column({ space: 4 }) {
        if (this.isStarted) {
          Text(this.currentPhase.toLowerCase())
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White);

          Text(this.phaseCountdown.toString())
            .fontSize(14)
            .fontColor(Color.White)
            .opacity(0.95);
        } else {
          Text(this.currentTechnique.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#006064')
            .textAlign(TextAlign.Center);

          Text('Tap Start to begin')
            .fontSize(12)
            .fontColor('#5F7480')
            .textAlign(TextAlign.Center);
        }
      }
      .hitTestBehavior(HitTestMode.None);
    }
    .width(240)
    .height(240);
  }

  build(): void {
    NavDestination() {
      Stack() {
        Column() {
        this.BreathingCircle()
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ bottom: 74 });

      this.StartButton();
    }
      .width('100%')
      .height('100%')
      .backgroundColor('#E4F6FA');
    }
    .hideTitleBar(true)
  }
}