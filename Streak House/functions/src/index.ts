import * as functions from "firebase-functions/v1"; // v1 명시적으로 사용
import * as admin from "firebase-admin";
import { DateTime } from "luxon";

admin.initializeApp();

export const resetDailyStreaks = functions.pubsub.schedule("every 1 hours")
  .timeZone("UTC") // 기준은 UTC, 사용자 기준은 개별로 계산
  .onRun(async () => {
    const db = admin.firestore();
    const streaksSnap = await db.collection("streaks").get();

    const batch = db.batch();
    const userTimezones: Record<string, string> = {};

    for (const doc of streaksSnap.docs) {
      const data = doc.data();
      const ref = doc.ref;

      const createdBy = data.createdBy;
      if (!createdBy) continue;

      // 캐싱 안 된 사용자 timezone 불러오기
      if (!userTimezones[createdBy]) {
        const userDoc = await db.collection("users").doc(createdBy).get();
        userTimezones[createdBy] = userDoc.data()?.timezone || "Asia/Seoul";
      }

      const timezone = userTimezones[createdBy];
      const now = DateTime.now().setZone(timezone);
      const todayMidnight = now.startOf("day").toJSDate();

      const lastCheckedAt = data.lastCheckedAt?.toDate?.() || null;
      const isCompletedToday = lastCheckedAt && lastCheckedAt >= todayMidnight;

      // streak 초기화 (오늘 완료 안 했을 경우)
      if (!isCompletedToday) {
        batch.update(ref, { streakCount: 0 });
      }

      // cheeredBy는 무조건 초기화
      batch.update(ref, { cheeredBy: [] });
    }

    await batch.commit();
    console.log("✅ Timezone-aware streak reset complete");
    return null;
  });