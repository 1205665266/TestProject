/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/27 10:27
class ServiceTimeUtil {
  static bool judgeInsideServiceTime(String swTime) {
    DateTime now = DateTime.now();
    List<String> tList = swTime.split('-');
    if (tList.length != 2) {
      tList = ['09:00', '21:00'];
    }

    List<String> sList = tList[0].split(":"); // ["09","00"]
    List<String> eList = tList[1].split(":"); // ["21","00"]

    String sh = sList[0];
    sh = sh.replaceAll(RegExp('^0*'), '');
    sh = sh == "" ? '0' : sh; // 9
    String sm = sList[1];
    sm = sm.replaceAll(RegExp('^0*'), '');
    sm = sm == "" ? '0' : sm; // 0

    String eh = eList[0];
    eh = eh.replaceAll(RegExp('^0*'), '');
    eh = eh == "" ? '0' : eh; // 21
    String em = eList[1];
    em = em.replaceAll(RegExp('^0*'), '');
    em = em == "" ? '0' : em; // 0

    DateTime sTime = DateTime(now.year, now.month, now.day, int.parse(sh), int.parse(sm));
    DateTime eTime = DateTime(now.year, now.month, now.day, int.parse(eh), int.parse(em));

    bool isAfterStart = !now.isBefore(sTime);
    bool isBeforeEnd = now.isBefore(eTime);

    return isAfterStart && isBeforeEnd;
  }
}
