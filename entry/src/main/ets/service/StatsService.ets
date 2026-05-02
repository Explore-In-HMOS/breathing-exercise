import { SessionResult } from '../model/SessionModel';

export class StatsService {
  public static saveSession(result: SessionResult) {
    let sessionsJson = AppStorage.get<string>('sessions') || '[]';
    let sessions: SessionResult[] = JSON.parse(sessionsJson);
    sessions.push(result);
    AppStorage.setOrCreate('sessions', JSON.stringify(sessions));

    // Update streak and total time
    let totalMinutes = AppStorage.get<number>('totalMinutes') || 0;
    AppStorage.setOrCreate('totalMinutes', totalMinutes + result.duration);

    StatsService.updateStreak();
  }

  private static updateStreak() {
    let lastDate = AppStorage.get<string>('lastExerciseDate');
    let today = new Date().toDateString();
    let streak = AppStorage.get<number>('streak') || 0;

    if (lastDate === today) {
      return;
    }

    if (lastDate) {
      let last = new Date(lastDate);
      let yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);

      if (last.toDateString() === yesterday.toDateString()) {
        streak++;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    AppStorage.setOrCreate('streak', streak);
    AppStorage.setOrCreate('lastExerciseDate', today);
  }
}
